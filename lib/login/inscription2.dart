import 'package:flutter/material.dart';

import '../yyu.dart';
import 'paccueil2.dart';
import 'inscription3.dart';
import 'inscription%3.dart';
import 'inscription1.dart';
import '../models/Map.dart';
void main() {
  runApp(MyApp());
}

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
bool isValidEmail(String email) {
  final emailRegex = RegExp(r"^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$");
  return emailRegex.hasMatch(email);
}

Widget buildCon(String ty) {
  return ElevatedButton(
    onPressed: () {},
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue, // Button background color
      foregroundColor: Colors.white, // Text color
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 12,
      ), // Padding
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Rounded corners
      ),
      elevation: 5, // Shadow effect
    ),
    child: Text(
      ty,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
  );
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomeS7());
  }
}

class HomeS7 extends StatefulWidget {
  @override
  _HomeS7State createState() => _HomeS7State();
}

class _HomeS7State extends State<HomeS7> {
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _closeContactController = TextEditingController();
  String? errorMessage;
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
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF396C9B),
                      ),
                    ),
                  ),
                  SizedBox(height: 30),

                  Text(
                    "Nom complet",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF396C9B),
                    ),
                  ),

                  SizedBox(height: 16),

                  TextField(
                    // Toggles hiding/showing password
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: "Entrer Votre Nom complet",
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
                    "Email",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF396C9B),
                    ),
                  ),

                  SizedBox(height: 16),
                  TextField(
                    // Toggles hiding/showing password
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: "Entrer votre Email",
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
                    "Adresse Postal",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF396C9B),
                    ),
                  ),

                  SizedBox(height: 16),
                  TextField(
                    // Toggles hiding/showing password
                    controller: _addressController,
                    decoration: InputDecoration(
                      hintText: "Entrer votre Adresse Postal",
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
                    "Numero proche",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF396C9B),
                    ),
                  ),

                  SizedBox(height: 16),
                  TextField(
                    // Toggles hiding/showing password
                    controller: _closeContactController,
                    decoration: InputDecoration(
                      hintText: "Entrer le Numero du votre proche",
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
                  SizedBox(height: 16),
                  Center(
                    child: SizedBox(
                      width: 200, // Set the width
                      height: 50, // Set the height
                      child: ElevatedButton(
                        onPressed: () {
                          final name = _nameController.text.trim();
                          final email = _emailController.text.trim();
                          final addresse = _addressController.text.trim();
                          final close = _closeContactController.text.trim();
                          if (name.isEmpty ||
                              email.isEmpty ||
                              addresse.isEmpty ||
                              close.isEmpty) {
                            setState(() {
                              errorMessage =
                                  "Tous les champs sont obligatoires.";
                            });
                          } else if (!isValidEmail(email)) {
                            // if phone is used as email
                            setState(() {
                              errorMessage = "Format d'email invalide.";
                            });
                            return;
                          } else {
                            setState(() {
                              errorMessage = null; // Clear error message
                            });
                            if (pr == 1) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => HomeS10(
                                        name: _nameController.text,
                                        email: _emailController.text,
                                        address: _addressController.text,
                                        closeContact:
                                            _closeContactController.text,
                                      ),
                                ),
                              );
                            }
                            ;
                           /* if (pr == 2) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => HomeS9(
                                        name: _nameController.text,
                                        email: _emailController.text,
                                        address: _addressController.text,
                                        closeContact:
                                            _closeContactController.text,
                                      ),
                                ),
                              );
                            }
                            ;*/
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
                          style: TextStyle(color: Colors.white, fontSize: 18),
                        ),
                      ),
                    ),
                  ),

                  SizedBox(height: 16),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
