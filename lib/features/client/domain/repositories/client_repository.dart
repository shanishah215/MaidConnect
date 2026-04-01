import '../entities/client_portal_models.dart';

abstract class ClientRepository {
  Future<List<MaidProfile>> getMaidProfiles();

  Future<List<ClientRequest>> getClientRequests();
}
