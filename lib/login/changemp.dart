import 'package:flutter/material.dart';
import '../auth_service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomeS5());
  }
}

class HomeS5 extends StatefulWidget {
  @override
  _HomeS5State createState() => _HomeS5State();
}

class _HomeS5State extends State<HomeS5> {
  final TextEditingController _emailController = TextEditingController();
  final AuthService _authService = AuthService();
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  // Function to handle sending password reset email
  Future<void> _sendPasswordResetEmail() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
      _successMessage = null;
    });

    try {
      // Validate email
      final email = _emailController.text.trim();
      if (email.isEmpty) {
        setState(() {
          _errorMessage = "Veuillez entrer votre adresse email";
          _isLoading = false;
        });
        return;
      }

      // Call the auth service to send password reset email
      final success = await _authService.sendPasswordResetEmail(email: email);
      
      if (success) {
        setState(() {
          _successMessage = "Un email de réinitialisation a été envoyé à $email";
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
        if (_errorMessage!.contains("Exception: ")) {
          _errorMessage = _errorMessage!.split("Exception: ")[1];
        }
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        toolbarHeight: 60,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              margin: EdgeInsets.all(20),
              height: screenHeight * 0.7,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFFA3C3E4),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Column(
                children: [
                  Text(
                    "Mot de passe oublié",
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF396C9B),
                    ),
                  ),
                  SizedBox(height: 30),
                  Center(
                    child: Text(
                      "Entrez votre adresse email pour recevoir un lien de réinitialisation de mot de passe",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                  Center(
                    child: Text(
                      "Email",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF396C9B),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      hintText: "Entrer votre adresse email",
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
                    ),
                  ),
                  
                  if (_errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        _errorMessage!,
                        style: TextStyle(color: Colors.red, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    
                  if (_successMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(top: 16.0),
                      child: Text(
                        _successMessage!,
                        style: TextStyle(color: Colors.green, fontSize: 14),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    
                  SizedBox(height: 40),
                  _isLoading 
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF396C9B)),
                    )                  : ElevatedButton(
                      onPressed: _sendPasswordResetEmail,
                      child: Text(
                        'Envoyer le lien de réinitialisation', 
                        style: TextStyle(color: Colors.white)
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF396C9B),
                        foregroundColor: Colors.white,
                        elevation: 8,
                        padding: EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                    ),
                    
                  // Back to login button
                  SizedBox(height: 20),
                  TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Retour à la connexion",
                      style: TextStyle(
                        color: Color(0xFF396C9B),
                        fontWeight: FontWeight.bold,
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
