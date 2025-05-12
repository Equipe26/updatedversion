import 'package:flutter/material.dart';
import '../auth_service.dart';
import '../yyu.dart';
import '../login/inscription5.dart';
import '../login/connexion.dart';

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

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: chmdp_admin());
  }
}

// État de la case à cocher

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

class chmdp_admin extends StatefulWidget {
  @override
  chmdp_adminState createState() => chmdp_adminState();
}

class chmdp_adminState extends State<chmdp_admin> {
  bool isChecked = false;
  bool _obscureText = true;
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  String? _statusMessage; // for feedback message
  Color _statusColor = Colors.red; // red for errors, green for success
  bool _isPasswordValid = false;
  
  @override
  void initState() {
    super.initState();
    // Add listener to password field to check validity as user types
    newPasswordController.addListener(() {
      final password = newPasswordController.text;
      setState(() {
        _isPasswordValid = password.isNotEmpty && AuthService().isPasswordValid(password);
      });
    });
  }
  
  @override
  void dispose() {
    currentPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  void updatePassword() async {
    // Show loading indicator
    setState(() {
      _statusMessage = "Traitement en cours...";
      _statusColor = Colors.blue;
    });

    final currentPassword = currentPasswordController.text.trim();
    final newPassword = newPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (currentPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmPassword.isEmpty) {
      setState(() {
        _statusMessage = "Veuillez remplir tous les champs.";
        _statusColor = Colors.red;
      });
      return;
    }

    if (newPassword != confirmPassword) {
      setState(() {
        _statusMessage = "Les mots de passe ne correspondent pas.";
        _statusColor = Colors.red;
      });
      return;
    }
    
    if (!_isPasswordValid) {
      setState(() {
        _statusMessage = "Le mot de passe doit contenir au moins 8 caractères et une lettre majuscule.";
        _statusColor = Colors.red;
      });
      return;
    }

    try {
      // Use AuthService to update the password
      await AuthService().updatePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );

      setState(() {
        _statusMessage = "Mot de passe modifié avec succès.";
        _statusColor = Colors.green;
        
        // Reset form
        currentPasswordController.clear();
        newPasswordController.clear();
        confirmPasswordController.clear();
      });
      
      // Show confirmation dialog
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Succès", style: TextStyle(color: Colors.green)),
            content: Text("Votre mot de passe a été modifié avec succès."),
            actions: [
              TextButton(
                child: Text("OK"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } catch (e) {
      String errorMessage = e.toString();
      
      // Extract the message from Exception
      if (errorMessage.contains("Exception: ")) {
        errorMessage = errorMessage.split("Exception: ")[1];
      }
      
      // Show specific error messages for common issues
      if (errorMessage.contains("Incorrect current password")) {
        errorMessage = "Mot de passe actuel incorrect.";
      } else if (errorMessage.contains("User not logged in")) {
        errorMessage = "Veuillez vous reconnecter avant de modifier votre mot de passe.";
      }
      
      setState(() {
        _statusMessage = "Erreur: $errorMessage";
        _statusColor = Colors.red;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: const Color(0xFFA3C3E4),
        elevation: 0,
        title: Center(
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.key, color: Color(0xFF073057)),
              SizedBox(width: 10),
              Text(
                'Gestion de mot de passe',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color(0xFF073057),
                ),
              ),
            ],
          ),
        ),
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
                  SizedBox(height: 40),

                  Text(
                    "Mot de passe actuel",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF396C9B),
                    ),
                  ),

                  SizedBox(height: 20),

                  TextField(
                    controller: currentPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      hintText: "Entrer Votre mot de passe actuel",
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
                    ),
                  ),
                  SizedBox(height: 20),
                  Text(
                    "Nouveau mot de passe",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF396C9B),
                    ),
                  ),

                  SizedBox(height: 20),
                  TextField(
                    controller: newPasswordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                      hintText: "Entrez Votre nouveau mot de passe",
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
                      suffixIcon: IconButton(
                        icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                  ),
                  
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
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
                    "Confirmer le mot de passe",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF396C9B),
                    ),
                  ),

                  SizedBox(height: 20),
                  TextField(
                    controller: confirmPasswordController,
                    obscureText: _obscureText,
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
                      suffixIcon: IconButton(
                        icon: Icon(_obscureText ? Icons.visibility_off : Icons.visibility),
                        onPressed: () {
                          setState(() {
                            _obscureText = !_obscureText;
                          });
                        },
                      ),
                    ),
                  ),
                  
                  if (_statusMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 20.0),
                      child: Center(
                        child: Text(
                          _statusMessage!,
                          style: TextStyle(
                            color: _statusColor,
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                    ),

                  SizedBox(height: 40),
                  Center(
                    child: SizedBox(
                      width: 300, // Set the width
                      height: 50, // Set the height
                      child: ElevatedButton(
                        onPressed: updatePassword,
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
                          'Modifier le mot de passe',
                          style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
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
