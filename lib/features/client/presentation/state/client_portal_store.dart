import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../../data/repositories/client_repository_impl.dart';
import '../../domain/entities/client_portal_models.dart';

class ClientPortalStore extends ChangeNotifier {
  ClientPortalStore._();

  static final ClientPortalStore instance = ClientPortalStore._();
  final ClientRepositoryImpl _repository = ClientRepositoryImpl();

  List<MaidProfile> _maids = <MaidProfile>[];
  List<ClientRequest> _requests = <ClientRequest>[];
  final Set<String> _shortlistedIds = <String>{};
  bool _loaded = false;

  StreamSubscription<List<MaidProfile>>? _maidsSubscription;
  StreamSubscription<List<ClientRequest>>? _requestsSubscription;
  StreamSubscription<DocumentSnapshot>? _userSubscription;

  Future<void> ensureLoaded() async {
    if (_loaded) return;
    
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    // Cancel existing subscriptions if any
    await _maidsSubscription?.cancel();
    await _requestsSubscription?.cancel();
    await _userSubscription?.cancel();

    _maidsSubscription = _repository.getMaidProfiles().listen((maids) {
      _maids = maids;
      _loaded = true;
      notifyListeners();
    });

    _requestsSubscription = _repository.getClientRequests(user.uid).listen(
      (requests) {
        _requests = requests;
        notifyListeners();
      },
      onError: (e) => debugPrint('ClientPortalStore: Error fetching requests: $e'),
    );

    _userSubscription = FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .snapshots()
        .listen((snapshot) {
      if (snapshot.exists) {
        final data = snapshot.data() as Map<String, dynamic>?;
        final list = List<String>.from(data?['shortlist'] ?? []);
        _shortlistedIds.clear();
        _shortlistedIds.addAll(list);
        notifyListeners();
      }
    });
  }

  @override
  void dispose() {
    _maidsSubscription?.cancel();
    _requestsSubscription?.cancel();
    _userSubscription?.cancel();
    super.dispose();
  }

  List<MaidProfile> get maids => _maids;
  List<ClientRequest> get requests => _requests;

  List<MaidProfile> get shortlist =>
      _maids.where((maid) => _shortlistedIds.contains(maid.id)).toList();

  bool isShortlisted(String maidId) => _shortlistedIds.contains(maidId);

  Future<void> toggleShortlist(String maidId) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final docRef = FirebaseFirestore.instance.collection('users').doc(user.uid);

    if (_shortlistedIds.contains(maidId)) {
      _shortlistedIds.remove(maidId);
      await docRef.update({
        'shortlist': FieldValue.arrayRemove([maidId])
      });
    } else {
      _shortlistedIds.add(maidId);
      await docRef.update({
        'shortlist': FieldValue.arrayUnion([maidId])
      });
    }
    notifyListeners();
  }

  Future<void> createRequest({
    required MaidProfile maid,
    required ClientRequestType type,
    required String notes,
  }) async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    final request = ClientRequest(
      id: '', 
      maidId: maid.id,
      maidName: maid.name,
      type: type,
      status: ClientRequestStatus.submitted,
      createdAtLabel: 'Just now',
      notes: notes,
      createdAt: DateTime.now(),
      clientId: user.uid,
      clientName: user.displayName ?? user.email ?? 'Client',
    );

    final Map<String, dynamic> data = request.toMap();
    // We send 'pending' as the status string to Firestore so the Admin sees it correctly
    data['status'] = 'pending';

    await FirebaseFirestore.instance.collection('inquiries').add(data);
  }
}
