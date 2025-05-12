import 'package:flutter/material.dart';
import 'package:flutter_application_2/admin/user.dart';
import 'package:flutter_application_2/login/paccueil2.dart';
import '../common/notifications_screen.dart';
import '../common/messages/messages_screen.dart';
import '../common/temp_ph_profile.dart';
import 'comments_screen.dart';
import 'files_screen.dart';
import '../../models/HealthcareProfessional.dart';
import '../../models/WeeklyAvailability.dart';
import '../../models/Comment.dart';
import '../../models/Comment_service.dart';
import '../../models/Patient.dart';
import '../../models/Patient_service.dart';
import '../../models/Rating_service.dart';
import '../../models/Rating.dart';

class PharmacieHomeScreen extends StatefulWidget {
  final HealthcareProfessional user;

  PharmacieHomeScreen({Key? key, required this.user}) : super(key: key);
  @override
  State<PharmacieHomeScreen> createState() => _PharmacieHomeScreenState();
}

class _PharmacieHomeScreenState extends State<PharmacieHomeScreen> {
  int _selectedIndex = 0;
  List<Comment>? myComments;
  int _selectedDayIndex = 2; // Par défaut, jeudi (index 2) est sélectionné
  static const Color myDarkBlue = Color(0xFF073057);
  static const Color myBlue2 = Color(0xFF396C9B);
  static const Color myLightBlue = Color(0xFFA3C3E4);

