
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class FirestoreService {
  final CollectionReference medicalRequests = FirebaseFirestore.instance.collection("medical_requests");

  Future<void> saveMedicalRequest(String imageUrl, String question, String answer) async {
    try {
      await medicalRequests.add({
        "image_url": imageUrl,
        "question": question,
        "answer": answer,
        "timestamp": DateTime.now(),
        "user_id": FirebaseAuth.instance.currentUser?.uid
      });
    } catch (e) {
      debugPrint("Erreur Firestore : $e");
    }
  }
}