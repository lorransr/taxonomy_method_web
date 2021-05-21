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
    var _normalizedMatrixArray =
        _helper.getMatrixArray(_data.results.normalizedMatrix, _alternatives);
    // var _weightedMatrixArray =
    //     _helper.getMatrixArray(_data.results.weightedMatrix, _alternatives);
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
            pw.Header(text: "Codas Method Result Sheet"),
            pw.Text("Normalized Matrix"),
            pw.Table.fromTextArray(data: _normalizedMatrixArray),
            pw.Divider(),
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
      ..download = 'codas_results.pdf';
    html.document.body.children.add(anchor);
    anchor.click();
    html.document.body.children.remove(anchor);
    html.Url.revokeObjectUrl(url);
  }
}
