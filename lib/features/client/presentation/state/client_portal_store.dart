import '../../data/repositories/client_repository_impl.dart';
import '../../domain/entities/client_portal_models.dart';

class ClientPortalStore {
  ClientPortalStore._();

  static final ClientPortalStore instance = ClientPortalStore._();
  final ClientRepositoryImpl _repository = ClientRepositoryImpl();

  List<MaidProfile> _maids = <MaidProfile>[];
  List<ClientRequest> _requests = <ClientRequest>[];
  final Set<String> _shortlistedIds = <String>{};
  bool _loaded = false;

  Future<void> ensureLoaded() async {
    if (_loaded) return;
    _maids = await _repository.getMaidProfiles();
    _requests = await _repository.getClientRequests();
    _loaded = true;
  }

  List<MaidProfile> get maids => _maids;
  List<ClientRequest> get requests => _requests;

  List<MaidProfile> get shortlist =>
      _maids.where((maid) => _shortlistedIds.contains(maid.id)).toList();

  bool isShortlisted(String maidId) => _shortlistedIds.contains(maidId);

  void toggleShortlist(String maidId) {
    if (_shortlistedIds.contains(maidId)) {
      _shortlistedIds.remove(maidId);
    } else {
      _shortlistedIds.add(maidId);
    }
  }

  void createRequest({
    required MaidProfile maid,
    required ClientRequestType type,
    required String notes,
  }) {
    final int nextId = _requests.length + 1003;
    _requests = <ClientRequest>[
      ClientRequest(
        id: 'REQ-$nextId',
        maidId: maid.id,
        maidName: maid.name,
        type: type,
        status: ClientRequestStatus.submitted,
        createdAtLabel: 'Just now',
        notes: notes,
      ),
      ..._requests,
    ];
  }
}
