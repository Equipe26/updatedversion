class MedicalDocument {
  final String id;
  final String type;
  final String fileUrl;
  final int fileSize;
  final DateTime uploadDate;
  final String healthcareProfessionalId;
  final String? patientId;
  final String? documentName; // Add this new field

  MedicalDocument({
    required this.id,
    required this.type,
    required this.fileUrl,
    required this.fileSize,
    required this.uploadDate,
    required this.healthcareProfessionalId,
    this.patientId,
    this.documentName, // Add to constructor
  });

  // Update copyWith
  MedicalDocument copyWith({
    String? id,
    String? type,
    String? fileUrl,
    int? fileSize,
    DateTime? uploadDate,
    String? healthcareProfessionalId,
    String? patientId,
    String? documentName, // Add this
  }) {
    return MedicalDocument(
      id: id ?? this.id,
      type: type ?? this.type,
      fileUrl: fileUrl ?? this.fileUrl,
      fileSize: fileSize ?? this.fileSize,
      uploadDate: uploadDate ?? this.uploadDate,
      healthcareProfessionalId: healthcareProfessionalId ?? this.healthcareProfessionalId,
      patientId: patientId ?? this.patientId,
      documentName: documentName ?? this.documentName, // Add this
    );
  }

  // Update toJson
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'fileUrl': fileUrl,
      'fileSize': fileSize,
      'uploadDate': uploadDate.toIso8601String(),
      'healthcareProfessionalId': healthcareProfessionalId,
      'patientId': patientId,
      'documentName': documentName, // Add this
    };
  }

  // Update fromJson
  factory MedicalDocument.fromJson(Map<String, dynamic> json) {
    return MedicalDocument(
      id: json['id'],
      type: json['type'],
      fileUrl: json['fileUrl'],
      fileSize: json['fileSize'] ?? 0,
      uploadDate: DateTime.parse(json['uploadDate']),
      healthcareProfessionalId: json['healthcareProfessionalId'],
      patientId: json['patientId'],
      documentName: json['documentName'], // Add this
    );
  }
}