import 'MedicalDocument.dart';

class MedicalFolder {
  final String id;
  final String patientId;
  final String healthcareProfessionalId;
  final List<MedicalDocument> documents;
  final String? comments;

  MedicalFolder({
    required this.id,
    required this.patientId,
    required this.healthcareProfessionalId,
    required this.documents,
    this.comments,
  });

  MedicalFolder copyWith({
    String? id,
    String? patientId,
    String? healthcareProfessionalId,
    List<MedicalDocument>? documents,
    String? comments,
  }) {
    return MedicalFolder(
      id: id ?? this.id,
      patientId: patientId ?? this.patientId,
      healthcareProfessionalId:
          healthcareProfessionalId ?? this.healthcareProfessionalId,
      documents: documents ?? this.documents,
      comments: comments ?? this.comments,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'patientId': patientId,
      'healthcareProfessionalId': healthcareProfessionalId,
      'documents': documents.map((doc) => doc.toJson()).toList(),
      'comments': comments,
    };
  }

  factory MedicalFolder.fromJson(Map<String, dynamic> json) {
    return MedicalFolder(
      id: json['id'],
      patientId: json['patientId'],
      healthcareProfessionalId: json['healthcareProfessionalId'],
      documents:
          (json['documents'] as List)
              .map((doc) => MedicalDocument.fromJson(doc))
              .toList(),
      comments: json['comments'],
    );
  }

  @override
  String toString() {
    return 'MedicalFolder(id: $id, patientId: $patientId, healthcareProfessionalId: $healthcareProfessionalId, documents: ${documents.length}, comments: $comments)';
  }
}
