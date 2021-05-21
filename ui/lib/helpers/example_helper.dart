import 'package:taxonomy_method/model/criteria.dart';
import 'package:taxonomy_method/model/criteria_type.dart';
import 'package:taxonomy_method/model/taxonomy_input.dart';

class ExampleHelper {
  TaxonomyInput carExample() {
    List<Criteria> _criterias = [
      Criteria("custo", CriteriaType.cost),
      Criteria("mala", CriteriaType.benefit),
      Criteria("seguranca", CriteriaType.benefit),
      Criteria("confort", CriteriaType.benefit),
      Criteria("tempo_de_entrega", CriteriaType.cost),
    ];
    List<List<double>> _alternatives = [
      [40, 380, 11, 9, 22],
      [52, 590, 13, 9, 10],
      [68, 710, 15, 13, 25],
      [92, 900, 18, 15, 2],
    ];

    List<String> _alternativesNames = ["ka", "onix", "prisma", "eco_esporte"];
    return TaxonomyInput(_criterias, _alternatives, _alternativesNames);
  }
}
