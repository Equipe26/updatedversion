import 'package:flutter/material.dart';
import 'package:flutter_application_2/admin/user.dart';
import 'package:flutter_application_2/login/inscription4.dart';
import 'package:flutter_application_2/screens/patient/home_screen.dart';
import '../auth_service.dart';
import '../yyu.dart';
import '../screens/medecin/home_screen.dart';
import '../screens/pharmacie/home_screen.dart';
import 'inscription5.dart';
import '../screens/clinique/home_screen.dart';
import '../models/HealthcareProfessional.dart';
import '../models/Specialty.dart';
import '../models/WeeklyAvailability.dart';
import 'email_verification.dart';
import '../models/Map.dart';
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

class Pharmacie extends StatefulWidget {
  final String password;
  final String name;
  final String email;
  final String address;
  final AlgerianWilayas closeContact;
  final HealthcareType Type;
  final Specialty specialty;
  final List<Specialty> availableSpecialties;
  final List<String> serviceId;
   final Gender gender;
 
 
  Pharmacie({
    required this.password,
    required this.name,
    required this.email,
    required this.address,
    required this.closeContact,
    required this.Type,
    required this.specialty,
    required this.availableSpecialties,
    required this.serviceId,
    required this.gender,
  });
  @override
  PharmacieState createState() => PharmacieState();
}

class PharmacieState extends State<Pharmacie> {
  bool isChecked = false;
  final TextEditingController _locationController = TextEditingController();
  final _communeController = TextEditingController();
  AlgiersCommunes? _selectedCommune;
  bool _obscureText = true;
   
