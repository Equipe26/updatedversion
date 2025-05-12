import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/HealthcareProfessional.dart';
import '../models/Patient.dart';
import '../models/Comment.dart';
import '../models/Rating.dart';
import '../database_service.dart';

class CommentRatingService {
  final FirestoreService<HealthcareProfessional> _healthcareProfessionalService;
  final FirestoreService<Patient> _patientService;
  final FirestoreService<Comment> _commentService;
  final FirestoreService<Rating> _ratingService;

  CommentRatingService()
      : _healthcareProfessionalService = FirestoreService<HealthcareProfessional>(
    collectionPath: 'healthcareProfessional',
    fromJson: HealthcareProfessional.fromJson,
    toJson: (professional) => professional.toJson(),
  ),
        _patientService = FirestoreService<Patient>(
          collectionPath: 'patients',
          fromJson: Patient.fromJson,
          toJson: (patient) => patient.toJson(),
        ),
        _commentService = FirestoreService<Comment>(
          collectionPath: 'comments',
          fromJson: Comment.fromJson,
          toJson: (comment) => comment.toJson(),
        ),
        _ratingService = FirestoreService<Rating>(
          collectionPath: 'ratings',
          fromJson: Rating.fromJson,
          toJson: (rating) => rating.toJson(),
        );

  /// Adds a comment by a patient for a healthcare professional.
  Future<String> addComment({
    required String patientId,
    required String healthcareProfessionalId,
    required String commentText,
  }) async {
    try {
      // Validate inputs
      if (commentText.trim().isEmpty) {
        throw ArgumentError('Comment cannot be empty');
      }

      // Verify patient and professional exist
      final patient = await _patientService.get(patientId);
      final professional = await _healthcareProfessionalService.get(healthcareProfessionalId);
      if (patient == null || professional == null) {
        throw Exception('Patient or Healthcare Professional not found');
      }

      // Create a new Comment
      final newComment = Comment(
        patientName: patient.name,
        id: '', // ID will be set by Firestore
        patientId: patientId,
        healthcareProfessionalId: healthcareProfessionalId,
        comment: commentText,
        date: DateTime.now(),
      );

      // Add to Firestore and get the generated ID
      final commentId = await _commentService.add(data: newComment);

      // Update HealthcareProfessional's commentIds
      final updatedProfessional = professional.copyWith(
        commentIds: [...professional.commentIds, commentId],
      );
      await _healthcareProfessionalService.update(
        healthcareProfessionalId,
        updatedProfessional,
            (p) => p.toJson(),
      );

      return commentId;
    } catch (e) {
      throw Exception('Failed to add comment: $e');
    }
  }

  /// Deletes a comment and removes its ID from the healthcare professional's commentIds.
  Future<void> deleteComment({
    required String commentId,
    required String patientId,
    required String healthcareProfessionalId,
  }) async {
    try {
      // Fetch the comment
      final comment = await _commentService.get(commentId);
      if (comment == null) {
        throw Exception('Comment not found');
      }

      // Verify ownership
      if (comment.patientId != patientId) {
        throw Exception('Unauthorized: You can only delete your own comments');
      }

      // Delete the comment
      await _commentService.delete(commentId);

      // Update HealthcareProfessional's commentIds
      final professional = await _healthcareProfessionalService.get(healthcareProfessionalId);
      if (professional == null) {
        throw Exception('Healthcare Professional not found');
      }
      final updatedCommentIds = professional.commentIds
          .where((id) => id != commentId)
          .toList();
      final updatedProfessional = professional.copyWith(
        commentIds: updatedCommentIds,
      );
      await _healthcareProfessionalService.update(
        healthcareProfessionalId,
        updatedProfessional,
            (p) => p.toJson(),
      );
    } catch (e) {
      throw Exception('Failed to delete comment: $e');
    }
  }

