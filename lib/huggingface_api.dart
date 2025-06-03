// lib/services/huggingface_api.dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class HuggingFaceService {
  static const String modelUrl = "https://api-inference.huggingface.co/models/AmiraAmri/multimodal-gastro ";
  static const String hfToken = "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   "; // Remplacez par votre token avec permission "read"

  Future<String> getDiagnosisFromImageAndQuestion(String imageUrl, String question) async {
    final response = await http.post(
        Uri.parse(modelUrl),
        headers: {"Authorization": "Bearer $hfToken"},
        body: jsonEncode({
          "inputs": {
            "image_url": imageUrl,
            "question": question
          }
        })
    );

    if (response.statusCode == 200) {
      final answer = jsonDecode(response.body)["generated_text"];
      return answer;
    } else {
      throw Exception("Hugging Face API call failed: ${response.reasonPhrase}");
    }
  }
}