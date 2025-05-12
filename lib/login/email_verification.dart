import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../auth_service.dart';
import '../models/HealthcareProfessional.dart';
import 'connexion.dart';
import 'admin_validation_waiting.dart';

class EmailVerificationScreen extends StatefulWidget {
  final String email;

  const EmailVerificationScreen({Key? key, required this.email}) : super(key: key);

  @override
  _EmailVerificationScreenState createState() => _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  final AuthService _authService = AuthService();
  bool isEmailVerified = false;
  bool canResendEmail = true;
  Timer? timer;

  @override
  void initState() {
    super.initState();

    // Check if email is already verified
    checkEmailVerified();

    // Set up timer to check verification status periodically
    timer = Timer.periodic(Duration(seconds: 3), (_) {
      checkEmailVerified();
    });
  }

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  Future<void> checkEmailVerified() async {
    try {
      final verified = await _authService.isEmailVerified();
      
      if (verified) {
        timer?.cancel();
        setState(() {
          isEmailVerified = true;
        });
        
        // Give the user a moment to see the success message before navigating
        Future.delayed(Duration(seconds: 2), () async {
          // Check what type of user this is
          final user = await _authService.getCurrentUserData();
          
          if (user != null && user is HealthcareProfessional) {
            // Healthcare professionals need admin validation after email verification
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => AdminValidationWaitingScreen(
                  userId: user.id,
                ),
              ),
            );
          } else {
            // For patients, just go to login screen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => LoginScreen()),
            );
          }
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error checking verification: ${e.toString()}')),
      );
    }
  }

  Future<void> resendVerificationEmail() async {
    try {
      await _authService.sendEmailVerification();
      
      setState(() {
        canResendEmail = false;
      });

      // Enable resend again after a minute
      await Future.delayed(Duration(minutes: 1));
      if (mounted) {
        setState(() {
          canResendEmail = true;
        });
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Email de vérification envoyé')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Vérification Email'),
        backgroundColor: Color(0xFF396C9B),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Icon(
              isEmailVerified ? Icons.verified : Icons.mark_email_unread,
              size: 100,
              color: isEmailVerified ? Colors.green : Color(0xFF396C9B),
            ),
            SizedBox(height: 20),
            Text(
              'Vérifiez votre email',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF396C9B),
              ),
            ),
            SizedBox(height: 16),
            if (isEmailVerified)
              Text(
                'Email vérifié! Vous allez être redirigé vers la page de connexion.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.green),
              )
            else
              Column(
                children: [
                  Text(
                    'Un email de vérification a été envoyé à:',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 8),
                  Text(
                    widget.email,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    'Merci de cliquer sur le lien dans l\'email pour activer votre compte.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 32),
                  ElevatedButton(
                    onPressed: canResendEmail ? resendVerificationEmail : null,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF396C9B),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 24,
                      ),
                    ),
                    child: Text(
                      canResendEmail
                          ? 'Renvoyer l\'email de vérification'
                          : 'Patientez...',
                      style: TextStyle(fontSize: 16),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextButton(
                    onPressed: () {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => LoginScreen()),
                      );
                    },
                    child: Text(
                      'Retour à la page de connexion',
                      style: TextStyle(color: Color(0xFF396C9B)),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }
}