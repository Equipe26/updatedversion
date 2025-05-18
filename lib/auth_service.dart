import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

// Import models
import '../models/User.dart';
import '../models/Patient.dart';
import '../models/HealthcareProfessional.dart';
import '../models/WeeklyAvailability.dart';
import '../models/Specialty.dart';
import '../models/Map.dart';

/// sign-up for both healthcare professionals and patients, login, and logout.
class AuthService {
  // Firebase instances
  final firebase_auth.FirebaseAuth _firebaseAuth =
      firebase_auth.FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Current authenticated user
  User? _currentUser;

  // User getter
  User? get currentUser => _currentUser;

  // Stream controller for auth state changes
  final StreamController<User?> _userStreamController =
      StreamController<User?>.broadcast();
  Stream<User?> get userStream => _userStreamController.stream;

  // Email verification bypass
  bool _debugSkipEmailVerification = false;


  bool get debugSkipEmailVerification => _debugSkipEmailVerification;
  set debugSkipEmailVerification(bool value) => _debugSkipEmailVerification = value;

  // Password validation checker
  bool isPasswordValid(String password) {
    // Check if password is at least 8 characters long and has at least one uppercase letter
    final RegExp passwordRegex = RegExp(r'^(?=.*[A-Z]).{8,}$');
    return passwordRegex.hasMatch(password);
  }

  // Constructor
  AuthService() {
    // Listen to Firebase auth changes and update our stream
    _firebaseAuth
        .authStateChanges()
        .listen((firebase_auth.User? firebaseUser) async {
      if (firebaseUser != null) {
        // Fetch user data from Firestore
        try {
          DocumentSnapshot userDoc =
              await _firestore.collection('users').doc(firebaseUser.uid).get();

          if (userDoc.exists) {
            Map<String, dynamic> userData =
                userDoc.data() as Map<String, dynamic>;

            // Determine user type and create appropriate object
            if (userData['role'] == 'hp') {
              _currentUser = HealthcareProfessional.fromJson(userData);
            } else if (userData['role'] == 'patient') {
              _currentUser = Patient.fromJson(userData);
            } else {
              _currentUser = User.fromJson(userData);
            }

            _userStreamController.add(_currentUser);
          }
        } catch (e) {
          print('Error fetching user data: $e');
          _userStreamController.add(null);
        }
      } else {
        _currentUser = null;
        _userStreamController.add(null);
      }
    });
  }

