import 'package:flutter/material.dart';
import '../models/User.dart';
import '../models/Patient.dart';
import '../models/HealthcareProfessional.dart';
import '../auth_service.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UserInfoScreen(),
    );
  }
}

class UserInfoScreen extends StatefulWidget {
  final User? user;
  
  const UserInfoScreen({super.key, this.user});

  @override
  State<UserInfoScreen> createState() => _UserInfoScreenState();
}

class _UserInfoScreenState extends State<UserInfoScreen> {
  final AuthService _authService = AuthService();
  User? _currentUser;
  bool _isLoading = true;

  final TextEditingController _addressController = TextEditingController();

  final TextEditingController _specialtyController = TextEditingController();
  final TextEditingController _licenseController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    try {
      if (widget.user != null) {
        setState(() {
          _currentUser = widget.user;
          _isLoading = false;
        });
      } else {
        // If no user is provided, try to get the current logged-in user
        final user = await _authService.getCurrentUserData();
        setState(() {
          _currentUser = user;
          _isLoading = false;
        });
      }
      _updateTextFields();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors du chargement des informations')),
      );
    }
  }

  Future<void> _refreshUserData() async {
    try {
      setState(() {
        _isLoading = true;
      });
      
      // Get fresh user data
      final user = await _authService.getCurrentUserData();
      
      setState(() {
        _currentUser = user;
        _isLoading = false;
      });
      
      _updateTextFields();
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de l\'actualisation des informations')),
      );
    }
  }

  void _updateTextFields() {
    if (_currentUser != null) {
      if (_currentUser is Patient) {
        final patient = _currentUser as Patient;
       
      
      } else if (_currentUser is HealthcareProfessional) {
        final hp = _currentUser as HealthcareProfessional;
       
        _addressController.text = hp.exactAddress;
        
        _specialtyController.text = hp.specialty?.displayName ?? hp.typeDisplay;
        _licenseController.text = hp.licenseNumber ?? "Non défini";
      }
    }
  }

  List<Widget> _buildInfoFields() {
    final List<Widget> fields = [];
    
    fields.add(const SizedBox(height: 50));
    
    if (_currentUser == null) {
      fields.add(Center(
        child: Text(
          "Aucune information disponible",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ));
      return fields;
    }

    // Common fields for all user types

    fields.add(_buildInfoField("Adresse postale", _addressController));
    fields.add(const SizedBox(height: 15));

    
    // Healthcare professional specific fields
    if (_currentUser is HealthcareProfessional) {
      fields.add(const SizedBox(height: 15));
      fields.add(_buildInfoField("Spécialité", _specialtyController));
      fields.add(const SizedBox(height: 15));
      fields.add(_buildInfoField("Numéro de licence", _licenseController));
    }
    
    return fields;
  }

  void _showEditDialog(String title, TextEditingController controller) {
    final TextEditingController dialogController = TextEditingController(text: controller.text);
    
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Modifier $title"),
        content: TextField(
          controller: dialogController,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: "Entrer $title",
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text("Annuler"),
          ),
          TextButton(
            onPressed: () async {
              try {
                // Determine which field is being updated
                String? phoneNumber;
                String? location;
                String? emergencyContact;
                String? exactAddress;
                String? licenseNumber;
                
                // Set appropriate variables based on field title
                if (title == "Numéro de téléphone") {
                  phoneNumber = dialogController.text;
                } else if (title == "Adresse postale" && _currentUser is Patient) {
                  location = dialogController.text;
                } else if (title == "Adresse postale" && _currentUser is HealthcareProfessional) {
                  exactAddress = dialogController.text;
                } 
                else if (title == "Numéro de licence") {
                  licenseNumber = dialogController.text;
                }
                
                // Update user in the backend
                await _authService.updateUserInfo(
                  
                  location: location,
            
                  exactAddress: exactAddress,
                  licenseNumber: licenseNumber,
                );
                
                // Refresh user data to ensure we have the latest info
                await _refreshUserData();

                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Information mise à jour')),
                );
              } catch (e) {
                Navigator.pop(context);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Erreur: ${e.toString()}')),
                );
              }
            },
            child: Text("Enregistrer"),
          ),
        ],
      ),
    );
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
        child: _isLoading 
          ? Center(child: CircularProgressIndicator()) 
          : SingleChildScrollView(
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

                  children: _buildInfoFields(),
                ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInfoField(String label, TextEditingController controller) {
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
                  controller: controller,
                  readOnly: true,
                  decoration: const InputDecoration(border: InputBorder.none),
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              IconButton(
                icon: const Icon(Icons.edit, color: Colors.grey),
                onPressed: () {
                  _showEditDialog(label, controller);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