  /// Adds a rating by a patient for a healthcare professional.
  Future<String> addRating({
    required String patientId,
    required String healthcareProfessionalId,
    required double ratingValue,
    String? comment,
  }) async {
    try {
      // Validate rating
      if (ratingValue < 0 || ratingValue > 5) {
        throw ArgumentError('Rating must be between 0 and 5');
      }

      // Verify patient and professional exist
      final patient = await _patientService.get(patientId);
      final professional = await _healthcareProfessionalService.get(healthcareProfessionalId);
      if (patient == null || professional == null) {
        throw Exception('Patient or Healthcare Professional not found');
      }

      // Create a new Rating
      final newRating = Rating(
        id: '', // ID will be set by Firestore
        patientId: patientId,
        healthcareProfessionalId: healthcareProfessionalId,
        ratingValue: ratingValue,
        comment: comment,
        date: DateTime.now(),
      );

      // Add to Firestore and get the generated ID
      final ratingId = await _ratingService.add(data: newRating);

      // Update HealthcareProfessional's ratingIds and recalculate average rating
      final ratings = await _ratingService.queryField('healthcareProfessionalId', healthcareProfessionalId);
      final updatedRatingIds = [...professional.ratingIds, ratingId];
      final newAverageRating = ratings.isNotEmpty
          ? ratings.map((r) => r.ratingValue).reduce((a, b) => a + b) / ratings.length
          : ratingValue;

      final updatedProfessional = professional.copyWith(
        ratingIds: updatedRatingIds,
        rating: newAverageRating,
      );
      await _healthcareProfessionalService.update(
        healthcareProfessionalId,
        updatedProfessional,
            (p) => p.toJson(),
      );

      return ratingId;
    } catch (e) {
      throw Exception('Failed to add rating: $e');
    }
  }

  /// Deletes a rating and updates the healthcare professional's ratingIds and average rating.
  Future<void> deleteRating({
    required String ratingId,
    required String patientId,
    required String healthcareProfessionalId,
  }) async {
    try {
      // Fetch the rating
      final rating = await _ratingService.get(ratingId);
      if (rating == null) {
        throw Exception('Rating not found');
      }

      // Verify ownership
      if (rating.patientId != patientId) {
        throw Exception('Unauthorized: You can only delete your own ratings');
      }

      // Delete the rating
      await _ratingService.delete(ratingId);

      // Update HealthcareProfessional's ratingIds and recalculate average rating
      final professional = await _healthcareProfessionalService.get(healthcareProfessionalId);
      if (professional == null) {
        throw Exception('Healthcare Professional not found');
      }
      final updatedRatingIds = professional.ratingIds
          .where((id) => id != ratingId)
          .toList();
      final remainingRatings = await _ratingService.queryField('healthcareProfessionalId', healthcareProfessionalId);
      final newAverageRating = remainingRatings.isNotEmpty
          ? remainingRatings.map((r) => r.ratingValue).reduce((a, b) => a + b) / remainingRatings.length
          : 0.0;

      final updatedProfessional = professional.copyWith(
        ratingIds: updatedRatingIds,
        rating: newAverageRating,
      );
      await _healthcareProfessionalService.update(
        healthcareProfessionalId,
        updatedProfessional,
            (p) => p.toJson(),
      );
    } catch (e) {
      throw Exception('Failed to delete rating: $e');
    }
  }

  /// Retrieves all comments for a healthcare professional.
  Future<List<Comment>> getComments({
    required String healthcareProfessionalId,
  }) async {
    try {
      // Fetch comments for the professional
      final comments = await _commentService.queryField('healthcareProfessionalId', healthcareProfessionalId);
      return comments;
    } catch (e) {
      throw Exception('Failed to retrieve comments: $e');
    }
  }

  /// Retrieves all ratings for a healthcare professional.
  Future<List<Rating>> getRatings({
    required String healthcareProfessionalId,
  }) async {
    try {
      // Fetch ratings for the professional
      final ratings = await _ratingService.queryField('healthcareProfessionalId', healthcareProfessionalId);
      return ratings;
    } catch (e) {
      throw Exception('Failed to retrieve ratings: $e');
    }
  }
}