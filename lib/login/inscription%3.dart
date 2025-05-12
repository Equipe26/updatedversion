import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_application_2/admin/user.dart';
import '../yyu.dart';
import '../auth_service.dart';
import 'inscription5.dart';
import 'inscription4.dart';
import '../models/Map.dart';
import '../models/HealthcareProfessional.dart';
import 'inscription.dart';
/*class Main2Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Main2 Page")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context); // Goes back to the previous page
          },
          child: Text("Back to Main"),
        ),
      ),
    );
  }
}*/

class HomeS9 extends StatefulWidget {
  final String name;
  final String email;
  final String address;
  final AlgerianWilayas closeContact;

  HomeS9({
    required this.name,
    required this.email,
    required this.address,
    required this.closeContact,
  });
  @override
  _HomeS9State createState() => _HomeS9State();
}

class _HomeS9State extends State<HomeS9> {
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  String? errorMessage;
  bool _isPasswordValid = false;
   Gender?
 _selectedsexe;
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    // Add listener to password field to check validity as user types
    _passwordController.addListener(() {
      final password = _passwordController.text;
      setState(() {
        _isPasswordValid =
            password.isNotEmpty && _authService.isPasswordValid(password);
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
                  SizedBox(height: 60),
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
                    // Toggles hiding/showing password
                    controller: _passwordController,
                    obscureText: true,
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
                      suffixIcon: Icon(
                        _isPasswordValid ? Icons.check_circle : null,
                        color: Colors.green,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Row(
                      children: [
                        Icon(
                          _isPasswordValid
                              ? Icons.check_circle
                              : Icons.info_outline,
                          color: _isPasswordValid ? Colors.green : Colors.amber,
                          size: 16,
                        ),
                        SizedBox(width: 8),
                        Flexible(
                          child: Text(
                            "Le mot de passe doit contenir au moins 8 caractères et une lettre majuscule",
                            style: TextStyle(
                              fontSize: 12,
                              color: _isPasswordValid
                                  ? Colors.green
                                  : Colors.amber,
                              fontStyle: FontStyle.italic,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Confirmer votre mot de passe",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF396C9B),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _confirmPasswordController,
                    // Toggles hiding/showing password
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
                  SizedBox(height: 16),
                  Text(
                    "Sexe",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF396C9B),
                    ),
                  ),
                  SizedBox(height: 16),
                  DropdownButtonFormField<Gender>(
                    value: _selectedsexe,
                    decoration: InputDecoration(
                      fillColor: Colors.grey[300],
                      filled: true,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                      contentPadding:
                          EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                    ),
                    hint: Text("Sélectionner votre Sexe"),
                    items: Gender.values.map((sexe) {
                      return DropdownMenuItem(
                        value: sexe,
                        child: Text(sexe.name
                            .replaceAllMapped(RegExp(r'([A-Z])'),
                                (match) => ' ${match.group(0)}')
                            .capitalize()),
                      );
                    }).toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedsexe = value;
                      });
                    },
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
                  Center(
                    child: SizedBox(
                      width: 200, // Set the width
                      height: 50, // Set the height
                      child: ElevatedButton(
                        onPressed: () {
                          if (_passwordController.text.isEmpty ||
                              _confirmPasswordController.text.isEmpty || _selectedsexe == null) {
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
                          } else if (!_isPasswordValid) {
                            setState(() {
                              errorMessage =
                                  "Le mot de passe doit contenir au moins 8 caractères et une lettre majuscule.";
                            });
                          } else {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => HomeS8(
                                  password: _passwordController.text.trim(),
                                  name: widget.name,
                                  email: widget.email,
                                  address: widget.address,
                                  closeContact: widget.closeContact,
                                  gender: _selectedsexe ?? Gender.male,
                                ),
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF396C9B), // Button color
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
                          'Suivant',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
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
