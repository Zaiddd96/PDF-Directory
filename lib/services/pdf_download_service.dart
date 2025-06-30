import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class PdfDownloadService {
  Future<File> downloadAndSavePdf(String url, String filename) async {
    final pdfUrl = Uri.parse(url);
    final response = await http.get(pdfUrl);
    if (response.statusCode == 200){
      final pdf = response.bodyBytes;
      final dir = await getApplicationDocumentsDirectory();
      final filePath = "${dir.path}/$filename.pdf";
      final file = File(filePath);
      await file.writeAsBytes(pdf);
      return file;
    } else{
      throw Exception('Failed to download PDF');
    }
  }
}