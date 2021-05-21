import 'package:taxonomy_method/model/taxonomy_input.dart';
import 'package:taxonomy_method/model/model_results.dart';
import 'package:taxonomy_method/repository/result_repository.dart';
import 'package:rxdart/rxdart.dart';

class ResultsBloc {
  final _repository = ResultsRepository();
  final BehaviorSubject<ModelResults> _subject =
      BehaviorSubject<ModelResults>();

  getRanking(TaxonomyInput input) async {
    ModelResults response = await _repository.getRanking(input);
    _subject.sink.add(response);
  }

  dispose() {
    _subject.close();
  }

  BehaviorSubject<ModelResults> get subject => _subject;
}

final resultsBloc = ResultsBloc();
