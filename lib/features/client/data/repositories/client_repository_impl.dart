import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repositories/client_repository.dart';
import '../../domain/entities/client_portal_models.dart';

/// Implementation of ClientRepository using Firebase Firestore
class ClientRepositoryImpl implements ClientRepository {
  /// Instance of Firebase Firestore for data operations
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  /// Retrieves a stream of all available maid profiles
  Stream<List<MaidProfile>> getMaidProfiles() {
    return _firestore
        .collection('maids')
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => MaidProfile.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  @override
  /// Retrieves a stream of service requests for a specific client
  Stream<List<ClientRequest>> getClientRequests(String clientId) {
    return _firestore
        .collection('inquiries')
        .where('clientId', isEqualTo: clientId)
        // .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ClientRequest.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  /// Submits a new service request to Firestore
  Future<void> submitRequest(ClientRequest request) async {
    await _firestore.collection('inquiries').add(request.toMap());
  }
}
