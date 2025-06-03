
import 'package:flutter/material.dart';
import 'huggingface_api.dart';
import 'firestore_service.dart';

class DiagnosisScreen extends StatefulWidget {
  @override
  _DiagnosisScreenState createState() => _DiagnosisScreenState();
}

class _DiagnosisScreenState extends State<DiagnosisScreen> {
  final HuggingFaceService _hfService = HuggingFaceService();
  final FirestoreService _firestoreService = FirestoreService();

  Future<void> analyzeImageAndSaveToFirestore(String imageUrl, String question) async {
    try {
      final diagnosis = await _hfService.getDiagnosisFromImageAndQuestion(imageUrl, question);
      await _firestoreService.saveMedicalRequest(imageUrl, question, diagnosis);
      // Affichez le diagnostic à l’utilisateur
      print("Diagnostic : $diagnosis");
    } catch (e) {
      print("error : $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Analyze an image")),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            final imageUrl = "https://votre-image-url.jpg "; // Remplacez par l’URL réelle
            final question = "What is the diagnosis?";
            await analyzeImageAndSaveToFirestore(imageUrl, question);
          },
          child: Text("Analyze"),
        ),
      ),
    );
  }
}