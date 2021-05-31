import numpy as np
import math

##mostly borrowed from scipy

def euclidean(u, v, w=None):
    """
    Computes the Euclidean distance between two 1-D arrays.
    The Euclidean distance between 1-D arrays `u` and `v`, is defined as
    .. math::
       {||u-v||}_2
       \\left(\\sum{(w_i |(u_i - v_i)|^2)}\\right)^{1/2}
    Parameters
    ----------
    u : (N,) array_like
        Input array.
    v : (N,) array_like
        Input array.
    w : (N,) array_like, optional
        The weights for each value in `u` and `v`. Default is None,
        which gives each value a weight of 1.0
    Returns
    -------
    euclidean : double
        The Euclidean distance between vectors `u` and `v`.
    Examples
    --------
    >>> from scipy.spatial import distance
    >>> distance.euclidean([1, 0, 0], [0, 1, 0])
    1.4142135623730951
    >>> distance.euclidean([1, 1, 0], [0, 1, 0])
    1.0
    """
    return minkowski(u, v, p=2, w=w)

def _validate_vector(u, dtype=None):
    # XXX Is order='c' really necessary?
    u = np.asarray(u, dtype=dtype, order='c')
    if u.ndim == 1:
        return u

    # Ensure values such as u=1 and u=[1] still return 1-D arrays.
    u = np.atleast_1d(u.squeeze())
    if u.ndim > 1:
        raise ValueError("Input vector should be 1-D.")
    return u

def _validate_weights(w, dtype=np.double):
    w = _validate_vector(w, dtype=dtype)
    if np.any(w < 0):
        raise ValueError("Input weights should be all non-negative")
    return w

def minkowski(u, v, p=2, w=None):
    """
    Compute the Minkowski distance between two 1-D arrays.
    The Minkowski distance between 1-D arrays `u` and `v`,
    is defined as
    .. math::
       {||u-v||}_p = (\\sum{|u_i - v_i|^p})^{1/p}.
       \\left(\\sum{w_i(|(u_i - v_i)|^p)}\\right)^{1/p}.
    Parameters
    ----------
    u : (N,) array_like
        Input array.
    v : (N,) array_like
        Input array.
    p : scalar
        The order of the norm of the difference :math:`{||u-v||}_p`.
    w : (N,) array_like, optional
        The weights for each value in `u` and `v`. Default is None,
        which gives each value a weight of 1.0
    Returns
    -------
    minkowski : double
        The Minkowski distance between vectors `u` and `v`.
    Examples
    --------
    >>> from scipy.spatial import distance
    >>> distance.minkowski([1, 0, 0], [0, 1, 0], 1)
    2.0
    >>> distance.minkowski([1, 0, 0], [0, 1, 0], 2)
    1.4142135623730951
    >>> distance.minkowski([1, 0, 0], [0, 1, 0], 3)
    1.2599210498948732
    >>> distance.minkowski([1, 1, 0], [0, 1, 0], 1)
    1.0
    >>> distance.minkowski([1, 1, 0], [0, 1, 0], 2)
    1.0
    >>> distance.minkowski([1, 1, 0], [0, 1, 0], 3)
    1.0
    """
    u = _validate_vector(u)
    v = _validate_vector(v)
    if p < 1:
        raise ValueError("p must be at least 1")
    u_v = u - v
    if w is not None:
        w = _validate_weights(w)
        if p == 1:
            root_w = w
        elif p == 2:
            # better precision and speed
            root_w = np.sqrt(w)
        elif p == np.inf:
            root_w = (w != 0)
        else:
            root_w = np.power(w, 1/p)
        u_v = root_w * u_v
    dist = np.linalg.norm(u_v, ord=p)
    return dist


