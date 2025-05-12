import 'dart:async';
import 'dart:io';
import '../../../models//conversation.dart';
import 'package:file_picker/file_picker.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'models/HealthcareProfessional.dart';
import 'models/HealthcareProfessionalService.dart';
import 'models/Map.dart';
import 'models/MedicalDocumentService.dart';
import 'models/MessagingService.dart';
import 'models/Service.dart';
import 'models/Specialty.dart';
import 'models/Patient.dart';
import 'models/Notification.dart' as MyNotification;
import 'models/Appointment.dart';
import 'models/Notification_service.dart';
import 'database_service.dart';
import 'models/User.dart';
import 'models/Connection.dart';

class DBBuilder {
  final FirestoreService<HealthcareProfessional> _hpService;
  final FirestoreService<Service> _serviceService;
  final FirestoreService<Patient> _patientService;
  final FirestoreService<Appointment> _appointmentService;
  final FirestoreService<User> _userService;
  final FirestoreService<Connection> _connectionService;
  final FirestoreService<Conversation> _conversationService;
  final MedicalDocumentService _documentService;
  final NotificationService _notificationService;
  final BuildContext context;
  final MessagingService _messagingService;

  DBBuilder(this.context)
      : _hpService = FirestoreService(
    collectionPath: 'healthcareProfessional',
    fromJson: HealthcareProfessional.fromJson,
    toJson: (hp) => hp.toJson(),
  ),
        _serviceService = FirestoreService(
          collectionPath: 'services',
          fromJson: Service.fromJson,
          toJson: (service) => service.toJson(),
        ),
        _conversationService = FirestoreService(
          collectionPath: 'conversations',
          fromJson: Conversation.fromJson,
          toJson: (service) => service.toJson(),
        ),
        _patientService = FirestoreService(
          collectionPath: 'patients',
          fromJson: Patient.fromJson,
          toJson: (patient) => patient.toJson(),
        ),
        _appointmentService = FirestoreService(
          collectionPath: 'appointments',
          fromJson: Appointment.fromJson,
          toJson: (appointment) => appointment.toJson(),
        ),
        _userService = FirestoreService(
          collectionPath: 'users',
          fromJson: User.fromJson,
          toJson: (user) => user.toJson(),
        ),
        _connectionService = FirestoreService(
          collectionPath: 'connections',
          fromJson: Connection.fromJson,
          toJson: (connection) => connection.toJson(),
        ),

        _notificationService = NotificationService(),
        _documentService = MedicalDocumentService(),
        _messagingService = MessagingService();


  Future<void> run() async {
    while (true) {
      final choice = await _showMenuDialog();
      switch (choice) {
        case 1:
          await _addHealthcareProfessional();
          break;
        case 2:
          await _addMedicalService();
          break;
        case 3:
          await _addPatient();
          break;
        case 4:
          await _addAppointment();
          break;
        case 5:
          await _addNotification();
          break;
        case 6:
          await _testPatientFunctions();
          break;
        case 7:
          await _testNotificationFunctions();
          break;
        case 8:
          await _testAppointmentFunctions();
          break;
        case 9:
          await _testEmergencyFunctions();
          break;
        case 10:
          await _testConversationFunctions();
          break;
        case 11:
          await _testHealthcareProfessionalFunctions();
          break;
        case 12:
          return;
        default:
          await _showMessageDialog('Invalid choice');
      }
    }
  }

  Future<int> _showMenuDialog() async {
    return await showDialog<int>(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text('Healthcare DB Builder'),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text('1. Add Healthcare Professional'),
                    onTap: () => Navigator.pop(context, 1),
                  ),
                  ListTile(
                    title: Text('2. Add Medical Service'),
                    onTap: () => Navigator.pop(context, 2),
                  ),
                  ListTile(
                    title: Text('3. Add Patient'),
                    onTap: () => Navigator.pop(context, 3),
                  ),
                  ListTile(
                    title: Text('4. Add Appointment'),
                    onTap: () => Navigator.pop(context, 4),
                  ),
                  ListTile(
                    title: Text('5. Add Notification'),
                    onTap: () => Navigator.pop(context, 5),
                  ),
                  ListTile(
                    title: Text('6. Test Patient Functions'),
                    onTap: () => Navigator.pop(context, 6),
                  ),
                  ListTile(
                    title: Text('7. Test Notification Functions'),
                    onTap: () => Navigator.pop(context, 7),
                  ),
                  ListTile(
                    title: Text('8. Test Appointment Functions'),
                    onTap: () => Navigator.pop(context, 8),
                  ),
                  ListTile(
                    title: Text('9. Test Emergency Functions'),
                    onTap: () => Navigator.pop(context, 9),
                  ),
                  ListTile(
                    title: Text('10. Test Conversation Functions'),
                    onTap: () => Navigator.pop(context, 10),
                  ),
                  ListTile(
                    title: Text('11. Test Healthcare Professionals'),
                    onTap: () => Navigator.pop(context, 11),
                  ),

                  ListTile(
                    title: Text('12. Exit'),
                    onTap: () => Navigator.pop(context, 12),
                  ),
                ],
              ),
            ),
          ),
    ) ?? 0;
  }


