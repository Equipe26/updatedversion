import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/HealthcareProfessional.dart';
import 'package:flutter_application_2/models/Comment_service.dart';
import 'package:flutter_application_2/models/Rating_service.dart';
import 'rendez_vous_page.dart';

class InfoPage extends StatefulWidget {
  final HealthcareProfessional professional;

  const InfoPage({Key? key, required this.professional}) : super(key: key);

  @override
  _InfoPageState createState() => _InfoPageState();
}

class _InfoPageState extends State<InfoPage> {
  final RatingService _ratingService = RatingService();
  final CommentService _commentService = CommentService();
  double _averageRating = 0.0;
  int _commentCount = 0;
  List<HealthcareProfessional> _clinicDoctors = [];

  @override
  void initState() {
    super.initState();
    _loadRatingAndComments();
    if (widget.professional.isClinic) {
      _loadClinicDoctors();
    }
  }

  Future<void> _loadClinicDoctors() async {
    // In a real app, you would fetch actual doctor data using staffIds
    // For now, we'll create placeholder doctors based on available specialties
    if (widget.professional.staffIds != null && widget.professional.staffIds!.isNotEmpty) {
      setState(() {
        _clinicDoctors = widget.professional.availableSpecialties.map((specialty) {
          return HealthcareProfessional(
            id: 'doc_${specialty.name}',
            name: "Dr. ${specialty.name}",
            email: "doctor_${specialty.name}@clinique.com",
            password: "",
            location: widget.professional.location ?? '',
            wilaya: widget.professional.wilaya,
            exactAddress: widget.professional.exactAddress,
            type: HealthcareType.medecin,
            gender: Gender.male,
            specialty: specialty,
            availableSpecialties: [specialty],
            licenseNumber: widget.professional.licenseNumber,
          );
        }).toList();
      });
    }
  }

  Future<void> _loadRatingAndComments() async {
    try {
      final rating = await _ratingService.getAverageRating(widget.professional.id);
      final count = await _commentService.getCommentCount(widget.professional.id);
      
      setState(() {
        _averageRating = rating;
        _commentCount = count ?? 0;
      });
    } catch (e) {
      print('Error loading rating and comments: $e');
    }
  }

  String _getAvailabilityText() {
    if (widget.professional.weeklyAvailability.isEmpty) {
      return "Horaires non disponibles";
    }

    final availability = widget.professional.weeklyAvailability.first;
    final days = ['Lundi', 'Mardi', 'Mercredi', 'Jeudi', 'Vendredi', 'Samedi', 'Dimanche'];
    final workingDays = days.where((day) {
      final slots = availability.availability[day] ?? [];
      return slots.any((slot) => slot == 1);
    }).toList();

    if (workingDays.isEmpty) return "Non disponible";

    final firstDay = workingDays.first;
    final lastDay = workingDays.last;

    if (workingDays.length == 1) {
      return "$firstDay: 08h-17h";
    } else {
      return "$firstDay - $lastDay: 08h-17h";
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDoctorOrClinic = widget.professional.isDoctor || widget.professional.isClinic;
    
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
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header Card
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 6,
                    offset: Offset(0, 2)),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(widget.professional.profileImageUrl),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              widget.professional.name,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18),
                            ),
                            SizedBox(height: 4),
                            Text(
                              widget.professional.specialty?.name ?? 
                                widget.professional.typeDisplay,
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14),
                            ),
                            SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(Icons.star, color: Colors.amber, size: 20),
                                SizedBox(width: 4),
                                Text(_averageRating.toStringAsFixed(1)),
                                SizedBox(width: 12),
                                Icon(Icons.comment, color: Colors.blue, size: 20),
                                SizedBox(width: 4),
                                Text(_commentCount.toString()),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 16),
                  Wrap(
                    spacing: 12,
                    runSpacing: 12,
                    children: [
                      // Horaires button (always shown)
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text("Horaires"),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(_getAvailabilityText()),
                                  if (widget.professional.weeklyAvailability.isNotEmpty)
                                    ...widget.professional.weeklyAvailability.first.availability.entries.map((e) {
                                      final hasAvailability = e.value.any((slot) => slot == 1);
                                      return Text("${e.key}: ${hasAvailability ? '08h-17h' : 'Fermé'}");
                                    }).toList(),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: Text("OK"),
                                ),
                              ],
                            ),
                          );
                        },
                        child: Text("Horaires"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue[100],
                          foregroundColor: Color.fromARGB(255, 19, 87, 114),
                        ),
                      ),
                      // Rendez-vous button (only for doctors/clinics)
                      if (isDoctorOrClinic)
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AppointmentPage(professional: widget.professional),
                            ),
                          );
                        },
                        child: Text("Prendre RDV"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color.fromARGB(255, 19, 87, 114),
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 24),

            // Profile Section
            if (isDoctorOrClinic)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Description",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 19, 87, 114),
                )),
                SizedBox(height: 8),
                Text(
                  widget.professional.isClinic 
                    ? "${widget.professional.name} est une clinique spécialisée offrant des services de haute qualité dans divers domaines médicaux."
                    : "Dr. ${widget.professional.name.split(' ').last} est un(e) spécialiste en ${widget.professional.specialty?.name ?? widget.professional.typeDisplay}, reconnu(e) pour son expertise dans le diagnostic et le traitement des maladies.",
                  style: TextStyle(fontSize: 14),
                ),
                SizedBox(height: 24),
              ],
            ),

            // Services Section
            if (isDoctorOrClinic)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Services",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 19, 87, 114),
                )),
                SizedBox(height: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (widget.professional.isClinic)
                      ...widget.professional.availableSpecialties.map((specialty) => 
                        _buildServiceItem("• ${specialty.name}")),
                    if (widget.professional.isDoctor)
                      ...widget.professional.serviceIds.map((service) => 
                        _buildServiceItem("• $service")),
                  ],
                ),
                SizedBox(height: 24),
              ],
            ),

            // Clinic Doctors Section
            if (widget.professional.isClinic && _clinicDoctors.isNotEmpty)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Médecins",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 19, 87, 114),
                  ),
                ),
                SizedBox(height: 12),
                ..._clinicDoctors.map((doctor) => 
                  Container(
                    margin: EdgeInsets.only(bottom: 12),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.grey[50],
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.grey[200]!),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 24,
                          backgroundImage: NetworkImage(doctor.profileImageUrl),
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                doctor.name,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold),
                              ),
                              Text(
                                doctor.specialty?.name ?? "Médecin",
                                style: TextStyle(
                                  color: Colors.grey[600],
                                  fontSize: 13),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.arrow_forward_ios, size: 16),
                          onPressed: () {
                            // Navigate to doctor's profile
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => InfoPage(professional: doctor),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(height: 24),
              ],
            ),

            // Contact Section
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Contact",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 19, 87, 114),
                )),
                SizedBox(height: 12),
                _buildContactItem(
                  Icons.location_on,
                  "${widget.professional.exactAddress}, ${widget.professional.commune?.name ?? widget.professional.wilaya.name}",
                ),
              
                _buildContactItem(
                  Icons.email,
                  widget.professional.email,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildServiceItem(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 4),
      child: Text(
        text,
        style: TextStyle(fontSize: 14),
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 20, color: Colors.blue[700]),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: TextStyle(fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }
}