  String _selectedValue = 'Oui';
   WeeklyAvailability? _selectedAvailability;
 List<WeeklyAvailability> predefinedAvailabilities = [
    WeeklyAvailability(
      id: '1',
      healthcareProfessionalId: '',
      availability: {
        'Monday': List.generate(24, (i) => i >= 8 && i < 16 ? 1 : 0),
        'Tuesday': List.generate(24, (i) => i >= 8 && i < 16 ? 1 : 0),
        'Wednesday': List.generate(24, (i) => i >= 8 && i < 16 ? 1 : 0),
        'Thursday': List.generate(24, (i) => i >= 8 && i < 16 ? 1 : 0),
        'Friday': List.generate(24, (i) => i >= 8 && i < 16 ? 1 : 0),
        'Saturday': List.filled(24, 0),
        'Sunday': List.filled(24, 0),
      },
    ),
    WeeklyAvailability(
      id: '2',
      healthcareProfessionalId: '',
      availability: {
        'Monday': List.generate(24, (i) => i >= 14 && i < 20 ? 1 : 0),
        'Tuesday': List.generate(24, (i) => i >= 14 && i < 20 ? 1 : 0),
        'Wednesday': List.generate(24, (i) => i >= 14 && i < 20 ? 1 : 0),
        'Thursday': List.generate(24, (i) => i >= 14 && i < 20 ? 1 : 0),
        'Friday': List.generate(24, (i) => i >= 14 && i < 20 ? 1 : 0),
        'Saturday': List.filled(24, 0),
        'Sunday': List.filled(24, 0),
      },
    ),
    WeeklyAvailability(
      id: '3',
      healthcareProfessionalId: '',
      availability: {
        'Monday': List.generate(24, (i) => i >= 9 && i < 13 ? 1 : 0),
        'Tuesday': List.generate(24, (i) => i >= 9 && i < 13 ? 1 : 0),
        'Wednesday': List.generate(24, (i) => i >= 9 && i < 13 ? 1 : 0),
        'Thursday': List.generate(24, (i) => i >= 9 && i < 13 ? 1 : 0),
        'Friday': List.generate(24, (i) => i >= 9 && i < 13 ? 1 : 0),
        'Saturday': List.filled(24, 0),
        'Sunday': List.filled(24, 0),
      },
    ),
    WeeklyAvailability(
      id: '4',
      healthcareProfessionalId: '',
      availability: {
        'Monday': List.generate(24, (i) => i >= 10 && i < 18 ? 1 : 0),
        'Tuesday': List.generate(24, (i) => i >= 10 && i < 18 ? 1 : 0),
        'Wednesday': List.generate(24, (i) => i >= 10 && i < 18 ? 1 : 0),
        'Thursday': List.generate(24, (i) => i >= 10 && i < 18 ? 1 : 0),
        'Friday': List.generate(24, (i) => i >= 10 && i < 18 ? 1 : 0),
        'Saturday': List.filled(24, 0),
        'Sunday': List.filled(24, 0),
      },
    ),
    WeeklyAvailability(
      id: '5',
      healthcareProfessionalId: '',
      availability: {
        'Monday': List.filled(24, 1),
        'Tuesday': List.filled(24, 1),
        'Wednesday': List.filled(24, 1),
        'Thursday': List.filled(24, 1),
        'Friday': List.filled(24, 1),
        'Saturday': List.filled(24, 0),
        'Sunday': List.filled(24, 0),
      },
    ),
  ];
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
                  Center(
                    child: Text(
                      "Nouveau Compte",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF396C9B),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                  Text(
                    "Commune",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF396C9B),
                    ),
                  ),
                  SizedBox(height: 16),
                DropdownButtonFormField<AlgiersCommunes>(
  value: _selectedCommune,
  hint: Text("Choisissez une commune"),
  items: AlgiersCommunes.values.map((commune) {
    return DropdownMenuItem(
      value: commune,
      child: Text(commune.name),
    );
  }).toList(),
  onChanged: (newValue) {
    setState(() {
      _selectedCommune = newValue;
    });
  },
  decoration: InputDecoration(
    filled: true,
    fillColor: Colors.grey[300],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide.none,
    ),
  ),
),
                  SizedBox(height: 16),
                  Text(
                    "Horaires de disponibilité",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF396C9B),
                    ),
                  ),
                  SizedBox(height: 16),
                DropdownButtonFormField<WeeklyAvailability>(
  value: _selectedAvailability,
  hint: Text("Choisissez vos horaires"),
  items: predefinedAvailabilities.map((availability) {
    return DropdownMenuItem<WeeklyAvailability>(
      value: availability,
      child: Text(
        availability.summary(),
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
      ),
    );
  }).toList(),
  onChanged: (newValue) {
    setState(() {
      _selectedAvailability = newValue;
    });
  },
  decoration: InputDecoration(
    filled: true,
    fillColor: Colors.grey[300],
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(30),
      borderSide: BorderSide.none,
    ),
  ),
),


                  SizedBox(height: 16),
                  Text(
                    "Deplacement",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF396C9B),
                    ),
                  ),
                  SizedBox(height: 16),
                  Row(
                    children: [
                      _buildOption('Oui'),
                      const SizedBox(width: 16),
                      _buildOption('Non'),
                    ],
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Geolocalisation",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF396C9B),
                    ),
                  ),
                  SizedBox(height: 16),
                  TextField(
                    // Toggles hiding/showing password
                    controller: _locationController,
                    decoration: InputDecoration(
                      hintText: "Entrez Votre Geolocalisation",
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
                  TermsAndConditions(
                    isChecked: isChecked,
                    onChanged: (bool? newValue) {
                      setState(() {
                        isChecked = newValue ?? false;
                      });
                    },
                  ),
                  SizedBox(height: 16),
                  Center(
                    child: SizedBox(
                      width: 200, // Set the width
                      height: 50, // Set the height
                      child: ElevatedButton(
                        onPressed: () async {
                          if (!isChecked) {
                            // User must accept terms
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Veuillez accepter les termes et conditions',
                                ),
                              ),
                            );
                            return;
                          }

                          try {
                              // Check password validity
                              if (!AuthService().isPasswordValid(widget.password)) {
                                throw Exception('Le mot de passe doit contenir au moins 8 caractères et une lettre majuscule.');
                              }
                                
                              final HealthcareProfessional hp =
                                  await AuthService()
                                      .signUpAsHealthcareProfessional(
                                email: widget.email,
                                password: widget.password,
                                name: widget.name,
                                wilaya: widget.closeContact, // or get it if you want
                                commune: _selectedCommune ?? AlgiersCommunes.babEzzouar, // or get it if you want
                                exactAddress: _locationController.text.trim(),
                                type: widget.Type,
                                specialty: widget.specialty,
                                availableSpecialties: widget.availableSpecialties,
                                weeklyAvailability: _selectedAvailability != null ? [_selectedAvailability!] : [],
                                licenseNumber: widget.address,
                                serviceIds: widget.serviceId, // example defaults
                                staffIds: [],
                                gender: widget.gender,
                              );
                              
                              // Navigate to email verification screen instead of home screen
                             Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EmailVerificationScreen(
                                    email: widget.email,
                                  ),
                                ),
                              );
                              /* Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => PharmacieHomeScreen(
                      user: hp),
                                ),
                              );*/
                            } catch (e) {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Erreur lors de l\'inscription: $e',
                                  ),
                                ),
                              );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isChecked
                              ? Color(0xFF396C9B)
                              : Color(0xFFD9D9D9), // Button color
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
                          'S'
                          'inscrire',
                          style: TextStyle(
                            color: isChecked
                                ? Color.fromARGB(255, 255, 255, 255)
                                : Color.fromARGB(255, 0, 0, 0),
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
    bool isSelected = (_selectedValue == value);

    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedValue = value;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        decoration: BoxDecoration(
          // Slightly darker color when selected
          color: isSelected ? Colors.grey.shade400 : Colors.grey.shade300,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          children: [
            // The small circle indicating selection
            Container(
              width: 16,
              height: 16,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                // A dark border to mimic the radio outline

                // Fill with a color only if selected
                color: isSelected ? Colors.blue : Colors.white,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              value,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
          ],
        ),
      ),
    );
  }
}
