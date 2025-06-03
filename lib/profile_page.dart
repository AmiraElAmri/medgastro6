import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ProfilePage extends StatelessWidget {
  final User? user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFE3F2FD),
              Color(0xFFFFFFFF),
              Color(0xFFE3F2FD),
            ],
            stops: [0.0, 0.5, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // En-tête personnalisé avec logo et titre
              Container(
                padding: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: [
                      Color(0xFF1263AF).withOpacity(0.95),
                      Color(0xFF1263AF).withOpacity(0.85),
                    ],
                  ),
                  borderRadius: BorderRadius.vertical(
                    bottom: Radius.elliptical(MediaQuery.of(context).size.width, 50),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    IconButton(
                      icon: Icon(Icons.arrow_back, color: Colors.white),
                      onPressed: () => Navigator.pop(context),
                    ),
                    Text(
                      'User Profile',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        shadows: [
                          Shadow(
                            color: Colors.black.withOpacity(0.3),
                            blurRadius: 4,
                            offset: Offset(0, 2),
                          )
                        ],
                      ),
                    ),
                    SizedBox(width: 24), // Espace pour aligner le texte au centre
                  ],
                ),
              ),

              // Contenu principal
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.95),
                    borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: Offset(0, -5),
                      )
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Avatar utilisateur
                        Center(
                          child: Container(
                            margin: EdgeInsets.symmetric(vertical: 30),
                            width: 120,
                            height: 120,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xFFDDEEFF),
                              border: Border.all(
                                color: Color(0xFF1263AF).withOpacity(0.3),
                                width: 2,
                              ),
                            ),
                            child: Icon(
                              Icons.person_outline,
                              size: 60,
                              color: Color(0xFF1263AF),
                            ),
                          ),
                        ),

                        // Section Email
                        ListTile(
                          leading: Icon(
                            Icons.email,
                            color: Color(0xFF1263AF),
                          ),
                          title: Text('Email', style: TextStyle(fontWeight: FontWeight.bold)),
                          subtitle: Text(user?.email ?? 'No email provided'),
                        ),
                        Divider(color: Colors.grey[300]),

                        // Section Réglages (non fonctionnelle)
                        ListTile(
                          leading: Icon(
                            Icons.settings,
                            color: Color(0xFF1263AF),
                          ),
                          title: Text('Settings', style: TextStyle(fontWeight: FontWeight.bold)),
                          onTap: () {
                            // Ajoutez votre logique ici
                            print('Settings tapped');
                          },
                        ),
                        Divider(color: Colors.grey[300]),

                        // Bouton de déconnexion
                        ListTile(
                          leading: Icon(
                            Icons.logout,
                            color: Colors.red,
                          ),
                          title: Text('Log out', style: TextStyle(color: Colors.red)),
                          onTap: () async {
                            await FirebaseAuth.instance.signOut();
                            Navigator.pushReplacementNamed(context, '/login');
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}