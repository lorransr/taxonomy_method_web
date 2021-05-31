import 'package:taxonomy_method/helpers/table_helper.dart';
import 'package:taxonomy_method/model/model_results.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';
import 'package:universal_html/html.dart' as html;

class PDFProvider {
  var _helper = TableHelper();
  createPDF(ModelResults _data) async {
    final pdf = pw.Document();
    var _alternatives = _helper.getAlternatives(_data);
    var _rawMatrixArray =
        _helper.getMatrixArray(_data.results.rawMatrix, _alternatives);
    var _normalizedMatrixArray =
        _helper.getMatrixArray(_data.results.normalizedMatrix, _alternatives);
    var _normalizedMatrixFilteredArray = _helper.getMatrixArray(
        _data.results.normalizedMatrixFiltered, _alternatives);
    var _developmentAttributeArray = _helper.getSeriesArray(
        _data.results.developmentAttributes,
        header: ["Alternative", "Value"]);
    var _shortestDistanceArray = _helper.getSeriesArray(
        _data.results.shortestDistance.values,
        header: ["Alternative", "Value"]);
    var distanceMap = {
      "Avg Distance": _data.results.shortestDistance.mean,
      "Std Distance": _data.results.shortestDistance.std
    };
    var _distanceMapArray =
        _helper.getSeriesArray(distanceMap, header: ["Metric", "Value"]);
    var _acceptedRange = {
      "Lower Bound": _data.results.acceptedRange[0],
      "Upper Bound": _data.results.acceptedRange[1]
    };
    var _acceptendRangeArray =
        _helper.getSeriesArray(_acceptedRange, header: ["Bound", "Value"]);
    var _idealValuesArray = _helper.getSeriesArray(_data.results.idealValues,
        header: ["Criteria", "Value"]);
    var _developmentPattern = _helper.getSeriesArray(
        _data.results.developmentPattern,
        header: ["Alternative", "Value"]);
    // var _negativeIdealSolution =
    //     _helper.getVectorArray(_data.results.negativeIdealSolution);
    // var _euclidianDistance = _helper.getDistanceArray(
    //     _data.results.euclidianDistance, _alternatives);
    // var _manhathanDistance = _helper.getDistanceArray(
    //     _data.results.manhathanDistance, _alternatives);
    // var _relativeAssessmentMatrix = _helper.getComparrisonMatrixArray(
    //     _data.results.relativeAssessmentMatrix, _alternatives);
    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build: (pw.Context context) {
          return [
            pw.Header(text: "Taxonomy Method Result Sheet"),
            pw.Text('Development Attributes'),
            pw.Table.fromTextArray(data: _developmentAttributeArray),
            pw.Divider(),
            pw.Text("Inputs"),
            pw.Table.fromTextArray(data: _rawMatrixArray),
            pw.Divider(),
            pw.Text("Normalized Matrix"),
            pw.Table.fromTextArray(data: _normalizedMatrixArray),
            pw.Divider(),
            pw.Text("Shortest Distance"),
            pw.Table.fromTextArray(data: _shortestDistanceArray),
            pw.Divider(),
            pw.Text("Shortest Distance"),
            pw.Table.fromTextArray(data: _distanceMapArray),
            pw.Divider(),
            pw.Text("Accepted Range"),
            pw.Table.fromTextArray(data: _acceptendRangeArray),
            pw.Divider(),
            pw.Text("Normalized Matrix Filtered"),
            pw.Table.fromTextArray(data: _normalizedMatrixFilteredArray),
            pw.Divider(),
            pw.Text("Ideal Values"),
            pw.Table.fromTextArray(data: _idealValuesArray),
            pw.Divider(),
            pw.Text("Development Pattern"),
            pw.Table.fromTextArray(data: _developmentPattern)
            // pw.Text("Weighted Matrix"),
            // pw.Table.fromTextArray(data: _weightedMatrixArray),
            // pw.Divider(),
            // pw.Text("Negative Ideal Solution Matrix"),
            // pw.Table.fromTextArray(data: _negativeIdealSolution),
            // pw.Divider(),
            // pw.Text("Euclidian Distance from Negative Ideal Solution"),
            // pw.Table.fromTextArray(data: _euclidianDistance),
            // pw.Divider(),
            // pw.Text("Manhathan Distance from Negative Ideal Solution"),
            // pw.Table.fromTextArray(data: _manhathanDistance),
            // pw.Divider(),
            // pw.Text("Relative Assessment Matrix"),
            // pw.Table.fromTextArray(data: _relativeAssessmentMatrix),
          ];
        },
      ),
    );
    final bytes = await pdf.save();
    final blob = html.Blob([bytes], 'application/pdf');
    final url = html.Url.createObjectUrlFromBlob(blob);
    final anchor = html.document.createElement('a') as html.AnchorElement
      ..href = url
      ..style.display = 'none'
      ..download = 'taxonomy_method_results.pdf';
    html.document.body.children.add(anchor);
    anchor.click();
    html.document.body.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }
}
