import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_2/models/MedicalDocumentService.dart';

import 'firebase_options.dart';
import 'login/paccueil2.dart';
import 'screens/medecin/home_screen.dart';
import 'admin/admin.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_application_2/models/Comment_service.dart';
import 'package:flutter_application_2/models/Rating_service.dart';
import 'package:flutter_application_2/models/UserService.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'firebase_options.dart';
import 'login/paccueil2.dart';
import 'models/MessagingService.dart';
import 'models/ConnectionService.dart';
import 'models/Notification_service.dart'; // Add this import
import 'providers/NotificationProvider.dart'; // Add this import


import 'package:intl/date_symbol_data_local.dart';
import 'models/MedicalDocumentService.dart';

>>>>>>> cecfbbe (commit)
void main() async {
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

    await Supabase.initialize(
    url: "https://djroiqetexvueyexaeav.supabase.co",
    anonKey: "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRqcm9pcWV0ZXh2dWV5ZXhhZWF2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDUwNzQyOTksImV4cCI6MjA2MDY1MDI5OX0.1PkNLCTrlTsRems-x43k9EyKhH8Jvihz_uNXVVnrzho",
  );

  await Supabase.initialize(
    url: "https://djroiqetexvueyexaeav.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImRqcm9pcWV0ZXh2dWV5ZXhhZWF2Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NDUwNzQyOTksImV4cCI6MjA2MDY1MDI5OX0.1PkNLCTrlTsRems-x43k9EyKhH8Jvihz_uNXVVnrzho",
  );
  WidgetsFlutterBinding.ensureInitialized(); // Ensures Flutter is ready
  await initializeDateFormatting('fr_FR', null);
>>>>>>> cecfbbe (commit)
  final backendMessagingService = MessagingService();
  final connectionService = ConnectionService();
  final notificationService = NotificationService();
  runApp(
    MultiProvider(
      providers: [
        Provider<RatingService>(create: (_) => RatingService()),
        Provider<CommentService>(create: (_) => CommentService()),
        Provider<UserService>(create: (_) => UserService()),
        Provider<MessagingService>(create: (_) => MessagingService()),
        Provider<MessagingService>(create: (_) => backendMessagingService),
        Provider<ConnectionService>(create: (_) => connectionService),
        Provider<NotificationService>(create: (_) => notificationService),
        ChangeNotifierProvider(
          create: (context) => NotificationProvider(notificationService),
        ),
        Provider<MessagingService>(create: (_) => MessagingService()),

    Provider<MedicalDocumentService>(create: (_) => MedicalDocumentService()),

        Provider<MedicalDocumentService>(
            create: (_) => MedicalDocumentService()),

      ],
      child: MyApp(),
    ),
  );
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

/*class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(debugShowCheckedModeBanner: false, home: HomeS14());
  }
}*/
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => HomeS14(), // Splash screen
        '/home': (context) => HomeS13(), // Main screen after splash
        // Add if you have a login page
      },
    );
  }
}

class HomeS14 extends StatefulWidget {
  @override
  _HomeS14State createState() => _HomeS14State();
}

class _HomeS14State extends State<HomeS14> {
  @override
  void initState() {
    super.initState();
    // Navigate after 5 seconds
    Future.delayed(Duration(seconds: 5), () {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => HomeS13()), // Target page
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF396C9B),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: 20),
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(),
            alignment: Alignment.center,
            child: Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/logop1.PNG"),
                  fit: BoxFit.cover, // Ajuste l'image à l'espace dispo
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
