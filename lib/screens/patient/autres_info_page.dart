import 'package:flutter/material.dart';
import '../../models/hospital_info.dart';
import 'rendez_vous2.dart';
import 'package:flutter_application_2/models/HealthcareProfessional.dart';

class InfoPage extends StatefulWidget {
  final HealthcareProfessional professional;

  InfoPage({Key? key, required this.professional}) : super(key: key);
  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {

  late HospitalInfo hospital;

  final List<Map<String, dynamic>> _services = [
    {
      "name": "Dr. Hachi Karim",
      "type": "Médecine interne",
      "image":
          "https://th.bing.com/th/id/OIP.ftpyW0_ODpuiXjJl2EFj-AAAAA?w=474&h=474&rs=1&pid=ImgDetMain",
    },
    {
      "name": "Dr. Djebari Nacera",
      "type": "Orthopédie",
      "image": "https://thumbs.dreamstime.com/b/medical-people-16261743.jpg",
    },

    {
      "name": "Dr. Khiat Nadjia",
      "type": "Stomatologie",
      "image":
          "https://static.vecteezy.com/system/resources/previews/027/546/977/large_2x/doctor-lady-friendly-smiling-arms-crossed-free-photo.jpg",
    },
    {
      "name": "Dr. Kamel Rahal",
      "type": "Pédiatrie",
      "image":
          "https://th.bing.com/th/id/OIP.FAKpw1VnVlsHVktq6w_uqwHaHa?rs=1&pid=ImgDetMain",
    },
    {
      "name": "Dr. Abdouni Khaled",
      "type": "Stomatologie",
      "image":
          "https://m.media-amazon.com/images/S/aplus-media-library-service-media/7a841341-ccb4-416d-a5f4-4eb4777b2275.__CR0,0,362,453_PT0_SX362_V1___.jpg",
    },
  ];

  @override
  void initState() {
    super.initState();
    loadHospitalData();
  }

  void loadHospitalData() {
    hospital = HospitalInfo(
      name: "Clinique El Mountazah",
      imageUrl:
          "https://cdn-icons-png.flaticon.com/512/7447/7447748.png",
      rating: 0.0,
      reviews: 0,
      specialties: [
        "ORL et chirurgie",
        "Dermatologie",
        "Pédiatrie",
        "Cardiologie",
        "Médecine générale",
        "Ophtalmologie",
        "Gynécologie obstétrique"
      ],
      services: ["Médecine interne"],
      address: "Lot 265, Bois des Cars 3, Dely Ibrahim",
      phone: "023 29 14 14 / 023 29 15 15",
      email: "contact.co@cliniquefatemaolazhar.com",
      workHours: [
        "Lundi - Jeudi : 08h00 - 17h00",
        "Vendredi : 08h00 - 12h00",
        "Samedi : 09h00 - 13h00",
        "Dimanche : Fermé"
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          "plus d’informations",
          style: TextStyle(
            color: Color.fromARGB(255, 19, 87, 114),
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        leading: BackButton(color: Color.fromARGB(255, 19, 87, 114)),
        backgroundColor:
            Colors.blue[100], // Même couleur que le fond de la page
        elevation: 0, // Supprime l'ombre sous l'AppBar
        scrolledUnderElevation: 0, // Empêche l'effet d'élévation lors du scroll
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header card
            Container(
              padding: const EdgeInsets.all(16),
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
                        backgroundImage: NetworkImage(hospital.imageUrl),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              hospital.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.star,
                                    color: Color(0xFF073057), size: 16),
                                SizedBox(width: 4),
                                Text('${hospital.rating}'),
                                SizedBox(width: 12),
                                Icon(Icons.comment_outlined,
                                    color: Color(0xFF073057), size: 16),
                                SizedBox(width: 4),
                                Text('${hospital.reviews}'),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: Icon(Icons.chat_bubble_outline,
                                color: Color(0xFF073057)),
                            onPressed: () {},
                            tooltip: "Envoyer un message",
                          ),
                          IconButton(
                            icon: Icon(Icons.favorite_border,
                                color: Color(0xFF073057)),
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
                      GestureDetector(
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("Horaires d'ouverture"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text("Lundi - Jeudi : 08h00 - 17h00"),
                                  Text("Vendredi : 08h00 - 12h00"),
                                  Text("Samedi : 09h00 - 13h00"),
                                  Text("Dimanche : Fermé"),
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
                        child: Chip(
                          label: Text('Horaires'),
                          backgroundColor: Colors.blue[100],
                          avatar: Icon(Icons.access_time,
                              size: 18, color: Color(0xFF073057)),
                        ),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AppointmentPage2()),
                          );
                        },
                        icon: Icon(Icons.calendar_today,
                            size: 18, color: Color(0xFF073057)),
                        label: Text(
                          "Prendre un rendez-vous",
                          style: TextStyle(fontSize: 14),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor:
                              const Color.fromARGB(225, 43, 133, 206),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(15),
                          ),
                          padding: EdgeInsets.symmetric(
                              horizontal: 16, vertical: 10),
                          elevation: 0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Spécialités médicales
            Text('🔹 Spécialités médicales',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            ...hospital.specialties.map((e) => ListTile(
                  leading: Icon(Icons.circle, size: 10, color: Colors.blue),
                  title: Text(e),
                  dense: true,
                )),
            SizedBox(height: 20),

            // spécialistes
            Text('🔹 Nos spécialistes',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _services.map((service) {
                  return Container(
                    width: 140,
                    margin: EdgeInsets.only(right: 12),
                    padding: EdgeInsets.all(8),
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
                      mainAxisSize:
                          MainAxisSize.min, // <-- Important pour l'ajustement
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 30,
                          backgroundImage: NetworkImage(service["image"]),
                        ),
                        SizedBox(height: 8),
                        Text(service["name"],
                            textAlign: TextAlign.center,
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(service["type"],
                            textAlign: TextAlign.center,
                            style: TextStyle(fontSize: 12)),
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),

            SizedBox(height: 20),

            // Adresse & Contact
            Text('📍 Adresse & Contact',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text('Adresse: ${hospital.address}'),
            Text('Téléphone: ${hospital.phone}'),
            Text('Email: ${hospital.email}'),
          ],
        ),
      ),
    );
  }
}