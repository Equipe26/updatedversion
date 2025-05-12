import 'dart:async';
import 'package:flutter/material.dart';
import '../auth_service.dart';
import '../models/HealthcareProfessional.dart';
import '../screens/medecin/home_screen.dart';
import '../screens/pharmacie/home_screen.dart';
import '../screens/clinique/home_screen.dart';
import 'connexion.dart';

class AdminValidationWaitingScreen extends StatefulWidget {
  final String userId;
  
  const AdminValidationWaitingScreen({
    Key? key,
    required this.userId,
  }) : super(key: key);

  @override
  _AdminValidationWaitingScreenState createState() => _AdminValidationWaitingScreenState();
}

class _AdminValidationWaitingScreenState extends State<AdminValidationWaitingScreen> {
  final AuthService _authService = AuthService();
  Timer? _timer;
  bool _isChecking = false;

  @override
  void initState() {
    super.initState();
    // Check validation status every 30 seconds
    _timer = Timer.periodic(Duration(seconds: 5), (_) {
      _checkValidationStatus();
    });
    
    // Initial check
    _checkValidationStatus();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  Future<void> _checkValidationStatus() async {
    if (_isChecking) return;
    
    setState(() {
      _isChecking = true;
    });
    
    try {
      final user = await _authService.getCurrentUserData();
      if (user != null && user is HealthcareProfessional && user.isValidatedByAdmin) {
        _timer?.cancel();
        _navigateToAppropriateScreen(user);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Une erreur est survenue: ${e.toString()}')),
      );
    } finally {
      if (mounted) {
        setState(() {
          _isChecking = false;
        });
      }
    }
  }
  
  void _navigateToAppropriateScreen(HealthcareProfessional user) {
    switch (user.type) {
      case HealthcareType.medecin:
      case HealthcareType.dentiste:
      case HealthcareType.infermier:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => MedecinHomeScreen(user: user)),
        );
        break;
      case HealthcareType.pharmacie:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => PharmacieHomeScreen(user: user)),
        );
        break;
      case HealthcareType.clinique:
      case HealthcareType.centre_imagerie:
      case HealthcareType.laboratoire_analyse:
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => ClinicHomeScreen(user: user)),
        );
        break;
      default:
        // Default case if none of the above match
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => MedecinHomeScreen(user: user)),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 40.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(
                Icons.hourglass_top,
                size: 100,
                color: Color(0xFF396C9B),
              ),
              SizedBox(height: 40),
              Text(
                'Compte en attente de validation',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF396C9B),
                ),
              ),
              SizedBox(height: 20),
              Text(
                'Votre compte a été créé avec succès et votre email a été vérifié. Un administrateur doit maintenant valider votre compte avant que vous puissiez y accéder.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 40),
              CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF396C9B)),
              ),
              SizedBox(height: 40),
              Text(
                'Cette page se mettra à jour automatiquement une fois votre compte validé.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 14,
                  fontStyle: FontStyle.italic,
                  color: Colors.grey[700],
                ),
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: _isChecking ? null : _checkValidationStatus,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF396C9B),
                  padding: EdgeInsets.symmetric(horizontal: 30, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: Text(
                  'Vérifier maintenant',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              SizedBox(height: 20),
              TextButton(
                onPressed: () {
                  _authService.logout();
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(builder: (_) => LoginScreen()),
                  );
                },
                child: Text(
                  'Se déconnecter',
                  style: TextStyle(
                    color: Colors.red,
                    fontSize: 16,
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