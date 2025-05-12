import 'package:flutter/material.dart';

class AppointmentPage2 extends StatefulWidget {
  @override
  State<AppointmentPage2> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage2> {
  DateTime? selectedDate;
  int? selectedChrono;
  String? selectedSpecialty;
  String? selectedDoctor;

  final List<String> specialties = [
    "ORL et chirurgie",
    "Dermatologie",
    "Pédiatrie",
    "Cardiologie",
    "Médecine générale",
    "Ophtalmologie",
    "Gynécologie obstétrique",
    "Stomatologie"
  ];

  final Map<String, List<String>> doctorsBySpecialty = {
    "Stomatologie": ["Dr. Khiat Nadjia", "Dr. Abdouni Khaled"],
    // Vous pouvez ajouter d'autres spécialités et médecins ici
  };

  // Liste complète des chronos possibles
  final List<Map<String, dynamic>> allChronos = [
    {'id': 1, 'start': '08:00', 'end': '09:00'},
    {'id': 2, 'start': '09:00', 'end': '10:00'},
    {'id': 3, 'start': '10:00', 'end': '11:00'},
    {'id': 4, 'start': '11:00', 'end': '12:00'},
    {'id': 5, 'start': '12:00', 'end': '13:00'},
    {'id': 6, 'start': '13:00', 'end': '14:00'},
    {'id': 7, 'start': '14:00', 'end': '15:00'},
    {'id': 8, 'start': '15:00', 'end': '16:00'},
  ];

  // Liste des chronos disponibles
  List<Map<String, dynamic>> availableChronos = [];

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        selectedDate = picked;
        selectedChrono = null;
        _updateAvailableChronos(picked);
      });
    }
  }

  void _updateAvailableChronos(DateTime date) {
    final random = DateTime.now().millisecondsSinceEpoch % 8;
    availableChronos = allChronos.map((chrono) {
      return {
        ...chrono,
        'available': chrono['id'] % 3 != random % 3,
      };
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Prendre un rendez-vous",
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
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.blue[100],
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: [
              // Spécialité
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Spécialité",
                    style: TextStyle(fontWeight: FontWeight.w500)),
              ),
              SizedBox(height: 6),
              DropdownButtonFormField<String>(
                value: selectedSpecialty,
                hint: Text("Choisir une spécialité"),
                items: specialties
                    .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                onChanged: (val) {
                  setState(() {
                    selectedSpecialty = val;
                    selectedDoctor = null; // Reset doctor when specialty changes
                  });
                },
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.blue[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Médecin (n'apparaît que si spécialité sélectionnée)
              if (selectedSpecialty != null && 
                  doctorsBySpecialty.containsKey(selectedSpecialty)) ...[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Médecin",
                      style: TextStyle(fontWeight: FontWeight.w500)),
                ),
                SizedBox(height: 6),
                DropdownButtonFormField<String>(
                  value: selectedDoctor,
                  hint: Text("Choisir un médecin"),
                  items: doctorsBySpecialty[selectedSpecialty]!
                      .map((d) => DropdownMenuItem(value: d, child: Text(d)))
                      .toList(),
                  onChanged: (val) {
                    setState(() {
                      selectedDoctor = val;
                    });
                  },
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.blue[50],
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(25),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                SizedBox(height: 20),
              ],

              // Date
              Align(
                alignment: Alignment.centerLeft,
                child: Text("Date",
                    style: TextStyle(fontWeight: FontWeight.w500)),
              ),
              SizedBox(height: 6),
              TextFormField(
                readOnly: true,
                decoration: InputDecoration(
                  hintText: selectedDate != null
                      ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                      : "JJ/MM/AAAA",
                  suffixIcon: IconButton(
                    icon: Icon(Icons.calendar_today),
                    onPressed: _pickDate,
                  ),
                  filled: true,
                  fillColor: Colors.blue[50],
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(25),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              SizedBox(height: 20),

              // Chronos disponibles (n'apparaît que si date sélectionnée)
              if (selectedDate != null) ...[
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text("Choisissez un créneau horaire",
                      style: TextStyle(fontWeight: FontWeight.w500)),
                ),
                SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: availableChronos.map((chrono) {
                    return GestureDetector(
                      onTap: chrono['available']
                          ? () {
                              setState(() {
                                selectedChrono = chrono['id'];
                              });
                            }
                          : null,
                      child: Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        decoration: BoxDecoration(
                          color: chrono['available']
                              ? (selectedChrono == chrono['id']
                                  ? Colors.green[200]
                                  : Colors.blue[50])
                              : Colors.grey[300],
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: chrono['available']
                                ? Colors.blue
                                : Colors.grey,
                          ),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              "${chrono['start']} - ${chrono['end']}",
                              style: TextStyle(
                                color: chrono['available'] ? Colors.black : Colors.grey,
                                decoration: chrono['available'] ? null : TextDecoration.lineThrough,
                              ),
                            ),
                            if (!chrono['available'])
                              Icon(Icons.block, size: 16, color: Colors.red),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                ),
                SizedBox(height: 20),
              ],

              // Button
              ElevatedButton(
                onPressed: selectedSpecialty != null && 
                          (doctorsBySpecialty[selectedSpecialty] == null || 
                           selectedDoctor != null) &&
                          selectedDate != null && 
                          selectedChrono != null
                    ? () {
                        showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Succès"),
                            content: Text(
                                "Votre rendez-vous avec ${selectedDoctor ?? 'un spécialiste'} en $selectedSpecialty a été demandé avec succès pour le ${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year} à ${allChronos.firstWhere((c) => c['id'] == selectedChrono)['start']}."),
                            actions: [
                              TextButton(
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  Navigator.of(context).pop();
                                },
                                child: Text("OK"),
                              ),
                            ],
                          ),
                        );
                      }
                    : null,
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  backgroundColor: selectedSpecialty != null && 
                                 (doctorsBySpecialty[selectedSpecialty] == null || 
                                  selectedDoctor != null) &&
                                 selectedDate != null && 
                                 selectedChrono != null
                      ? Colors.blue[200]
                      : Colors.grey[300],
                  foregroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                child: Text("Demander le rendez-vous",
                    style: TextStyle(fontWeight: FontWeight.bold)),
              )
            ],
          ),
        ),
      ),
    );
  }
}