// Helper methods
  Future<String?> _showInputDialog(String title) async {
    final controller = TextEditingController();
    return await showDialog<String>(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text(title),
            content: TextField(controller: controller),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, controller.text),
                child: Text('OK'),
              ),
            ],
          ),
    );
  }

  Future<void> _showMessageDialog(String message) async {
    await showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            content: Text(message),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('OK'),
              ),
            ],
          ),
    );
  }


  // Add these methods to the DBBuilder class in db_init.dart

  Future<void> _testConversationFunctions() async {
    final choice = await showDialog<int>(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text('Test Conversation Functions'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text('1. Send Message with Attachment'),
                  onTap: () => Navigator.pop(context, 1),
                ),
                ListTile(
                  title: Text('2. Download Message Attachment'),
                  onTap: () => Navigator.pop(context, 2),
                ),
                ListTile(
                  title: Text('3. Cancel'),
                  onTap: () => Navigator.pop(context, 3),
                ),
              ],
            ),
          ),
    );

    switch (choice) {
      case 1:
        await _testSendMessageWithAttachment();
        break;
      case 2:
        await _testDownloadAttachment();
        break;
    }
  }

  Future<void> _testSendMessageWithAttachment() async {
    try {
      // Get conversation info
      final conversationId = await _showInputDialog('Enter Conversation ID');
      if (conversationId == null || conversationId.isEmpty) return;

      final senderId = await _showInputDialog('Enter Sender ID');
      if (senderId == null || senderId.isEmpty) return;

      final recipientId = await _showInputDialog('Enter Recipient ID');
      if (recipientId == null || recipientId.isEmpty) return;

      final content = await _showInputDialog('Enter Message Content');
      if (content == null) return;

      // Pick files with proper error handling
      FilePickerResult? result;
      try {
        result = await FilePicker.platform.pickFiles(
          allowMultiple: true,
          type: FileType.any,
        );
      } catch (e) {
        await _showMessageDialog('File picker error: ${e.toString()}');
        return;
      }

      if (result == null || result.files.isEmpty) {
        await _showMessageDialog('No files selected');
        return;
      }

      // Process files - remove duplicates by path
      final uniqueFiles = <String, File>{};
      for (final platformFile in result.files) {
        if (platformFile.path != null) {
          uniqueFiles[platformFile.path!] = File(platformFile.path!);
        }
      }

      if (uniqueFiles.isEmpty) {
        await _showMessageDialog('No valid files selected');
        return;
      }

      // Prepare attachment data
      final attachments = <Map<String, dynamic>>[];
      for (final file in uniqueFiles.values) {
        final fileName = file.path
            .split('/')
            .last;
        final extension = file.path
            .split('.')
            .last
            .toLowerCase();

        final documentName = await _showInputDialog(
          'Name for $fileName',
        ) ?? fileName
            .split('.')
            .first;

        attachments.add({
          'file': file,
          'name': documentName,
          'extension': extension,
        });
      }

      // Show loading dialog
      bool isLoading = true;
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return WillPopScope(
            onWillPop: () async => !isLoading,
            child: AlertDialog(
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text('Uploading ${attachments.length} attachment(s)...'),
                ],
              ),
            ),
          );
        },
      );

      // Upload files
      final attachmentIds = <String>[];
      for (final attachment in attachments) {
        try {
          final document = await _documentService.uploadDocument(
            file: attachment['file'] as File,
            type: null,
            // Auto-detect type
            healthcareProfessionalId: senderId,
            patientId: recipientId,
            documentName: attachment['name'] as String,
          );
          attachmentIds.add(document.id);
        } catch (e) {
          debugPrint('Failed to upload ${attachment['file']}: $e');
        }
      }

      // Close loading dialog
      isLoading = false;
      Navigator.of(context).pop();

      if (attachmentIds.isEmpty) {
        await _showMessageDialog('No attachments uploaded successfully');
        return;
      }

      // Send message with attachment IDs
      await _messagingService.sendMessage(
        connectionId: conversationId,
        conversationId: conversationId,
        senderId: senderId,
        recipientId: recipientId,
        content: content,
        attachmentIds: attachmentIds,
      );

      await _showMessageDialog(
          'Success! Sent message with ${attachmentIds.length} attachment(s)\n'
              'Types: ${attachments.map((a) => a['extension']).join(', ')}'
      );
    } catch (e) {
      try {
        Navigator.of(context).pop(); // Close any open dialogs
      } catch (_) {}
      await _showMessageDialog('Error: ${e.toString()}');
    }
  }

