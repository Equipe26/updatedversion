import 'package:flutter/material.dart';

class RendezVousclinic extends StatelessWidget {
  static const Color myDarkBlue = Color(0xFF073057);
  static const Color myBlue2 = Color(0xFF396C9B);
  static const Color myLightBlue = Color(0xFFA3C3E4);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Rendez-vous',
          style: TextStyle(
            color: myDarkBlue,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.blue[100],
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: myDarkBlue),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDateSelector(),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  _buildAppointmentCard(
                    patientName: "Yacine Khleifa",
                    reason: "Consultation pour otite",
                    time: "09:00 - 09:30",
                    isNext: true,
                  ),
                  _buildAppointmentCard(
                    patientName: "Souad Benameur",
                    reason: "Suture de plaie profonde",
                    time: "09:30 - 10:00",
                  ),
                  _buildAppointmentCard(
                    patientName: "Mourad Saidi",
                    reason: "Suivi des amygdales",
                    time: "10:00 - 10:30",
                  ),
                  _buildAppointmentCard(
                    patientName: "Lilia Hammadi",
                    reason: "Consultation pour allergie nasale",
                    time: "10:30 - 11:00",
                  ),
                  _buildAppointmentCard(
                    patientName: "Karim Bouzid",
                    reason: "Examen des cordes vocales",
                    time: "11:00 - 11:30",
                  ),
                ],
              ),
            ),
            _buildAddButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: myLightBlue.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(Icons.chevron_left, color: myBlue2),
            onPressed: () {},
          ),
          Text(
            "Aujourd'hui, 15 Avril 2023",
            style: TextStyle(fontWeight: FontWeight.bold, color: myDarkBlue),
          ),
          IconButton(
            icon: Icon(Icons.chevron_right, color: myBlue2),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard({
    required String patientName,
    required String reason,
    required String time,
    bool isNext = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: isNext ? myBlue2 : Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isNext ? myBlue2 : myLightBlue,
            shape: BoxShape.circle,
          ),
          child: Icon(Icons.person, color: isNext ? Colors.white : myDarkBlue),
        ),
        title: Text(
          patientName,
          style: TextStyle(fontWeight: FontWeight.bold, color: myDarkBlue),
        ),
        subtitle: Text(reason, style: TextStyle(color: Colors.grey.shade600)),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              time,
              style: TextStyle(
                color: isNext ? myBlue2 : myDarkBlue,
                fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: ElevatedButton.icon(
        icon: Icon(Icons.add, color: Colors.white),
        label: Text(
          'Nouveau rendez-vous',
          style: TextStyle(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: myBlue2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        onPressed: () {
          // Action pour ajouter un nouveau rendez-vous
        },
      ),
    );
  }
}
