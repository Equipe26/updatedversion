import 'package:flutter/material.dart';
import '../models/HealthcareProfessional.dart';
import 'admin_service.dart';

void main() {
  runApp(MyApp());
}

/*class Main2Screen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Main2 Page")),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context); // Goes back to the previous page
          },
          child: Text("Back to Main"),
        ),
      ),
    );
  }
}*/

Widget buildCon(String ty) {
  return ElevatedButton(
    onPressed: () {
      printhell();
    },
    style: ElevatedButton.styleFrom(
      backgroundColor: Colors.blue, // Button background color
      foregroundColor: Colors.white, // Text color
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 12,
      ), // Padding
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Rounded corners
      ),
      elevation: 5, // Shadow effect
    ),
    child: Text(
      ty,
      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
    ),
  );
}

Widget buil(User rt) {
  return Container(
    decoration: BoxDecoration(
      border: Border.all(
        color: Colors.blue, // Border color
        width: 3, // Border width
      ),
    ),
    child: Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween, // Ensures space between components
      crossAxisAlignment: CrossAxisAlignment.start, 
      children: [
        /// **Column for Text**
        ///
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start, // Aligns text to left
            children: [
              Text(
                rt.name,
                style: TextStyle(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                ),
              ),
              Text(
                "Kvaratskhelia, Georgia",
                style: TextStyle(
                  color: Color.fromARGB(255, 204, 204, 205),
                  fontSize: 18,
                ),
              ),
            ],
          ),
        ),

        /// **Row for Icon and Number**
        Row(
          children: [
            Icon(Icons.star, color: Colors.red, size: 24),

            SizedBox(width: 5), // Space between icon and text
            Text(
              rt.number,
              style: TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
            ),
          ],
        ),
      ],
    ),
  );
}

PreferredSizeWidget Appbuild() {
  return AppBar(
    title: Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Profile Picture
        CircleAvatar(
          radius: 20,
          backgroundImage: AssetImage(
            'assets/profile.jpg',
          ), // Replace with your image
        ),

        // Search Bar (Expanded to take available space)
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: TextField(
              decoration: InputDecoration(
                hintText: "Search...",
                prefixIcon: Icon(Icons.search, color: Colors.white),
                filled: true,
                fillColor: Color(0xFFA3C3E4),
                contentPadding: EdgeInsets.symmetric(vertical: 5),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(25),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
        ),

        // Notification Icon
        CircleAvatar(
          backgroundColor: Color(0xFFA3C3E4),
          radius: 20,
          child: Icon(Icons.notifications, color: Colors.white),
        ),

        SizedBox(width: 10), // Space between icons
        // Messages Icon
        CircleAvatar(
          backgroundColor: Color(0xFFA3C3E4),
          radius: 20,
          child: Icon(Icons.forum, color: Colors.white),
        ),
      ],
    ),
    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
  );
}

printhell() {
  print("hello");
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: PersonnelSante(),
    );
  }
}

class User {
  final String number;
  final String name;
  final String image;

  // Using a shorthand constructor with 'const'.
  const User(this.number, this.name, this.image);
}

class DateWidget extends StatelessWidget {
  final int index;
  final List<String> days = ["17", "18", "19", "20", "21", "22"];
  final List<String> weekDays = ["MAR", "MER", "JEU", "VEN", "SAM", "DIM"];

  DateWidget(this.index);

  @override
  Widget build(BuildContext context) {
    bool isSelected = index == 2;
    return Container(
      width: 50,
      padding: EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: isSelected ? Color(0xFF3A6EA5) : Colors.white,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        children: [
          Text(
            days[index],
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: isSelected ? Colors.white : Colors.black,
            ),
          ),
          Text(
            weekDays[index],
            style: TextStyle(
              fontSize: 14,
              color: isSelected ? Colors.white : Colors.black54,
            ),
          ),
        ],
      ),
    );
  }
}

class AppointmentCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Color(0xFFA3C3E4),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Dr. Bensoltane Souhila",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              Row(
                children: [
                  Icon(Icons.location_on, color: Colors.black54, size: 18),
                  Icon(Icons.check_circle, color: Colors.green, size: 18),
                  Icon(Icons.cancel, color: Colors.red, size: 18),
                ],
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            "Soins pour les amygdales",
            style: TextStyle(fontSize: 14, color: Colors.black54),
          ),
        ],
      ),
    );
  }
}

class ContactEmergencyDoctorButton extends StatelessWidget {
  final String text;

  ContactEmergencyDoctorButton({required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 148,
      height: 48,
      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
      ),
    );
  }
}

