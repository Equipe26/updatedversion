import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../parametres/par1.dart';
import '../../parametres/politique.dart';
import '../../parametres/Centre_aide1.dart';
import '../../auth_service.dart';
import '../../models/HealthcareProfessional.dart';

class ProfileScreen extends StatefulWidget {
  final HealthcareProfessional user;

  const ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final AuthService _authService = AuthService();
  
  void _handleLogout() async {
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
              onPressed: () async {
                Navigator.of(context).pop(); // Close dialog
                try {
                  await _authService.logout();
                  if (mounted) {
                    Navigator.pushNamedAndRemoveUntil(
                      context, 
                      '/home',
                      (Route<dynamic> route) => false, // Remove all previous routes
                    );
                  }
                } catch (e) {
                  print("Logout failed: $e");
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Erreur lors de la déconnexion')),
                  );
                }
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFA3C3E4),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF073057)),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Mon profile',
          style: GoogleFonts.leagueSpartan(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            color: const Color(0xFF073057),
          ),
        ),
        centerTitle: true,
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
                    height: screenHeight * 0.75,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: const Color(0xFFA3C3E4),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: const Color(
                            0xFF073057,
                          ), // Couleur de fond
                          child: const Icon(
                            Icons.medical_services,
                            color: Colors.white, // Couleur de l'icône
                            size: 40, // Taille de l'icône
                          ),
                        ),
                        const SizedBox(height: 10),
                        Text(
                          widget.user.name,
                          style: GoogleFonts.leagueSpartan(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF000000),
                          ),
                        ),
                        const SizedBox(height: 50),
                        _buildProfileOption(Icons.settings, 'Paramètres', () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const para1(),
                            ),
                          );
                        }),
                        const SizedBox(height: 30),
                        _buildProfileOption(
                          Icons.lock,
                          'Politique de confidentialité',
                          () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    const PrivacyPolicyScreen(),
                              ),
                            );
                          },
                        ),
                        const SizedBox(height: 30),
                        _buildProfileOption(Icons.help, 'Aide', () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const HelpCenterScreen(),
                            ),
                          );
                        }),
                        const SizedBox(height: 30),
                        _buildLogoutOption(
                            Icons.logout, 'Se déconnecter', _handleLogout)
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

  Widget _buildProfileOption(IconData icon, String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF073057), size: 28),
          const SizedBox(width: 15),
          Text(
            text,
            style: GoogleFonts.leagueSpartan(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF073057),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLogoutOption(IconData icon, String text, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF073057), size: 28),
          const SizedBox(width: 15),
          Text(
            text,
            style: GoogleFonts.leagueSpartan(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF073057),
            ),
          ),
        ],
      ),
    );
  }
}
