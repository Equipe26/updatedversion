/*import 'package:flutter/material.dart';
import 'package:flutter_application_2/admin/user.dart';
import 'discover_screen.dart';
import 'favorite_screen.dart';
import 'files_screen.dart';
import '../common/profile_screen.dart';
import '../common/notifications_screen.dart';
import '../common/messages/messages_screen.dart';
import '/auth_service.dart';
import '../../login/connexion.dart' hide Patient;
import '../../models/Patient.dart';

class MyApp extends StatelessWidget {
  final Patient user;

  const MyApp({Key? key, required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PatientHomeScreen(patient: user),
    );
  }
}

class PatientHomeScreen extends StatefulWidget {
  final Patient patient;

  const PatientHomeScreen({super.key, required this.patient});

  @override
  _PatientHomeScreenState createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  int _selectedIndex = 0;
  late List<Widget> _pages;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _pages = [
      PatientHomeScreenContent(patient: widget.patient),
      DiscoverScreen(),
      FavoriteScreen(),
      FilesScreen(),
    ];
  }

  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          decoration: BoxDecoration(
            color: _PatientHomeScreenContentState.myBlue2,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                elevation: 0,
                showSelectedLabels: false,
                showUnselectedLabels: false,
              ),
            ),
            child: SizedBox(
              height: 60,
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.transparent,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.white60,
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
                iconSize: 28,
                items: [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: '',
                  ), // Index 0
                  BottomNavigationBarItem(
                    icon: Icon(Icons.auto_awesome),
                    label: '',
                  ), // Index 1
                  BottomNavigationBarItem(
                    icon: Icon(Icons.favorite),
                    label: '',
                  ), // Index 2

                  BottomNavigationBarItem(
                    icon: Icon(Icons.folder),
                    label: '',
                  ), // Index 3
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PatientHomeScreenContent extends StatefulWidget {
  final Patient patient;

  const PatientHomeScreenContent({Key? key, required this.patient})
      : super(key: key);

  @override
  _PatientHomeScreenContentState createState() =>
      _PatientHomeScreenContentState();
}

class _PatientHomeScreenContentState extends State<PatientHomeScreenContent> {
  static const Color myDarkBlue = Color(0xFF073057);
  static const Color myBlue2 = Color(0xFF396C9B);
  int? _selectedDate; // Moved selected date here

  @override
  Widget build(BuildContext context) {
    int today = DateTime.now().day;
    _selectedDate ??= today; // Initialize with today's date if null

    List<int> dates = List.generate(6, (index) => 17 + index);

    // Sample appointments data
    Map<int, List<Map<String, dynamic>>> appointments = {
      19: [
        {
          'doctor': 'Dr. Bensoltane Souhila',
          'specialty': 'Soins pour les amygdales',
          'confirmed': true,
          'location': 'Clinique du Nord, Salle 12',
        },
        {
          'doctor': 'Dr. Khiati Nadjia',
          'specialty': 'Consultation pour allergie nasale',
          'confirmed': false,
          'location': 'Hôpital Central, Bâtiment A',
        },
      ],
      20: [
        {
          'doctor': 'Dr. Djabali Morad',
          'specialty': 'Contrôle annuel',
          'confirmed': true,
          'location': 'Centre Médical Sud',
        },
      ],
    };

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopBar(),
            SizedBox(height: 24),
            _buildAppointmentsCard(context, today, dates, appointments),
            SizedBox(height: 16),
            _buildEmergencyCard(),
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
    MaterialPageRoute(builder: (context) => ProfileScreen(patient: widget.patient)),
  );
          },
          child: Container(
            width: 40,
            height: 40,
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                'https://th.bing.com/th/id/R.90bb9597bff6b281ea8e079c339e97d8?rik=T1yOj6l%2bhakOrw&pid=ImgRaw&r=0',
              ),
            ),
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

  Widget _buildAppointmentsCard(
    BuildContext context,
    int today,
    List<int> dates,
    Map<int, List<Map<String, dynamic>>> appointments,
  ) {
    return Card(
      color: Colors.blue[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '📅 Prochains rendez-vous',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: myDarkBlue,
              ),
            ),
            SizedBox(height: 20),

            // Date selector
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: dates.map((date) {
                bool isSelected = date == _selectedDate;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDate = date;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(
                      vertical: 8,
                      horizontal: 12,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected ? myBlue2 : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Text(
                          '$date',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                        Text(
                          [
                            'DIM',
                            'LUN',
                            'MAR',
                            'MER',
                            'JEU',
                            'VEN',
                            'SAM',
                          ][date % 7],
                          style: TextStyle(
                            color: isSelected ? Colors.white : Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            Divider(),
            SizedBox(height: 16),

            // Appointments list
            if (appointments.containsKey(_selectedDate))
              ...appointments[_selectedDate]!
                  .map(
                    (appointment) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: Container(
                        width: double.infinity,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  appointment['doctor'],
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                    color: myDarkBlue,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 4),
                            Text(
                              appointment['specialty'],
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  )
                  .toList()
            else
              Center(
                child: Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  child: Text(
                    'Aucun rendez-vous ce jour',
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyCard() {
    return Card(
      color: Colors.blue[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '🚨 Urgence médicale',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: myDarkBlue,
              ),
            ),
            SizedBox(height: 10),
            Text(
              "Vous avez besoin d'une assistance immédiate ? Utilisez l'un des services ci-dessous pour obtenir de l'aide en urgence.",
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 16),

            // First row with two buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Appeler les secours
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(right: 8),
                    padding: EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        'Appeler les secours',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),

                // Alerter un proche
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(left: 8),
                    padding: EdgeInsets.symmetric(vertical: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        'Alerter un proche',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 16),

            // Personnels de santé centered below with tight width
            Center(
              child: Container(
                padding: EdgeInsets.symmetric(vertical: 12, horizontal: 24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'Personnels de santé à proximité',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}*/
