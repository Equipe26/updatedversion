import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_2/admin/user.dart';
import '../auth_service.dart';
import '../yyu.dart';
import '../screens/patient/home_screen.dart';
import 'inscription5.dart';
import 'connexion.dart' hide AuthService, Patient;
import '../models/Patient.dart';
import 'email_verification.dart';

class TermsAndConditions extends StatelessWidget {
  final bool isChecked;
  final ValueChanged<bool?> onChanged;

  const TermsAndConditions({
    Key? key,
    required this.isChecked,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Checkbox(
          value: isChecked,
          onChanged: onChanged,
          activeColor: const Color(0xFF396C9B),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
        RichText(
          text: const TextSpan(
            children: [
              TextSpan(
                text: "J’accepte les ",
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                ),
              ),
              TextSpan(
                text: "termes et conditions",
                style: TextStyle(
                  fontSize: 16,
                  color: Color(0xFF396C9B),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class HomeS10 extends StatefulWidget {
  final String name;
  final String email;
  final String address;
  final String closeContact;

  HomeS10({
    required this.name,
    required this.email,
    required this.address,
    required this.closeContact,
  });
  @override
  _HomeS10State createState() => _HomeS10State();
}

class _HomeS10State extends State<HomeS10> {
  bool isChecked = false;
  bool _obscureText = true;
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? errorMessage;
  final AuthService _authService = AuthService();
  bool _isPasswordValid = false;
  
  @override
  void initState() {
    super.initState();
    // Add listener to password field to check validity as user types
    _passwordController.addListener(() {
      final password = _passwordController.text;
      setState(() {
        _isPasswordValid = password.isNotEmpty && _authService.isPasswordValid(password);
      });
    });
  }
  
  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        toolbarHeight: 60, // Creates more space at the top
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              margin: EdgeInsets.all(20),
              height: screenHeight * 0.8,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
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
                children: [
                  Center(
                    child: Text(
                      "Nouveau Compte",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF396C9B),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  Text(
                    "Mot de passe",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF396C9B),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    obscureText: _obscureText,
                    controller: _passwordController,
                    decoration: InputDecoration(
                      hintText: "Entrer Votre mot de passe",
                      fillColor: Colors.grey[300],
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding: EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 14,
                      ),
                      suffixIcon: IconButton(
                        icon: Icon(
                          _obscureText ? Icons.visibility_off : Icons.visibility,
                        ),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        Icon(
                          _isPasswordValid ? Icons.check_circle : Icons.info_outline,
                          color: _isPasswordValid ? Colors.green : Colors.amber,
                          size: 16,
                        ),
                        SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            "Le mot de passe doit contenir au moins 8 caractères et une lettre majuscule",
                            style: TextStyle(
                              fontSize: 12,
                              color: _isPasswordValid ? Colors.green : Colors.amber,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Confirmer votre mot de passe",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF396C9B),
                    ),
                  ),
                  SizedBox(height: 20),
                  TextField(
                    // Toggles hiding/showing password
                    controller: _confirmPasswordController,
                    decoration: InputDecoration(
                      hintText: "Confirmer Votre mot de passe",
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
                  if (errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: Text(
                        errorMessage!,
                        style: TextStyle(color: Colors.red, fontSize: 16),
                      ),
                    ),
                  SizedBox(height: 100),
                  TermsAndConditions(
                    isChecked: isChecked,
                    onChanged: (bool? newValue) {
                      setState(() {
                        isChecked = newValue ?? false;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: SizedBox(
                      width: 200, // Set the width
                      height: 50, // Set the height
                      child: ElevatedButton(
                        onPressed: () async {
                          // Validate password and confirm password
                          if (_passwordController.text.isEmpty ||
                              _confirmPasswordController.text.isEmpty) {
                            setState(() {
                              errorMessage =
                                  "Tous les champs sont obligatoires.";
                            });
                          } else if (_passwordController.text !=
                              _confirmPasswordController.text) {
                            setState(() {
                              errorMessage =
                                  "Les mots de passe ne correspondent pas.";
                            });
                          } else if (!isChecked) {
                            setState(() {
                              errorMessage =
                                  "Vous devez accepter les termes et conditions.";
                            });
                          } else {
                            setState(() {
                              errorMessage = null; // Clear error message
                            });

                            try {
                              // Sign up the patient
                              Patient newPatient =
                                  await _authService.signUpAsPatient(
                                email: widget.email,
                                password: _passwordController.text.trim(),
                                name: widget.name,
                                location: widget.address,
                                emergencyContactPhone: widget.closeContact,
                              );

                              // Navigate to email verification screen
                             Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EmailVerificationScreen(
                                    email: widget.email,
                                  ),
                                ),
                              );
                              /* Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PatientHomeScreen(
                                    patient: newPatient,
                                  ),
                                ),
                              );*/
                            } catch (e) {
                              setState(() {
                                errorMessage =
                                    "Erreur lors de l'inscription: ${e.toString()}";
                              });
                            }
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isChecked
                              ? Color(0xFF396C9B)
                              : Color(0xFFD9D9D9), // Button color
                          foregroundColor: Colors.white, // Text color
                          elevation: 8, // Shadow elevation
                          padding: EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              30,
                            ), // Rounded corners
                          ),
                        ),
                        child: Text(
                          'S'
                          'inscrire',
                          style: TextStyle(
                            color: isChecked
                                ? Color.fromARGB(255, 255, 255, 255)
                                : Color.fromARGB(255, 0, 0, 0),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Vous avez déjà un compte? ',
                        style: TextStyle(color: Colors.black, fontSize: 18),
                      ),
                      GestureDetector(
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => LoginScreen(),
                            ), // Replace with your login page
                          );
                        },
                        child: Text(
                          'Connecter',
                          style: TextStyle(
                            color: Color(0xFF396C9B),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            // Optional for better visibility
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
