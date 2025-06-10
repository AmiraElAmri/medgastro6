import 'package:http/http.dart' as http;
import 'dart:io';
import 'dart:convert';

class ApiService {
  static const String _baseUrl = "https://vqa-medical-model-api.hf.space/predict";

  static Future<String> askQuestion(File imageFile, String question) async {
    var uri = Uri.parse(_baseUrl);

    var request = http.MultipartRequest('POST', uri);
    request.fields['question'] = question;

    // Ajouter l'image
    request.files.add(await http.MultipartFile.fromPath('image', imageFile.path));

    try {
      var response = await request.send();
      var resp = await response.stream.bytesToString();

      var data = jsonDecode(resp);
      return data["answer"];
    } catch (e) {
      print("Erreur lors de l'appel de l'API : $e");
      return "Erreur lors de la génération de la réponse";
    }
  }
}