import 'package:flutter/material.dart';
import 'package:flutter_application_2/models/Appointment.dart';
import 'discover_screen.dart';
import 'favorite_screen.dart';
import 'files_screen.dart';
import '../common/profile_screen.dart';
import '../common/notifications_screen.dart';
import '../common/messages/messages_screen.dart';
import '../../models/Patient.dart';
import '../../models/Patient_service.dart';

class PatientHomeScreen extends StatefulWidget {
  final Patient patient;

  const PatientHomeScreen({super.key, required this.patient});
  @override
  _PatientHomeScreenState createState() => _PatientHomeScreenState();
}

class _PatientHomeScreenState extends State<PatientHomeScreen> {
  int _selectedIndex = 0;
  late PatientService _patientService;
  Patient? _currentPatient;

  late List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _patientService = PatientService();
    _loadPatientData();

    _pages = [
      PatientHomeScreenContent(patient: widget.patient),
      DiscoverScreen(),
      FavoriteScreen(),
      FilesScreen(),
    ];
  }

  Future<void> _loadPatientData() async {
    // Remplacez 'patient_id' par l'ID réel du patient connecté
    final patient = await _patientService.getPatient('patient_id');
    setState(() {
      _currentPatient = patient;
    });
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Padding(
        padding: EdgeInsets.only(bottom: 16),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 4),
          decoration: BoxDecoration(
            color: _PatientHomeScreenContentState.myBlue2,
            borderRadius: BorderRadius.circular(30),
          ),
          child: Theme(
            data: Theme.of(context).copyWith(
              splashColor: Colors.transparent,
              highlightColor: Colors.transparent,
              bottomNavigationBarTheme: BottomNavigationBarThemeData(
                elevation: 0,
                showSelectedLabels: false,
                showUnselectedLabels: false,
              ),
            ),
            child: SizedBox(
              height: 60,
              child: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor: Colors.transparent,
                selectedItemColor: Colors.white,
                unselectedItemColor: Colors.white60,
                currentIndex: _selectedIndex,
                onTap: _onItemTapped,
                iconSize: 28,
                items: [
                  BottomNavigationBarItem(icon: Icon(Icons.home), label: ''),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.auto_awesome), label: ''),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.favorite), label: ''),
                  BottomNavigationBarItem(icon: Icon(Icons.folder), label: ''),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class PatientHomeScreenContent extends StatefulWidget {
  final Patient patient;

  const PatientHomeScreenContent({Key? key, required this.patient})
      : super(key: key);
  @override
  _PatientHomeScreenContentState createState() =>
      _PatientHomeScreenContentState();
}

class _PatientHomeScreenContentState extends State<PatientHomeScreenContent> {
  static const Color myDarkBlue = Color(0xFF073057);
  static const Color myBlue2 = Color(0xFF396C9B);
  DateTime? _selectedDate;
  late PatientService _patientService;
  Patient? _currentPatient;

  @override
  void initState() {
    super.initState();
    _patientService = PatientService();
    _loadPatientData();
    _selectedDate = DateTime.now();
  }

  Future<void> _loadPatientData() async {
    // Remplacez 'patient_id' par l'ID réel du patient connecté
    final patient = await _patientService.getPatient(widget.patient.id);
    setState(() {
      _currentPatient = patient;
    });
  }

  Future<void> _callEmergencyContact() async {
    if (_currentPatient != null) {
      await _patientService.callEmergencyContact(_currentPatient!);
    }
  }

  Future<void> _callEmergencyServices() async {
    if (_currentPatient != null) {
      await _patientService.callEmergencyServices(_currentPatient!);
    }
  }

