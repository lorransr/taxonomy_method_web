import 'package:taxonomy_method/model/criteria.dart';

class TaxonomyInput {
  List<Criteria> criterias;
  List<List<double>> alternatives;
  List<String> alternativesNames;
  TaxonomyInput(this.criterias, this.alternatives, this.alternativesNames);

  Map<String, dynamic> toJson() => {
        'criterias': criterias,
        'alternatives': alternatives,
        'alternatives_names': alternativesNames
      };
}
