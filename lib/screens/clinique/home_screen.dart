import 'package:flutter/material.dart';
import 'package:flutter_application_2/login/paccueil2.dart';
import '../common/notifications_screen.dart';
import '../common/messages/messages_screen.dart';
import '../common/temp_clinic_profile.dart';
import 'service.dart';
import 'file_screen.dart';
import 'rendez_vous.dart';
import '../../models/HealthcareProfessional.dart';

import '../../models/HealthcareProfessionalservice.dart';
import '../../models/AppointementService.dart';
import '../../models/Appointment.dart';
import '../../models/Comment.dart';
import '../../models/Comment_service.dart';
import 'package:intl/intl.dart';
class ClinicHomeScreen extends StatefulWidget {
  final HealthcareProfessional user;
  ClinicHomeScreen({Key? key, required this.user}) : super(key: key);
  @override
  State<ClinicHomeScreen> createState() => _ClinicHomeScreenState();
}

class _ClinicHomeScreenState extends State<ClinicHomeScreen> {
  int _selectedIndex = 0;
  late HealthcareProfessional? _healthcareProfessional;
  late Future<List<Appointment>> _upcomingAppointments;
  late Future<List<Comment>> _recentComments;
  bool _isLoading = true;
  static const Color myDarkBlue = Color(0xFF073057);
  static const Color myBlue2 = Color(0xFF396C9B);
  static const Color myLightBlue = Color(0xFFA3C3E4);
  int _currentIndex = 0;
  final HealthcareProfessionalService _hpService =
      HealthcareProfessionalService();
  final AppointmentService _appointmentService = AppointmentService();
  final CommentService _commentService = CommentService();

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);

    try {
      // Charger les données du professionnel de santé
      _healthcareProfessional = await _hpService.get(widget.user.id);

      // Charger les rendez-vous à venir
      _upcomingAppointments = _appointmentService
          .queryField('healthcareProfessionalId', widget.user.id)
          .then((appointments) {
        final now = DateTime.now();
        return appointments.where((appt) {
          return appt.date.isAfter(now) &&
              appt.status == AppointmentStatus.scheduled;
        }).toList()
          ..sort((a, b) => a.date.compareTo(b.date));
      });

      // Charger les commentaires récents
      _recentComments = _commentService
          .getCommentsForProfessional(widget.user.id)
          .then((comments) {
        return comments..sort((a, b) => b.date.compareTo(a.date));
      });
    } catch (e) {
      print('Error loading data: $e');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  final List<Map<String, String>> doctors = [
    {
      'name': 'Dr. Boudaoud Athmane',
      'specialty': 'Médecine interne',
      'image':
          'https://img.freepik.com/free-photo/smiley-doctor-with-stethoscope-isolated_23-2148473568.jpg',
    },
    {
      'name': 'Dr. Sofia Leclerc',
      'specialty': 'Cardiologie',
      'image':
          'https://img.freepik.com/free-photo/portrait-confident-female-doctor_329181-13484.jpg',
    },
    {
      'name': 'Dr. Karim Benyahia',
      'specialty': 'Pédiatrie',
      'image':
          'https://img.freepik.com/free-photo/smiley-male-doctor-uniform_23-2148473544.jpg',
    },
  ];

  void _nextDoctor() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % doctors.length;
    });
  }

  void _previousDoctor() {
    setState(() {
      _currentIndex = (_currentIndex - 1 + doctors.length) % doctors.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: _getScreenForIndex(_selectedIndex),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _getScreenForIndex(int index) {
    switch (index) {
      case 0:
        return HomeContent();
      case 1:
        return Serviceclinique();
      case 2:
        return RendezVousclinic();
        return RendezVousScreen( 
       healthcareProfessionalId: widget.user.id,
        );
      case 3:
        return Files_clinique();
      default:
        return HomeContent();
    }
  }

  Widget HomeContent() {
    double screenWidth = MediaQuery.of(context).size.width;

    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopBar(),
            const SizedBox(height: 20),
            _buildPatientReviewsSection(),
            const SizedBox(height: 20),
            _buildWorkScheduleSection(screenWidth),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Profile photo (40x40)
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfileScreen(user: widget.user)),
            );
          },
          child: Container(
            width: 40,
            height: 40,
            child: CircleAvatar(backgroundImage: NetworkImage('')),
          ),
        ),
        // Search bar (50% width, 40 height)
        Container(
          width: MediaQuery.of(context).size.width * 0.5,
          height: 40, // Match profile photo height
          margin: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.blue[100],
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Rechercher...',
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(
                vertical: 11,
              ), // Adjust text position
              prefixIcon: Icon(Icons.search, color: Colors.blueGrey, size: 20),
            ),
          ),
        ),
        // Notification and message icons (both 40x40)
        Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.blue[100],
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(Icons.notifications, color: myDarkBlue, size: 20),
                padding: EdgeInsets.zero,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => NotificationsScreen(),
                  ),
                ),
              ),
            ),
            SizedBox(width: 8),
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Colors.blue[100],
                shape: BoxShape.circle,
              ),
              child: IconButton(
                icon: Icon(Icons.message, color: myDarkBlue, size: 20),
                padding: EdgeInsets.zero,
                onPressed: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MessagesScreen()),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPatientReviewsSection() {
    return Container(
      decoration: BoxDecoration(
        color: myLightBlue,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "📢 Derniers avis",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: myDarkBlue,
                ),
              ),
              TextButton(
                onPressed: () {},
                child: Text("Voir tous", style: TextStyle(color: myDarkBlue)),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildReviewItem("Mahdi", "Super hopital", "Aujourd'hui", 5),
          _buildReviewItem(
            "Melissa",
            "les medecins sont professionals",
            "Hier",
            3,
          ),
        ],
      ),
    );
  }

  Widget _buildReviewItem(String name, String review, String time, int stars) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          CircleAvatar(
            backgroundColor: myBlue2,
            child: Text(name[0], style: const TextStyle(color: Colors.white)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: myDarkBlue,
                  ),
                ),
                Row(
                  children: [
                    ...List.generate(
                      5,
                      (index) => Icon(
                        Icons.star,
                        color: index < stars ? Colors.amber : Colors.grey,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Text(
                      time,
                      style: const TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
                Text(review, style: TextStyle(color: myDarkBlue)),
              ],
            ),
          ),
        ],
      ),
    );
  }

 Widget _buildPatientReviewsSection() {
    return FutureBuilder<List<Comment>>(
      future: _recentComments,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }
        
        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return Container(
            decoration: BoxDecoration(
              color: myLightBlue,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
            child: Text(
              "Aucun avis pour le moment",
              style: TextStyle(color: myDarkBlue),
            ),
          );
        }
        
        final comments = snapshot.data!.take(2).toList();
        
        return Container(
          decoration: BoxDecoration(
            color: myLightBlue,
            borderRadius: BorderRadius.circular(12),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "📢 Derniers avis",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: myDarkBlue,
                    ),
                  ),
                  TextButton(
                    onPressed: () {},
                    child: Text(
                      "Voir tous",
                      style: TextStyle(color: myDarkBlue),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ...comments.map((comment) => _buildReviewItem(
                comment.patientName,
                comment.comment,
                _formatDate(comment.date),
                _calculateRating(comment.comment), // Vous devrez implémenter cette logique
              )).toList(),
            ],
          ),
        );
      },
    );
  }
   String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);
    
    if (difference.inDays == 0) return "Aujourd'hui";
    if (difference.inDays == 1) return "Hier";
    if (difference.inDays < 7) return "Il y a ${difference.inDays} jours";
    
    return DateFormat('dd/MM/yyyy').format(date);
  }

  int _calculateRating(String comment) {
    // Logique simple pour déterminer une note basée sur le commentaire
    // Vous devriez remplacer cela par la vraie note si disponible
    if (comment.toLowerCase().contains('excellent')) return 5;
    if (comment.toLowerCase().contains('très bien')) return 4;
    if (comment.toLowerCase().contains('bien')) return 3;
    if (comment.toLowerCase().contains('moyen')) return 2;
    return 1;
  }


  Widget _buildReviewItem(
    String name, String review, String time, int stars) { // <-- Change DateTime to String
  return Container(
    margin: const EdgeInsets.symmetric(vertical: 8),
    padding: const EdgeInsets.all(12),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(10),
    ),
    child: Row(
      children: [
        CircleAvatar(
          backgroundColor: myBlue2,
          child: Text(name[0], style: TextStyle(color: Colors.white)),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(name,
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: myDarkBlue)),
              Row(
                children: [
                  ...List.generate(
                      5,
                      (index) => Icon(
                            Icons.star,
                            color: index < stars ? Colors.amber : Colors.grey,
                            size: 16,
                          )),
                  const SizedBox(width: 8),
                  Text("$time",
                      style: TextStyle(color: Colors.grey, fontSize: 12)),
                ],
              ),
              Text(review, style: TextStyle(color: myDarkBlue)),
            ],
          ),
        ),
      ],
    ),
  );
}
  Widget _buildWorkScheduleSection(double screenWidth) {
    final currentDoctor = doctors[_currentIndex];

    return Container(
      decoration: BoxDecoration(
        color: myLightBlue,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: myLightBlue, width: 2),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: const [
              Icon(Icons.local_hospital, color: Colors.red),
              SizedBox(width: 8),
              Text(
                'Nos services et spécialistes',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                  color: Color(0xFF073057),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_left),
                onPressed: _previousDoctor,
              ),
              CircleAvatar(
                radius: 40,
                backgroundImage: NetworkImage(currentDoctor['image']!),
              ),
              IconButton(
                icon: const Icon(Icons.arrow_right),
                onPressed: _nextDoctor,
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            currentDoctor['name']!,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
          Text(
            currentDoctor['specialty']!,
            style: const TextStyle(color: Colors.black87, fontSize: 14),
          ),
          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              DropdownButton<String>(
                value: 'Médecins',
                items: const [
                  DropdownMenuItem(value: 'Médecins', child: Text('Médecins')),
                  DropdownMenuItem(
                    value: 'Chirurgiens',
                    child: Text('Chirurgiens'),
                  ),
                ],
                onChanged: (value) {},
              ),
              const SizedBox(width: 10),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.arrow_forward),
                label: const Text('savoir plus'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF073057),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard({
    required String patient,
    required String reason,
    required String time,
    bool isNext = false,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: isNext ? myBlue2.withOpacity(0.1) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isNext ? myBlue2 : Colors.grey.shade200,
          width: isNext ? 1.5 : 1,
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: isNext ? myBlue2 : myLightBlue,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person,
              color: isNext ? Colors.white : myDarkBlue,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  patient,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: myDarkBlue,
                    fontSize: 16,
                  ),
                ),
                Text(
                  reason,
                  style: TextStyle(color: Colors.grey.shade700, fontSize: 14),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: isNext ? myBlue2 : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isNext ? myBlue2 : Colors.grey.shade400,
              ),
            ),
            child: Text(
              time,
              style: TextStyle(
                color: isNext ? Colors.white : myDarkBlue,
                fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: myBlue2,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Theme(
        data: ThemeData(
          splashColor: Colors.transparent,
          highlightColor: Colors.transparent,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white60,
            currentIndex: _selectedIndex,
            onTap: (index) => setState(() => _selectedIndex = index),
            elevation: 0,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            selectedFontSize: 0,
            unselectedFontSize: 0,
            enableFeedback: false,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
              BottomNavigationBarItem(
                icon: Icon(Icons.medical_services),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today),
                label: '',
              ),
              BottomNavigationBarItem(icon: Icon(Icons.folder), label: ''),
            ],
          ),
        ),
      ),
    );
  }
}