  // Liste des jours avec leurs informations
  final List<Map<String, dynamic>> _days = [
    {
      "number": "17",
      "weekday": "MAR",
      "fullDate": "17 Mars 2025",
      "isOpen": true,
      "hours": "08:00 - 19:00",
      "isToday": false
    },
    {
      "number": "18",
      "weekday": "MER",
      "fullDate": "18 Mars 2025",
      "isOpen": true,
      "hours": "08:00 - 19:00",
      "isToday": false
    },
    {
      "number": "19",
      "weekday": "JEU",
      "fullDate": "19 Mars 2025",
      "isOpen": true,
      "hours": "08:00 - 17:00",
      "isToday": true
    },
    {
      "number": "20",
      "weekday": "VEN",
      "fullDate": "20 Mars 2025",
      "isOpen": true,
      "hours": "08:00 - 19:00",
      "isToday": false
    },
    {
      "number": "21",
      "weekday": "SAM",
      "fullDate": "21 Mars 2025",
      "isOpen": true,
      "hours": "09:00 - 17:00",
      "isToday": false
    },
    {
      "number": "22",
      "weekday": "DIM",
      "fullDate": "22 Mars 2025",
      "isOpen": false,
      "hours": "Fermé",
      "isToday": false
    },
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  void updateDaysWithAvailability(
      List<WeeklyAvailability> weeklyAvailabilities) {
    // Days of the week mapping
    const daysOfWeek = {
      'MAR': 'Monday',
      'MER': 'Tuesday',
      'JEU': 'Wednesday',
      'VEN': 'Thursday',
      'SAM': 'Friday',
      'DIM': 'Saturday',
    };

    for (int i = 0; i < _days.length; i++) {
      final day = _days[i];
      final weekdayAbbreviation = day['weekday']; // Example: "MAR"
      final dayName =
          daysOfWeek[weekdayAbbreviation]; // Full day name: "Monday", etc.

      if (dayName != null) {
        // Find the corresponding WeeklyAvailability for the day
        for (final availability in weeklyAvailabilities) {
          // Check if the healthcare professional is open for the given day
          final isOpen = availability.isOpenForDay(dayName);

          // Update the day's details in _days based on availability
          day['isOpen'] = isOpen;
          day['hours'] = isOpen
              ? '${availability.openingHour} - ${availability.closingHour}'
              : 'Fermé';

          // Optionally check if today matches the date and set 'isToday' accordingly
          final today = DateTime.now();
          final fullDate = DateTime.parse(day['fullDate']);
          day['isToday'] = today.day == fullDate.day &&
              today.month == fullDate.month &&
              today.year == fullDate.year;
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: IndexedStack(
          index: _selectedIndex,
          children: [
            // Écran d'accueil
            SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildPharmacyHeader(),
                  const SizedBox(height: 20),
                  _buildPatientReviewsSection(),
                  const SizedBox(height: 20),
                  _buildWorkScheduleSection(MediaQuery.of(context).size.width),
                ],
              ),
            ),
            // Écran des commentaires
            CommentsScreen(),
            // Écran des fichiers
            FilesScreen(),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomNavBar(),
    );
  }

  Widget _buildPharmacyHeader() {
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
                  image: DecorationImage(
                    image: NetworkImage('later.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: const Center(
                  child: Icon(Icons.local_pharmacy, color: myBlue2, size: 24),
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
                  "Pharmacie ${widget.user.name}",
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

  /*Widget _buildPatientReviewsSection() {
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
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => CommentsScreen()),
                  );
                },
                child: Text(
                  "Voir tous",
                  style: TextStyle(color: myDarkBlue),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

myComments = await CommentService.getCommentsForProfessional(widget.user.id);
         
          _buildReviewItem(
              "Sarah", "Service rapide et efficace, merci !", "Aujourd'hui", 5),
          _buildReviewItem(
              "Mohammed", "Dommage que ce soit fermé le dimanche.", "Hier", 3),
        ],
      ),
    );
  }
*/
  Widget _buildPatientReviewsSection() {
    return FutureBuilder<List<Comment>>(
      future: CommentService()
          .getCommentsForProfessional(widget.user.id), // Fetch comments
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
     
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error1: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Aucun avis disponible.'));
        } else {
          List<Comment> comments = snapshot.data!;

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
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => CommentsScreen()),
                        );
                      },
                      child: Text(
                        "Voir tous",
                        style: TextStyle(color: myDarkBlue),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                // Show the first two comments
                ...comments
                    .take(2)
                    .map((comment) => FutureBuilder<Map<String, dynamic>>(
                          future: _getCommentDetails(comment
                              .patientId), // Fetch details using comment ID
                          builder: (context, detailsSnapshot) {
                            if (detailsSnapshot.connectionState ==
                                ConnectionState.waiting) {
                              return CircularProgressIndicator();
                            } else if (detailsSnapshot.hasError) {
                                   print(comment.comment);
                              return Text('Error1: ${detailsSnapshot.error}');
                            } else if (detailsSnapshot.hasData) {
                              var commentDetails = detailsSnapshot.data!;
                              return _buildReviewItem(
                                commentDetails['author'], // Patient name
                                comment.comment, // Comment text
                                comment.date, // Date
                                commentDetails['rating'], // Rating
                              );
                            }
                            return SizedBox(); // Default return if no data
                          },
                        )),
              ],
            ),
          );
        }
      },
    );
  }

  Future<Map<String, dynamic>> _getCommentDetails(String patientId) async {
    print(patientId);
    var patientName = await PatientService().getPatient(patientId);
    double rating =
        await RatingService().getAverageRating(patientId); // Get comment by ID
    print(patientName);
    print(rating);
    if ((patientName != null)) {
      // Get patient name by ID
      return {
        'author': patientName.name,
        'rating': rating,
      };
    } else {
      throw Exception("Comment not found!");
    }
  }

  Widget _buildReviewItem(
      String name, String review, DateTime time, int stars) {
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
    final selectedDay = _days[_selectedDayIndex];

    return Container(
      decoration: BoxDecoration(
        color: myLightBlue,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "🗓️ Horaires d'ouverture",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: myDarkBlue,
            ),
          ),
          const SizedBox(height: 10),
          Container(
            height: 60,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.symmetric(horizontal: 2, vertical: 4),
              itemCount: _days.length,
              itemBuilder: (context, index) {
                final day = _days[index];
                return _buildDayItem(
                  day["number"],
                  day["weekday"],
                  isSelected: index == _selectedDayIndex,
                  onTap: () {
                    setState(() {
                      _selectedDayIndex = index;
                    });
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "${selectedDay["fullDate"]}${selectedDay["isToday"] ? " - Aujourd'hui" : ""}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: myDarkBlue,
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  selectedDay["isOpen"]
                      ? "Pharmacie ouverte"
                      : "Pharmacie fermée",
                  style: TextStyle(
                      color: selectedDay["isOpen"] ? Colors.green : Colors.red,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
                if (selectedDay["isOpen"]) ...[
                  SizedBox(height: 6),
                  Text(
                    _formatHours(selectedDay["hours"]),
                    style: TextStyle(
                      color: myDarkBlue,
                      fontSize: 15,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 12),
          Center(
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: myBlue2,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              onPressed: () {},
              child: Text(
                "Modifier les horaires",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _formatHours(String hours) {
    if (hours == "Fermé") {
      return hours;
    }

    List<String> parts = hours.split(" - ");
    if (parts.length == 2) {
      return "De ${parts[0]} jusqu'à ${parts[1]}";
    }

    return hours;
  }

  Widget _buildDayItem(String day, String weekday,
      {bool isSelected = false, Function()? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? myBlue2 : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: myBlue2),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              day,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : myBlue2),
            ),
            Text(
              weekday,
              style: TextStyle(
                  fontSize: 12, color: isSelected ? Colors.white : myBlue2),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomNavBar() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
        decoration: BoxDecoration(
          color: myBlue2,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Theme(
          data: Theme.of(context).copyWith(
            splashColor: Colors.transparent,
            highlightColor: Colors.transparent,
          ),
          child: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            selectedItemColor: Colors.white,
            unselectedItemColor: Colors.white60,
            currentIndex: _selectedIndex,
            onTap: _onItemTapped,
            elevation: 0,
            showSelectedLabels: false,
            showUnselectedLabels: false,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.home),
                label: 'Accueil',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.forum),
                label: 'Commentaires',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.folder),
                label: 'Fichiers',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
