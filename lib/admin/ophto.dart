import 'package:flutter/material.dart';
import 'nvservice.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: Ophto());
  }
}

class Ophto extends StatefulWidget {
  @override
  OphtoState createState() => OphtoState();
}

class OphtoState extends State<Ophto> {
  // Use a Set to allow multiple selections
  Set<String> _selectedOptions = {};

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(backgroundColor: Colors.white, toolbarHeight: 60),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child: Container(
              margin: const EdgeInsets.all(20),
              height: screenHeight * 0.8,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFFA3C3E4),
                borderRadius: BorderRadius.circular(40),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 70),

                  _buildOption('Consultation ophtalmologique'),
                  const SizedBox(height: 20),
                  _buildOption('Dépistage presbytie'),
                  const SizedBox(height: 20),
                  _buildOption('Tonometrie'),
                  const SizedBox(height: 20),
                  _buildOption('Fond d''œil'),
                  const SizedBox(height: 40),
                  Center(
                    child: SizedBox(
                      width: 200,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                            Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DashboardScreen()),
                  );
                        }, // Disable if no selection
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF396C9B), // Button color

                          elevation: 8,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Ajouter',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: SizedBox(
                      width: 200,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {}, // Disable if no selection
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFD9D9D9), // Button color

                          elevation: 8,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: const Text(
                          'Supprimer',
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
            Text(value, style: TextStyle(fontSize: 16, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
