import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../models/AppointementService.dart';
import 'package:flutter_application_2/models/HealthcareProfessional.dart';
import 'package:flutter_application_2/models/Service.dart';

class AppointmentPage extends StatefulWidget {
  final HealthcareProfessional professional;
  final Service? service;

  const AppointmentPage({
    required this.professional,
    this.service,
    Key? key,
  }) : super(key: key);

  @override
  State<AppointmentPage> createState() => _AppointmentPageState();
}

class _AppointmentPageState extends State<AppointmentPage> {
  DateTime? selectedDate;
  int? selectedTimeSlot;
  String? selectedService;
  String? selectedSpecialty;
  String? selectedDoctor;

  List<Service> availableServices = [];
  List<String> specialties = [];
  Map<String, List<HealthcareProfessional>> doctorsBySpecialty = {};
  List<Map<String, dynamic>> availableTimeSlots = [];
  String? _currentPatientId;
  bool _isLoading = false;

  final AppointmentService _appointmentService = AppointmentService();
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    _getCurrentPatient();
    _loadInitialData();
  }

  Future<void> _getCurrentPatient() async {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        final patientDoc = await _firestore.collection('patients')
          .where('userId', isEqualTo: user.uid)
          .limit(1)
          .get();
        
        if (patientDoc.docs.isNotEmpty) {
          setState(() {
            _currentPatientId = patientDoc.docs.first.id;
          });
        }
      }
    } catch (e) {
      log('Error getting current patient: $e');
      _showError('Erreur de chargement du profil patient');
    }
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);
    try {
      if (widget.professional.isDoctor) {
        await _loadDoctorServices();
      } else if (widget.professional.isClinic) {
        await _loadClinicSpecialtiesAndDoctors();
      }
    } catch (e) {
      log('Error loading initial data: $e');
      _showError('Erreur de chargement des données');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  Future<void> _loadDoctorServices() async {
    try {
      if (widget.professional.specialty == null) return;

      final servicesSnapshot = await _firestore.collection('services')
          .where('healthcareType', isEqualTo: HealthcareType.medecin.name)
          .where('specialty', isEqualTo: widget.professional.specialty!.name)
          .get();

      setState(() {
        availableServices = servicesSnapshot.docs
            .map((doc) => Service.fromJson({...doc.data(), 'id': doc.id}))
            .toList();
        
        if (widget.service != null && availableServices.any((s) => s.id == widget.service!.id)) {
          selectedService = widget.service!.name;
        }
      });
    } catch (e) {
      log('Error loading doctor services: $e');
      throw Exception('Failed to load doctor services');
    }
  }

  Future<void> _loadClinicSpecialtiesAndDoctors() async {
    try {
      // Get specialties from availableSpecialties of the clinic
      setState(() {
        specialties = widget.professional.availableSpecialties
            .map((spec) => spec.name)
            .toList();
      });

      // Get doctors working at this clinic
      final doctorsSnapshot = await _firestore.collection('healthcareProfessional')
          .where('staffIds', arrayContains: widget.professional.id)
          .get();

      doctorsBySpecialty = {};
      for (var doc in doctorsSnapshot.docs) {
        final doctor = HealthcareProfessional.fromJson({...doc.data(), 'id': doc.id});
        if (doctor.specialty != null) {
          doctorsBySpecialty.putIfAbsent(
            doctor.specialty!.name, 
            () => []
          ).add(doctor);
        }
      }
    } catch (e) {
      log('Error loading clinic specialties and doctors: $e');
      throw Exception('Failed to load clinic data');
    }
  }

Future<void> _pickDate() async {
  final DateTime? picked = await showDatePicker(
    context: context,
    initialDate: selectedDate ?? DateTime.now(),
    firstDate: DateTime.now(),
    lastDate: DateTime.now().add(const Duration(days: 365)),
    locale: const Locale('fr', 'FR'),
    selectableDayPredicate: (DateTime day) {
      if (widget.professional.weeklyAvailability.isEmpty) return true;
      
      final dayIndex = day.weekday - 1;
      if (dayIndex >= widget.professional.weeklyAvailability.length) return false;
      
      // Get the day name in English (Monday, Tuesday, etc.)
      final daysOfWeek = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
      final dayName = daysOfWeek[dayIndex];
      
      // Check availability for this day
      final weeklyAvailability = widget.professional.weeklyAvailability.first;
      return weeklyAvailability.availability[dayName]?.contains(1) ?? false;
    },
  );
  
  if (picked != null && mounted) {
    setState(() {
      selectedDate = picked;
      selectedTimeSlot = null;
    });
    await _loadAvailableTimeSlots(picked);
  }
}

 Future<void> _loadAvailableTimeSlots(DateTime date) async {
  if (!mounted) return;
  
  setState(() => _isLoading = true);
  try {
    String professionalId = widget.professional.id;
    
    if (widget.professional.isClinic && selectedDoctor != null) {
      professionalId = doctorsBySpecialty[selectedSpecialty]!
          .firstWhere((doc) => doc.name == selectedDoctor).id;
    }

    final dayOfWeek = date.weekday - 1;
    final hpDoc = await _firestore.collection('healthcareProfessional')
        .doc(professionalId)
        .get();
    
    if (hpDoc.exists) {
      final hp = HealthcareProfessional.fromJson({...hpDoc.data()!, 'id': hpDoc.id});
      
      if (hp.weeklyAvailability.isNotEmpty) {
        final daysOfWeek = ['Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday'];
        final dayName = daysOfWeek[dayOfWeek];
        final weeklyAvailability = hp.weeklyAvailability.first;
        
        if (!(weeklyAvailability.availability[dayName]?.contains(1) ?? false)) {
          if (mounted) {
            setState(() {
              availableTimeSlots = [];
            });
          }
          _showError('Le professionnel ne travaille pas ce jour-là');
          return;
        }
      }
    }

    final availability = await _appointmentService.checkAvailability(
      healthcareProfessionalId: professionalId,
      date: date,
    );

    if (mounted) {
      setState(() {
        availableTimeSlots = List.generate(10, (index) {
          final hour = 8 + index;
          return {
            'id': index,
            'start': '${hour.toString().padLeft(2, '0')}:00',
            'end': '${(hour + 1).toString().padLeft(2, '0')}:00',
            'available': availability[index] == 1,
          };
        });
      });
    }
  } catch (e) {
    log('Error loading available time slots: $e');
    _showError('Erreur de chargement des créneaux disponibles');
  } finally {
    if (mounted) {
      setState(() => _isLoading = false);
    }
  }
}

  Future<void> _bookAppointment() async {
    if (!_isFormComplete() || _currentPatientId == null) return;

    setState(() => _isLoading = true);
    try {
      final startTime = TimeOfDay(hour: 8 + selectedTimeSlot!, minute: 0);
      final endTime = TimeOfDay(hour: 9 + selectedTimeSlot!, minute: 0);

      String professionalId = widget.professional.id;
      if (widget.professional.isClinic && selectedDoctor != null) {
        professionalId = doctorsBySpecialty[selectedSpecialty]!
            .firstWhere((doc) => doc.name == selectedDoctor).id;
      }

      final serviceId = widget.professional.isDoctor
          ? availableServices.firstWhere((s) => s.name == selectedService).id
          : availableServices.firstWhere((s) => s.name == selectedService).id;

      await _appointmentService.createAppointment(
        patientId: _currentPatientId!,
        healthcareProfessionalId: professionalId,
        serviceId: serviceId,
        date: selectedDate!,
        startTime: startTime,
        endTime: endTime,
      );

      _showSuccessDialog();
    } catch (e) {
      log('Error booking appointment: $e');
      _showError('Échec de la réservation: ${e.toString()}');
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  void _showSuccessDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text("Demande de rendez-vous envoyée"),
        content: Text(
          widget.professional.isDoctor
              ? "Votre demande de rendez-vous avec le Dr. ${widget.professional.name} a été envoyée avec succès. Veuillez attendre la confirmation du médecin."
              : "Votre demande de rendez-vous avec le Dr. $selectedDoctor a été envoyée avec succès. Veuillez attendre la confirmation de la clinique.",
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop();
            },
            child: const Text("OK"),
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Prendre un rendez-vous"),
        centerTitle: true,
        leading: const BackButton(),
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  if (widget.professional.isDoctor) ...[
                    _buildServiceDropdown(),
                  ],
                  if (widget.professional.isClinic) ...[
                    _buildSpecialtyDropdown(),
                    if (selectedSpecialty != null && 
                        doctorsBySpecialty.containsKey(selectedSpecialty))
                      _buildDoctorDropdown(),
                  ],
                  _buildDatePicker(),
                  if (selectedDate != null) _buildTimeSlots(),
                  const SizedBox(height: 20),
                  _buildBookButton(),
                ],
              ),
            ),
    );
  }

  Widget _buildSpecialtyDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Spécialité", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: selectedSpecialty,
            hint: const Text("Choisir une spécialité"),
            items: specialties
                .map((s) => DropdownMenuItem(value: s, child: Text(s)))
                .toList(),
            onChanged: (val) {
              setState(() {
                selectedSpecialty = val;
                selectedDoctor = null;
                selectedDate = null;
                availableTimeSlots = [];
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDoctorDropdown() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Médecin", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: selectedDoctor,
            hint: const Text("Choisir un médecin"),
            items: doctorsBySpecialty[selectedSpecialty]!
                .map((doc) => DropdownMenuItem(
                      value: doc.name,
                      child: Text(doc.name),
                    ))
                .toList(),
            onChanged: (val) {
              setState(() {
                selectedDoctor = val;
                selectedDate = null;
                availableTimeSlots = [];
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildServiceDropdown() {
    if (availableServices.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Service", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text("Aucun service disponible"),
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Service", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: selectedService,
            hint: const Text("Choisir un service"),
            items: availableServices
                .map((service) => DropdownMenuItem(
                      value: service.name,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(service.name),
                          if (service.description.isNotEmpty)
                            Text(
                              service.description,
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey[600],
                              ),
                            ),
                        ],
                      ),
                    ))
                .toList(),
            onChanged: (val) {
              setState(() {
                selectedService = val;
              });
            },
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDatePicker() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Date", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          InkWell(
            onTap: _pickDate,
            child: InputDecorator(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                suffixIcon: const Icon(Icons.calendar_today),
              ),
              child: Text(
                selectedDate != null
                    ? "${selectedDate!.day}/${selectedDate!.month}/${selectedDate!.year}"
                    : "Choisir une date",
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSlots() {
    if (availableTimeSlots.isEmpty) {
      return Padding(
        padding: const EdgeInsets.only(bottom: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text("Créneaux horaires", style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Center(
                child: Text("Aucun créneau disponible pour cette date"),
              ),
            ),
          ],
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Créneaux horaires", style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: availableTimeSlots.map((slot) {
              return ChoiceChip(
                label: Text("${slot['start']} - ${slot['end']}"),
                selected: selectedTimeSlot == slot['id'],
                onSelected: slot['available']
                    ? (selected) {
                        if (selected) {
                          setState(() {
                            selectedTimeSlot = slot['id'];
                          });
                        }
                      }
                    : null,
                selectedColor: Colors.blue[200],
                backgroundColor: Colors.grey[200],
                disabledColor: Colors.grey[300],
                labelStyle: TextStyle(
                  color: slot['available'] ? Colors.black : Colors.grey,
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildBookButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: _isFormComplete() ? _bookAppointment : null,
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        child: const Text("Demander le rendez-vous"),
      ),
    );
  }

  bool _isFormComplete() {
    if (selectedDate == null || selectedTimeSlot == null) return false;
    
    if (widget.professional.isDoctor) {
      return selectedService != null;
    } else {
      return selectedSpecialty != null && selectedDoctor != null;
    }
  }
}