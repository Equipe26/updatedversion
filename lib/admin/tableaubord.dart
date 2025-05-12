import 'package:flutter/material.dart';
import 'admin_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DashboardScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class DashboardScreen extends StatefulWidget {
  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final AdminService _adminService = AdminService();
  bool _isLoading = true;
  Map<String, dynamic> _stats = {
    'totalPatients': 0,
    'totalHealthcareProfessionals': 0,
    'pendingHealthcareProfessionals': 0,
    'totalAppointments': 0,
  };

  @override
  void initState() {
    super.initState();
    _loadStatistics();
  }

  Future<void> _loadStatistics() async {
    setState(() {
      _isLoading = true;
    });

    try {
      // Get healthcare professional statistics
      final hpStats = await _adminService.getHealthcareProfessionalsStats();
      
      // Get patient count
      final patientCount = await FirebaseFirestore.instance
          .collection('users')
          .where('role', isEqualTo: 'patient')
          .count()
          .get();
      
      // Get appointment count
      final appointmentCount = await FirebaseFirestore.instance
          .collection('appointments')
          .count()
          .get();
      
      setState(() {
        _stats['totalPatients'] = patientCount.count;
        _stats['totalHealthcareProfessionals'] = hpStats['total'];
        _stats['pendingHealthcareProfessionals'] = hpStats['pending'];
        _stats['totalAppointments'] = appointmentCount.count;
      });
    } catch (e) {
      print('Error loading statistics: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load statistics: ${e.toString()}')),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
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
              Icon(Icons.dashboard, color: Color(0xFF073057)),
              SizedBox(width: 10),
              Text(
                'Tableau de bord',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20,
                  color: Color(0xFF073057),
                ),
              ),
            ],
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.refresh, color: Color(0xFF073057)),
            onPressed: _loadStatistics,
          ),
        ],
      ),

      body: Center(
        child: Container(
          margin: EdgeInsets.all(20),
          height: screenHeight * 0.8,
          width: double.infinity,
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
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      SizedBox(height: 30),
                      DashboardItem(
                        iconPath: 'assets/utilisateurs.png',
                        label: '+${_stats['totalPatients']} Patients',
                        color: Colors.blue,
                      ),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            child: DashboardItem(
                              iconPath: 'assets/personnel.png',
                              label: '+${_stats['totalHealthcareProfessionals']} Personnels de santé',
                              color: Colors.green,
                            ),
                          ),
                        ],
                      ),
                      if (_stats['pendingHealthcareProfessionals'] > 0) ...[
                        SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Expanded(
                              child: DashboardItem(
                                iconPath: 'assets/personnel.png',
                                label: '${_stats['pendingHealthcareProfessionals']} en attente',
                                color: Colors.orange,
                                badge: true,
                              ),
                            ),
                          ],
                        ),
                      ],
                      SizedBox(height: 20),
                      DashboardItem(
                        iconPath: 'assets/service.png',
                        label: '+${_stats['totalAppointments']} rendez-vous',
                        color: Colors.purple,
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}

class DashboardItem extends StatelessWidget {
  final String iconPath;
  final String label;
  final Color color;
  final bool badge;

  const DashboardItem({
    required this.iconPath, 
    required this.label,
    this.color = const Color(0xFF073057),
    this.badge = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Image.asset(iconPath, height: 60),
            ),
            if (badge)
              Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.priority_high,
                    color: Colors.white,
                    size: 15,
                  ),
                ),
              ),
          ],
        ),
        SizedBox(height: 10),
        Container(
          padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            label,
            style: TextStyle(color: Colors.white, fontSize: 16),
          ),
        ),
      ],
    );
  }
}