// NEW HELPER METHOD FOR NAME INPUT
  Future<String?> _showDocumentNameDialog(BuildContext context, String title,
      String defaultValue) async {
    final controller = TextEditingController(text: defaultValue);
    return await showDialog<String>(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text(title),
            content: TextField(
              controller: controller,
              decoration: InputDecoration(hintText: 'Enter document name'),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, controller.text),
                child: Text('OK'),
              ),
            ],
          ),
    );
  }

  Future<void> _testDownloadAttachment() async {
    try {
      // Get document ID from user
      final documentId = await _showInputDialog(
          'Enter Document ID to download');
      if (documentId == null || documentId.isEmpty) return;

      // Get document metadata
      final document = await _documentService.getDocument(documentId);
      if (document == null) {
        await _showMessageDialog('Document not found');
        return;
      }

      // Get Android Downloads directory
      Directory? downloadsDir;
      if (Platform.isAndroid) {
        downloadsDir = Directory('/storage/emulated/0/Download');
        if (!await downloadsDir.exists()) {
          downloadsDir = await getExternalStorageDirectory();
        }
      } else {
        downloadsDir = await getDownloadsDirectory();
      }

      if (downloadsDir == null) {
        await _showMessageDialog('Could not access downloads directory');
        return;
      }

      // Create medical_documents subfolder if it doesn't exist
      final saveDir = Directory('${downloadsDir.path}/medical_documents');
      if (!await saveDir.exists()) {
        await saveDir.create(recursive: true);
      }

      // Extract file extension from URL
      final fileUrl = document.fileUrl;
      final extension = fileUrl
          .split('.')
          .last
          .split('?')
          .first;
      final fileName = 'medical_doc_${documentId}_${DateTime
          .now()
          .millisecondsSinceEpoch}.$extension';
      final savePath = '${saveDir.path}/$fileName';

      // Show loading dialog
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) =>
        const AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Downloading document...'),
            ],
          ),
        ),
      );

      // Download the file
      final downloadedFile = await _documentService.downloadDocumentToDevice(
        documentId,
        savePath,
      );

      // Close loading dialog
      Navigator.pop(context);

      // Show success dialog with open option
      final shouldOpen = await showDialog<bool>(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: const Text('Download Complete'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('File saved to:',
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  Text(savePath, style: TextStyle(fontSize: 12)),
                  SizedBox(height: 10),
                  Text('File size: ${(document.fileSize / 1024).toStringAsFixed(
                      2)} KB'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context, false),
                  child: const Text('OK'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, true),
                  child: const Text('OPEN FILE'),
                ),
              ],
            ),
      );

      // Open the file if requested
      if (shouldOpen == true) {
        try {
          final result = await OpenFile.open(downloadedFile.path);
          if (result.type != ResultType.done) {
            await _showMessageDialog('Could not open file: ${result.message}');
          }
        } catch (e) {
          await _showMessageDialog(
              'Error opening file: $e\n\nFile saved at: ${downloadedFile
                  .path}');
        }
      }
    } catch (e) {
      Navigator.pop(context); // Close loading dialog if open
      await _showMessageDialog('Error downloading document: ${e.toString()}');
    }
  }


  // [Keep all the existing methods unchanged below this point]
  Future<void> _addPatient() async {
    final id = await _showInputDialog('Patient ID');
    if (id == null || id.isEmpty) return;

    final name = await _showInputDialog('Name');
    if (name == null || name.isEmpty) return;

    final email = await _showInputDialog('Email');
    if (email == null || email.isEmpty) return;

    final password = await _showInputDialog('Password');
    if (password == null || password.isEmpty) return;

    final location = await _showInputDialog('Location');
    if (location == null || location.isEmpty) return;

    final emergencyContactName = await _showInputDialog(
        'Emergency Contact Name');
    if (emergencyContactName == null || emergencyContactName.isEmpty) return;

    final emergencyContactPhone = await _showInputDialog(
        'Emergency Contact Phone');
    if (emergencyContactPhone == null || emergencyContactPhone.isEmpty) return;

    try {
      // Create User document
      final user = User(
        id: id,
        name: name,
        email: email,
        password: password,
        location: location,
        role: Role.patient,
      );
      await _userService.add(data: user, id: user.id, randomizeId: false);

      // Create Patient document
      final patient = Patient(
        id: id,
        name: name,
        email: email,
        password: password,
        location: location,
        medicalRecord: [],
        appointmentIds: [],
        emergencyContactName: emergencyContactName,
        emergencyContactPhone: emergencyContactPhone,
      );

      await _patientService.add(data: patient, id: user.id, randomizeId: false);
      await _showMessageDialog('✅ Patient added successfully!');
    } catch (e) {
      await _showMessageDialog('Error: ${e.toString()}');
    }
  }

  Future<void> _addAppointment() async {
    final id = await _showInputDialog('Appointment ID');
    if (id == null || id.isEmpty) return;

    final patientId = await _showInputDialog('Patient ID');
    if (patientId == null || patientId.isEmpty) return;

    final hpId = await _showInputDialog('Healthcare Professional ID');
    if (hpId == null || hpId.isEmpty) return;

    final serviceId = await _showInputDialog('Service ID');
    if (serviceId == null || serviceId.isEmpty) return;

    final dateStr = await _showInputDialog('Date (YYYY-MM-DD)');
    if (dateStr == null || dateStr.isEmpty) return;
    final date = DateTime.parse(dateStr);

    final startTimeStr = await _showInputDialog('Start Time (HH:MM)');
    if (startTimeStr == null || startTimeStr.isEmpty) return;
    final startParts = startTimeStr.split(':');
    final startTime = TimeOfDay(
      hour: int.parse(startParts[0]),
      minute: int.parse(startParts[1]),
    );

    final endTimeStr = await _showInputDialog('End Time (HH:MM)');
    if (endTimeStr == null || endTimeStr.isEmpty) return;
    final endParts = endTimeStr.split(':');
    final endTime = TimeOfDay(
      hour: int.parse(endParts[0]),
      minute: int.parse(endParts[1]),
    );

    try {
      final appointment = Appointment(
        id: id,
        patientId: patientId,
        healthcareProfessionalId: hpId,
        serviceId: serviceId,
        date: date,
        startTime: startTime,
        endTime: endTime,
        status: AppointmentStatus.scheduled,
      );

      await _appointmentService.add(
          data: appointment, id: appointment.id, randomizeId: false);

      // Update patient's appointmentIds
      final patient = await _patientService.get(patientId);
      if (patient != null) {
        await _patientService.update(
          patientId,
          patient.copyWith(appointmentIds: [...patient.appointmentIds, id]),
              (patient) => patient.toJson(),
        );
      }

      // Update healthcare professional's appointmentIds
      final hp = await _hpService.get(hpId);
      if (hp != null) {
        await _hpService.update(
          hpId,
          hp.copyWith(appointmentIds: [...hp.appointmentIds, id]),
              (hp) => hp.toJson(),
        );
      }

      await _showMessageDialog('✅ Appointment added successfully!');
    } catch (e) {
      await _showMessageDialog('Error: ${e.toString()}');
    }
  }

  Future<void> _addMedicalService() async {
    try {
      // Get basic service information
      final id = await _showInputDialog('Service ID');
      if (id == null || id.isEmpty) return;

      final name = await _showInputDialog('Service Name (FR)');
      if (name == null || name.isEmpty) return;

      final description = await _showInputDialog('Description');
      if (description == null || description.isEmpty) return;

      final priceStr = await _showInputDialog('Price (DA)');
      if (priceStr == null || priceStr.isEmpty) return;
      final price = double.tryParse(priceStr) ?? 0.0;

      // Get specialty and healthcare type
      final specialty = await _selectSpecialtyDialog();
      if (specialty == null) return;

      final healthcareType = await _selectHealthcareTypeDialog();
      if (healthcareType == null) return;

      // Validate specialty requirement for doctors
      if (healthcareType == HealthcareType.medecin && specialty == null) {
        await _showMessageDialog(
            'Specialty must be provided for medical services');
        return;
      }

      // Create the service with existing structure
      final service = Service(
        id: id,
        name: name,
        description: description,
        price: price,
        specialty: specialty,
        healthcareType: healthcareType,
      );

      await _serviceService.add(
          data: service, id: service.id, randomizeId: false);

      // Option to assign to healthcare professionals (except clinics)
      if (healthcareType != HealthcareType.clinique) {
        final assignToHp = await showDialog<bool>(
          context: context,
          builder: (context) =>
              AlertDialog(
                title: Text('Assign Service'),
                content: Text(
                    'Would you like to assign this service to a healthcare professional now?'),
                actions: [
                  TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: Text('Skip'),
                  ),
                  TextButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: Text('Assign'),
                  ),
                ],
              ),
        );

        if (assignToHp == true) {
          await _assignServiceToHealthcareProfessional(
              service.id, healthcareType, specialty);
        }
      }

      await _showMessageDialog(
          '✅ Service "${service.name}" added successfully!');
    } catch (e) {
      await _showMessageDialog('Error adding service: ${e.toString()}');
    }
  }

  Future<void> _assignServiceToHealthcareProfessional(String serviceId,
      HealthcareType healthcareType,
      Specialty? specialty,) async {
    try {
      // Get all healthcare professionals filtered by type and specialty
      final allHps = await _hpService.getAll();
      final filteredHps = allHps.where((hp) {
        // Match healthcare type
        if (hp.type != healthcareType) return false;

        // For doctors, match specialty if specified
        if (healthcareType == HealthcareType.medecin &&
            specialty != null &&
            hp.specialty != specialty) {
          return false;
        }

        return true;
      }).toList();

      if (filteredHps.isEmpty) {
        await _showMessageDialog('No matching healthcare professionals found');
        return;
      }

      // Show selection dialog
      final selectedHpId = await showDialog<String>(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text('Select Healthcare Professional'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: filteredHps.map((hp) {
                    return ListTile(
                      title: Text(hp.name),
                      subtitle: Text('${hp.typeDisplay}${hp.specialty != null
                          ? ' - ${hp.specialty!.displayName}'
                          : ''}'),
                      onTap: () => Navigator.pop(context, hp.id),
                    );
                  }).toList(),
                ),
              ),
            ),
      );

      if (selectedHpId != null) {
        final hp = await _hpService.get(selectedHpId);
        if (hp != null) {
          await _hpService.update(
            selectedHpId,
            hp.copyWith(serviceIds: [...hp.serviceIds, serviceId]),
                (hp) => hp.toJson(),
          );
          await _showMessageDialog(
              'Service assigned to ${hp.name} successfully!');
        }
      }
    } catch (e) {
      await _showMessageDialog('Error assigning service: ${e.toString()}');
    }
  }

  Future<void> _addNotification() async {
    final id = await _showInputDialog('Notification ID');
    if (id == null || id.isEmpty) return;

    final userId = await _showInputDialog('User ID (patient or HP ID)');
    if (userId == null || userId.isEmpty) return;

    final title = await _showInputDialog('Title');
    if (title == null || title.isEmpty) return;

    final body = await _showInputDialog('Body');
    if (body == null || body.isEmpty) return;

    final type = await _selectNotificationTypeDialog();
    if (type == null) return;

    try {
      final notification = MyNotification.Notification(
        id: id,
        userId: userId,
        title: title,
        body: body,
        type: type,
        payload: {'test': 'value'},
      );

      await _notificationService.addNotification(notification);
      await _showMessageDialog('✅ Notification added successfully!');
    } catch (e) {
      await _showMessageDialog('Error: ${e.toString()}');
    }
  }

  Future<void> _testPatientFunctions() async {
    final patientId = await _showInputDialog('Enter Patient ID to test');
    if (patientId == null || patientId.isEmpty) return;

    try {
      final patient = await _patientService.get(patientId);
      if (patient == null) {
        await _showMessageDialog('Patient not found');
        return;
      }

      final choice = await showDialog<int>(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text('Test Patient Functions'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text('1. View Patient Details'),
                    onTap: () => Navigator.pop(context, 1),
                  ),
                  ListTile(
                    title: Text('2. View Medical Records'),
                    onTap: () => Navigator.pop(context, 2),
                  ),
                  ListTile(
                    title: Text('3. View Appointments'),
                    onTap: () => Navigator.pop(context, 3),
                  ),
                  ListTile(
                    title: Text('4. Cancel'),
                    onTap: () => Navigator.pop(context, 4),
                  ),
                ],
              ),
            ),
      );

      switch (choice) {
        case 1:
          await _showMessageDialog('Patient Details:\n\n${patient.toString()}');
          break;
        case 2:
          await _showMessageDialog(
              'Medical Records:\n\n${patient.medicalRecord.length} records');
          break;
        case 3:
          await _showMessageDialog(
              'Appointments:\n\n${patient.appointmentIds.length} appointments');
          break;
      }
    } catch (e) {
      await _showMessageDialog('Error testing patient functions: $e');
    }
  }

  Future<void> _testNotificationFunctions() async {
    final userId = await _showInputDialog(
        'Enter User ID (patient or HP) to test');
    if (userId == null || userId.isEmpty) return;

    try {
      final choice = await showDialog<int>(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text('Test Notification Functions'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text('1. Create Test Notification'),
                    onTap: () => Navigator.pop(context, 1),
                  ),
                  ListTile(
                    title: Text('2. View Current Notifications (Once)'),
                    onTap: () => Navigator.pop(context, 2),
                  ),
                  ListTile(
                    title: Text('3. View Realtime Notifications (Stream)'),
                    onTap: () => Navigator.pop(context, 3),
                  ),
                  ListTile(
                    title: Text('4. Mark All as Read'),
                    onTap: () => Navigator.pop(context, 4),
                  ),
                  ListTile(
                    title: Text('5. Cancel'),
                    onTap: () => Navigator.pop(context, 5),
                  ),
                ],
              ),
            ),
      );

      switch (choice) {
        case 1:
          await _createTestNotification(userId);
          break;
        case 2:
          await _viewCurrentNotifications(userId);
          break;
        case 3:
          await _viewRealtimeNotifications(userId);
          break;
        case 4:
          await _notificationService.markAllAsRead(userId);
          await _showMessageDialog('All notifications marked as read');
          break;
      }
    } catch (e) {
      await _showMessageDialog('Error testing notifications: $e');
    }
  }

  Future<void> _createTestNotification(String userId) async {
    final testNotif = MyNotification.Notification(
      id: 'test_${DateTime
          .now()
          .millisecondsSinceEpoch}',
      userId: userId,
      title: 'Test Notification',
      body: 'This is a test notification',
      type: MyNotification.NotificationType.systemAlert,
    );
    await _notificationService.addNotification(testNotif);
    await _showMessageDialog('Test notification created!');
  }

  Future<void> _viewCurrentNotifications(String userId) async {
    try {
      // Get the first snapshot from the stream (one-time read)
      final notifications = await _notificationService
          .streamUserNotifications(userId)
          .first;

      String notifInfo = notifications.isEmpty
          ? 'No notifications found'
          : notifications.map((n) =>
      'ID: ${n.id}\n'
          'Title: ${n.title}\n'
          'Body: ${n.body}\n'
          'Type: ${n.type}\n'
          'Read: ${n.isRead}\n'
          'Created: ${n.createdAt}'
      ).join('\n\n');

      await _showMessageDialog('Current Notifications:\n\n$notifInfo');
    } catch (e) {
      await _showMessageDialog('Error fetching notifications: $e');
    }
  }

  Future<void> _viewRealtimeNotifications(String userId) async {
    // Create a subscription to the stream
    final StreamSubscription<List<MyNotification.Notification>> subscription =
    _notificationService.streamUserNotifications(userId).listen(
          (notifications) async {
        String notifInfo = notifications.isEmpty
            ? 'No notifications found'
            : notifications.map((n) =>
        'ID: ${n.id}\n'
            'Title: ${n.title}\n'
            'Body: ${n.body}\n'
            'Type: ${n.type}\n'
            'Read: ${n.isRead}\n'
            'Created: ${n.createdAt}'
        ).join('\n\n');

        // Use a new dialog for each update
        await _showMessageDialog('Realtime Notifications:\n\n$notifInfo');
      },
      onError: (e) => _showMessageDialog('Stream error: $e'),
    );

    // Show a dialog with option to cancel the subscription
    await showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text('Realtime Notifications Active'),
            content: Text('Listening for notification updates...'),
            actions: [
              TextButton(
                onPressed: () {
                  subscription.cancel();
                  Navigator.pop(context);
                },
                child: Text('Stop Listening'),
              ),
            ],
          ),
    );
  }

  Future<void> _testAppointmentFunctions() async {
    final patientId = await _showInputDialog('Enter Patient ID to test');
    if (patientId == null || patientId.isEmpty) return;

    try {
      final choice = await showDialog<int>(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text('Test Appointment Functions'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text('1. Create Test Appointment'),
                    onTap: () => Navigator.pop(context, 1),
                  ),
                  ListTile(
                    title: Text('2. View Appointments by Date'),
                    onTap: () => Navigator.pop(context, 2),
                  ),
                  ListTile(
                    title: Text('3. Cancel'),
                    onTap: () => Navigator.pop(context, 3),
                  ),
                ],
              ),
            ),
      );

      switch (choice) {
        case 1:
          final testAppt = Appointment(
            id: 'test_${DateTime
                .now()
                .millisecondsSinceEpoch}',
            patientId: patientId,
            healthcareProfessionalId: 'test_hp',
            serviceId: 'test_service',
            date: DateTime.now().add(Duration(days: 1)),
            startTime: TimeOfDay(hour: 10, minute: 0),
            endTime: TimeOfDay(hour: 11, minute: 0),
            status: AppointmentStatus.scheduled,
          );
          await _appointmentService.add(data: testAppt);
          await _showMessageDialog('Test appointment created!');
          break;
        case 2:
          final dateStr = await _showInputDialog('Enter date (YYYY-MM-DD)');
          if (dateStr != null && dateStr.isNotEmpty) {
            final date = DateTime.parse(dateStr);
            final appointments = await getPatientAppointmentsForDate(
              patientId: patientId,
              date: date,
            );
            String apptInfo = appointments.isEmpty
                ? 'No appointments found'
                : appointments.map((a) =>
            'ID: ${a.id}\nService: ${a.serviceId}\nHP: ${a
                .healthcareProfessionalId}\nTime: ${a.startTime.format(
                context)}-${a.endTime.format(context)}\nStatus: ${a.status}'
            ).join('\n\n');
            await _showMessageDialog('Appointments:\n\n$apptInfo');
          }
          break;
      }
    } catch (e) {
      await _showMessageDialog('Error testing appointments: $e');
    }
  }

  Future<void> _testEmergencyFunctions() async {
    final patientId = await _showInputDialog('Enter Patient ID to test');
    if (patientId == null || patientId.isEmpty) return;

    try {
      final patient = await _patientService.get(patientId);
      if (patient == null) {
        await _showMessageDialog('Patient not found');
        return;
      }

      final choice = await showDialog<int>(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: Text('Test Emergency Functions'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ListTile(
                    title: Text('1. Call Emergency Contact (${patient
                        .emergencyContactPhone})'),
                    onTap: () => Navigator.pop(context, 1),
                  ),
                  ListTile(
                    title: Text('2. Call Emergency Services (${patient
                        .emergencyServicesPhone})'),
                    onTap: () => Navigator.pop(context, 2),
                  ),
                  ListTile(
                    title: Text('3. Cancel'),
                    onTap: () => Navigator.pop(context, 3),
                  ),
                ],
              ),
            ),
      );

      switch (choice) {
        case 1:
          await callEmergencyContact(patient);
          break;
        case 2:
          await callEmergencyServices(patient);
          break;
      }
    } catch (e) {
      await _showMessageDialog('Error testing emergency functions: $e');
    }
  }

  Future<void> callEmergencyContact(Patient patient) async {
    final url = 'tel:${patient.emergencyContactPhone}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      await _showMessageDialog(
          'Could not launch call to ${patient.emergencyContactPhone}');
    }
  }

  Future<void> callEmergencyServices(Patient patient) async {
    final url = 'tel:${patient.emergencyServicesPhone}';
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      await _showMessageDialog('Could not launch call to emergency services');
    }
  }

  Future<void> _addHealthcareProfessional() async {
    final type = await _selectTypeDialog();
    if (type == null) return;

    final id = await _showInputDialog('ID');
    if (id == null || id.isEmpty) return;

    final name = await _showInputDialog('Name');
    if (name == null || name.isEmpty) return;

    final email = await _showInputDialog('Email');
    if (email == null || email.isEmpty) return;

    final password = await _showInputDialog('Password');
    if (password == null || password.isEmpty) return;

    // Get wilaya with validation
    AlgerianWilayas? wilaya;
    while (wilaya == null) {
      final wilayaStr = await _showInputDialog('Wilaya (e.g., alger, oran)');
      if (wilayaStr == null || wilayaStr.isEmpty) return;
      wilaya = AlgerianWilayas.values.firstWhere(
            (e) => e.name == wilayaStr.toLowerCase(),
        orElse: () => AlgerianWilayas.alger,
      );
    }

    // Get commune if wilaya is Alger
    AlgiersCommunes? commune;
    if (wilaya == AlgerianWilayas.alger) {
      while (commune == null) {
        final communeStr = await _showInputDialog(
            'Commune (e.g., casbah, birMouradRaies)');
        if (communeStr == null || communeStr.isEmpty) return;
        commune = AlgiersCommunes.values.firstWhere(
              (e) => e.name == communeStr.toLowerCase(),
          orElse: () => AlgiersCommunes.husseinDey,
        );
      }
    }

    final address = await _showInputDialog('Exact Address');
    if (address == null || address.isEmpty) return;

    final gender = await _selectGenderDialog();
    if (gender == null) return;

    Specialty? specialty;
    List<Specialty>? availableSpecialties;
    List<String>? staffIds;

    if (type == HealthcareType.medecin || type == HealthcareType.dentiste) {
      specialty = await _selectSpecialtyDialog();
      if (specialty == null) return;
    } else if (type == HealthcareType.clinique) {
      availableSpecialties = await _selectMultipleSpecialtiesDialog();
      if (availableSpecialties == null || availableSpecialties.isEmpty) return;

      final staffInput = await _showInputDialog(
          'Enter doctor IDs (comma separated)');
      if (staffInput == null || staffInput.isEmpty) return;
      staffIds = staffInput.split(',').map((id) => id.trim()).toList();
    }

    final location = '${wilaya.name}, ${commune?.name ?? ''}, $address';

    try {
      // Create User document
      final user = User(
        id: id,
        name: name,
        email: email,
        password: password,
        location: location,
        role: Role.healthcareProfessional,
      );
      await _userService.add(data: user, id: user.id, randomizeId: false);

      // Create HealthcareProfessional document
      final hp = HealthcareProfessional(
        id: id,
        name: name,
        email: email,
        password: password,
        location: location,
        wilaya: wilaya,
        commune: commune,
        exactAddress: address,
        type: type,
        gender: gender,
        specialty: specialty,
        availableSpecialties: availableSpecialties ?? [],
        serviceIds: [],
        weeklyAvailability: [],
        ratingIds: [],
        commentIds: [],
        appointmentIds: [],
        staffIds: staffIds,
        notificationIds: [],
        rating: 0.0,
        licenseNumber: '',
      );

      await _hpService.add(data: hp, id: hp.id, randomizeId: false);
      await _showMessageDialog('✅ ${hp.typeDisplay} added successfully!');
    } catch (e) {
      await _showMessageDialog('Error: ${e.toString()}');
    }
  }

  Future<Gender?> _selectGenderDialog() async {
    return await showDialog<Gender>(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text('Select Gender'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: Gender.values.map((gender) {
                return ListTile(
                  title: Text(gender.name),
                  onTap: () => Navigator.pop(context, gender),
                );
              }).toList(),
            ),
          ),
    );
  }


  Future<
      MyNotification.NotificationType?> _selectNotificationTypeDialog() async {
    return await showDialog<MyNotification.NotificationType>(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text('Select Notification Type'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: MyNotification.NotificationType.values.map((type) {
                return ListTile(
                  title: Text(type
                      .toString()
                      .split('.')
                      .last),
                  onTap: () => Navigator.pop(context, type),
                );
              }).toList(),
            ),
          ),
    );
  }

  Future<HealthcareType?> _selectTypeDialog() async {
    return await showDialog<HealthcareType>(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text('Select Professional Type'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: HealthcareType.values.map((type) {
                return ListTile(
                  title: Text(
                      HealthcareProfessional.typeDisplayMap[type] ?? type.name),
                  onTap: () => Navigator.pop(context, type),
                );
              }).toList(),
            ),
          ),
    );
  }

  Future<Specialty?> _selectSpecialtyDialog() async {
    return await showDialog<Specialty>(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text('Select Specialty'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: Specialty.values.map((specialty) {
                return ListTile(
                  title: Text(specialty.displayName),
                  onTap: () => Navigator.pop(context, specialty),
                );
              }).toList(),
            ),
          ),
    );
  }

  Future<List<Specialty>?> _selectMultipleSpecialtiesDialog() async {
    final selected = <Specialty>[];
    bool isDone = false;

    await showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text('Select Clinic Specialties'),
            content: StatefulBuilder(
              builder: (context, setState) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ...Specialty.values.map((specialty) {
                        return CheckboxListTile(
                          title: Text(specialty.displayName),
                          value: selected.contains(specialty),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                selected.add(specialty);
                              } else {
                                selected.remove(specialty);
                              }
                            });
                          },
                        );
                      }).toList(),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        onPressed: () {
                          isDone = true;
                          Navigator.pop(context);
                        },
                        child: Text('Done'),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
    );

    return isDone && selected.isNotEmpty ? selected : null;
  }

  Future<HealthcareType?> _selectHealthcareTypeDialog() async {
    final options = [
      HealthcareType.medecin,
      HealthcareType.dentiste,
      HealthcareType.clinique,
      HealthcareType.centre_imagerie,
      HealthcareType.laboratoire_analyse,
    ];

    return await showDialog<HealthcareType>(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text('Service For'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: options
                  .asMap()
                  .entries
                  .map((entry) {
                final index = entry.key + 1;
                final type = entry.value;
                return ListTile(
                  title: Text(
                      '$index. ${HealthcareProfessional.typeDisplayMap[type]}'),
                  onTap: () => Navigator.pop(context, type),
                );
              }).toList(),
            ),
          ),
    );
  }

  Future<List<Appointment>> getPatientAppointmentsForDate({
    required String patientId,
    required DateTime date,
  }) async {
    try {
      final allAppointments = await _appointmentService.getAll();
      return allAppointments.where((appt) {
        return appt.patientId == patientId &&
            appt.date.year == date.year &&
            appt.date.month == date.month &&
            appt.date.day == date.day;
      }).toList();
    } catch (e) {
      return [];
    }
  }


