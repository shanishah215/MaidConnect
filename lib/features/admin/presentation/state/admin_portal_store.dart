import '../../data/repositories/admin_repository_impl.dart';
import '../../domain/entities/admin_models.dart';

/// In-memory singleton store for the Admin Portal.
/// All state mutations happen here; Firebase can later replace the seed data
/// by swapping [AdminRepositoryImpl] for a Firebase-backed implementation.
class AdminPortalStore {
  AdminPortalStore._();
  static final AdminPortalStore instance = AdminPortalStore._();
  final AdminRepositoryImpl _repo = AdminRepositoryImpl();

  // ── State ──────────────────────────────────────────────────────────────────
  List<AdminMaidProfile> _maids = <AdminMaidProfile>[];
  List<AdminClient> _clients = <AdminClient>[];
  List<ClientInquiry> _inquiries = <ClientInquiry>[];
  AnalyticsSnapshot? _analytics;
  bool _loaded = false;

  // ── Getters ────────────────────────────────────────────────────────────────
  List<AdminMaidProfile> get maids => _maids;
  List<AdminClient> get clients => _clients;
  List<ClientInquiry> get inquiries => _inquiries;
  AnalyticsSnapshot? get analytics => _analytics;

  // ── Load ───────────────────────────────────────────────────────────────────
  Future<void> ensureLoaded() async {
    if (_loaded) return;
    _maids = await _repo.getMaidProfiles();
    _clients = await _repo.getClients();
    _inquiries = await _repo.getInquiries();
    _analytics = await _repo.getAnalytics();
    _loaded = true;
  }

  void reset() => _loaded = false;

  // ── Maid CRUD ──────────────────────────────────────────────────────────────
  Future<void> addMaid(AdminMaidProfile maid) async {
    final realId = await _repo.createMaidProfile(maid);
    // Create actual object with Firestore ID for local state sync
    final finalMaid = AdminMaidProfile.fromMap(maid.toMap(), realId);
    _maids = <AdminMaidProfile>[finalMaid, ..._maids];
  }

  Future<void> updateMaid(AdminMaidProfile updated) async {
    await _repo.updateMaidProfile(updated);
    _maids = _maids.map((m) => m.id == updated.id ? updated : m).toList();
  }

  Future<void> deleteMaid(String id) async {
    await _repo.deleteMaidProfile(id);
    _maids = _maids.where((m) => m.id != id).toList();
  }

  AdminMaidProfile? getMaidById(String id) {
    try {
      return _maids.firstWhere((m) => m.id == id);
    } catch (_) {
      return null;
    }
  }

  // ── Inquiry Workflow ───────────────────────────────────────────────────────
  Future<void> approveInquiry(String id) async {
    await _repo.updateInquiryStatus(id, InquiryStatus.approved);
    final inq = _inquiries.firstWhere((i) => i.id == id);
    inq.status = InquiryStatus.approved;
  }

  Future<void> rejectInquiry(String id) async {
    await _repo.updateInquiryStatus(id, InquiryStatus.rejected);
    final inq = _inquiries.firstWhere((i) => i.id == id);
    inq.status = InquiryStatus.rejected;
  }

  Future<void> assignInquiry(String id, String maidName) async {
    await _repo.updateInquiryStatus(id, InquiryStatus.assigned);
    final inq = _inquiries.firstWhere((i) => i.id == id);
    inq.status = InquiryStatus.assigned;
    inq.assignedTo = maidName;
  }

  // ── Filtered views ─────────────────────────────────────────────────────────
  List<AdminMaidProfile> searchMaids(String query) {
    if (query.isEmpty) return _maids;
    final q = query.toLowerCase();
    return _maids
        .where((m) =>
            m.name.toLowerCase().contains(q) ||
            m.nationality.toLowerCase().contains(q) ||
            m.skills.any((s) => s.toLowerCase().contains(q)))
        .toList();
  }

  List<ClientInquiry> getInquiriesByStatus(InquiryStatus? status) {
    if (status == null) return _inquiries;
    return _inquiries.where((i) => i.status == status).toList();
  }
}
