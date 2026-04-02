import '../entities/client_portal_models.dart';

abstract class ClientRepository {
  Stream<List<MaidProfile>> getMaidProfiles();

  Stream<List<ClientRequest>> getClientRequests(String clientId);
}
