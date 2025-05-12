import 'package:flutter/material.dart';
import 'package:flutter_application_2/login/gastro.dart';
import 'package:flutter_application_2/login/inscription2.dart';
import 'package:flutter_application_2/login/ophto.dart';
import 'card.dart';
import 'derma.dart';
import 'gastro.dart';
import 'gene.dart';
import 'gyne.dart';
import 'orl.dart';
import 'ophto.dart';
import 'pedia.dart';
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
    return MaterialApp(debugShowCheckedModeBanner: false, home: Choix());
  }
}

Widget _buildCircleIconButton1({
  required IconData icon,
  required VoidCallback onTap,
  required String text,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      // Increased height for better spacing
      padding: EdgeInsets.symmetric(horizontal: 8), // Added padding
      width: 150,
      height: 30,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: Colors.blue),
          SizedBox(width: 5), // Spacing between icon and text
          Text(text),
        ],
      ),
    ),
  );
}

class Choix extends StatelessWidget {
  @override
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
                  SizedBox(height: 50),
                  SizedBox(
                    width: 300, // Set the width
                    height: 50, // Set the height
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Gene(),
                          ),
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
                        'Medecine générale',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  /* ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      'Patient',
                      style: TextStyle(color: Colors.white),
                    ),
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
                  ),*/
                  SizedBox(height: 16),
                  SizedBox(
                    width: 300, // Set the width
                    height: 50, // Set the height
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Gyne(),
                          ),
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
                        'Gynécologie obstétrique',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  /*   ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      'Personnel de Sante',
                      style: TextStyle(color: Colors.white),
                    ),
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
                  ),*/
                  SizedBox(height: 16),
                  SizedBox(
                    width: 300, // Set the width
                    height: 50, // Set the height
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Derma(),
                          ),
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
                        'Dermatologie',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: 300, // Set the width
                    height: 50, // Set the height
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Orl(),
                          ),
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
                        'ORL et chirurgie',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: 300, // Set the width
                    height: 50, // Set the height
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Gastro(),
                          ),
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
                        'Gastro-Entérologie',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: 300, // Set the width
                    height: 50, // Set the height
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Card1(),
                          ),
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
                        'Cardiologie',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: 300, // Set the width
                    height: 50, // Set the height
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => pedia(),
                          ),
                        );
                        // Navigator.push(
                        //   context,
                        // MaterialPageRoute(builder: (context) => ()),
                        // );
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
                        'Pédiatrie',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: 300, // Set the width
                    height: 50, // Set the height
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Ophto(),
                          ),
                        );
                        // Navigator.push(
                        //   context,
                        // MaterialPageRoute(builder: (context) => ()),
                        // );
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
                        'Ophtalmologie',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 20),
                
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
