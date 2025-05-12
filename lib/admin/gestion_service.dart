/*import 'package:flutter/material.dart';
import 'gestion_service.dart';
import 'choix1.dart';
import 'choix2.dart';
import 'CIM.dart';
import 'infermier.dart';
void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: gservice(), debugShowCheckedModeBanner: false);
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

class gservice extends StatelessWidget {
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
              Icon(Icons.settings, color: Color(0xFF073057)),
              SizedBox(width: 10),
              Text(
                'Gestion de service',
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

      body: Center(
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
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DashboardButton(
                    iconPath: 'assets/medicin.png',
                    label: 'medecins',
                    onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Choix()),
                  );
                },
                  ),
                  SizedBox(width: 50),
                 /*  DashboardButton(
                    iconPath: 'assets/pharmacie.png',
                    label: 'Pharmacies',
                    onTap: () {},
      
                  ),*/
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DashboardButton(
                    iconPath: 'assets/laboratoires.png',
                    label: 'Laboratoires',
                     onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Choix2()),
                  );
                },
                    
                  ),
                  SizedBox(width: 50),
                  DashboardButton(
                    iconPath: 'assets/infermiers.png',
                    label: 'infermiers',
                    onTap: () {
                      Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Infermier()),
                  );
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DashboardButton(
                    iconPath: 'assets/CIM.png',
                    label:
                        'Centre d'
                        'imagerie',
                        onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Cim()),
                  );
                },
                  ),
                 
                  
                ],
              ),
              SizedBox(height: 20),
           
            ],
          ),
        ),
      ),
    );
  }
}

class DashboardButton extends StatelessWidget {
  final String iconPath;
  final String label;
  final VoidCallback onTap;

  const DashboardButton({
    required this.iconPath,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Column(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset(
                iconPath,
                height: 100,
                width: 100,
                fit: BoxFit.cover,
              ),
            ),
            SizedBox(height: 5),
            Text(
              label,
              style: TextStyle(fontSize: 16, color: const Color(0xFF396C9B)),
            ),
          ],
        ),
      ),
    );
  }
}


class DashboardItem extends StatelessWidget {
  final String iconPath;
  final String label;

  const DashboardItem({required this.iconPath, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Image.asset(iconPath, height: 60),
        ),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          decoration: BoxDecoration(
            color: Color(0xFF073057),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ],
    );
  }
}*/
import 'package:flutter/material.dart';
import 'nvservice.dart';
import 'admin_service.dart';
import '../models/HealthcareProfessional.dart';
import '../models/Service.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: gservice(), debugShowCheckedModeBanner: false);
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
      // Adjust width to fit content with proper padding
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      // Use constraints instead of fixed width to adapt to content
      constraints: BoxConstraints(minWidth: 150),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min, // Important to make the Row take only needed width
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

class gservice extends StatefulWidget {
  @override
  _gserviceState createState() => _gserviceState();
}

class _gserviceState extends State<gservice> {
  final AdminService _adminService = AdminService();
  bool _isLoading = false;
  HealthcareType _selectedType = HealthcareType.medecin;
  List<Map<String, dynamic>> _services = [];

  @override
  void initState() {
    super.initState();
    _loadServices();
  }