// Add to your DBBuilder class in db_init.dart

  Future<void> _testHealthcareProfessionalFunctions() async {
    final choice = await showDialog<int>(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text('Healthcare Professional Tests'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  title: Text('1. Add Test Professionals'),
                  onTap: () => Navigator.pop(context, 1),
                ),
                ListTile(
                  title: Text('2. Search Professionals'),
                  onTap: () => Navigator.pop(context, 2),
                ),
              ],
            ),
          ),
    );

    switch (choice) {
      case 1:
        await _addTestHealthcareProfessionals();
        break;
      case 2:
        await _searchHealthcareProfessionals();
        break;
    }
  }

  Future<void> _addTestHealthcareProfessionals() async {
    try {
      final testHps = [
        // General Practitioner in Alger
        HealthcareProfessional(
          id: 'test_gp1',
          name: 'Dr. Ahmed Benali',
          email: 'dr.benali@example.com',
          password: 'test123',
          location: 'Alger, Hydra, 12 Rue des Frères Oughlis',
          wilaya: AlgerianWilayas.alger,
          commune: AlgiersCommunes.darElBeida,
          exactAddress: '12 Rue des Frères Oughlis',
          type: HealthcareType.medecin,
          gender: Gender.male,
          specialty: Specialty.generaliste,
          rating: 4.5,
          commentIds: ['comment1', 'comment2'],
          licenseNumber: '987654321',
        ),

        // Cardiologist in Oran
        HealthcareProfessional(
          id: 'test_cardio1',
          name: 'Dr. Leila Mansouri',
          email: 'dr.mansouri@example.com',
          password: 'test123',
          location: 'Oran, Boulevard de la Soummam',
          wilaya: AlgerianWilayas.oran,
          exactAddress: '45 Boulevard de la Soummam',
          type: HealthcareType.medecin,
          gender: Gender.female,
          specialty: Specialty.cardio,
          rating: 4.8,
          commentIds: ['comment3', 'comment4'],
          licenseNumber: '123456789',
        ),

        // Dentist in Constantine
        HealthcareProfessional(
          id: 'test_dent1',
          name: 'Dr. Samir Dentaire',
          email: 'dr.dentaire@example.com',
          password: 'test123',
          location: 'Constantine, Rue Abane Ramdane',
          wilaya: AlgerianWilayas.constantine,
          exactAddress: '8 Rue Abane Ramdane',
          type: HealthcareType.dentiste,
          gender: Gender.male,
          specialty: Specialty.orl,
          rating: 4.2,
          commentIds: ['comment5'],
          licenseNumber: '123456789',
        ),

        // Clinic in Alger
        HealthcareProfessional(
          id: 'test_clinic1',
          name: 'Clinique El Mountazah',
          email: 'contact@mountazah.dz',
          password: 'test123',
          location: 'Alger, El Biar, Rue Mohamed Belouizdad',
          wilaya: AlgerianWilayas.alger,
          commune: AlgiersCommunes.babEzzouar,
          exactAddress: '10 Rue Mohamed Belouizdad',
          type: HealthcareType.clinique,
          gender: Gender.male,
          availableSpecialties: [Specialty.cardio, Specialty.dermato],
          staffIds: ['test_gp1', 'test_cardio1'],
          rating: 4.7,
          commentIds: ['comment6', 'comment7'],
          licenseNumber: '987654321',
        ),

        // Pharmacy in Blida
        HealthcareProfessional(
          id: 'test_pharma1',
          name: 'Pharmacie Es Salam',
          email: 'pharma.salam@example.com',
          password: 'test123',
          location: 'Blida, Rue des Martyrs',
          wilaya: AlgerianWilayas.blida,
          exactAddress: '22 Rue des Martyrs',
          type: HealthcareType.pharmacie,
          gender: Gender.female,
          rating: 4.3,
          commentIds: ['comment8'],
          licenseNumber: '1122334455',
        ),
      ];

      int createdCount = 0;
      for (final hp in testHps) {
        try {
          // Check if already exists
          final existing = await _hpService.get(hp.id);
          if (existing != null) continue;

          // Create user first
          await _userService.add(
            data: User(
              id: hp.id,
              name: hp.name,
              email: hp.email,
              password: hp.password,
              location: hp.location,
              role: Role.healthcareProfessional,
            ),
            id: hp.id,
            randomizeId: false,
          );

          // Then create healthcare professional
          await _hpService.add(
            data: hp,
            id: hp.id,
            randomizeId: false,
          );
          createdCount++;
        } catch (e) {
          debugPrint('Error creating test HP ${hp.id}: $e');
        }
      }

      await _showMessageDialog(
          'Added $createdCount test professionals\n'
              'Skipped ${testHps.length - createdCount} existing ones'
      );
    } catch (e) {
      await _showMessageDialog('Error creating test professionals: $e');
    }
  }

  Future<void>  _searchHealthcareProfessionals() async {
    try {
      final choice = await showDialog<int>(
        context: context,
        builder: (context) =>
            AlertDialog(
              title: const Text('Healthcare Professional Search Tests'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: const Text('1. Search by Name'),
                      onTap: () => Navigator.pop(context, 1),
                    ),
                    ListTile(
                      title: const Text('2. Search by Specialty'),
                      onTap: () => Navigator.pop(context, 2),
                    ),
                    ListTile(
                      title: const Text('3. Search by Location'),
                      onTap: () => Navigator.pop(context, 3),
                    ),
                    ListTile(
                      title: const Text(
                          '4. Combined Search (Name + Specialty)'),
                      onTap: () => Navigator.pop(context, 4),
                    ),
                  ],
                ),
              ),
            ),
      );

      if (choice == null) return;

      final hpService = HealthcareProfessionalService();
      List<HealthcareProfessional> results = [];
      String testName = '';

      switch (choice) {
       /* case 1: // Search by Name
          testName = 'Name Search';
          final nameQuery = await _showInputDialog(
              'Enter name to search (e.g., "Dr. Ahmed")');
          if (nameQuery == null || nameQuery.isEmpty) return;

          results = await hpService.searchWithFilters(nameQuery: nameQuery);
          break;*/

        case 2: // Search by Specialty
          testName = 'Specialty Search';
          final specialty = await _selectSpecialtyDialog();
          if (specialty == null) return;

          results = await hpService.searchWithFilters(specialty: specialty);
          break;

        case 3: // Search by Location
          testName = 'Location Search';
          final wilaya = await _selectWilayaDialog();
          if (wilaya == null) return;

          AlgiersCommunes? commune;
          if (wilaya == AlgerianWilayas.alger) {
            commune = await _selectCommuneDialog();
          }

          results = await hpService.searchWithFilters(wilaya: wilaya, commune: commune);
          break;

        /*case 4: // Combined Search
          testName = 'Combined Search';
          final nameQuery = await _showInputDialog(
              'Enter name (leave empty to skip)');
          final specialty = await _selectSpecialtyDialog();
          if (nameQuery == null && specialty == null) {
            await _showMessageDialog(
                'Please provide at least one search criteria');
            return;
          }

          results = await hpService.searchWithFilters(
            nameQuery: nameQuery,
            specialty: specialty,
          );
          break;*/
      }

      // Display results
      if (results.isEmpty) {
        await _showMessageDialog('$testName\n\nNo results found');
        return;
      }

      final resultText = StringBuffer(
          '$testName Results (${results.length} found):\n\n');
      for (final hp in results.take(5)) { // Limit to 5 for display
        resultText.writeln('• ${hp.name} (${hp.typeDisplay})');
        resultText.writeln('  Specialty: ${hp.specialty?.displayName ??
            hp.availableSpecialties.map((s) => s.displayName).join(", ")}');
        resultText.writeln(
            '  Location: ${hp.wilaya.name}${hp.commune != null ? ', ${hp
                .commune!.name}' : ''}');
        resultText.writeln(
            '  Rating: ${hp.rating} (${hp.commentIds.length} reviews)');
        resultText.writeln();
      }

      if (results.length > 5) {
        resultText.writeln('...and ${results.length - 5} more');
      }

      await _showMessageDialog(resultText.toString());
    } catch (e, stack) {
      debugPrint('Search test error: $e\n$stack');
      await _showMessageDialog('Error during search test: ${e.toString()}');
    }
  }

// Add these helper methods if not already present
  Future<AlgerianWilayas?> _selectWilayaDialog() async {
    return await showDialog<AlgerianWilayas>(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: const Text('Select Wilaya'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: AlgerianWilayas.values.length,
                itemBuilder: (context, index) {
                  final wilaya = AlgerianWilayas.values[index];
                  return ListTile(
                    title: Text(wilaya.name),
                    onTap: () => Navigator.pop(context, wilaya),
                  );
                },
              ),
            ),
          ),
    );
  }

  Future<AlgiersCommunes?> _selectCommuneDialog() async {
    return await showDialog<AlgiersCommunes>(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: const Text('Select Commune'),
            content: SizedBox(
              width: double.maxFinite,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: AlgiersCommunes.values.length,
                itemBuilder: (context, index) {
                  final commune = AlgiersCommunes.values[index];
                  return ListTile(
                    title: Text(commune.name),
                    onTap: () => Navigator.pop(context, commune),
                  );
                },
              ),
            ),
          ),
    );
  }

}
