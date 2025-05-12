/*import 'package:flutter/material.dart';
import '../common/notifications_screen.dart';
import '../common/messages/messages_screen.dart';
import '../common/temp_med_profile.dart';
import 'rendez_vous_screen.dart';
import 'services_screen.dart';
import 'files_screen.dart';
import '../../models/HealthcareProfessional.dart';

class MedecinHomeScreen extends StatefulWidget {
  final HealthcareProfessional user;

  MedecinHomeScreen({Key? key, required this.user}) : super(key: key);
  @override
  State<MedecinHomeScreen> createState() => _MedecinHomeScreenState();
}

class _MedecinHomeScreenState extends State<MedecinHomeScreen> {
  int _selectedIndex = 0;
  static const Color myDarkBlue = Color(0xFF073057);
  static const Color myBlue2 = Color(0xFF396C9B);
  static const Color myLightBlue = Color(0xFFA3C3E4);

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
        return ServicesScreen();
      case 2:
        return RendezVousScreen();
      case 3:
        return FilesScreen();
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
            _buildMedecinHeader(),
            const SizedBox(height: 20),
            _buildWorkScheduleSection(screenWidth),
            const SizedBox(height: 20),
            _buildPatientReviewsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildMedecinHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => ProfileScreen(user: widget.user)),
                );
              },
              child: Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: myBlue2.withOpacity(0.2),
                  border: Border.all(color: myBlue2, width: 2),
                  image: const DecorationImage(
                    image: NetworkImage('later.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.medical_services, color: myBlue2, size: 24),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Bienvenue",
                  style: TextStyle(
                    fontSize: 18,
                    color: myDarkBlue,
                  ),
                ),
                Text(
                  "Dr. Djabali",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: myDarkBlue,
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.notifications, color: myDarkBlue),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NotificationsScreen()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.message, color: myDarkBlue),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MessagesScreen()),
                );
              },
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
                child: Text(
                  "Voir tous",
                  style: TextStyle(color: myDarkBlue),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildReviewItem(
              "Mahdi", "Médecin très professionnel.", "Aujourd'hui", 5),
          _buildReviewItem("Melissa", "Consultation satisfaisante", "Hier", 3),
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
                    Text(time,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12)),
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
    return Container(
      decoration: BoxDecoration(
        color: myLightBlue, // même fond que "Derniers avis"
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
                "🗓️ Prochains rendez-vous",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: myDarkBlue,
                ),
              ),
              IconButton(
                icon: Icon(Icons.calendar_today, color: myDarkBlue),
                onPressed: () {
                  setState(() {
                    _selectedIndex = 2;
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildAppointmentCard(
            patient: "Yacine Khleifa",
            reason: "Consultation pour otite",
            time: "09:00 - 09:30",
            isNext: true,
          ),
          _buildAppointmentCard(
            patient: "Souad Benameur",
            reason: "Suture de plaie profonde",
            time: "09:30 - 10:00",
          ),
          _buildAppointmentCard(
            patient: "Mourad Saidi",
            reason: "Suivi des amygdales",
            time: "10:00 - 10:30",
          ),
          _buildAppointmentCard(
            patient: "Lilia Hammadi",
            reason: "Consultation pour allergie nasale",
            time: "10:30 - 11:00",
          ),
          _buildAppointmentCard(
            patient: "Karim Bouzid",
            reason: "Examen des cordes vocales",
            time: "11:00 - 11:30",
          ),
          const SizedBox(height: 10),
          Center(
            child: TextButton(
              onPressed: () {
                setState(() {
                  _selectedIndex = 2;
                });
              },
              child: Text(
                "VOIR TOUS LES RENDEZ-VOUS",
                style: TextStyle(
                  color: myBlue2,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
            ),
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
        color: Colors.white.withOpacity(0.95), // Couleur de fond adoucie
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isNext ? myBlue2 : Colors.grey.shade300,
          width: isNext ? 1.5 : 1,
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: myBlue2.withOpacity(0.15), // Couleur douce de fond icône
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person,
              color: myDarkBlue,
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
                const SizedBox(height: 4),
                Text(
                  reason,
                  style: TextStyle(
                    color: Colors.grey.shade700,
                    fontSize: 14,
                  ),
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
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.medical_services),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.folder),
                label: '',
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/

import 'package:flutter/material.dart';
import '../../models/AppointementService.dart';
import 'package:intl/intl.dart';
import '../common/notifications_screen.dart';
import '../common/messages/messages_screen.dart';
import '../common/temp_med_profile.dart';
import 'rendez_vous_screen.dart';
import 'services_screen.dart';
import 'files_screen.dart';
import '../../models/HealthcareProfessional.dart';
import '../../models/Appointment.dart';
import '../../models/Comment.dart';
import '../../models/Comment_service.dart';
import '../../models/HealthcareProfessionalService.dart';

/*void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: MedecinHomeScreen(
        user: , // À remplacer par l'ID réel
      ),
    );
  }
}*/

class MedecinHomeScreen extends StatefulWidget {
final HealthcareProfessional user;

  MedecinHomeScreen({Key? key, required this.user}) : super(key: key);

  @override
  State<MedecinHomeScreen> createState() => _MedecinHomeScreenState();
}

class _MedecinHomeScreenState extends State<MedecinHomeScreen> {
  int _selectedIndex = 0;
  static const Color myDarkBlue = Color(0xFF073057);
  static const Color myBlue2 = Color(0xFF396C9B);
  static const Color myLightBlue = Color(0xFFA3C3E4);
  
