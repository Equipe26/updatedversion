import 'package:flutter/material.dart';
import '../auth_service.dart';
import '../yyu.dart';

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
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomeS5());
  }
}

class HomeS5 extends StatefulWidget {
  @override
  _HomeS5State createState() => _HomeS5State();
}

class _HomeS5State extends State<HomeS5> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _obscureText = true;

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
                children: [
                  Text(
                    "Changer de mot de passe",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF396C9B),
                    ),
                  ),
                  SizedBox(height: 30),
                  Center(
                    child: Text(
                      "Choisissez un nouveau mot de passe securuisé:",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ),
                  SizedBox(height: 110),
                  Center(
                    child: Text(
                      "Nouveau Mot de passe",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF396C9B),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
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
                    child: Text(
                      "Confirmer le Mot de passe",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF396C9B),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    obscureText:
                        _obscureText, // Toggles hiding/showing password
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
                  SizedBox(height: 50),
                  ElevatedButton(
                    onPressed: () {},
                    child:
                        Text('Changer', style: TextStyle(color: Colors.white)),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(
                        0xFF396C9B,
                      ), // Use backgroundColor instead of primary
                      foregroundColor: Colors.white,
                      elevation: 8, // Shadow elevation
                      // Shadow color
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