  @override
  Widget build(BuildContext context) {
    DateTime today = DateTime.now();
    _selectedDate ??= today;

    return SafeArea(
      child: SingleChildScrollView(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildTopBar(),
            SizedBox(height: 24),
            _buildAppointmentsCard(context),
            SizedBox(height: 16),
            _buildEmergencyCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => ProfileScreen(patient: widget.patient)),
            );
          },
          child: Container(
            width: 40,
            height: 40,
            child: CircleAvatar(
              backgroundImage: NetworkImage(
                'https://cdn-icons-png.flaticon.com/512/5653/5653363.png',
              ),
            ),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width * 0.5,
          height: 40,
          margin: EdgeInsets.symmetric(horizontal: 12),
          decoration: BoxDecoration(
            color: Colors.blue[100],
            borderRadius: BorderRadius.circular(20),
          ),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Rechercher...',
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(vertical: 11),
              prefixIcon: Icon(Icons.search, color: Colors.blueGrey, size: 20),
            ),
          ),
        ),
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
                      builder: (context) => NotificationsScreen()),
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

  Widget _buildAppointmentsCard(BuildContext context) {
    // Get today's date
    DateTime today = DateTime.now();

    // Create a list of dates centered around today
    // 2 days before today and 3 days after today (total of 6 dates)
    List<DateTime> datesToShow =
        List.generate(6, (index) => today.subtract(Duration(days: 2 - index)));

    // Helper function to get the day of week abbreviation in French
    String getDayAbbreviation(int weekday) {
      return ['DIM', 'LUN', 'MAR', 'MER', 'JEU', 'VEN', 'SAM'][weekday - 1];
    }

    return Card(
      color: Colors.blue[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('📅 Prochains rendez-vous',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: myDarkBlue)),
            SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: datesToShow.map((date) {
                bool isSelected = _selectedDate?.day == date.day &&
                    _selectedDate?.month == date.month &&
                    _selectedDate?.year == date.year;
                bool isToday = date.day == today.day &&
                    date.month == today.month &&
                    date.year == today.year;

                // Définir des couleurs spéciales pour aujourd'hui
                Color containerColor;
                Color textColor;

                if (isSelected) {
                  containerColor = myBlue2;
                  textColor = Colors.white;
                } else if (isToday) {
                  containerColor = Color(
                      0xFFCFE2F3); // Bleu clair qui s'harmonise avec le thème existant
                  textColor = myDarkBlue;
                } else {
                  containerColor = Colors.white;
                  textColor = Colors.black;
                }

                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedDate = date;
                    });
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                    decoration: BoxDecoration(
                      color: containerColor,
                      borderRadius: BorderRadius.circular(16),
                      // Ajouter un contour pour mieux distinguer le jour d'aujourd'hui
                      border: isToday && !isSelected
                          ? Border.all(
                              color: myBlue2.withOpacity(0.7), width: 2)
                          : null,
                    ),
                    child: Column(
                      children: [
                        Text('${date.day}',
                            style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: textColor)),
                        Text(getDayAbbreviation(date.weekday),
                            style: TextStyle(color: textColor)),
                        if (isToday)
                          Container(
                            margin: EdgeInsets.only(top: 2),
                            width: 4,
                            height: 4,
                            decoration: BoxDecoration(
                              color: isSelected ? Colors.white : myBlue2,
                              shape: BoxShape.circle,
                            ),
                          ),
                      ],
                    ),
                  ),
                );
              }).toList(),
            ),
            Divider(),
            SizedBox(height: 16),
            FutureBuilder<List<Appointment>>(
              future: _patientService.getPatientAppointmentsForDate(
                patientId: _currentPatient?.id ?? '',
                date: _selectedDate!,
              ),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError ||
                    !snapshot.hasData ||
                    snapshot.data!.isEmpty) {
                  return Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      child: Text('Aucun rendez-vous ce jour',
                          style: TextStyle(fontSize: 14, color: Colors.grey)),
                    ),
                  );
                }

                return Column(
                  children: snapshot.data!
                      .map((appointment) => Padding(
                            padding: const EdgeInsets.only(bottom: 12),
                            child: Container(
                              width: double.infinity,
                              padding: EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                          appointment.doctorName ??
                                              'Unknown Doctor',
                                          style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: myDarkBlue)),
                                    ],
                                  ),
                                  SizedBox(height: 4),
                                  Text(
                                      appointment.specialty ??
                                          'Unknown Specialty',
                                      style: TextStyle(
                                          fontSize: 14, color: Colors.black)),
                                ],
                              ),
                            ),
                          ))
                      .toList(),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmergencyCard() {
    return Card(
      color: Colors.blue[100],
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('🚨 Urgence médicale',
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: myDarkBlue)),
            SizedBox(height: 10),
            Text(
              "Vous avez besoin d'une assistance immédiate ? Utilisez l'un des services ci-dessous pour obtenir de l'aide en urgence.",
              style: TextStyle(fontSize: 14),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: _callEmergencyServices,
                    child: Container(
                      margin: EdgeInsets.only(right: 8),
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text('Appeler les secours',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: _callEmergencyContact,
                    child: Container(
                      margin: EdgeInsets.only(left: 8),
                      padding: EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text('Alerter un proche',
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.w500)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

extension on Object? {
  String? get doctorName => null;
}
