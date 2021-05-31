from app.model import ShortestDistance, TaxonomyOutput, Criteria
import pandas as pd
import numpy as np
from app.distance import pdist,squareform,euclidean
from typing import List
import logging

logger = logging.getLogger()


def calculate(m_raw: pd.DataFrame, alternatives: List[str], criterias: List[Criteria]):
    """calculate Taxonomy Method assessment score for alternatives

    Args:
        m_raw (str): raw dicision matrix
        alternatives (List[str]): name of the alternatives
        benefit_criteria (List[str]): list of benefit criterias
        cost_criteria (List[str]): list of cost criterias (complement to benefit criteria, could be an empty list)
    Returns:
        pd.Series: alternatives ranking"""
    # step 1
    criteria_mean = m_raw.mean()
    criteria_std = m_raw.std()
    # step 2
    std_matrix = (m_raw - criteria_mean) / criteria_std
    # step 3
    composite_distance = squareform(pdist(std_matrix.values,metric=euclidean),len(std_matrix.values))

    composite_distance_df = pd.DataFrame(
        composite_distance, index=alternatives, columns=alternatives
    )

    # step 4
    filter_1 = composite_distance_df > 0
    shortest_distance_values = composite_distance_df[filter_1].min()
    mean_shortest = shortest_distance_values.mean()
    std_shortest = shortest_distance_values.std()

    lower = mean_shortest - 2 * std_shortest
    upper = mean_shortest + 2 * std_shortest

    accepted_range = [lower, upper]
    logger.info("accepted range: {}".format(accepted_range))
    condition_1 = shortest_distance_values >= accepted_range[0]
    condition_2 = shortest_distance_values <= accepted_range[1]
    std_matrix_filtered = std_matrix.loc[
        shortest_distance_values[(condition_1) & (condition_2)].index
    ]

    # step 5
    criteria_type = {}
    for c in criterias:
        criteria_type[c.name] = c.type
    ideal_values = std_matrix_filtered.apply(
        lambda x: x.max() if criteria_type[x.name] == "benefit" else x.min()
    )
    development_pattern = np.sqrt(
        ((std_matrix_filtered - ideal_values) ** 2).sum(axis=1)
    )

    # step 6
    high_limit = development_pattern.mean() + 2 * development_pattern.std()
    development_attribute = development_pattern / high_limit
    development_attribute.sort_values(inplace=True)
    output = TaxonomyOutput(
        **{
            "raw_matrix": m_raw.to_dict(),
            "normalized_matrix": std_matrix.to_dict(),
            "shortest_distance": ShortestDistance(
                **{
                    "values": shortest_distance_values.to_dict(),
                    "std": std_shortest,
                    "mean": mean_shortest,
                }
            ),
            "accepted_range": accepted_range,
            "normalized_matrix_filtered": std_matrix_filtered.to_dict(),
            "ideal_values": ideal_values.to_dict(),
            "development_pattern": development_pattern.to_dict(),
            "development_attributes": development_attribute.to_dict(),
        }
    )
    logger.info("resuts: {}".format(output.dict()))
    return output
