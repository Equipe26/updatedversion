import 'package:flutter/material.dart';
import 'med2.dart';
import 'pharmacie.dart';
import '../models/HealthcareProfessional.dart';
import '../models/Specialty.dart';
import '../models/Map.dart';
class gastro extends StatefulWidget {
  final String password;
  final String name;
  final String email;
  final String address;
  final AlgerianWilayas closeContact;
  final HealthcareType Type;
   final Gender gender;
  final Specialty? specialty;
  final List<Specialty> availableSpecialties;

  gastro({
    required this.password,
    required this.name,
    required this.email,
    required this.address,
    required this.closeContact,
    required this.Type,
    required this.specialty,
    required this.availableSpecialties,
    required this.gender,
  });
  @override
  gastroState createState() => gastroState();
}

class gastroState extends State<gastro> {
  // Use a Set to allow multiple selections
  Set<String> _selectedOptions = {};
  Specialty specialty = Specialty.gastro;
  List<Specialty> availableSpecialties = [];
  List<String> serviceId = [];
  final Map<String, String> serviceOptions = {
    'Colposcopie': 'gastro_colo ',
    'Échographie abdominale': 'gastro_echo ',
    'Suivi hépatite': 'gastro_hépatite ',
  };

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
                  const SizedBox(height: 40),
                  const Center(
                    child: Text(
                      "Choisis vos services proposés:",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  const SizedBox(height: 100),
                  _buildOption('Colposcopie'),
                  const SizedBox(height: 20),
                  _buildOption('Échographie abdominale'),
                  const SizedBox(height: 20),
                  _buildOption('Suivi hépatite'),
                  const Spacer(),
                  Center(
                    child: SizedBox(
                      width: 200,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: _selectedOptions.isNotEmpty
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Pharmacie(
                                      password: widget.password,
                                      name: widget.name,
                                      email: widget.email,
                                      address: widget.address,
                                      closeContact: widget.closeContact,
                                      Type: widget.Type,
                                      specialty: specialty,
                                      availableSpecialties:
                                          availableSpecialties,
                                      serviceId: serviceId,
                                      gender: widget.gender,
                                    ),
                                  ),
                                );
                              }
                            : null, // Disable if no selection
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFFD9D9D9), // Button color
                          foregroundColor: Colors.white,

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

  Widget _buildOption(String displayText) {
    bool isSelected = _selectedOptions.contains(displayText);

    return GestureDetector(
      onTap: () {
        setState(() {
          if (isSelected) {
            _selectedOptions.remove(displayText);
            serviceId.remove(serviceOptions[displayText]);
          } else {
            _selectedOptions.add(displayText);
            serviceId.add(serviceOptions[displayText]!);
          }
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF396C9B),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: isSelected ? Colors.blue : Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            Text(displayText,
                style: const TextStyle(fontSize: 16, color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