  Future<void> _loadServices() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final services = await _adminService.getServicesByType(_selectedType);
      setState(() {
        _services = services;
      });
    } catch (e) {
      print('Error loading services: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors du chargement des services: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _deleteService(String serviceId) async {
    try {
      await _adminService.deleteService(serviceId);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Service supprimé avec succès')),
      );
      _loadServices(); // Reload the list
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur lors de la suppression du service: ${e.toString()}')),
      );
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
              Icon(Icons.settings, color: Color(0xFF073057)),
              SizedBox(width: 10),
              Text(
                'Gestion de service',
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
      body: Center(
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
              SizedBox(height: 20),
              // Type selection buttons
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTypeButton(HealthcareType.medecin, 'assets/medicin.png', 'Médecins'),
                    SizedBox(width: 15),
                    _buildTypeButton(HealthcareType.pharmacie, 'assets/pharmacie.png', 'Pharmacies'),
                    SizedBox(width: 15),
                    _buildTypeButton(HealthcareType.laboratoire_analyse, 'assets/laboratoires.png', 'Laboratoires'),
                  ],
                ),
              ),
              SizedBox(height: 10),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildTypeButton(HealthcareType.infermier, 'assets/infermiers.png', 'Infirmiers'),
                    SizedBox(width: 15),
                    _buildTypeButton(HealthcareType.centre_imagerie, 'assets/CIM.png', 'Centre d\'imagerie'),
                    SizedBox(width: 15),
                    _buildTypeButton(HealthcareType.clinique, 'assets/clinique.png', 'Clinique'),
                    SizedBox(width: 15),
                    _buildTypeButton(HealthcareType.dentiste, 'assets/medicin.png', 'Dentiste'),
                  ],
                ),
              ),
              SizedBox(height: 20),
              // Services list
              Expanded(
                child: _isLoading 
                  ? Center(child: CircularProgressIndicator()) 
                  : _services.isEmpty 
                    ? Center(child: Text(
                        'Aucun service disponible pour ce type',
                        style: TextStyle(
                          fontSize: 16,
                          color: Color(0xFF073057),
                          fontWeight: FontWeight.bold,
                        ),
                      )) 
                    : ListView.builder(
                        itemCount: _services.length,
                        itemBuilder: (context, index) {
                          final service = _services[index];
                          return _buildServiceCard(service);
                        },
                      ),
              ),
              SizedBox(height: 20),
              // Add service button
              _buildCircleIconButton1(
                icon: Icons.add,
                onTap: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => DashboardScreen()),
                  );
                  if (result != null) {
                    _loadServices();
                  }
                },
                text: "Ajouter un service",
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeButton(HealthcareType type, String iconPath, String label) {
    final isSelected = _selectedType == type;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedType = type;
        });
        _loadServices();
      },
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isSelected ? Color(0xFF073057) : Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                color: isSelected ? Color(0xFF073057) : Colors.grey.shade300,
                width: 2,
              ),
            ),
            child: Image.asset(
              iconPath,
              height: 50,
              width: 50,
              color: isSelected ? Colors.white : null,
            ),
          ),
          SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isSelected ? Color(0xFF073057) : Colors.black,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceCard(Map<String, dynamic> service) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 8),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
      elevation: 3,
      child: ListTile(
        contentPadding: EdgeInsets.all(16),
        title: Text(
          service['name'] ?? 'Sans nom',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Color(0xFF073057),
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: 5),
            Text(
              service['description'] ?? 'Aucune description',
              style: TextStyle(fontSize: 14),
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
            SizedBox(height: 5),
            Text(
              'Prix: ${service['price']?.toString() ?? 'N/A'} DZD',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                color: Colors.green[700],
              ),
            ),
          ],
        ),
        trailing: IconButton(
          icon: Icon(Icons.delete, color: Colors.red),
          onPressed: () {
            _showDeleteConfirmation(service['id']);
          },
        ),
      ),
    );
  }

  void _showDeleteConfirmation(String serviceId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirmation'),
          content: Text('Voulez-vous vraiment supprimer ce service?'),
          actions: [
            TextButton(
              child: Text('Annuler'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Supprimer', style: TextStyle(color: Colors.red)),
              onPressed: () {
                Navigator.of(context).pop();
                _deleteService(serviceId);
              },
            ),
          ],
        );
      },
    );
  }
}

class DashboardButton extends StatelessWidget {
  final String iconPath;
  final String label;

  const DashboardButton({required this.iconPath, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: [
          Container(
            padding: EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Image.asset(
              iconPath,
              height: 70,
              width: 70,
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(height: 5),
          Text(
            label,
            style: TextStyle(fontSize: 14, color: const Color(0xFF396C9B)),
          ),
        ],
      ),
    );
  }
}

class DashboardItem extends StatelessWidget {
  final String iconPath;
  final String label;

  const DashboardItem({required this.iconPath, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Image.asset(iconPath, height: 60),
        ),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          decoration: BoxDecoration(
            color: Color(0xFF073057),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ],
    );
  }
}
