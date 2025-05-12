import 'package:flutter/material.dart';
import 'package:flutter_application_2/login/inscription2.dart';

import '../yyu.dart';
import '../models/Specialty.dart';
import 'inscription2.dart';
import 'med1.dart';
import 'card1.dart';
import 'dermo.dart';
import 'pedia.dart';
import 'orl.dart';
import 'ophto.dart';
import 'gene.dart';
import 'gyne.dart';
import 'gastro.dart';
import '../models/Map.dart';

import '../models/HealthcareProfessional.dart';

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
class Med2 extends StatefulWidget {
  final String password;
  final String name;
  final String email;
  final String address;
   final AlgerianWilayas closeContact;
  final HealthcareType Type;
   final Gender gender;
  Med2({
    required this.password,
    required this.name,
    required this.email,
    required this.address,
    required this.closeContact,
    required this.Type,
    required this.gender,
  });

  @override
  _Med2State createState() => _Med2State();
}

class _Med2State extends State<Med2> {
  Specialty specialty = Specialty.generaliste;
  List<Specialty> availableSpecialties = [];
  @override
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
                      "Choisie Votre specialité :",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 50),
                  SizedBox(
                    width: 300, // Set the width
                    height: 50, // Set the height
                    child: ElevatedButton(
                      onPressed: () {
                        specialty = Specialty.generaliste;
                        print(specialty);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => gene(
                              password: widget.password,
                              name: widget.name,
                              email: widget.email,
                              address: widget.address,
                              closeContact: widget.closeContact,
                              Type: widget.Type,
                              specialty: specialty,
                              availableSpecialties: availableSpecialties,
                              gender: widget.gender,
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
                        'Medecine générale',
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
                    width: 300, // Set the width
                    height: 50, // Set the height
                    child: ElevatedButton(
                      onPressed: () {
                        specialty = Specialty.gyneco;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Gyne(
                              password: widget.password,
                              name: widget.name,
                              email: widget.email,
                              address: widget.address,
                              closeContact: widget.closeContact,
                              Type: widget.Type,
                              specialty: specialty,
                              availableSpecialties: availableSpecialties,
                              gender: widget.gender,
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
                        'Gynécologie obstérique',
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
                    width: 300, // Set the width
                    height: 50, // Set the height
                    child: ElevatedButton(
                      onPressed: () {
                        specialty = Specialty.dermato;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Dermo(
                              password: widget.password,
                              name: widget.name,
                              email: widget.email,
                              address: widget.address,
                              closeContact: widget.closeContact,
                              Type: widget.Type,
                              specialty: specialty,
                              availableSpecialties: availableSpecialties,
                              gender: widget.gender,
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
                        'Dermatologie',
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
                    width: 300, // Set the width
                    height: 50, // Set the height
                    child: ElevatedButton(
                      onPressed: () {
                        specialty = Specialty.orl;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => orl(
                              password: widget.password,
                              name: widget.name,
                              email: widget.email,
                              address: widget.address,
                              closeContact: widget.closeContact,
                              Type: widget.Type,
                              specialty: specialty,
                              availableSpecialties: availableSpecialties,
                              gender: widget.gender,
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
                        'ORL et chirurgie',
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
                    width: 300, // Set the width
                    height: 50, // Set the height
                    child: ElevatedButton(
                      onPressed: () {
                        specialty = Specialty.gastro;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => gastro(
                              password: widget.password,
                              name: widget.name,
                              email: widget.email,
                              address: widget.address,
                              closeContact: widget.closeContact,
                              Type: widget.Type,
                              specialty: specialty,
                              availableSpecialties: availableSpecialties,
                              gender: widget.gender,
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
                        'Gastro-Entérologie',
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
                    width: 300, // Set the width
                    height: 50, // Set the height
                    child: ElevatedButton(
                      onPressed: () {
                        specialty = Specialty.cardio;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Card1(
                              password: widget.password,
                              name: widget.name,
                              email: widget.email,
                              address: widget.address,
                              closeContact: widget.closeContact,
                              Type: widget.Type,
                              specialty: specialty,
                              availableSpecialties: availableSpecialties,
                              gender: widget.gender,
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
                        'Cardiologie',
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
                    width: 300, // Set the width
                    height: 50, // Set the height
                    child: ElevatedButton(
                      onPressed: () {
                        specialty = Specialty.pediatrie;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => pedia(
                              password: widget.password,
                              name: widget.name,
                              email: widget.email,
                              address: widget.address,
                              closeContact: widget.closeContact,
                              Type: widget.Type,
                              specialty: specialty,
                              availableSpecialties: availableSpecialties,
                              gender: widget.gender,
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
                        'Pédiatrie',
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
                    width: 300, // Set the width
                    height: 50, // Set the height
                    child: ElevatedButton(
                      onPressed: () {
                        specialty = Specialty.ophtalmo;
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => ophto(
                              password: widget.password,
                              name: widget.name,
                              email: widget.email,
                              address: widget.address,
                              closeContact: widget.closeContact,
                              Type: widget.Type,
                              specialty: specialty,
                              availableSpecialties: availableSpecialties,
                              gender: widget.gender,
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
                        'Ophtalmologie',
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
