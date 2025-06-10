import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:flutter/foundation.dart'; // Pour Platform.isWeb

class AnalysisPage extends StatefulWidget {
  @override
  _AnalysisPageState createState() => _AnalysisPageState();
}

class _AnalysisPageState extends State<AnalysisPage> {
  final _formKey = GlobalKey<FormState>();
  final _questionController = TextEditingController();
  dynamic _selectedImage; // Peut être File (mobile) ou Uint8List (web)
  String _answer = '';
  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();

  // Méthode pour choisir l'image (depuis galerie ou caméra)
  Future<void> _pickImageFrom(ImageSource source) async {
    try {
      final XFile? pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 70,
      );

      if (pickedFile != null) {
        dynamic imageData;

        if (kIsWeb) {
          imageData = await pickedFile.readAsBytes(); // Pour le web
        } else {
          imageData = File(pickedFile.path); // Pour Android/iOS
        }

        setState(() {
          _selectedImage = imageData;
        });
      }
    } catch (e) {
      debugPrint('Error when selecting the image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: Unable to load the image')),
      );
    }
  }

  void _generateAnswer() async {
    if (_formKey.currentState!.validate() && _selectedImage != null) {
      setState(() => _isLoading = true);

      final String apiUrl = "https://vqa-medical-model-api.hf.space/predict";

      try {
        var request = http.MultipartRequest('POST', Uri.parse(apiUrl));

        if (kIsWeb) {
          // Pour le web : envoyer l'image en tant que List<int>
          request.files.add(
            http.MultipartFile.fromBytes(
              'image',
              _selectedImage,
              filename: 'image.jpg',
            ),
          );
        } else {
          // Pour Android/iOS : envoyer un fichier image réel
          File imageFile = _selectedImage;
          var stream = http.ByteStream(imageFile.openRead());
          var length = await imageFile.length();
          var multipartFile = http.MultipartFile(
            'image',
            stream,
            length,
            filename: imageFile.path.split('/').last,
          );
          request.files.add(multipartFile);
        }

        // Ajouter la question au formulaire
        request.fields['question'] = _questionController.text;

        // Envoyer la requête
        var response = await request.send();

        // Lire la réponse
        final resp = await response.stream.bytesToString();
        final data = jsonDecode(resp);

        setState(() {
          _isLoading = false;
          _answer = data["answer"];
        });
      } catch (e) {
        setState(() {
          _isLoading = false;
          _answer = "❌ Error: $e";
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Medical Analysis',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color(0xFF1263AF),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Section d'importation d'image
              Container(
                height: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: _selectedImage != null
                        ? Color(0xFF1263AF).withValues(alpha: 0x99)
                        : Colors.grey.withValues(alpha: 0x4D),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withValues(alpha: 0x1A),
                      blurRadius: 5,
                      offset: Offset(0, 3),
                    )
                  ],
                ),
                child: Center(
                  child: _selectedImage == null
                      ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () =>
                            _pickImageFrom(ImageSource.gallery),
                        icon: Icon(Icons.image, color: Colors.white),
                        label: Text(" Add image"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF1263AF),
                          foregroundColor: Colors.white,      // Texte blanc
                          padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                      SizedBox(width: 16),
                      ElevatedButton.icon(
                        onPressed: () =>
                            _pickImageFrom(ImageSource.camera),
                        icon: Icon(Icons.camera_alt, color: Colors.white),
                        label: Text(" Camera"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF1263AF),
                          foregroundColor: Colors.white,      // Texte blanc
                          padding:
                          EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                      ),
                    ],
                  )
                      : _buildImagePreview(_selectedImage),
                ),
              ),

              SizedBox(height: 30),

              // Champ de question
              TextFormField(
                controller: _questionController,
                maxLines: 3,
                decoration: InputDecoration(
                  labelText: 'Ask your question',
                  hintText: 'Describe your request regarding the image...',
                  labelStyle: TextStyle(color: Color(0xFF1263AF)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide:
                    BorderSide(color: Color(0xFF1263AF), width: 2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please enter your question';
                  }
                  return null;
                },
              ),

              SizedBox(height: 20),

              // Bouton d'analyse
              ElevatedButton.icon(
                onPressed: _generateAnswer,
                icon: Icon(Icons.check_circle, size: 20),
                label: Text(' Analyze'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF1263AF),
                  foregroundColor: Colors.white,      // Texte blanc
                  padding: EdgeInsets.symmetric(vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),

              SizedBox(height: 30),

              // Zone de réponse
              Container(
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.15),
                      spreadRadius: 1,
                      blurRadius: 8,
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Response:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color(0xFF1263AF),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      _answer.isNotEmpty
                          ? _answer
                          : 'No results to display. Please import an image and ask a question.',
                      style: TextStyle(fontSize: 16),
                    ),
                  ],
                ),
              ),

              // Indicateur de chargement
              if (_isLoading)
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Center(
                    child: CircularProgressIndicator(
                      color: Color(0xFF1263AF),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper function to build image preview based on platform
  Widget _buildImagePreview(dynamic image) {
    if (kIsWeb) {
      return Image.memory(
        image as Uint8List,
        fit: BoxFit.cover,
        height: 200,
      );
    } else {
      return Image.file(
        image as File,
        fit: BoxFit.cover,
        height: 200,
      );
    }
  }
}