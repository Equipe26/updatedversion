import 'package:flutter/material.dart';
import 'main.dart';

void main() {
  runApp(MyApp());
}

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
      crossAxisAlignment: CrossAxisAlignment.start, // Aligns them properly
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
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomeS());
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
      child: SingleChildScrollView(
        child: Text(
          text,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
      ),
    );
  }
}

class HomeS extends StatelessWidget {
  @override
  User rt = new User(
    "32",
    "mahrez",
    'https://flutter.github.io/assets-for-api-docs/assets/widgets/owl.jpg',
  );
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: Appbuild(),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Expanded(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 20,
              ), // Add padding for spacing
              child: Container(
                margin: EdgeInsets.only(top: 20),
                width: MediaQuery.of(context).size.width,
                height: MediaQuery.of(context).size.height,
                child: Center(
                  child: ListView(
                    children: [
                      Container(
                        width: 364,
                        height: 288,
                        padding: EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Color(0xFFA3C3E4),
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(color: Colors.black26, blurRadius: 8),
                          ],
                        ),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Icons.calendar_month,
                                  color: Colors.black54,
                                ),
                                SizedBox(width: 8),
                                Text(
                                  "Prochains rendez-vous",
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF073057),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 12),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: List.generate(6, (index) {
                                return DateWidget(index);
                              }),
                            ),
                            SizedBox(height: 16),
                            Text(
                              "19 Mars 2025 - Aujourd’hui",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.black54,
                              ),
                            ),
                            SizedBox(height: 12),
                            AppointmentCard(),
                          ],
                        ),
                      ),
                      SizedBox(height: 16),
                      SingleChildScrollView(
                        child: Container(
                          width: 364,
                          height: 288,
                          padding: EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Color(0xFFA3C3E4),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(color: Colors.black26, blurRadius: 8),
                            ],
                          ),
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.calendar_month,
                                    color: Colors.black54,
                                  ),
                                  SizedBox(width: 8),
                                  Text(
                                    "Urgence medicale",
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      color: Color(0xFF073057),
                                    ),
                                  ),
                                ],
                              ),
                              SizedBox(height: 12),
                              Text(
                                "Vous avez besoin d'une assistance immédiate ? Utilisez l'un des services ci-dessous pour obtenir de l'aide en urgence.",
                              ),
                              SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  ContactEmergencyDoctorButton(
                                    text: "Contacter un médecin urgentiste",
                                  ),
                                  ContactEmergencyDoctorButton(
                                    text: "Appeler les secours",
                                  ),
                                ],
                              ),
                              SizedBox(height: 16),
                              Expanded(
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    ContactEmergencyDoctorButton(
                                      text: "Contacter un médecin urgentiste",
                                    ),
                                    ContactEmergencyDoctorButton(
                                      text: "Appeler les secours",
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: 16),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: BottomAppBar(
        color: Color.fromARGB(255, 255, 255, 255),
        child: Container(
          decoration: BoxDecoration(
            color: Color(0xFF396C9B),

            borderRadius: BorderRadius.circular(12),
          ),

          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: Icon(Icons.home, color: Color(0xFF073057)),
                  onPressed: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomeS()),
                    );
                  },
                ),

                IconButton(
                  icon: Icon(Icons.star, color: Colors.white),
                  onPressed: () {
                    /*Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomeS2()),
                    );*/
                  },
                ),
                SizedBox(width: 40),
                IconButton(
                  icon: Icon(Icons.folder, color: Colors.white),
                  onPressed: () {
                    /*Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(builder: (context) => HomeS4()),
                    );*/
                  },
                ),
                IconButton(
                  icon: Icon(Icons.person, color: Colors.white),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => HomeS14()),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
 /*Container(
            color: const Color.fromARGB(255, 255, 254, 254),
            child: Column(
              children: [
                Center(
                  child: Text(
                    "Date of birth",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 168, 167, 167),
                      fontSize: 30,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                buil(rt),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    "Today date",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 168, 167, 167),
                      fontSize: 30,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                buil(rt),
                SizedBox(height: 20),
                Row(
                  mainAxisAlignment:
                      MainAxisAlignment
                          .spaceBetween, // Ensures space between components
                  crossAxisAlignment:
                      CrossAxisAlignment.start, // Aligns them properly
                  children: [
                    /// **Column for Text**
                    ///
                    buildCon("CLEAR"),
                    buildCon("CALCULATE"),

                    /// **Row for Icon and Number**
                  ],
                ),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    "Age is",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 168, 167, 167),
                      fontSize: 30,
                    ),
                  ),
                ),
                SizedBox(height: 20),
                Center(
                  child: Text(
                    "Next Birth day in",
                    style: TextStyle(
                      color: const Color.fromARGB(255, 168, 167, 167),
                      fontSize: 30,
                    ),
                  ),
                ),
              ],
            ),
          ),*/