def pdist(X, *, out=None, metric, **kwargs):
    n = X.shape[0]
    out_size = (n * (n - 1)) // 2
    dm = _prepare_out_argument(out, np.double, (out_size,))
    k = 0
    for i in range(X.shape[0] - 1):
        for j in range(i + 1, X.shape[0]):
            dm[k] = metric(X[i], X[j])
            k += 1
    return dm

def _prepare_out_argument(out, dtype, expected_shape):
    if out is None:
        return np.empty(expected_shape, dtype=dtype)

    if out.shape != expected_shape:
        raise ValueError("Output array has incorrect shape.")
    if not out.flags.c_contiguous:
        raise ValueError("Output array must be C-contiguous.")
    if out.dtype != np.double:
        raise ValueError("Output array must be double type.")
    return out

def is_valid_dm(D, tol=0.0, throw=False, name="D", warning=False):
    """
    Return True if input array is a valid distance matrix.
    Distance matrices must be 2-dimensional numpy arrays.
    They must have a zero-diagonal, and they must be symmetric.
    Parameters
    ----------
    D : array_like
        The candidate object to test for validity.
    tol : float, optional
        The distance matrix should be symmetric. `tol` is the maximum
        difference between entries ``ij`` and ``ji`` for the distance
        metric to be considered symmetric.
    throw : bool, optional
        An exception is thrown if the distance matrix passed is not valid.
    name : str, optional
        The name of the variable to checked. This is useful if
        throw is set to True so the offending variable can be identified
        in the exception message when an exception is thrown.
    warning : bool, optional
        Instead of throwing an exception, a warning message is
        raised.
    Returns
    -------
    valid : bool
        True if the variable `D` passed is a valid distance matrix.
    Notes
    -----
    Small numerical differences in `D` and `D.T` and non-zeroness of
    the diagonal are ignored if they are within the tolerance specified
    by `tol`.
    """
    D = np.asarray(D, order='c')
    valid = True
    try:
        s = D.shape
        if len(D.shape) != 2:
            if name:
                raise ValueError(('Distance matrix \'%s\' must have shape=2 '
                                  '(i.e. be two-dimensional).') % name)
            else:
                raise ValueError('Distance matrix must have shape=2 (i.e. '
                                 'be two-dimensional).')
        if tol == 0.0:
            if not (D == D.T).all():
                if name:
                    raise ValueError(('Distance matrix \'%s\' must be '
                                     'symmetric.') % name)
                else:
                    raise ValueError('Distance matrix must be symmetric.')
            if not (D[range(0, s[0]), range(0, s[0])] == 0).all():
                if name:
                    raise ValueError(('Distance matrix \'%s\' diagonal must '
                                      'be zero.') % name)
                else:
                    raise ValueError('Distance matrix diagonal must be zero.')
        else:
            if not (D - D.T <= tol).all():
                if name:
                    raise ValueError(('Distance matrix \'%s\' must be '
                                      'symmetric within tolerance %5.5f.')
                                     % (name, tol))
                else:
                    raise ValueError('Distance matrix must be symmetric within'
                                     ' tolerance %5.5f.' % tol)
            if not (D[range(0, s[0]), range(0, s[0])] <= tol).all():
                if name:
                    raise ValueError(('Distance matrix \'%s\' diagonal must be'
                                      ' close to zero within tolerance %5.5f.')
                                     % (name, tol))
                else:
                    raise ValueError(('Distance matrix \'%s\' diagonal must be'
                                      ' close to zero within tolerance %5.5f.')
                                     % tol)
    except Exception as e:
        if throw:
            raise
        if warning:
            raise
        valid = False
    return valid



def squareform(dist_condensed:np.array,N:int):
    """
    Returns a squareform matrix from a given pairdistance array
    """
    a,b = np.triu_indices(N,k=1)
    dist_matrix = np.zeros((N,N))
    for i in range(len(dist_condensed)):
        dist_matrix[a[i],b[i]] = dist_condensed[i]
        dist_matrix[b[i],a[i]] = dist_condensed[i]
    return dist_matrix


