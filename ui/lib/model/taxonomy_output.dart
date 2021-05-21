import 'package:taxonomy_method/model/shortest_distance.dart';

class TaxonomyOutput {
  final Map<String, dynamic> normalizedMatrix;
  final Map<String, dynamic> rawMatrix;
  final ShortestDistance shortestDistance;
  final List<double> acceptedRange;
  final Map<String, dynamic> normalizedMatrixFiltered;
  final Map<String, dynamic> idealValues;
  final Map<String, dynamic> developmentPattern;
  final Map<String, dynamic> developmentAttributes;

  TaxonomyOutput(
      this.normalizedMatrix,
      this.rawMatrix,
      this.shortestDistance,
      this.acceptedRange,
      this.normalizedMatrixFiltered,
      this.idealValues,
      this.developmentPattern,
      this.developmentAttributes);

  TaxonomyOutput.fromJson(Map<String, dynamic> json)
      : normalizedMatrix = json["normalized_matrix"],
        rawMatrix = json["raw_matrix"],
        shortestDistance = ShortestDistance.fromJson(json["shortest_distance"]),
        acceptedRange = json["accepted_range"].cast<double>(),
        normalizedMatrixFiltered = json["normalized_matrix_filtered"],
        idealValues = json["ideal_values"],
        developmentPattern = json["development_pattern"],
        developmentAttributes = json["development_attributes"];

  Map<String, dynamic> toJson() => {
        "normalized_matrix": normalizedMatrix,
        "raw_matrix": rawMatrix,
        "shortest_distance": shortestDistance,
        "accepted_range": acceptedRange,
        "normalized_matrix_filtered": normalizedMatrixFiltered,
        "ideal_values": idealValues,
        "development_pattern": developmentPattern,
        "development_attributes": developmentAttributes
      };

  TaxonomyOutput.withError()
      : normalizedMatrix = {},
        rawMatrix = {},
        shortestDistance = ShortestDistance.empty(),
        acceptedRange = [],
        normalizedMatrixFiltered = {},
        idealValues = {},
        developmentPattern = {},
        developmentAttributes = {};
}
