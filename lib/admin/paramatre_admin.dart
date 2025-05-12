import 'package:flutter/material.dart';
import 'package:flutter_application_2/admin/politique_admin.dart';
import 'chmdp_admin.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'P.De Notifications',
      debugShowCheckedModeBanner: false,
      home: const paramatre_admin(),
    );
  }
}

class paramatre_admin extends StatefulWidget {
  const paramatre_admin({Key? key}) : super(key: key);

  @override
  State<paramatre_admin> createState() => paramatre_adminState();
}

class paramatre_adminState extends State<paramatre_admin> {
  bool _generalNotification = true;
  bool _sound = true;
  bool _vibrate = false;

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFE7ECFB),
      appBar: AppBar(
        backgroundColor: const Color(0xFFA3C3E4),
        elevation: 0,
        title: Center(
          child: const Row(
            children: [
              Icon(Icons.notifications, color: Color(0xFF073057)),
              SizedBox(width: 10),
              Text(
                'Parametres de notifications',
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: double.infinity,
                    height: screenHeight * 0.8,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFA3C3E4),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "P.De Notifications",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF000000),
                          ),
                        ),

                        const SizedBox(height: 95),
                        _buildSwitchRow(
                          label: 'General Notification',
                          value: _generalNotification,
                          onChanged: (val) {
                            setState(() {
                              _generalNotification = val;
                            });
                          },
                          activeColor: Colors.blue,
                        ),
                        const SizedBox(height: 20),
                        _buildSwitchRow(
                          label: 'Sound',
                          value: _sound,
                          onChanged: (val) {
                            setState(() {
                              _sound = val;
                            });
                          },
                          activeColor: Colors.blue,
                        ),
                        const SizedBox(height: 20),

                        // 3) Vibrate
                        _buildSwitchRow(
                          label: 'Vibrate',
                          value: _vibrate,
                          onChanged: (val) {
                            setState(() {
                              _vibrate = val;
                            });
                          },
                          activeColor: Colors.blue,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Widget réutilisable pour chaque ligne de paramètre
  Widget _buildSwitchRow({
    required String label,
    required bool value,
    required ValueChanged<bool> onChanged,
    Color activeColor = Colors.blue,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: Colors.black87,
          ),
        ),
        Switch(value: value, onChanged: onChanged, activeColor: activeColor),
      ],
    );
  }
}

class par1 extends StatelessWidget {
  const par1({super.key});

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
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
                'Parametre generale',
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

          body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              Expanded(
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: double.infinity,
                    height: screenHeight * 0.8,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFA3C3E4),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        Text(
                          "Parametres",
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF000000),
                          ),
                        ),
                        const SizedBox(height: 95),
                       _buildProfileOption(
                          context,
                          Icons.lightbulb,
                          'Paramétres de notification',
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const paramatre_admin()),
                            );
                          },
                        ),
                        const SizedBox(height: 35),
                       _buildProfileOption(
                          context,
                          Icons.key,
                          'Gestionnaire De mot De Passe',
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => chmdp_admin()),
                            );
                          },
                        ),
                        const SizedBox(height: 35),
                        _buildProfileOption(
                          context,
                          Icons.lock,
                          'Politique de confidentialité',
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (_) => const PrivacyPolicyScreenAdmin()),
                            );
                          },
                        ),
                        const SizedBox(height: 35),
                      _buildProfileOption1(
                          Icons.person,
                          'Supprimer le Compte',
                         
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileOption(
    BuildContext context,
    IconData icon,
    String text,
    VoidCallback onTap,
  ) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(12),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF073057), size: 28),
          const SizedBox(width: 15),
          Text(
            text,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w600,
              color: Color(0xFF000000),
            ),
          ),
        ],
      ),
    );
  }
Widget _buildProfileOption1(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF073057), size: 28),
        const SizedBox(width: 15),
        Text(
          text,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF000000),
          ),
        ),
      ],
    );
  }
}
