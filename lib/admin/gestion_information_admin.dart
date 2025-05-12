import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: const GestionInformationAdmin(),
    );
  }
}

class GestionInformationAdmin extends StatelessWidget {
  const GestionInformationAdmin({super.key});

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
                'Gestion des informations',
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
                  const SizedBox(height: 50),
                  _buildInfoField("Numéro de téléphone", "06 43 14 71 53"),
                  const SizedBox(height: 15),
                  _buildInfoField(
                    "Adresse postale",
                    "12 Rue Didouche Mourad, Alger Centre.",
                  ),
                  const SizedBox(height: 15),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: Color(0xFF396C9B),
          ),
        ),

        SizedBox(height: 15),
        Container(
          width: 310, // Fixed width
          height: 55, // Fixed height
          decoration: BoxDecoration(
            color: Colors.grey[300],

            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: [
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: TextEditingController(text: value),
                  readOnly: true,
                  decoration: const InputDecoration(border: InputBorder.none),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.grey),
                onPressed: () {
                  // Add edit functionality
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
