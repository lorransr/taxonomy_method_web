class ShortestDistance {
  Map<String, dynamic> values;
  double std;
  double mean;

  ShortestDistance(this.values, this.std, this.mean);
  ShortestDistance.fromJson(Map<String, dynamic> json)
      : values = json['values'],
        std = json['std'],
        mean = json['mean'];

  ShortestDistance.empty()
      : values = {},
        std = 0,
        mean = 0;

  Map<String, dynamic> toJson() => {'values': values, 'std': std, 'mean': mean};
}
