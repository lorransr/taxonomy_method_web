import 'taxonomy_output.dart';

class ModelResults {
  final TaxonomyOutput results;
  final String error;
  ModelResults(this.results, this.error);

  ModelResults.fromJson(Map<String, dynamic> json)
      : results = TaxonomyOutput.fromJson(json),
        error = "";

  ModelResults.withError(String errorValue)
      : results = TaxonomyOutput.withError(),
        error = errorValue;
}
