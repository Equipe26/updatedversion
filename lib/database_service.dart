import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreService<T> {
  final CollectionReference<T> _collectionRef;

  FirestoreService({
    required String collectionPath,
    required T Function(Map<String, dynamic>) fromJson,
    required Map<String, dynamic> Function(T) toJson,
  }) : _collectionRef = FirebaseFirestore.instance
           .collection(collectionPath)
           .withConverter<T>(
             fromFirestore: (s, _) => fromJson(s.data()!),
             toFirestore: (d, _) => toJson(d),
           );
  CollectionReference<T> get collectionRef => _collectionRef;
  FirebaseFirestore get firestore => FirebaseFirestore.instance;
  // Create/Add a document
  Future<String> add({
    required T data,
    String? id,
    bool randomizeId = true, // Default to random for safety
  }) async {
    if (!randomizeId && id == null) {
      throw ArgumentError('Must provide [id] when randomizeId=false');
    }

    if (randomizeId) {
      // Auto-generate ID (ignore provided id)
      final docRef = await _collectionRef.add(data);
      return docRef.id;
    } else {
      // Use custom ID
      await _collectionRef.doc(id!).set(data);
      return id;
    }
  }

  // Read a single document
  Future<T?> get(String id) async {
    final doc = await _collectionRef.doc(id).get();
    return doc.data();
  }

  // Read all documents
  Future<List<T>> getAll() async {
    final querySnapshot = await _collectionRef.get();
    return querySnapshot.docs.map((doc) => doc.data()).toList();
  }

  // Update a document
  Future<void> update(String id, T data,Map<String, dynamic> Function(T) toJson) async {
    await _collectionRef.doc(id).update(toJson(data));
  }

  // Delete a document
  Future<void> delete(String id) async {
    await _collectionRef.doc(id).delete();
  }

  // Simplified querying
  Future<List<T>> queryField(String field, dynamic value) {
    return _collectionRef
        .where(field, isEqualTo: value)
        .get()
        .then((s) => s.docs.map((d) => d.data()).toList());
  }
}
