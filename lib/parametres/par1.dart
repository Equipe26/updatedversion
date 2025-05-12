import 'package:flutter/material.dart';
import 'package:flutter_application_2/parametres/chmdp.dart';
import 'package:flutter_application_2/parametres/suppression.dart';
import 'par2.dart';
import 'gestion_information.dart';

class para1 extends StatelessWidget {
  const para1({super.key});

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
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.settings, color: Color(0xFF073057)),
              SizedBox(width: 10),
              Text(
                'Parametres Generales',
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
                        const SizedBox(height: 35),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => para2()),
                            );
                          },
                          child: _buildProfileOption(
                            Icons.lightbulb,
                            'Paramétres de notification',
                          ),
                        ),

                        const SizedBox(height: 35),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => para3()),
                            );
                          },
                          child: _buildProfileOption(
                            Icons.key,
                            'Gestionnaire De mot De Passe',
                          ),
                        ),

                        const SizedBox(height: 35),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserInfoScreen(),
                              ),
                            );
                          },
                          child: _buildProfileOption(
                            Icons.edit,
                            'Gestionnaire des informations',
                          ),
                        ),

                        const SizedBox(height: 35),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(builder: (context) => supp()),
                            );
                          },
                          child: _buildProfileOption(
                            Icons.person,
                            'Supprimer le Compte',
                          ),
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

  Widget _buildProfileOption(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, color: const Color(0xFF073057), size: 28),
        const SizedBox(width: 15),
        Text(
          text,
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF000000),
          ),
        ),
      ],
    );
  }
}
