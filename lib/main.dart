import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'log_in_page.dart';
import 'sign_up_page.dart';
import 'forgot_password_page.dart';
import 'home_page.dart'; // ✅ Import de HomePage
import 'auth_wrapper.dart'; // ✅ Pour la protection des routes

// ✅ Utilisez le fichier généré par FlutterFire (voir étape 2)
// import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Initialisation de Firebase (utilisez firebase_options.dart pour un projet réel)
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyDFVuwQjuWWhWftj-_ycr_eOGt8waP8v1A",
        authDomain: "medgastro6.firebaseapp.com",
        projectId: "medgastro6",
        storageBucket: "medgastro6.firebasestorage.app",
        messagingSenderId: "892623557940",
        appId: "1:892623557940:web:dc26234a14ffc245ee0161",
        measurementId: "G-RKMKWFH23H"
    ),
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MedGastro',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        fontFamily: 'Arial',
        colorScheme: ColorScheme.fromSwatch()
            .copyWith(primary: Color(0xFF1263AF))
            .copyWith(secondary: Color(0xFF1263AF)),
      ),
      debugShowCheckedModeBanner: false,
      // ✅ Utilisation de AuthWrapper pour la protection des routes
      home: AuthWrapper(),
      routes: {
        '/login': (context) => LoginPage(),
        '/signup': (context) => SignUpPage(),
        '/forgot-password': (context) => ForgotPasswordPage(),
        // '/home': (context) => HomePage(), // ❌ Remove this line
      },
    );
  }
}