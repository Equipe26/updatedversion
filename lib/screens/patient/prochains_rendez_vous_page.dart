import 'package:flutter/material.dart';

class ProchainsRendezvousPage extends StatelessWidget {
  const ProchainsRendezvousPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      backgroundColor: Color(0xFFB0C4DE), // Bleu clair de fond
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container( 
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.calendar_today, color: Colors.blue),
                          SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              "Prochains rendez-vous",
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.blue.shade900,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10),
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildDropdownButton("22/02/25"),
                            SizedBox(width: 5),
                            _buildDropdownButton("8:00 - 12:00"),
                            SizedBox(width: 5),
                            _buildDropdownButton("Spécialité"),
                            SizedBox(width: 5),
                            _buildDropdownButton("Dr. Amrane Kamal"),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Container(
                padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 4,
                        offset: Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Center(
                        child: Text(
                          "22 Février 2025",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.blue.shade900,
                          ),
                        ),
                      ),
                      SizedBox(height: 10),
                      ..._buildAppointmentsList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownButton(String text) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.blue.shade300),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            text,
            style: TextStyle(color: Colors.blue.shade900, fontSize: 14),
            overflow: TextOverflow.ellipsis,
          ),
          Icon(Icons.arrow_drop_down, color: Colors.blue.shade900),
        ],
      ),
    );
  }

  List<Widget> _buildAppointmentsList() {
    List<Map<String, String>> appointments = [
      {"time": "08:00", "title": "Consultation pour otite", "patient": "Yacine Thelfa"},
      {"time": "08:30", "title": "Suture de plaie profonde", "patient": "Souad Bennamur"},
      {"time": "09:00", "title": "Suivi des amygdales", "patient": "Mourad Saïd"},
      {"time": "09:30", "title": "Consultation pour allergie nasale", "patient": "Lilia Hamadi"},
      {"time": "10:00", "title": "Examen des cordes vocales", "patient": "Karim Bouzid"},
      {"time": "10:30", "title": "Suivi post-opération ORL", "patient": "Ahmed Mansour"},
      {"time": "11:00", "title": "Ablation de kyste sous anesthésie locale", "patient": "Yasmina Chibane"},
      {"time": "12:00", "title": "Vérification cicatrice post-chirurgie", "patient": "Leila Bourouba"},
    ];

    return appointments.map((appointment) {
      return _buildAppointmentItem(appointment["time"]!, appointment["title"]!, appointment["patient"]!);
    }).toList();
  }

  Widget _buildAppointmentItem(String time, String title, String patient) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Container(
        padding: EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: Colors.blue.shade200,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "$time  $title",
              style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Colors.black),
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              "→ $patient",
              style: TextStyle(fontSize: 12, color: Colors.black54),
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }
}