import 'Connection.dart';
import '../database_service.dart';

class ConnectionService {
  final FirestoreService<Connection> _connectionDb;

  ConnectionService()
      : _connectionDb = FirestoreService<Connection>(
          collectionPath: 'connections',
          fromJson: Connection.fromJson,
          toJson: (c) => c.toJson(),
        );

  Future<List<Connection>> getConnectionsForUser(String userId) async {
    try {
      // Get connections where user is either patient or professional
      final patientConnections = await _connectionDb.queryField('patientId', userId);
      final professionalConnections = await _connectionDb.queryField(
        'healthcareProfessionalId', 
        userId,
      );
      
      return [...patientConnections, ...professionalConnections];
    } catch (e) {
      throw Exception('Failed to get connections: $e');
    }
  }
}