class FilterButtons extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Selected Button
        ElevatedButton(
          onPressed: () {},
          style: ElevatedButton.styleFrom(
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
            backgroundColor: Color(0xFF073057), // Darker blue
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Row(
            children: [
              Text("P.de sante", style: TextStyle(fontSize: 20)),
              Icon(Icons.arrow_drop_down, size: 18),
            ],
          ),
        ),
        SizedBox(width: 2),

        // Other Filter Buttons
        filterButton("patients"),
        // filterButton("Sexe"),
        //filterButton("A Proximité"),
        //iconButton(Icons.star_border),
        //iconButton(Icons.favorite_border),
      ],
    );
  }

  Widget filterButton(String text) {
    return OutlinedButton(
      onPressed: () {},
      style: OutlinedButton.styleFrom(
        backgroundColor: Color(0xFF073057),
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 15),
        side: BorderSide(color: Color(0xFF073057)),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        minimumSize: Size(10, 33), // Custom width & height
      ),
      child: Row(
        children: [
          Text(
            text,
            style: TextStyle(
              color: Color.fromARGB(255, 255, 255, 255),
              fontSize: 20,
            ),
          ),
          Icon(Icons.arrow_drop_down, size: 18),
        ],
      ),
    );
  }

  // Function to create circular icon buttons
  Widget iconButton(IconData icon) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: OutlinedButton(
        onPressed: () {},
        style: OutlinedButton.styleFrom(
          shape: CircleBorder(),
          padding: EdgeInsets.all(10),
          side: BorderSide(color: Colors.transparent),
        ),
        child: Icon(icon, color: Colors.black),
      ),
    );
  }
}

class DoctorCard extends StatelessWidget {
  const DoctorCard({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 500,
      height: 200,
      margin: const EdgeInsets.all(0),
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: Colors.white,
        // Round corners
        borderRadius: BorderRadius.circular(25),
        // Outer border
        border: Border.all(color: Colors.black54, width: 1),
        // Optional shadow for depth
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),

      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // 1) Circular avatar
          Container(
            margin: const EdgeInsets.only(left: 8),
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(
                  'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(right: 20, top: 10),
                  width: 300,
                  height: 100,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.blue, width: 1),
                  ),

                  child: Column(
                    children: [
                      Expanded(
                        child: Text(
                          "Dr. Boudaoud Athmane",

                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),

                      // const SizedBox(height: 4),
                      Text(
                        "Médecine interne",
                        style: TextStyle(color: Colors.grey[700], fontSize: 14),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Check Button
                          Container(
                            child: IconButton(
                              icon: Icon(Icons.check, color: Colors.black),
                              onPressed: () {
                                // Add your check action here
                                print("Checked!");
                              },
                            ),
                          ),
                          Container(
                            child: IconButton(
                              icon: Icon(Icons.close, color: Colors.black),
                              onPressed: () {
                                // Add your cancel action here
                                print("Cancelled!");
                              },
                            ),
                          ),
                          // Cross Button
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Star + rating
                      _buildCircleIconButton1(
                        icon: Icons.keyboard_arrow_down,
                        onTap: () {},
                        text:
                            "plus de detail", // Specify the parameter name 'text'
                      ),

                      const SizedBox(width: 5),
                      _buildCircleIconButton1(
                        icon: Icons.more_vert,
                        onTap: () {},
                        text: "", // Specify the parameter name 'text'
                      ),
                      // User icon + number (example)

                      // Question mark icon
                    ],
                  ),
                ),
              ],
            ),
          ),
          // 2) Bubble with Name & Specialty

          // 3) Icons and labels on the right
        ],
      ),
    );
  }

  /// A pill-shaped container with an icon and a label, e.g., star + rating
  Widget _buildIconBadge({required IconData icon, required String label}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 5),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.blue),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          Icon(icon, size: 18, color: Colors.blue),
          const SizedBox(width: 4),
          Text(label, style: const TextStyle(color: Colors.blue)),
        ],
      ),
    );
  }

  /// A circular container for a single icon (e.g., question mark, heart)
  Widget _buildCircleIconButton({
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 35,
        height: 35,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(color: Colors.blue),
        ),
        child: Icon(icon, size: 18, color: Colors.blue),
      ),
    );
  }
}

Widget _buildCircleIconButton1({
  required IconData icon,
  required VoidCallback onTap,
  required String text,
}) {
  return InkWell(
    onTap: onTap,
    child: Container(
      // Increased height for better spacing
      padding: EdgeInsets.symmetric(horizontal: 8), // Added padding

      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.blue),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: Colors.blue),
          SizedBox(width: 5), // Spacing between icon and text
          Text(text),
        ],
      ),
    ),
  );
}

