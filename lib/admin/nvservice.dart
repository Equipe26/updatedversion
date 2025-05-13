import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/Service.dart';
import '../models/HealthcareProfessional.dart';
import '../models/Specialty.dart';

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
    return MaterialApp(debugShowCheckedModeBanner: false, home: Nvservice());
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

class Nvservice extends StatefulWidget {
  @override
  NvserviceState createState() => NvserviceState();
}

class NvserviceState extends State<Nvservice> {
  bool isChecked = false;
  bool _obscureText = true;
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  
  // Text controllers
  final _nameController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _priceController = TextEditingController();
  
  // Selected healthcare type and specialty
  HealthcareType _selectedType = HealthcareType.medecin;
  Specialty? _selectedSpecialty;
  
  // Add dropdown items
  final List<DropdownMenuItem<HealthcareType>> _typeItems = HealthcareType.values
      .map((type) => DropdownMenuItem(
            value: type,
            child: Text(typeDisplayName(type)),
          ))
      .toList();

  List<DropdownMenuItem<Specialty>> _specialtyItems = [];

  @override
  void initState() {
    super.initState();
    // Initialize specialty dropdown items based on default selected type
    _updateSpecialtyItems();
  }
  
  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }
  
  // Helper function to get display name for healthcare type
  static String typeDisplayName(HealthcareType type) {
    const Map<HealthcareType, String> typeDisplayMap = {
      HealthcareType.medecin: "Médecin",
      HealthcareType.clinique: "Clinique",
      HealthcareType.centre_imagerie: "Centre d'imagerie",
      HealthcareType.laboratoire_analyse: "Laboratoire d'analyse",
      HealthcareType.infermier: "Infirmier",
      HealthcareType.pharmacie: "Pharmacie",
      HealthcareType.dentiste: "Dentiste",
    };
    
    return typeDisplayMap[type] ?? type.name;
  }
  
  // Update specialty items based on selected healthcare type
  void _updateSpecialtyItems() {
    // Only show specialties for médecin
    if (_selectedType == HealthcareType.medecin) {
      _specialtyItems = Specialty.values
          .map((specialty) => DropdownMenuItem(
                value: specialty,
                child: Text(specialty.displayName),
              ))
          .toList();
      // Default to first specialty
      _selectedSpecialty = Specialty.values.first;
    } else {
      _specialtyItems = [];
      _selectedSpecialty = null;
    }
    setState(() {});
  }

  // Add service to Firestore
  Future<void> _addService() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }
    
    setState(() {
      _isLoading = true;
    });
    
    try {
      // Create a new document reference with auto-generated ID
      final serviceRef = FirebaseFirestore.instance.collection('services').doc();
      
      // Create service object
      final service = {
        'id': serviceRef.id,
        'name': _nameController.text.trim(),
        'description': _descriptionController.text.trim(),
        'price': double.parse(_priceController.text.trim()),
        'healthcareType': _selectedType.name,
        'specialty': _selectedType == HealthcareType.medecin ? _selectedSpecialty?.name : null,
        'createdAt': FieldValue.serverTimestamp(),
      };
      
      // Save to Firestore
      await serviceRef.set(service);
      
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Service ajouté avec succès')),
      );
      
      // Reset form
      _nameController.clear();
      _descriptionController.clear();
      _priceController.clear();
      
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'ajout du service: ${e.toString()}')),
      );
      print('Error adding service: $e');
    } finally {
      setState(() {
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
        backgroundColor: const Color(0xFFA3C3E4),
        elevation: 0,
        title: Center(
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.add_circle_outline, color: Color(0xFF073057)),
              SizedBox(width: 10),
              Text(
                'Nouveau Service',
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
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 20),
                    
                    // Type de professionnel de santé
                    Text(
                      "Type de professionnel de santé",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF396C9B),
                      ),
                    ),
                    
                    SizedBox(height: 10),
                    
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(30),
                      ),
                      child: DropdownButtonFormField<HealthcareType>(
                        decoration: InputDecoration(
                          border: InputBorder.none,
                        ),
                        value: _selectedType,
                        items: _typeItems,
                        onChanged: (value) {
                          setState(() {
                            _selectedType = value!;
                            _updateSpecialtyItems();
                          });
                        },
                        validator: (value) {
                          if (value == null) {
                            return 'Veuillez sélectionner un type';
                          }
                          return null;
                        },
                      ),
                    ),
                    
                    SizedBox(height: 20),
                    
                    // Specialty dropdown (only for médecin)
                    if (_selectedType == HealthcareType.medecin) ...[
                      Text(
                        "Spécialité",
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF396C9B),
                        ),
                      ),
                      
                      SizedBox(height: 10),
                      
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(30),
                        ),
                        child: DropdownButtonFormField<Specialty>(
                          decoration: InputDecoration(
                            border: InputBorder.none,
                          ),
                          value: _selectedSpecialty,
                          items: _specialtyItems,
                          onChanged: (value) {
                            setState(() {
                              _selectedSpecialty = value;
                            });
                          },
                          validator: (value) {
                            if (_selectedType == HealthcareType.medecin && value == null) {
                              return 'Veuillez sélectionner une spécialité';
                            }
                            return null;
                          },
                        ),
                      ),
                      
                      SizedBox(height: 20),
                    ],

                    Text(
                      "Nom du service",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF396C9B),
                      ),
                    ),

                    SizedBox(height: 10),

                    TextFormField(
                      controller: _nameController,
                      decoration: InputDecoration(
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
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Veuillez entrer un nom pour le service';
                        }
                        return null;
                      },
                    ),
                    
                    SizedBox(height: 20),
                    
                    Text(
                      "Description",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF396C9B),
                      ),
                    ),

                    SizedBox(height: 10),
                    
                    TextFormField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
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
                      maxLines: 3,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Veuillez entrer une description pour le service';
                        }
                        return null;
                      },
                    ),
                    
                    SizedBox(height: 20),
                    
                    Text(
                      "Prix approximatif (DZD)",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF396C9B),
                      ),
                    ),

                    SizedBox(height: 10),
                    
                    TextFormField(
                      controller: _priceController,
                      decoration: InputDecoration(
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
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) {
                          return 'Veuillez entrer un prix';
                        }
                        if (double.tryParse(value) == null) {
                          return 'Veuillez entrer un nombre valide';
                        }
                        return null;
                      },
                    ),

                    Spacer(),
                    
                    Center(
                      child: SizedBox(
                        width: 300, // Set the width
                        height: 50, // Set the height
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _addService,
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
                          child: _isLoading 
                            ? CircularProgressIndicator(color: Colors.white) 
                            : Text(
                                'Confirmer le service',
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
      ),
    );
  }
}
