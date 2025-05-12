import 'package:flutter/material.dart';

import '../yyu.dart';

import 'inscription1.dart';
import 'connexion.dart';

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

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomeS13());
  }
}

int pr = 0;

class HomeS13 extends StatefulWidget {
  @override
  _HomeS13State createState() => _HomeS13State();
}

class _HomeS13State extends State<HomeS13> {
  bool _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: const Color(0xFFA3C3E4),
        appBar: AppBar(
          automaticallyImplyLeading: false, // disables the back button

          backgroundColor: const Color(0xFFA3C3E4),
          toolbarHeight: 60, // Creates more space at the top
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Container(
                margin: EdgeInsets.only(top: 20),
                padding: EdgeInsets.all(16),
                decoration: BoxDecoration(color: const Color(0xFFA3C3E4)),
                child: Column(
                  children: [
                    Container(
                      width: 370, // Largeur de l'image
                      height: 370, // Hauteur de l'image
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: AssetImage("assets/logop2.PNG"),
                          fit: BoxFit.contain,
                        ),
                      ),
                    ),
                    SizedBox(height: 100),
                    SizedBox(
                      width: 200,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => LoginScreen()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF396C9B),
                          foregroundColor: Colors.white,
                          elevation: 8,
                          padding: EdgeInsets.symmetric(
                              horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                        ),
                        child: Text(
                          'Se connecter',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            shadows: [], // <-- Ceci supprime toute ombre du texte
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16),
                    SizedBox(
                      width: 200,
                      height: 50,
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => HomeS6()),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Color(0xFF396C9B),
                          foregroundColor: Colors.white,
                          elevation: 8,
                          padding: EdgeInsets.symmetric(
                              horizontal: 32, vertical: 16),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30)),
                        ),
                        child: Text(
                          "S'inscrire",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            shadows: [], // <-- Ceci supprime toute ombre du texte
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
      ),
    );
  }
}
