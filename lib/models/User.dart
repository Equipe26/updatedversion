import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

enum Role {
  patient,
  healthcareProfessional,
}

class User {
  final String id;
  final String name;
  final String email;
  final String? password; // Mark as nullable if optional
  final String? location; // Mark as nullable if optional
  final Role role;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.password,
    required this.location,
    required this.role,
  });

  // Named constructor for single document
  factory User.fromFirestore(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data() ?? {}; // Handle null document data
    return User(
      id: doc.id,
      name: data['name'],
      email: data['email'],
      password: data['password'],
      location: data['location'],
      role: Role.values.firstWhere(
        (e) => e.name == data['role'],
        orElse: () => Role.patient,
      ),
    );
  }

  // Static method for query snapshot (multiple documents)
  static Future<List<User>> fromQuerySnapshot(QuerySnapshot<Map<String, dynamic>> snapshot) async {
    try {
      return snapshot.docs.map((doc) {
        final data = doc.data();
        return User(
          id: doc.id,
          name: data['name'],
          email: data['email'],
          password: data['password'],
          location: data['location'],
          role: Role.values.firstWhere(
            (e) => e.name == data['role'],
            orElse: () => Role.patient,
          ),
        );
      }).toList();
    } catch (e) {
      debugPrint('Error converting firestore data to User: $e');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'password': password,
      'location': location,
      'role': role.name,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      password: json['password'],
      location: json['location'],
      role: Role.values.firstWhere(
        (e) => e.name == json['role'],
        orElse: () => Role.patient,
      ),
    );
  }

  get profileImageUrl => null;

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? password,
    String? location,
    Role? role,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      password: password ?? this.password,
      location: location ?? this.location,
      role: role ?? this.role,
    );
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, password: ****, '
        'location: $location, role: ${role.name})';
  }
}