import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/admin_models.dart';
import '../../domain/repositories/admin_repository.dart';

class AdminRepositoryImpl implements AdminRepository {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  Future<List<AdminMaidProfile>> getMaidProfiles() async {
    final snapshot = await _firestore.collection('maids').orderBy('createdAt', descending: true).get();
    return snapshot.docs.map((doc) => AdminMaidProfile.fromMap(doc.data(), doc.id)).toList();
  }

  @override
  Future<List<AdminClient>> getClients() async {
    // We fetch clients from the 'users' collection where role is 'client'
    final snapshot = await _firestore.collection('users').where('role', isEqualTo: 'client').get();
    return snapshot.docs.map((doc) => AdminClient.fromMap(doc.data(), doc.id)).toList();
  }

  @override
  Future<List<ClientInquiry>> getInquiries() async {
    final snapshot = await _firestore.collection('inquiries').orderBy('createdAt', descending: true).get();
    return snapshot.docs.map((doc) => ClientInquiry.fromMap(doc.data(), doc.id)).toList();
  }

  @override
  Future<AnalyticsSnapshot> getAnalytics() async {
    // Batch fetch counts for analytics
    final maidsCount = await _firestore.collection('maids').count().get();
    final usersCount = await _firestore.collection('users').count().get();
    final inquiriesCount = await _firestore.collection('inquiries').count().get();
    final pendingCount = await _firestore.collection('inquiries').where('status', isEqualTo: 'pending').count().get();

    return AnalyticsSnapshot(
      totalUsers: usersCount.count ?? 0,
      activeMaids: maidsCount.count ?? 0,
      activeRequests: inquiriesCount.count ?? 0,
      conversions: 0, // Calculated separately usually
      pendingApprovals: pendingCount.count ?? 0,
      thisMonthRegistrations: 0,
    );
  }

  @override
  Future<String> createMaidProfile(AdminMaidProfile maid) async {
    final docRef = await _firestore.collection('maids').add(maid.toMap());
    return docRef.id;
  }

  @override
  Future<void> updateMaidProfile(AdminMaidProfile maid) async {
    await _firestore.collection('maids').doc(maid.id).update(maid.toMap());
  }

  @override
  Future<void> deleteMaidProfile(String id) async {
    await _firestore.collection('maids').doc(id).delete();
  }

  @override
  Future<void> updateInquiryStatus(String id, InquiryStatus status) async {
    await _firestore.collection('inquiries').doc(id).update({
      'status': status.name,
    });
  }
}

// ── Seed Data Helpers (For initial populate) ──────────────────────────────────
// Note: You can call this once to populate your DB with the original design data.
Future<void> populateMaidSeedData() async {
  final firestore = FirebaseFirestore.instance;
  for (final maid in _seedMaids) {
    await firestore.collection('maids').add(maid.toMap());
  }
}

final List<AdminMaidProfile> _seedMaids = <AdminMaidProfile>[
  AdminMaidProfile(
    id: 'maid-01',
    name: 'Anita Perera',
    age: 29,
    nationality: 'Sri Lankan',
    skills: <String>['Childcare', 'Cooking', 'Laundry'],
    experienceYears: 6,
    languages: <String>['English', 'Sinhala'],
    availabilityStatus: AdminMaidAvailability.available,
    bio: 'Warm and dependable caregiver with strong childcare experience.',
    monthlyRate: 550,
    createdAt: DateTime.parse('2024-01-15'),
    documents: <MaidDocument>[
      MaidDocument(name: 'Passport_Anita.pdf', type: AdminMaidDocType.passport, uploadedAt: DateTime.parse('2024-01-15')),
      MaidDocument(name: 'Medical_Cert.pdf', type: AdminMaidDocType.medicalCert, uploadedAt: DateTime.parse('2024-01-16')),
    ],
  ),
  AdminMaidProfile(
    id: 'maid-02',
    name: 'Maya Fernando',
    age: 35,
    nationality: 'Sri Lankan',
    skills: <String>['Elder Care', 'Medication Reminders', 'Housekeeping'],
    experienceYears: 10,
    languages: <String>['English', 'Tamil'],
    availabilityStatus: AdminMaidAvailability.available,
    bio: 'Experienced in elder support, cleanliness, and calm communication.',
    monthlyRate: 680,
    createdAt: DateTime.parse('2023-11-03'),
    documents: <MaidDocument>[
      MaidDocument(name: 'Passport_Maya.pdf', type: AdminMaidDocType.passport, uploadedAt: DateTime.parse('2023-11-03')),
      MaidDocument(name: 'Work_Permit.pdf', type: AdminMaidDocType.workPermit, uploadedAt: DateTime.parse('2023-11-04')),
      MaidDocument(name: 'Reference_Letter.pdf', type: AdminMaidDocType.reference, uploadedAt: DateTime.parse('2023-11-05')),
    ],
  ),
];
