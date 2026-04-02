import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repositories/client_repository.dart';
import '../../domain/entities/client_portal_models.dart';

class ClientRepositoryImpl implements ClientRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Stream<List<MaidProfile>> getMaidProfiles() {
    return _firestore
        .collection('maids')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => MaidProfile.fromMap(doc.data(), doc.id))
            .toList());
  }

  @override
  Stream<List<ClientRequest>> getClientRequests(String clientId) {
    return _firestore
        .collection('inquiries')
        .where('clientId', isEqualTo: clientId)
        // .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => ClientRequest.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> submitRequest(ClientRequest request) async {
    await _firestore.collection('inquiries').add(request.toMap());
  }
}
