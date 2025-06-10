import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

import 'api_service.dart';

class MedicalModelPage extends StatefulWidget {
  @override
  _MedicalModelPageState createState() => _MedicalModelPageState();
}

class _MedicalModelPageState extends State<MedicalModelPage> {
  File? _image;
  String _response = "";

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _image = File(pickedFile.path);
      });
    }
  }

  Future<void> _sendToModel(String question) async {
    if (_image == null) {
      setState(() {
        _response = "Veuillez sélectionner une image.";
      });
      return;
    }

    try {
      String answer = await ApiService.askQuestion(_image!, question);
      setState(() {
        _response = answer;
      });
    } catch (e) {
      setState(() {
        _response = "Erreur lors de la génération de la réponse.";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Modèle Médical Multimodal"),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: _pickImage,
              child: Text("Sélectionner une image"),
            ),
            SizedBox(height: 20),
            TextField(
              decoration: InputDecoration(labelText: "Posez votre question"),
              onChanged: (value) {},
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                String question = "Quelle est la réponse ?"; // Remplacez par la question saisie
                _sendToModel(question);
              },
              child: Text("Envoyer à l'API"),
            ),
            SizedBox(height: 20),
            Text(
              _response,
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}