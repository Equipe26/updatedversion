import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreService<T> {
  final String collectionPath;
  final T Function(Map<String, dynamic>) fromJson;
  final Map<String, dynamic> Function(T) toJson;
  late final CollectionReference collectionRef;

  FirestoreService({
    required this.collectionPath,
    required this.fromJson,
    required this.toJson,
  }) {
    collectionRef = FirebaseFirestore.instance.collection(collectionPath);
  }

  Future<T?> get(String id) async {
    try {
      debugPrint('[FirestoreService] Getting document $id from $collectionPath');
      final snapshot = await collectionRef.doc(id).get();
      if (!snapshot.exists || snapshot.data() == null) {
        debugPrint('[FirestoreService] Document $id does not exist in $collectionPath');
        return null;
      }
      
      final data = snapshot.data() as Map<String, dynamic>;
      // Assurez-vous que l'ID est toujours présent dans les données
      if (!data.containsKey('id')) {
        data['id'] = id;
      }
      
      debugPrint('[FirestoreService] Document $id found in $collectionPath');
      return fromJson(data);
    } catch (e, stackTrace) {
      debugPrint('[FirestoreService] Error getting document $id: $e');
      debugPrint('[FirestoreService] Stack trace: $stackTrace');
      return null;
    }
  }

  Future<void> add({required T data, required String id}) async {
    try {
      debugPrint('[FirestoreService] Adding document $id to $collectionPath');
      await collectionRef.doc(id).set(toJson(data));
      debugPrint('[FirestoreService] Document $id added successfully to $collectionPath');
    } catch (e, stackTrace) {
      debugPrint('[FirestoreService] Error adding document $id: $e');
      debugPrint('[FirestoreService] Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<void> update(String id, T data, Map<String, dynamic> Function(T) customToJson) async {
    try {
      debugPrint('[FirestoreService] Updating document $id in $collectionPath');
      await collectionRef.doc(id).update(customToJson(data));
      debugPrint('[FirestoreService] Document $id updated successfully in $collectionPath');
    } catch (e, stackTrace) {
      debugPrint('[FirestoreService] Error updating document $id: $e');
      debugPrint('[FirestoreService] Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<void> delete(String id) async {
    try {
      debugPrint('[FirestoreService] Deleting document $id from $collectionPath');
      await collectionRef.doc(id).delete();
      debugPrint('[FirestoreService] Document $id deleted successfully from $collectionPath');
    } catch (e, stackTrace) {
      debugPrint('[FirestoreService] Error deleting document $id: $e');
      debugPrint('[FirestoreService] Stack trace: $stackTrace');
      rethrow;
    }
  }

  Stream<List<T>> getAll() {
    try {
      debugPrint('[FirestoreService] Getting all documents from $collectionPath');
      return collectionRef.snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          if (!data.containsKey('id')) {
            data['id'] = doc.id;
          }
          return fromJson(data);
        }).toList();
      });
    } catch (e, stackTrace) {
      debugPrint('[FirestoreService] Error getting all documents: $e');
      debugPrint('[FirestoreService] Stack trace: $stackTrace');
      return Stream.error(e);
    }
  }
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class FirestoreService<T> {
  final String collectionPath;
  final T Function(Map<String, dynamic>) fromJson;
  final Map<String, dynamic> Function(T) toJson;
  late final CollectionReference collectionRef;

  FirestoreService({
    required this.collectionPath,
    required this.fromJson,
    required this.toJson,
  }) {
    collectionRef = FirebaseFirestore.instance.collection(collectionPath);
  }

  Future<T?> get(String id) async {
    try {
      debugPrint('[FirestoreService] Getting document $id from $collectionPath');
      final snapshot = await collectionRef.doc(id).get();
      if (!snapshot.exists || snapshot.data() == null) {
        debugPrint('[FirestoreService] Document $id does not exist in $collectionPath');
        return null;
      }
      
      final data = snapshot.data() as Map<String, dynamic>;
      // Assurez-vous que l'ID est toujours présent dans les données
      if (!data.containsKey('id')) {
        data['id'] = id;
      }
      
      debugPrint('[FirestoreService] Document $id found in $collectionPath');
      return fromJson(data);
    } catch (e, stackTrace) {
      debugPrint('[FirestoreService] Error getting document $id: $e');
      debugPrint('[FirestoreService] Stack trace: $stackTrace');
      return null;
    }
  }

  Future<void> add({required T data, required String id}) async {
    try {
      debugPrint('[FirestoreService] Adding document $id to $collectionPath');
      await collectionRef.doc(id).set(toJson(data));
      debugPrint('[FirestoreService] Document $id added successfully to $collectionPath');
    } catch (e, stackTrace) {
      debugPrint('[FirestoreService] Error adding document $id: $e');
      debugPrint('[FirestoreService] Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<void> update(String id, T data, Map<String, dynamic> Function(T) customToJson) async {
    try {
      debugPrint('[FirestoreService] Updating document $id in $collectionPath');
      await collectionRef.doc(id).update(customToJson(data));
      debugPrint('[FirestoreService] Document $id updated successfully in $collectionPath');
    } catch (e, stackTrace) {
      debugPrint('[FirestoreService] Error updating document $id: $e');
      debugPrint('[FirestoreService] Stack trace: $stackTrace');
      rethrow;
    }
  }

  Future<void> delete(String id) async {
    try {
      debugPrint('[FirestoreService] Deleting document $id from $collectionPath');
      await collectionRef.doc(id).delete();
      debugPrint('[FirestoreService] Document $id deleted successfully from $collectionPath');
    } catch (e, stackTrace) {
      debugPrint('[FirestoreService] Error deleting document $id: $e');
      debugPrint('[FirestoreService] Stack trace: $stackTrace');
      rethrow;
    }
  }

  Stream<List<T>> getAll() {
    try {
      debugPrint('[FirestoreService] Getting all documents from $collectionPath');
      return collectionRef.snapshots().map((snapshot) {
        return snapshot.docs.map((doc) {
          final data = doc.data() as Map<String, dynamic>;
          if (!data.containsKey('id')) {
            data['id'] = doc.id;
          }
          return fromJson(data);
        }).toList();
      });
    } catch (e, stackTrace) {
      debugPrint('[FirestoreService] Error getting all documents: $e');
      debugPrint('[FirestoreService] Stack trace: $stackTrace');
      return Stream.error(e);
    }
  }
}