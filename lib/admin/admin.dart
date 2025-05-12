/*import 'package:flutter/material.dart';
import 'tableaubord.dart';
import 'gestion_service.dart';
import 'paramatre_admin.dart';
import 'user.dart';
import 'personnel_sante.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Admin(), debugShowCheckedModeBanner: false);
  }
}

class Admin extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA3C3E4),
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 40),
          decoration: BoxDecoration(),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 20),
                  CircleAvatar(
                    radius: 40,
                    backgroundColor: Colors.grey,
                    backgroundImage: AssetImage('assets/profile.png'),
                  ),
                  SizedBox(width: 30),
                  Text(
                    'BIENVENUE!',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: const Color(0xFF396C9B),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DashboardButton(
                    iconPath: 'assets/tableaubord.png',
                    label: 'Tableau de Bord',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => DashboardScreen()),
                      );
                    },
                  ),
                  SizedBox(width: 50),
                  DashboardButton(
                    iconPath: 'assets/utilisateurs.png',
                    label: 'Utilisateurs',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => user()),
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
                    iconPath: 'assets/service.png',
                    label: 'Gestion des services',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => gservice()),
                      );
                    },
                  ),
                  SizedBox(width: 50),
                  DashboardButton(
                    iconPath: 'assets/personnel.png',
                    label: 'Personnels de santé',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PersonnelSante()),
                      );
                    },
                  ),
                ],
              ),
              SizedBox(height: 20),
              DashboardButton(
                iconPath: 'assets/parametres.png',
                label: 'Paramètres',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => par1()),
                  );
                },
              ),
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
}*/
 import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'admin_service.dart';
import 'tableaubord.dart';
import 'personnel_sante.dart';
import 'admin_users.dart'; // Import the new AdminUsers screen
import 'gestion_service.dart'; // Import the gestion_service file
import 'politique_admin.dart'; // Import the admin privacy policy file

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: Admin(), debugShowCheckedModeBanner: false);
  }
}

class Admin extends StatefulWidget {
  @override
  _AdminState createState() => _AdminState();
}

class _AdminState extends State<Admin> {
  final AdminService _adminService = AdminService();
  int pendingCount = 0;
  bool isLoading = true;
  
  @override
  void initState() {
    super.initState();
    _loadPendingCount();
  }
  
  Future<void> _loadPendingCount() async {
    setState(() {
      isLoading = true;
    });
    
    try {
      final stats = await _adminService.getHealthcareProfessionalsStats();
      setState(() {
        pendingCount = stats['pending'];
      });
    } catch (e) {
      print('Error loading pending count: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA3C3E4),
      appBar: AppBar(
        backgroundColor: const Color(0xFF396C9B),
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.logout, color: Colors.white),
          onPressed: () {
            // Show confirmation dialog before logout
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text('Déconnexion'),
                  content: Text('Êtes-vous sûr de vouloir vous déconnecter?'),
                  actions: [
                    TextButton(
                      child: Text('Annuler'),
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                    ),
                    TextButton(
                      child: Text('Déconnecter'),
                      onPressed: () {
                        
                        Navigator.of(context).pop();
                        Navigator.of(context).pushNamedAndRemoveUntil(
                          '/home',
                          (Route<dynamic> route) => false,
                        );
                      },
                    ),
                  ],
                );
              },
            );
          },
        ),
        title: Text(
          'Administration',
          style: TextStyle(color: Colors.white),
        ),
        actions: [
         
        ],
      ),
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 40),
          decoration: BoxDecoration(),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  SizedBox(width: 20),
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 1,
                          blurRadius: 3,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Image.asset(
                        'assets/admin_icon.png',
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                  SizedBox(width: 30),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'BIENVENUE!',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: const Color(0xFF396C9B),
                        ),
                      ),
                      Text(
                        'Panneau d\'administration',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF073057),
                        ),
                      ),
                    ],
                  ),
                ],
              ),

              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  DashboardButton(
                    iconPath: 'assets/tableaubord.png',
                    label: 'Tableau de Bord',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => DashboardScreen()),
                      );
                    },
                  ),
                  SizedBox(width: 50),
                  DashboardButton(
                    iconPath: 'assets/utilisateurs.png',
                    label: 'Utilisateurs',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AdminUsers()),
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
                    iconPath: 'assets/service.png',
                    label: 'Gestion des services',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => gservice()),
                      );
                    },
                  ),
                  SizedBox(width: 50),
                  Stack(
                    children: [
                      DashboardButton(
                        iconPath: 'assets/personnel.png',
                        label: 'Personnels de santé',
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => PersonnelSante()),
                          );
                        },
                      ),
                      if (pendingCount > 0 && !isLoading)
                        Positioned(
                          right: 10,
                          top: 10,
                          child: Container(
                            padding: EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              color: Colors.red,
                              shape: BoxShape.circle,
                            ),
                            child: Text(
                              '$pendingCount',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      if (isLoading)
                        Positioned(
                          right: 10,
                          top: 10,
                          child: Container(
                            padding: EdgeInsets.all(8),
                            width: 30,
                            height: 30,
                            decoration: BoxDecoration(
                              color: Colors.grey.withOpacity(0.7),
                              shape: BoxShape.circle,
                            ),
                            child: SizedBox(
                              width: 15,
                              height: 15,
                              child: CircularProgressIndicator(
                                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                strokeWidth: 2,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              DashboardButton(
                iconPath: 'assets/parametres.png',
                label: 'Politique de confidentialité',
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => PrivacyPolicyScreenAdmin()),
                  );
                },
              ),
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
    return InkWell(
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

