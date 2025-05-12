/*import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/HealthcareProfessional.dart';
import 'rendez_vous_page.dart';

class InfoPage2 extends StatefulWidget {
  final HealthcareProfessional professional;

  const InfoPage2({Key? key, required this.professional}) : super(key: key);

  @override
  _InfoPage2State createState() => _InfoPage2State();
}

class _InfoPage2State extends State<InfoPage2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "plus d'informations",
          style: TextStyle(
            color: Color.fromARGB(255, 19, 87, 114),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: BackButton(color: Color.fromARGB(255, 19, 87, 114)),
        backgroundColor: Colors.blue[100],
        elevation: 0,
        scrolledUnderElevation: 0,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header card (comme dans votre exemple)
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 10,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(
                          "https://th.bing.com/th/id/OIP.6KV81xM8wNW3EBK_L4o64QHaHa?cb=iwp1&w=500&h=500&rs=1&pid=ImgDetMain",
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Dr. Leila Mansouri",
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 4),
                            Text(
                              "Cardiologie",
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.star, color: Color(0xFF073057), size: 16),
                                SizedBox(width: 4),
                                Text('4.8'),
                                SizedBox(width: 12),
                                Icon(Icons.comment_outlined, color: Color(0xFF073057), size: 16),
                                SizedBox(width: 4),
                                Text('24'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.chat_bubble_outline, color: Color(0xFF073057)),
                            onPressed: () {},
                            tooltip: "Envoyer un message",
                          ),
                          IconButton(
                            icon: Icon(Icons.favorite_border, color: Color(0xFF073057)),
                            onPressed: () {},
                            tooltip: "Ajouter aux favoris",
                          ),
                          IconButton(
                            icon: Icon(Icons.share, color: Color(0xFF073057)),
                            onPressed: () {},
                            tooltip: "Partager",
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Wrap(
                    alignment: WrapAlignment.spaceBetween,
                    runSpacing: 8,
                    spacing: 16,
                    children: [
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("Horaires"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Lundi - Vendredi: 08h00 - 17h00"),
                                  Text("Samedi: 09h00 - 13h00"),
                                  Text("Dimanche: Fermé"),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text("Fermer"),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Text("Horaires"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[100],
                          foregroundColor: Color.fromARGB(255, 19, 87, 114),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AppointmentPage(),
                            ),
                          );
                        },
                        child: Text("Prendre un rendez-vous"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(225, 43, 133, 206),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 30),

            // Profile section
            Text(
              "Profile",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 19, 87, 114),
              ),
            ),
            SizedBox(height: 8),
            Text(
              "Dr. Leila Mansouri est une spécialiste en cardiologie, reconnue pour son expertise dans le diagnostic et le traitement des maladies cardiovasculaires. Elle prend en charge les patients souffrant d'hypertension, d'insuffisance cardiaque, de troubles du rythme et d'autres pathologies cardiaques. Elle met l'accent sur une approche préventive, intégrant la nutrition, l'activité physique et les bilans cardiovasculaires pour optimiser la santé de ses patients.",
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 30),

            // Services section
            Text(
              "Services médicaux",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 19, 87, 114),
              ),
            ),
            SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildServiceItem("- Traitement de l'arythmie"),
                _buildServiceItem("- Electrocardiogramme"),
                _buildServiceItem("- Tests de stress cardiaque"),
                _buildServiceItem("- Chirurgie cardiaque"),
              ],
            ),
            SizedBox(height: 30),

            // Address & Contact section
            Text(
              "Adresse & Contact",
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color.fromARGB(255, 19, 87, 114),
              ),
            ),
            SizedBox(height: 8),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildContactItem("Adresse : 15 Rue des Frères Mokrani, Hussein Dey"),
                _buildContactItem("Téléphone : +213 554 31 22 04"),
                _buildContactItem("Email : dr.khati.nadjia@gmail.com"),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        text,
        style: TextStyle(fontSize: 14),
      ),
    );
  }

  Widget _buildContactItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Text(
        text,
        style: TextStyle(fontSize: 14),
      ),
    );
  }
}*/