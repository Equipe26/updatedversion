import 'package:flutter/material.dart';
import 'package:flutter_application_2/login/inscription2.dart';

import '../yyu.dart';
import '../models/HealthcareProfessional.dart';
import 'inscription2.dart';
import 'med2.dart';
import 'clinic.dart';
import 'pharmacie.dart';
import 'CIM.dart';
import 'infermier.dart';
import 'labo.dart';
import 'dentiste.dart';
import '../models/HealthcareProfessional.dart';
import '../models/Specialty.dart';
import '../models/Map.dart';
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

int y = 0;

class HomeS8 extends StatelessWidget {
  final String password;
  final String name;
  final String email;
  final String address;
  final AlgerianWilayas closeContact;
  final Gender gender;
  HomeS8({
    required this.password,
    required this.name,
    required this.email,
    required this.address,
    required this.closeContact,
    required this.gender,
  });
  HealthcareType Type = HealthcareType.pharmacie;
  Specialty specialty = Specialty.generaliste;
  List<Specialty> availableSpecialties = [];
  List<String> serviceId = [];
  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 255, 255, 255),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 255, 255, 255),
        toolbarHeight: 60, // Creates more space at the top
      ),
      body: SafeArea(
        child: SingleChildScrollView(
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
              child: Column(
                children: [
                  SizedBox(height: 16),
                  Center(
                    child: Text(
                      "Continuez à saisir vos information pour faire partir de L’équipe Chifaa",
                      style: TextStyle(
                        fontSize: 18,
                        //  fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 0, 0, 0),
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                  SizedBox(
                    width: 200, // Set the width
                    height: 50, // Set the height
                    child: ElevatedButton(
                      onPressed: () {
                        Type = HealthcareType.pharmacie;
                        y = 0;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Pharmacie(
                              password: password,
                              name: name,
                              email: email,
                              address: address,
                              closeContact: closeContact,
                              Type: Type,
                              specialty: specialty,
                              availableSpecialties: availableSpecialties,
                              serviceId: serviceId,
                              gender: gender,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF396C9B), // Button color
                        foregroundColor: Colors.white, // Text color
                        elevation: 8, // Shadow elevation
                        padding: EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            30,
                          ), // Rounded corners
                        ),
                      ),
                      child: Text(
                        'Pharmacie',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  /* ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      'Patient',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(
                        0xFF396C9B,
                      ), // Use backgroundColor instead of primary
                      foregroundColor: Colors.white,
                      elevation: 8, // Shadow elevation
                      // Shadow color
                      padding: EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          30,
                        ), // Rounded corners
                      ),
                    ),
                  ),*/
                  SizedBox(height: 16),
                  SizedBox(
                    width: 200, // Set the width
                    height: 50, // Set the height
                    child: ElevatedButton(
                      onPressed: () {
                        y = 1;
                        Type = HealthcareType.medecin;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Med2(
                              password: password,
                              name: name,
                              email: email,
                              address: address,
                              closeContact: closeContact,
                              Type: Type,
                              gender: gender,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF396C9B), // Button color
                        foregroundColor: Colors.white, // Text color
                        elevation: 8, // Shadow elevation
                        padding: EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            30,
                          ), // Rounded corners
                        ),
                      ),
                      child: Text(
                        'Medecin',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  /*   ElevatedButton(
                    onPressed: () {},
                    child: Text(
                      'Personnel de Sante',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color(
                        0xFF396C9B,
                      ), // Use backgroundColor instead of primary
                      foregroundColor: Colors.white,
                      elevation: 8, // Shadow elevation
                      // Shadow color
                      padding: EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 16,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          30,
                        ), // Rounded corners
                      ),
                    ),
                  ),*/
                  SizedBox(height: 16),
                  SizedBox(
                    width: 200, // Set the width
                    height: 50, // Set the height
                    child: ElevatedButton(
                      onPressed: () {
                        y = 2;
                        Type = HealthcareType.centre_imagerie;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CIM(
                              password: password,
                              name: name,
                              email: email,
                              address: address,
                              closeContact: closeContact,
                              Type: Type,
                              gender: gender,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF396C9B), // Button color
                        foregroundColor: Colors.white, // Text color
                        elevation: 8, // Shadow elevation
                        padding: EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            30,
                          ), // Rounded corners
                        ),
                      ),
                      child: Text(
                        'Centre d’imagerie',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: 200, // Set the width
                    height: 50, // Set the height
                    child: ElevatedButton(
                      onPressed: () {
                        y = 2;
                        Type = HealthcareType.laboratoire_analyse;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => labo(
                              password: password,
                              name: name,
                              email: email,
                              address: address,
                              closeContact: closeContact,
                              Type: Type,
                              gender: gender,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF396C9B), // Button color
                        foregroundColor: Colors.white, // Text color
                        elevation: 8, // Shadow elevation
                        padding: EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            30,
                          ), // Rounded corners
                        ),
                      ),
                      child: Text(
                        'Laboratoire',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: 200, // Set the width
                    height: 50, // Set the height
                    child: ElevatedButton(
                      onPressed: () {
                        y = 2;
                        Type = HealthcareType.clinique;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => clinic(
                              password: password,
                              name: name,
                              email: email,
                              address: address,
                              closeContact: closeContact,
                              Type: Type,
                              gender: gender,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF396C9B), // Button color
                        foregroundColor: Colors.white, // Text color
                        elevation: 8, // Shadow elevation
                        padding: EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            30,
                          ), // Rounded corners
                        ),
                      ),
                      child: Text(
                        'Clinic',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: 200, // Set the width
                    height: 50, // Set the height
                    child: ElevatedButton(
                      onPressed: () {
                        y = 1;
                        Type = HealthcareType.infermier;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => inf(
                              password: password,
                              name: name,
                              email: email,
                              address: address,
                              closeContact: closeContact,
                              Type: Type,
                              gender: gender,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF396C9B), // Button color
                        foregroundColor: Colors.white, // Text color
                        elevation: 8, // Shadow elevation
                        padding: EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            30,
                          ), // Rounded corners
                        ),
                      ),
                      child: Text(
                        'Infermier',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  SizedBox(
                    width: 200, // Set the width
                    height: 50, // Set the height
                    child: ElevatedButton(
                      onPressed: () {
                        y = 1;
                        Type = HealthcareType.dentiste;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Dentiste(
                              password: password,
                              name: name,
                              email: email,
                              address: address,
                              closeContact: closeContact,
                              Type: Type,
                              gender: gender,
                            ),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Color(0xFF396C9B), // Button color
                        foregroundColor: Colors.white, // Text color
                        elevation: 8, // Shadow elevation
                        padding: EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 16,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            30,
                          ), // Rounded corners
                        ),
                      ),
                      child: Text(
                        'Dentiste',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
