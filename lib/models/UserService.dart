import 'package:cloud_firestore/cloud_firestore.dart';
import 'User.dart';

class UserService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<User>> getAllUsers() async {
    try {
      final snapshot = await _firestore.collection('users').get();
      if (snapshot.docs.isEmpty) {
        throw Exception('No users found in database');
      }
      return snapshot.docs.map((doc) => User.fromFirestore(doc)).toList();
    } catch (e) {
      throw Exception('Failed to fetch users: ${e.toString()}');
    }
  }
}