import 'package:cloud_firestore/cloud_firestore.dart';
import 'Comment.dart';

class CommentService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<Comment>> getCommentsForProfessional(String professionalId) async {
    try {
      final querySnapshot = await _firestore
          .collection('comments')
          .where('healthcareProfessionalId', isEqualTo: professionalId)
          .orderBy('date', descending: true)
          .get();

      return querySnapshot.docs.map((doc) {
        return Comment(
          patientName: doc['patientName'],
          id: doc.id,
          patientId: doc['patientId'],
          healthcareProfessionalId: doc['healthcareProfessionalId'],
          comment: doc['comment'],
          date: (doc['date'] as Timestamp).toDate(),
        );
      }).toList();
    } catch (e) {
      print('Error getting comments: $e');
      throw Exception('Failed to load comments');
    }
  }

// Update your CommentService to match the fields you're using
Future<void> addComment(Comment comment) async {
  try {
    await _firestore.collection('comments').add({
      'patientId': comment.patientId,
      'patientName': comment.patientName, // Add this
      'healthcareProfessionalId': comment.healthcareProfessionalId,
      'comment': comment.comment,
      'date': Timestamp.fromDate(comment.date),
    });
  } catch (e) {
    print('Error adding comment: $e');
    throw Exception('Failed to add comment');
  }
}
  Future<int?> getCommentCount(String professionalId) async {
    try {
      final querySnapshot = await _firestore
          .collection('comments')
          .where('healthcareProfessionalId', isEqualTo: professionalId)
          .count()
          .get();

      return querySnapshot.count;
    } catch (e) {
      print('Error getting comment count: $e');
      return 0;
    }
  }
}