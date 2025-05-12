import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_application_2/models/Appointment.dart';
import '../../models/AppointementService.dart';
import 'package:flutter_application_2/models/HealthcareProfessional.dart';
import 'package:flutter_application_2/models/Patient.dart';
import 'package:flutter_application_2/models/Patient_service.dart';
import 'package:flutter_application_2/models/Service.dart';
import 'package:flutter_application_2/models/services_service.dart';
import 'package:flutter_application_2/screens/medecin/rendez_vous_screen.dart';
import 'package:intl/intl.dart';

// Move color constants to top-level so they are accessible everywhere in this file
const Color myDarkBlue = Color(0xFF073057);
const Color myBlue2 = Color(0xFF396C9B);
const Color myLightBlue = Color(0xFFA3C3E4);

class RendezVousScreen extends StatefulWidget {
  final String healthcareProfessionalId;

  const RendezVousScreen({Key? key, required this.healthcareProfessionalId}) : super(key: key);

  @override
  _RendezVousScreenState createState() => _RendezVousScreenState();
}

class _RendezVousScreenState extends State<RendezVousScreen> {

  final AppointmentService _appointmentService = AppointmentService();
  final PatientService _patientService = PatientService();
  final ServicesService _servicesService = ServicesService();
  DateTime _selectedDate = DateTime.now();
  List<Appointment> _appointments = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchAppointments();
  }

  Future<void> _fetchAppointments() async {
    setState(() => _isLoading = true);
    try {
      final appointments = await _appointmentService.queryField(
        'healthcareProfessionalId',
        widget.healthcareProfessionalId,
      );
      final filteredAppointments = appointments.where((appt) {
        return appt.date.year == _selectedDate.year &&
            appt.date.month == _selectedDate.month &&
            appt.date.day == _selectedDate.day &&
            appt.status == AppointmentStatus.scheduled;
      }).toList();
      setState(() {
        _appointments = filteredAppointments;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching appointments: $e');
      setState(() => _isLoading = false);
    }
  }

  void _changeDate(int days) {
    setState(() {
      _selectedDate = _selectedDate.add(Duration(days: days));
    });
    _fetchAppointments();
  }

  Future<String?> _getPatientName(String patientId) async {
    return await _patientService.getPatientName(patientId);
  }

  Future<String?> _getServiceName(String serviceId) async {
    try {
      final service = await _servicesService.getServicesByType(HealthcareType.medecin);
      final targetService = service.firstWhere((s) => s.id == serviceId, orElse: () => Service(
        id: '',
        name: 'Unknown Service',
        description: '',
        price: 0.0,
        healthcareType: HealthcareType.medecin,
      ));
      return targetService.name;
    } catch (e) {
      print('Error fetching service name: $e');
      return 'Unknown Service';
    }
  }

  Future<void> _addNewAppointment() async {
    // Navigate to a form to input new appointment details
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => NewAppointmentForm(
          healthcareProfessionalId: widget.healthcareProfessionalId,
          selectedDate: _selectedDate,
          onAppointmentCreated: _fetchAppointments,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Rendez-vous',
          style: TextStyle(
            color: myDarkBlue,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
        backgroundColor: Colors.blue[100],
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: myDarkBlue),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            _buildDateSelector(),
            const SizedBox(height: 20),
            Expanded(
              child: _isLoading
                  ? Center(child: CircularProgressIndicator())
                  : _appointments.isEmpty
                      ? Center(child: Text('Aucun rendez-vous pour ce jour'))
                      : ListView.builder(
                          itemCount: _appointments.length,
                          itemBuilder: (context, index) {
                            final appt = _appointments[index];
                            return FutureBuilder(
                              future: Future.wait([
                                _getPatientName(appt.patientId),
                                _getServiceName(appt.serviceId),
                              ]),
                              builder: (context, AsyncSnapshot<List<String?>> snapshot) {
                                if (!snapshot.hasData) {
                                  return Card(
                                    margin: const EdgeInsets.only(bottom: 12),
                                    child: ListTile(
                                      title: Text('Chargement...'),
                                    ),
                                  );
                                }
                                final patientName = snapshot.data![0] ?? 'Patient Inconnu';
                                final serviceName = snapshot.data![1] ?? 'Service Inconnu';
                                final isNext = index == 0 &&
                                    DateTime.now().isBefore(appt.date.add(Duration(
                                      hours: appt.startTime.hour,
                                      minutes: appt.startTime.minute,
                                    )));

                                return _buildAppointmentCard(
                                  patientName: patientName,
                                  reason: serviceName,
                                  time: '${appt.startTime.format(context)} - ${appt.endTime.format(context)}',
                                  isNext: isNext,
                                );
                              },
                            );
                          },
                        ),
            ),
            _buildAddButton(),
          ],
        ),
      ),
    );
  }

  Widget _buildDateSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: myLightBlue.withOpacity(0.3),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(Icons.chevron_left, color: myBlue2),
            onPressed: () => _changeDate(-1),
          ),
          Text(
            DateFormat('EEEE, d MMMM yyyy', 'fr_FR').format(_selectedDate),
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: myDarkBlue,
            ),
          ),
          IconButton(
            icon: Icon(Icons.chevron_right, color: myBlue2),
            onPressed: () => _changeDate(1),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard({
    required String patientName,
    required String reason,
    required String time,
    bool isNext = false,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: BorderSide(
          color: isNext ? myBlue2 : Colors.grey.shade200,
          width: 1,
        ),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            color: isNext ? myBlue2 : myLightBlue,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.person,
            color: isNext ? Colors.white : myDarkBlue,
          ),
        ),
        title: Text(
          patientName,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: myDarkBlue,
          ),
        ),
        subtitle: Text(
          reason,
          style: TextStyle(color: Colors.grey.shade600),
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              time,
              style: TextStyle(
                color: isNext ? myBlue2 : myDarkBlue,
                fontWeight: isNext ? FontWeight.bold : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAddButton() {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: ElevatedButton.icon(
        icon: Icon(Icons.add, color: Colors.white),
        label: Text(
          'Nouveau rendez-vous',
          style: TextStyle(color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: myBlue2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
        ),
        onPressed: _addNewAppointment,
      ),
    );
  }
}

class NewAppointmentForm extends StatefulWidget {
  final String healthcareProfessionalId;
  final DateTime selectedDate;
  final VoidCallback onAppointmentCreated;

  const NewAppointmentForm({
    Key? key,
    required this.healthcareProfessionalId,
    required this.selectedDate,
    required this.onAppointmentCreated,
  }) : super(key: key);

  @override
  _NewAppointmentFormState createState() => _NewAppointmentFormState();
}

class _NewAppointmentFormState extends State<NewAppointmentForm> {
  final _formKey = GlobalKey<FormState>();
  String? _patientId;
  String? _serviceId;
  TimeOfDay _startTime = TimeOfDay(hour: 8, minute: 0);
  TimeOfDay _endTime = TimeOfDay(hour: 8, minute: 30);
  List<Patient> _patients = [];
  List<Service> _services = [];
  bool _isLoading = true;
  final AppointmentService _appointmentService = AppointmentService();
  final PatientService _patientService = PatientService();
  final ServicesService _servicesService = ServicesService();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() => _isLoading = true);
    try {
      final patients = await _patientService.getAllPatients();
      final services = await _servicesService.getServicesByProfessional(widget.healthcareProfessionalId);
      setState(() {
        _patients = patients;
        _services = services;
        _isLoading = false;
      });
    } catch (e) {
      print('Error fetching data: $e');
      setState(() => _isLoading = false);
    }
  }

  Future<void> _selectTime(BuildContext context, bool isStart) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: isStart ? _startTime : _endTime,
    );
    if (picked != null) {
      setState(() {
        if (isStart) {
          _startTime = picked;
          // Auto-set end time to 30 minutes later
          final endDateTime = DateTime(
            widget.selectedDate.year,
            widget.selectedDate.month,
            widget.selectedDate.day,
            _startTime.hour,
            _startTime.minute,
          ).add(Duration(minutes: 30));
          _endTime = TimeOfDay.fromDateTime(endDateTime);
        } else {
          _endTime = picked;
        }
      });
    }
  }

  Future<void> _createAppointment() async {
    if (_formKey.currentState!.validate()) {
      try {
        await _appointmentService.createAppointment(
          patientId: _patientId!,
          healthcareProfessionalId: widget.healthcareProfessionalId,
          serviceId: _serviceId!,
          date: widget.selectedDate,
          startTime: _startTime,
          endTime: _endTime,
        );
        widget.onAppointmentCreated();
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Rendez-vous créé avec succès')),
        );
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Nouveau Rendez-vous'),
        backgroundColor: Colors.blue[100],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: 'Patient'),
                      value: _patientId,
                      items: _patients.map((patient) {
                        return DropdownMenuItem<String>(
                          value: patient.id,
                          child: Text(patient.name),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => _patientId = value),
                      validator: (value) => value == null ? 'Veuillez sélectionner un patient' : null,
                    ),
                    SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      decoration: InputDecoration(labelText: 'Service'),
                      value: _serviceId,
                      items: _services.map((service) {
                        return DropdownMenuItem<String>(
                          value: service.id,
                          child: Text(service.name),
                        );
                      }).toList(),
                      onChanged: (value) => setState(() => _serviceId = value),
                      validator: (value) => value == null ? 'Veuillez sélectionner un service' : null,
                    ),
                    SizedBox(height: 16),
                    ListTile(
                      title: Text('Heure de début: ${_startTime.format(context)}'),
                      trailing: Icon(Icons.access_time),
                      onTap: () => _selectTime(context, true),
                    ),
                    ListTile(
                      title: Text('Heure de fin: ${_endTime.format(context)}'),
                      trailing: Icon(Icons.access_time),
                      onTap: () => _selectTime(context, false),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: _createAppointment,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: myBlue2,
                        foregroundColor: Colors.white,
                      ),
                      child: Text('Créer le rendez-vous'),
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}