  /// Send email verification to the current user
  Future<void> sendEmailVerification() async {
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser != null && !firebaseUser.emailVerified) {
      await firebaseUser.sendEmailVerification();
    } else {
      throw Exception('No user to verify or user already verified');
    }
  }
  
  /// Check if the current user's email is verified
  Future<bool> isEmailVerified() async {
    // Skip verification check if debug mode is enabled
    if (_debugSkipEmailVerification) {
      return true;
    }
    
    final firebaseUser = _firebaseAuth.currentUser;
    if (firebaseUser != null) {
      await firebaseUser.reload();
      return firebaseUser.emailVerified;
    }
    return false;
  }
  
  /// Sign up a new healthcare professional
  ///
  /// Returns the created HealthcareProfessional object on success
  Future<HealthcareProfessional> signUpAsHealthcareProfessional({
    required String email,
    required String password,
    required String name,
    required AlgerianWilayas wilaya,
    required AlgiersCommunes commune,
    required String exactAddress,
    required HealthcareType type,
    required Gender gender,
    Specialty? specialty,
    List<Specialty> availableSpecialties = const [],
    required List<WeeklyAvailability> weeklyAvailability,
    String? licenseNumber,
    List<String> serviceIds = const [],
    List<String> staffIds = const [], // NEW ARGUMENT
  }) async {
    try {
      // Validate password
      if (!isPasswordValid(password)) {
        throw Exception('Le mot de passe doit contenir au moins 8 caractères et au moins une lettre majuscule.');
      }
      
      // Create Firebase Auth user
      final firebase_auth.UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final String uid = userCredential.user!.uid;
      
      // Send email verification
      await userCredential.user!.sendEmailVerification();

      // Create Healthcare Professional object
      final HealthcareProfessional hp = HealthcareProfessional(
        id: uid,
        name: name,
        email: email,
        password: password, // Don't store actual password in Firestore
        wilaya: wilaya,
        commune: commune,
        exactAddress: exactAddress,
        type: type,
         gender: gender,
        specialty: specialty,
        availableSpecialties: availableSpecialties,
        serviceIds: serviceIds,
        weeklyAvailability: weeklyAvailability,
        ratingIds: [],
        commentIds: [],
        appointmentIds: [],
        staffIds: type == HealthcareType.clinique ? staffIds : null,
        licenseNumber: licenseNumber ?? '',
        location: '$wilaya, $commune, $exactAddress',
      );

      // Save to Firestore
      await _firestore.collection('users').doc(uid).set(hp.toJson());
      // Save to hp collection
      await _firestore.collection('healthcareProfessional').doc(uid).set(hp.toJson());

      _currentUser = hp;
      _userStreamController.add(_currentUser);

      return hp;
    } catch (e) {
      print('Error signing up healthcare professional: $e');
      throw _handleAuthError(e);
    }
  }

  /// Sign up a new patient
  ///
  /// Returns the created Patient object on success
  Future<Patient> signUpAsPatient({
    required String email,
    required String password,
    required String name,
    required String location,
    required String emergencyContactPhone,
  }) async {
    try {
      // Validate password
      if (!isPasswordValid(password)) {
        throw Exception('Le mot de passe doit contenir au moins 8 caractères et au moins une lettre majuscule.');
      }
      
      // Create Firebase Auth user
      final firebase_auth.UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final String uid = userCredential.user!.uid;
      
      // Send email verification
      await userCredential.user!.sendEmailVerification();

      // Create Patient object
      final Patient patient = Patient(
        id: uid,
        name: name,
        email: email,
        password: password, // Don't store actual password in Firestore
        location: location,
        medicalRecord: [],
        appointmentIds: [],
        emergencyContactPhone: emergencyContactPhone,
        emergencyContactName: '',
      
      );

      // Save to Firestore
      await _firestore.collection('users').doc(uid).set(patient.toJson());

      await _firestore.collection('patients').doc(uid).set(patient.toJson());
      // Save to patients collection

      _currentUser = patient;
      _userStreamController.add(_currentUser);

      return patient;
    } catch (e) {
      print('Error signing up patient: $e');
      throw _handleAuthError(e);
    }
  }

  /// Login with email and password
  ///
  /// Returns the User object (which could be a Patient or HealthcareProfessional)
  Future<User> login({
    required String email,
    required String password,
    bool requireVerification = true,
  }) async {
    try {
      // Authenticate with Firebase
      final firebase_auth.UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      
      // Check if email is verified, unless we're in debug mode
      if (requireVerification && !_debugSkipEmailVerification && !userCredential.user!.emailVerified) {
        // Send another verification email if needed
        await userCredential.user!.sendEmailVerification();
        throw Exception('Email not verified. Please check your inbox for a verification link.');
      }

      final String uid = userCredential.user!.uid;

      // Fetch user data from Firestore
      DocumentSnapshot userDoc =
          await _firestore.collection('users').doc(uid).get();

      if (userDoc.exists) {
        Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
        print(userData['role']);
        
        // Create the appropriate user object based on role
        if (userData['role'] == "healthcareProfessional") {
          final hp = HealthcareProfessional.fromJson(userData);
          
          // Check if healthcare professional is validated by admin
         /* if (!hp.isValidatedByAdmin) {
            _currentUser = hp; // Still set as current user so we can navigate to waiting screen
            _userStreamController.add(_currentUser);
            throw Exception('admin_validation_required');
          }*/
          
          _currentUser = hp;
        } else if (userData['role'] == "patient") {
          _currentUser = Patient.fromJson(userData);
        } else {
          _currentUser = User.fromJson(userData);
        }

        _userStreamController.add(_currentUser);
        return _currentUser!;
      } else {
        throw Exception('User not found in database');
      }
    } catch (e) {
      print('Error logging in: $e');
      throw _handleAuthError(e);
    }
  }

  /// Logs out the current user
  Future<void> logout() async {
    try {
      await _firebaseAuth.signOut();
      _currentUser = null;
      _userStreamController.add(null);
    } catch (e) {
      print('Error logging out: $e');
      throw Exception('Failed to log out');
    }
  }

  /// Updates the current user's password.
  /// Requires the user's current password for re-authentication.
  Future<void> updatePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final firebaseUser = _firebaseAuth.currentUser;

    if (firebaseUser == null) {
      throw Exception("User not logged in.");
    }
    
    // Validate new password
    if (!isPasswordValid(newPassword)) {
      throw Exception('Le mot de passe doit contenir au moins 8 caractères et au moins une lettre majuscule.');
    }

    // Create credential for re-authentication
    final cred = firebase_auth.EmailAuthProvider.credential(
      email: firebaseUser.email!, // Assumes user logged in with email
      password: currentPassword,
    );

    try {
      // Re-authenticate the user
      await firebaseUser.reauthenticateWithCredential(cred);

      // If re-authentication is successful, update the password
      await firebaseUser.updatePassword(newPassword);
      print("Password updated successfully.");
    } on firebase_auth.FirebaseAuthException catch (e) {
      print('Error updating password: ${e.code}');
      // Handle specific errors like 'wrong-password', 'weak-password', etc.
      if (e.code == 'wrong-password') {
        throw Exception('Incorrect current password.');
      } else if (e.code == 'weak-password') {
        throw Exception('The new password is too weak.');
      } else {
        throw Exception('Failed to update password: ${e.message}');
      }
    } catch (e) {
      print('An unexpected error occurred during password update: $e');
      throw Exception('An unexpected error occurred.');
    }
  }

  /// Deletes the current user's account.
  /// Requires the user's current password for re-authentication.
  Future<void> deleteUser({
    required String currentPassword,
  }) async {
    final firebaseUser = _firebaseAuth.currentUser;

    if (firebaseUser == null) {
      throw Exception("User not logged in.");
    }

    // Create credential for re-authentication
    final cred = firebase_auth.EmailAuthProvider.credential(
      email: firebaseUser.email!, // Assumes user logged in with email
      password: currentPassword,
    );

    try {
      // Re-authenticate the user
      print("Re-authenticating user for deletion...");
      await firebaseUser.reauthenticateWithCredential(cred);
      print("Re-authentication successful.");

      final String uid = firebaseUser.uid;

      // Delete Firestore document first
      print("Deleting Firestore document for user $uid...");
      await _firestore.collection('users').doc(uid).delete();
      print("Firestore document deleted.");

      // Then delete Firebase Auth user
      print("Deleting Firebase Auth user...");
      await firebaseUser.delete();
      print("Firebase Auth user deleted successfully.");

      // Clear local state
      _currentUser = null;
      _userStreamController.add(null);
      print("User deleted completely.");
    } on firebase_auth.FirebaseAuthException catch (e) {
      print('Error during user deletion (Auth): ${e.code}');
      if (e.code == 'wrong-password') {
        throw Exception('Incorrect current password.');
      } else if (e.code == 'requires-recent-login') {
        throw Exception(
            'Please log out and log back in before deleting your account.');
      } else {
        // Use existing handler for other auth errors
        throw _handleAuthError(e);
      }
    } catch (e) {
      print('An unexpected error occurred during user deletion: $e');
      // Check if it's a Firestore error or something else
      if (e.toString().contains('firestore')) {
        throw Exception('Failed to delete user data. Please try again.');
      }
      throw Exception('An unexpected error occurred during account deletion.');
    }
  }
   Future<User?> updateUserInfo({
   
    String? location,
   
    String? exactAddress,
    String? licenseNumber,
  }) async {
    try {
      final firebaseUser = _firebaseAuth.currentUser;
      if (firebaseUser == null || _currentUser == null) {
        throw Exception('No authenticated user found');
      }
      
      final String uid = firebaseUser.uid;
      Map<String, dynamic> updateData = {};
      
      // Add fields that should be updated
    
      
      // Update specific fields based on user type
      if (_currentUser is Patient) {
        if (location != null) updateData['location'] = location;
        
        // Update the current user object
        _currentUser = (_currentUser as Patient).copyWith(
          
          location: location,
         
        );
        
        // Update in Firestore
        await _firestore.collection('users').doc(uid).update(updateData);
        await _firestore.collection('patients').doc(uid).update(updateData);
      } 
      else if (_currentUser is HealthcareProfessional) {
        if (exactAddress != null) {
          updateData['exactAddress'] = exactAddress;
          
          // Update the location string
          final hp = _currentUser as HealthcareProfessional;
          updateData['location'] = '${hp.wilaya}, ${hp.commune}, $exactAddress';
        }
        
        if (licenseNumber != null) updateData['licenseNumber'] = licenseNumber;
        
        // Update the current user object
        _currentUser = (_currentUser as HealthcareProfessional).copyWith(
          
          exactAddress: exactAddress,
          licenseNumber: licenseNumber,
         
          location: exactAddress != null 
              ? '${(_currentUser as HealthcareProfessional).wilaya}, ${(_currentUser as HealthcareProfessional).commune}, $exactAddress' 
              : null,
        );
        
        // Update in Firestore
        await _firestore.collection('users').doc(uid).update(updateData);
        await _firestore.collection('healthcareProfessional').doc(uid).update(updateData);
      }
      
      // Notify listeners about the update
      _userStreamController.add(_currentUser);
      return _currentUser;
    } catch (e) {
      print('Error updating user information: $e');
      throw Exception('Failed to update user information: $e');
    }
  }

  /// Get current user data from Firestore
  Future<User?> getCurrentUserData() async {
    final firebaseUser = _firebaseAuth.currentUser;
    
    if (firebaseUser == null) {
      return null;
    }
    
    try {
      DocumentSnapshot userDoc = await _firestore.collection('users').doc(firebaseUser.uid).get();
      
      if (!userDoc.exists) {
        return null;
      }
      
      Map<String, dynamic> userData = userDoc.data() as Map<String, dynamic>;
      
      if (userData['role'] == 'hp') {
        return HealthcareProfessional.fromJson(userData);
      } else if (userData['role'] == 'patient') {
        return Patient.fromJson(userData);
      } else {
        return User.fromJson(userData);
      }
    } catch (e) {
      print('Error getting current user data: $e');
      throw Exception('Error retrieving user data');
    }
  }

  /// Sends a password reset email to the specified email address
  ///
  /// Returns true if the reset email was sent successfully
  Future<bool> sendPasswordResetEmail({required String email}) async {
    try {
      // Make sure email is valid
      if (email.isEmpty || !email.contains('@')) {
        throw Exception('Veuillez fournir une adresse email valide.');
      }
      
      // Send reset email
      await _firebaseAuth.sendPasswordResetEmail(email: email);
      print('Password reset email sent to $email');
      return true;
    } on firebase_auth.FirebaseAuthException catch (e) {
      print('Error sending password reset email: ${e.code}');
      if (e.code == 'user-not-found') {
        throw Exception('Aucun utilisateur trouvé avec cette adresse email.');
      } else {
        throw Exception('Erreur lors de l\'envoi de l\'email de réinitialisation: ${e.message}');
      }
    } catch (e) {
      print('An unexpected error occurred: $e');
      throw Exception('Une erreur inattendue s\'est produite.');
    }
  }

  /// Error handling helper for Firebase Auth errors
  Exception _handleAuthError(dynamic error) {
    String message = 'An unexpected error occurred';

    if (error is firebase_auth.FirebaseAuthException) {
      switch (error.code) {
        case 'email-already-in-use':
          message = 'Email already in use';
          break;
        case 'invalid-email':
          message = 'Invalid email address';
          break;
        case 'user-disabled':
          message = 'User has been disabled';
          break;
        case 'user-not-found':
          message = 'User not found';
          break;
        case 'wrong-password':
          message = 'Incorrect password';
          break;
        case 'weak-password':
          message = 'Password is too weak';
          break;
        case 'operation-not-allowed':
          message = 'Operation not allowed';
          break;
        case 'too-many-requests':
          message = 'Too many requests. Try again later';
          break;
        default:
          message = 'Authentication error: ${error.code}';
          break;
      }
    }

    return Exception(message);
  }

  /// Dispose method to close streams when service is no longer needed
  void dispose() {
    _userStreamController.close();
  }
}
