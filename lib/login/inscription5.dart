/*import 'package:flutter/material.dart';
import 'package:flutter_application_2/login/inscription6.dart';
// mchi sur mais normalment mtss7a9ohch
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
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomeS11());
  }
}

class HomeS11 extends StatefulWidget {
  @override
  _HomeS11State createState() => _HomeS11State();
}

class _HomeS11State extends State<HomeS11> {
  @override
  Widget build(BuildContext context) {
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
              margin: EdgeInsets.only(top: 20),

              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 255, 255, 255),
              ),

              child: Column(
                children: [
                  Center(
                    child: Text(
                      "Domaine D''expertise",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF396C9B),
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  TextField(
                    // Toggles hiding/showing password
                    decoration: InputDecoration(
                      hintText: "Entrez Votre Domaine D''expertise",
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
                  Center(
                    child: Text(
                      "Type de prestation",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF396C9B),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    // Toggles hiding/showing password
                    decoration: InputDecoration(
                      hintText: "Entrez Votre Type de prestation",
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
                  Center(
                    child: Text(
                      "Nature",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF396C9B),
                      ),
                    ),
                  ),

                  SizedBox(height: 16),

                  TextField(
                    // Toggles hiding/showing password
                    decoration: InputDecoration(
                      hintText: "Entrez Votre Nature",
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
                    // Toggles hiding/showing password
                    decoration: InputDecoration(
                      hintText: "Entrez Votre Email",
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
                  SizedBox(height: 100),
                  SizedBox(
                    width: 200, // Set the width
                    height: 50, // Set the height
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => HomeS12()),
                        );
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
                  SizedBox(height: 16),
                  SizedBox(
                    width: 200, // Set the width
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
                        'Précédent',
                        style: TextStyle(color: Colors.white, fontSize: 18),
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
}*/