class PersonnelSante extends StatefulWidget {
  @override
  _PersonnelSanteState createState() => _PersonnelSanteState();
}

class _PersonnelSanteState extends State<PersonnelSante> {
  final AdminService _adminService = AdminService();
  List<HealthcareProfessional> _pendingProfessionals = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPendingProfessionals();
  }

  Future<void> _loadPendingProfessionals() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final pendingProfessionals = await _adminService.getPendingHealthcareProfessionals();
      setState(() {
        _pendingProfessionals = pendingProfessionals;
      });
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error loading pending healthcare professionals: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  void _approveHealthcareProfessional(String id) async {
    try {
      await _adminService.approveHealthcareProfessional(id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Healthcare professional approved successfully')),
      );
      // Reload the list after approval
      _loadPendingProfessionals();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error approving healthcare professional: ${e.toString()}')),
      );
    }
  }

  void _denyHealthcareProfessional(String id) async {
    try {
      await _adminService.denyHealthcareProfessional(id);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Healthcare professional denied successfully')),
      );
      // Reload the list after denial
      _loadPendingProfessionals();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error denying healthcare professional: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: const Color(0xFFA3C3E4),
        elevation: 0,
        title: Center(
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(Icons.person, color: Color(0xFF073057)),
              SizedBox(width: 10),
              Text(
                'Personnels de santé',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color(0xFF073057),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: Container(
            margin: EdgeInsets.all(20),
            height: screenHeight * 0.8,
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFFA3C3E4),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
                bottomLeft: Radius.circular(40),
                bottomRight: Radius.circular(40),
              ),
            ),
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _pendingProfessionals.isEmpty
                    ? Center(child: Text('Aucune demande du professionnel de la santé en attente trouvé'))
                    : ListView.separated(
                        itemCount: _pendingProfessionals.length,
                        separatorBuilder: (context, index) => SizedBox(height: 16),
                        itemBuilder: (context, index) {
                          final professional = _pendingProfessionals[index];
                          return _buildProfessionalCard(professional);
                        },
                      ),
          ),
        ),
      ),
    );
  }

  Widget _buildProfessionalCard(HealthcareProfessional professional) {
    return Container(
      width: 500,
      height: 200,
      margin: const EdgeInsets.all(0),
      padding: const EdgeInsets.all(0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.black54, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Profile image
          Container(
            margin: const EdgeInsets.only(left: 8),
            width: 60,
            height: 60,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(
                  'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  margin: EdgeInsets.only(right: 20, top: 10),
                  width: 300,
                  height: 100,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(color: Colors.blue, width: 1),
                  ),
                  child: Column(
                    children: [
                      Expanded(
                        child: Text(
                          professional.name,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                            color: Colors.grey[800],
                          ),
                        ),
                      ),
                      Text(
                        professional.specialty?.displayName ?? 
                        professional.typeDisplay,
                        style: TextStyle(color: Colors.grey[700], fontSize: 14),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          // Approve button
                          Container(
                            child: IconButton(
                              icon: Icon(Icons.check, color: Colors.green),
                              onPressed: () => _approveHealthcareProfessional(professional.id),
                            ),
                          ),
                          // Deny button
                          Container(
                            child: IconButton(
                              icon: Icon(Icons.close, color: Colors.red),
                              onPressed: () => _denyHealthcareProfessional(professional.id),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      _buildCircleIconButton1(
                        icon: Icons.keyboard_arrow_down,
                        onTap: () {
                          _showProfessionalDetails(context, professional);
                        },
                        text: "plus de detail",
                      ),
                      const SizedBox(width: 5),
                      _buildCircleIconButton1(
                        icon: Icons.more_vert,
                        onTap: () {},
                        text: "",
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showProfessionalDetails(BuildContext context, HealthcareProfessional professional) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('${professional.name} - ${professional.typeDisplay}'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Email: ${professional.email}'),
              SizedBox(height: 8),
              Text('Location: ${professional.location}'),
              SizedBox(height: 8),
              Text('Specialty: ${professional.specialty?.displayName ?? "N/A"}'),
              SizedBox(height: 8),
              Text('License Number: ${professional.licenseNumber ?? "N/A"}'),
              if (professional.availableSpecialties.isNotEmpty) ...[
                SizedBox(height: 8),
                Text('Available Specialties:'),
                ...professional.availableSpecialties.map(
                  (specialty) => Padding(
                    padding: const EdgeInsets.only(left: 16.0, top: 4),
                    child: Text('- ${specialty.displayName}'),
                  ),
                ),
              ],
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Close'),
          ),
        ],
      ),
    );
  }
}
