import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_application_2/login/changemp.dart';
import '../screens/patient/home_screen.dart';
import '../firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import '../screens/medecin/home_screen.dart';
import '../screens/pharmacie/home_screen.dart';
import '../screens/clinique/home_screen.dart';
import '../auth_service.dart';
import '../yyu.dart';
import '../models/Patient.dart';
import 'inscription5.dart';
import '../models/HealthcareProfessional.dart';
import 'admin_validation_waiting.dart';
import '../admin/admin.dart';
import '../models/User.dart'; // Add import for admin screen

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true; // Toggles password visibility
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Veuillez remplir tous les champs')),
      );
      return;
    }

    // Check for admin credentials
    if (email == 'admin@gmail.com' && password == 'Admin1234') {
      // Navigate directly to admin screen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => Admin()),
      );
      return;
    }

    try {
      // print('Button was clicked!');

      final user = await AuthService().login(email: email, password: password);
      print('Button was clicked!');
      print(user.role);

      // Healthcare professionals may need admin validation
      if (user is HealthcareProfessional && !user.isValidatedByAdmin) {
        print('Button1');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => AdminValidationWaitingScreen(userId: user.id),
          ),
        );
        return;
      }

      // Regular navigation based on user role
      if (user.role == Role.patient) {
        /*Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (_) => PatientHomeScreen(patient: user as Patient),
          ),
        );*/
        print('Button2');
       
        print(user is Patient);
        if (user is Patient) {
           print('Button12');
          Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => PatientHomeScreen(patient: user as Patient),
          ),
          (Route<dynamic> route) => false, // remove all previous routes
        );
        }
       
      } else if (user.role == Role.healthcareProfessional) {
        print('Button3');
        print(user is HealthcareProfessional);
        print(user is Patient);
     
        if (user is HealthcareProfessional) {
          print('Button4');
             print(user.type);
          if (user.type == HealthcareType.clinique) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                      ClinicHomeScreen(user: user)),
            );
          } else if (user.type == HealthcareType.pharmacie) {
            print('Button5');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) => PharmacieHomeScreen(
                      user: user)),
            );
          } else if (user.type == HealthcareType.dentiste) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                      MedecinHomeScreen(user: user )),
            );
          } else if (user.type == HealthcareType.infermier) {
             print('Button6');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                      MedecinHomeScreen(user: user)),
            );
          } else if (user.type == HealthcareType.centre_imagerie) {

            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                      ClinicHomeScreen(user: user)),
            );
          } else if (user.type == HealthcareType.laboratoire_analyse) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                      ClinicHomeScreen(user: user)),
            );
          } else if (user.type == HealthcareType.medecin) {
            print('Button8');
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (_) =>
                      MedecinHomeScreen(user: user)),
            );
          } else {
            // Handle other types if necessary
            print('Unknown healthcare type: ${user.type}');
          }
        }
       
      }
      print('Button7');
      /* Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (_) => HomeScreen(user: user), // Create this screen
        ),
      );*/
    } catch (e, stacktrace) {
      print('Button8');
      print('Login failed: $e');
      print('Stacktrace: $stacktrace');
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Erreur: ${e.toString()}')));
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        // Allows the screen to scroll if the content is large
        child: Column(
          children: [
            // 1) Top Image
            Container(
              height: 400, // Adjust as needed
              width: double.infinity,
              child: Image.asset(
                'assets/1404bf94e1cee9f5066fce0a068c4cc0.jfif', // Update with your asset name
                fit: BoxFit.cover,
              ),
            ),

            // 2) Rounded White Container
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Title
                  Text(
                    'Bienvenue',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF396C9B),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Email / Phone TextField
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 32,
                    ),
                    decoration: const BoxDecoration(
                      color: Color(0xFFA3C3E4),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(40),
                        topRight: Radius.circular(40),
                        bottomLeft: Radius.circular(40),
                        bottomRight: Radius.circular(40),
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          "Email ou Numero de telephone",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF396C9B),
                          ),
                        ),

                        SizedBox(height: 16),

                        TextField(
                          controller: _emailController,
                          keyboardType: TextInputType.emailAddress,
                          // Toggles hiding/showing password
                          decoration: InputDecoration(
                            hintText: "Email ou Numero de telephone",
                            // Make background gray and fill the entire shape
                            fillColor: Colors.grey[300],
                            filled: true,
                            // Remove default border and make corners fully rounded
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            // Control the space inside the text field
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 14,
                            ),

                            // The icon on the right to toggle password visibility
                          ),
                        ),
                        SizedBox(height: 16),
                        // Password TextField
                        Text(
                          "Mot de passe",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF396C9B),
                          ),
                        ),

                        SizedBox(height: 16),

                        TextField(
                          controller: _passwordController,
                          obscureText:
                              _obscureText, // Toggles hiding/showing password
                          decoration: InputDecoration(
                            hintText: "Entrer Votre mot de passe",
                            // Make background gray and fill the entire shape
                            fillColor: Colors.grey[300],
                            filled: true,
                            // Remove default border and make corners fully rounded
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30),
                              borderSide: BorderSide.none,
                            ),
                            // Control the space inside the text field
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 20,
                              vertical: 14,
                            ),
                            // The icon on the right to toggle password visibility
                            suffixIcon: IconButton(
                              icon: Icon(
                                _obscureText
                                    ? Icons.visibility_off
                                    : Icons.visibility,
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureText =
                                      !_obscureText; // Toggle between true/false
                                });
                              },
                            ),
                          ),
                        ),

                        SizedBox(height: 16),
                        Center(
                          child: SizedBox(
                            //   width: double.infinity,
                            width: 200,
                            child: ElevatedButton(
                              onPressed: _handleLogin,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF396C9B),
                                foregroundColor: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                padding: const EdgeInsets.symmetric(
                                  vertical: 16,
                                ),
                              ),
                              child: const Text(
                                'Connexion',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // Forgot Password
                        Center(
                          child: TextButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => HomeS5(),
                                ),
                              );
                            },
                            child: const Text(
                              'Mot de passe oublié ?',
                              style: TextStyle(color: Color(0xFF396C9B)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
