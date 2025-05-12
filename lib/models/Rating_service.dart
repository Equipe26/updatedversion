import 'package:cloud_firestore/cloud_firestore.dart';

class RatingService {
  // Pour Firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> submitRating({
    required String professionalId,
    required String patientId,
    required double rating,
  }) async {
    try {
      await _firestore.collection('ratings').add({
        'professionalId': professionalId,
        'patientId': patientId,
        'rating': rating,
        'timestamp': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error submitting rating: $e');
      throw Exception('Failed to submit rating');
    }
  }

  Future<double> getAverageRating(String professionalId) async {
    try {
      final snapshot = await _firestore
          .collection('ratings')
          .where('professionalId', isEqualTo: professionalId)
          .get();

      if (snapshot.docs.isEmpty) return 0.0;

      final total = snapshot.docs.fold(0.0, (sum, doc) => sum + doc['rating']);
      return total / snapshot.docs.length;
    } catch (e) {
      print('Error getting average rating: $e');
      return 0.0;
    }
  }
}