  late HealthcareProfessional? _healthcareProfessional;
  late Future<List<Appointment>> _upcomingAppointments;
  late Future<List<Comment>> _recentComments;
  bool _isLoading = true;
  
  final HealthcareProfessionalService _hpService = HealthcareProfessionalService();
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
      _upcomingAppointments = _appointmentService.queryField(
        'healthcareProfessionalId', 
        widget.user.id
      ).then((appointments) {
        final now = DateTime.now();
        return appointments.where((appt) {
          return appt.date.isAfter(now) && 
                 appt.status == AppointmentStatus.scheduled;
        }).toList()
          ..sort((a, b) => a.date.compareTo(b.date));
      });
      
      // Charger les commentaires récents
      _recentComments = _commentService.getCommentsForProfessional(
        widget.user.id
      ).then((comments) {
        return comments..sort((a, b) => b.date.compareTo(a.date));
      });
      
    } catch (e) {
      print('Error loading data: $e');
    } finally {
      setState(() => _isLoading = false);
    }
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
        return ServicesScreen(
          healthcareType: HealthcareType.medecin,
          professionalId: widget.user.id,
        );
      case 2:
        return RendezVousScreen(
          healthcareProfessionalId: widget.user.id,
        );
      case 3:
        return FilesScreen();
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
            _buildMedecinHeader(),
            const SizedBox(height: 20),
            _buildWorkScheduleSection(screenWidth),
            const SizedBox(height: 20),
            _buildPatientReviewsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildMedecinHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProfileScreen(
                      user : widget.user,
                    ),
                  ),
                );
              },
              child: Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: myBlue2.withOpacity(0.2),
                  border: Border.all(color: myBlue2, width: 2),
                  image: DecorationImage(
                    image: NetworkImage(_healthcareProfessional?.profileImageUrl ?? ''),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Center(
                  child: Icon(Icons.medical_services, color: myBlue2, size: 24),
                ),
              ),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Bienvenue",
                  style: TextStyle(
                    fontSize: 18,
                    color: myDarkBlue,
                  ),
                ),
                Text(
                  "Dr ${widget.user.name}",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: myDarkBlue,
                  ),
                ),
              ],
            ),
          ],
        ),
        Row(
          children: [
            IconButton(
              icon: Icon(Icons.notifications, color: myDarkBlue),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => NotificationsScreen()),
                );
              },
            ),
            IconButton(
              icon: Icon(Icons.message, color: myDarkBlue),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => MessagesScreen()),
                );
              },
            ),
          ],
        ),
      ],
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
            child: Text(name.isNotEmpty ? name[0] : '?', 
                style: const TextStyle(color: Colors.white)),
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
                    Text(time,
                        style:
                            const TextStyle(color: Colors.grey, fontSize: 12)),
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
    return FutureBuilder<List<Appointment>>(
      future: _upcomingAppointments,
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
              "Aucun rendez-vous à venir",
              style: TextStyle(color: myDarkBlue),
            ),
          );
        }
        
        final appointments = snapshot.data!.take(5).toList();
        final now = DateTime.now();
        final nextAppointment = appointments.firstWhere(
          (appt) => appt.date.isAfter(now),
          orElse: () => appointments.first,
        );
        
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
                    "🗓️ Prochains rendez-vous",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: myDarkBlue,
                    ),
                  ),
                  IconButton(
                    icon: Icon(Icons.calendar_today, color: myDarkBlue),
                    onPressed: () {
                      setState(() {
                        _selectedIndex = 2;
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 10),
              ...appointments.map((appt) => _buildAppointmentCard(
                patient: appt.patientId, // Vous devrez récupérer le nom du patient
                reason: appt.serviceId, // Vous devrez récupérer le nom du service
                time: '${appt.startTime.format(context)} - ${appt.endTime.format(context)}',
                isNext: appt.id == nextAppointment.id,
              )).toList(),
              const SizedBox(height: 10),
              Center(
                child: TextButton(
                  onPressed: () {
                    setState(() {
                      _selectedIndex = 2;
                    });
                  },
                  child: Text(
                    "VOIR TOUS LES RENDEZ-VOUS",
                    style: TextStyle(
                      color: myBlue2,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
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
        color: Colors.white.withOpacity(0.95),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isNext ? myBlue2 : Colors.grey.shade300,
          width: isNext ? 1.5 : 1,
        ),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: myBlue2.withOpacity(0.15),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.person,
              color: myDarkBlue,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                FutureBuilder<String?>(
                  future: _getPatientName(patient),
                  builder: (context, snapshot) {
                    return Text(
                      snapshot.data ?? 'Patient',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: myDarkBlue,
                        fontSize: 16,
                      ),
                    );
                  },
                ),
                const SizedBox(height: 4),
                FutureBuilder<String?>(
                  future: _getServiceName(reason),
                  builder: (context, snapshot) {
                    return Text(
                      snapshot.data ?? 'Service',
                      style: TextStyle(
                        color: Colors.grey.shade700,
                        fontSize: 14,
                      ),
                    );
                  },
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

  Future<String?> _getPatientName(String patientId) async {
    // Implémentez cette méthode pour récupérer le nom du patient
    // Utilisez PatientService
    return 'Nom Patient'; // Remplacer par l'appel réel au service
  }

  Future<String?> _getServiceName(String serviceId) async {

    // Implémentez cette méthode pour récupérer le nom du service
    // Utilisez ServicesService
    return 'Nom Service'; // Remplacer par l'appel réel au service
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
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.medical_services),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_today),
                label: '',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.folder),
                label: '',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

