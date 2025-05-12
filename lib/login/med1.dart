import 'package:flutter/material.dart';

import '../yyu.dart';

import 'inscription5.dart';
import 'med2.dart';

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
    return MaterialApp(debugShowCheckedModeBanner: false, home: Med1());
  }
}

// État de la case à cocher

class Med1 extends StatefulWidget {
  @override
  med1State createState() => med1State();
}

class med1State extends State<Med1> {
  bool isChecked = false;
  bool _obscureText = true;
  String _selectedValue = 'Oui';
  Set<String> _selectedOptions = {};
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
                  SizedBox(height: 40),
                  Center(
                    child: Text(
                      "Choisis vos types de prestations:",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  _buildOption('Consultations medicals'),
                  SizedBox(height: 16),
                  _buildOption('Soins infirmiers'),
                  SizedBox(height: 16),
                  _buildOption('Opérations chirurgicales'),
                  SizedBox(height: 16),

                  SizedBox(height: 16),

                  SizedBox(height: 16),

                  SizedBox(height: 16),

                  SizedBox(height: 16),

                  SizedBox(height: 16),

                  SizedBox(height: 16),

                  SizedBox(height: 16),

                  SizedBox(height: 16),
                  Center(
                    child: SizedBox(
                      width: 200, // Set the width
                      height: 50, // Set the height
                      child: ElevatedButton(
                        onPressed: () {
                          /*   Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Med2()),
                          );*/
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFD9D9D9), // Button color
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
                            color: Color.fromARGB(255, 0, 0, 0),
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

  Widget _buildOption(String value) {
    bool isSelected = _selectedOptions.contains(value);

    return GestureDetector(
      onTap: () {
        setState(() {
          // Toggle the selection for this option
          if (isSelected) {
            _selectedOptions.remove(value);
          } else {
            _selectedOptions.add(value);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          // Change background color if selected
          color: const Color(0xFF396C9B),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            // Circular indicator for selection
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? Colors.blue : Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            Text(value, style: TextStyle(fontSize: 20, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
