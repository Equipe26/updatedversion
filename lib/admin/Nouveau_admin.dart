import 'package:flutter/material.dart';

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
    return MaterialApp(debugShowCheckedModeBanner: false, home: NouveauAdmin());
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

class NouveauAdmin extends StatefulWidget {
  @override
  NouveauAdminState createState() => NouveauAdminState();
}

class NouveauAdminState extends State<NouveauAdmin> {
  bool isChecked = false;

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
                'Nouveau Administrateur',
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
                    "Nom Complet",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF396C9B),
                    ),
                  ),

                  SizedBox(height: 20),

                  TextField(
                    // Toggles hiding/showing password
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
                  SizedBox(height: 20),
                  Text(
                    "Numero de telephone",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF396C9B),
                    ),
                  ),

                  SizedBox(height: 20),
                  TextField(
                    // Toggles hiding/showing password
                    decoration: InputDecoration(
                      hintText: "Entrez Votre Numero de telephone",
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
                  SizedBox(height: 20),
                  Text(
                    "mot de passe",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF396C9B),
                    ),
                  ),

                  SizedBox(height: 20),
                  TextField(
                    // Toggles hiding/showing password
                    decoration: InputDecoration(
                      hintText: "Entrez Votre mot de passe",
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

                  SizedBox(height: 60),
                  Center(
                    child: SizedBox(
                      width: 300, // Set the width
                      height: 50, // Set the height
                      child: ElevatedButton(
                        onPressed: () {},
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
                          'Ajouter',
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
