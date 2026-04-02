import 'package:cloud_firestore/cloud_firestore.dart';

// ── Enums ────────────────────────────────────────────────────────────────────

enum AdminMaidAvailability { available, unavailable, onLeave }

enum AdminMaidDocType { passport, workPermit, medicalCert, reference, other }

enum AdminClientStatus { active, suspended }

enum InquiryType { callback, hire }

enum InquiryStatus { pending, approved, rejected, assigned, completed }

// ── Maid Profile ─────────────────────────────────────────────────────────────

class AdminMaidProfile {
  AdminMaidProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.nationality,
    required this.skills,
    required this.experienceYears,
    required this.languages,
    required this.availabilityStatus,
    required this.bio,
    required this.monthlyRate,
    this.createdAt,
    this.photoUrl,
    this.documents = const <MaidDocument>[],
  });

  final String id;
  String name;
  int age;
  String nationality;
  List<String> skills;
  int experienceYears;
  List<String> languages;
  AdminMaidAvailability availabilityStatus;
  String bio;
  int monthlyRate;
  final DateTime? createdAt;
  String? photoUrl;
  List<MaidDocument> documents;

  factory AdminMaidProfile.fromMap(Map<String, dynamic> map, String docId) {
    return AdminMaidProfile(
      id: docId,
      name: map['name'] ?? '',
      age: map['age'] ?? 0,
      nationality: map['nationality'] ?? '',
      skills: List<String>.from(map['skills'] ?? []),
      experienceYears: map['experienceYears'] ?? 0,
      languages: List<String>.from(map['languages'] ?? []),
      availabilityStatus: AdminMaidAvailability.values.firstWhere(
        (e) => e.name == map['availabilityStatus'],
        orElse: () => AdminMaidAvailability.available,
      ),
      bio: map['bio'] ?? '',
      monthlyRate: map['monthlyRate'] ?? 0,
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
      photoUrl: map['photoUrl'],
      documents: (map['documents'] as List? ?? [])
          .map((d) => MaidDocument.fromMap(Map<String, dynamic>.from(d)))
          .toList(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'nationality': nationality,
      'skills': skills,
      'experienceYears': experienceYears,
      'languages': languages,
      'availabilityStatus': availabilityStatus.name,
      'bio': bio,
      'monthlyRate': monthlyRate,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      'photoUrl': photoUrl,
      'documents': documents.map((d) => d.toMap()).toList(),
    };
  }

  AdminMaidProfile copyWith({
    String? name,
    int? age,
    String? nationality,
    List<String>? skills,
    int? experienceYears,
    List<String>? languages,
    AdminMaidAvailability? availabilityStatus,
    String? bio,
    int? monthlyRate,
    String? photoUrl,
    List<MaidDocument>? documents,
  }) {
    return AdminMaidProfile(
      id: id,
      name: name ?? this.name,
      age: age ?? this.age,
      nationality: nationality ?? this.nationality,
      skills: skills ?? this.skills,
      experienceYears: experienceYears ?? this.experienceYears,
      languages: languages ?? this.languages,
      availabilityStatus: availabilityStatus ?? this.availabilityStatus,
      bio: bio ?? this.bio,
      monthlyRate: monthlyRate ?? this.monthlyRate,
      createdAt: createdAt,
      photoUrl: photoUrl ?? this.photoUrl,
      documents: documents ?? this.documents,
    );
  }
}

class MaidDocument {
  const MaidDocument({
    required this.name,
    required this.type,
    this.uploadedAt,
  });
  final String name;
  final AdminMaidDocType type;
  final DateTime? uploadedAt;

  factory MaidDocument.fromMap(Map<String, dynamic> map) {
    return MaidDocument(
      name: map['name'] ?? '',
      type: AdminMaidDocType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => AdminMaidDocType.other,
      ),
      uploadedAt: (map['uploadedAt'] as Timestamp?)?.toDate(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type.name,
      'uploadedAt': uploadedAt != null ? Timestamp.fromDate(uploadedAt!) : FieldValue.serverTimestamp(),
    };
  }
}

// ── Client ────────────────────────────────────────────────────────────────────

class AdminClient {
  const AdminClient({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.registeredAt,
    required this.status,
    this.totalRequests = 0,
  });
  final String id;
  final String name;
  final String email;
  final String? phone;
  final DateTime? registeredAt;
  final AdminClientStatus status;
  final int totalRequests;

  factory AdminClient.fromMap(Map<String, dynamic> map, String docId) {
    return AdminClient(
      id: docId,
      name: map['name'] ?? map['email'] ?? 'Unknown',
      email: map['email'] ?? '',
      phone: map['phone'],
      registeredAt: (map['registeredAt'] ?? map['createdAt'] as Timestamp?)?.toDate(),
      status: AdminClientStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => AdminClientStatus.active,
      ),
      totalRequests: map['totalRequests'] ?? 0,
    );
  }
}

// ── Inquiry ───────────────────────────────────────────────────────────────────

class ClientInquiry {
  ClientInquiry({
    required this.id,
    required this.clientId,
    required this.clientName,
    required this.maidId,
    required this.maidName,
    required this.type,
    required this.status,
    this.createdAt,
    required this.notes,
    this.assignedTo,
  });
  final String id;
  final String clientId;
  final String clientName;
  final String maidId;
  final String maidName;
  final InquiryType type;
  InquiryStatus status;
  final DateTime? createdAt;
  final String notes;
  String? assignedTo;

  factory ClientInquiry.fromMap(Map<String, dynamic> map, String docId) {
    return ClientInquiry(
      id: docId,
      clientId: map['clientId'] ?? '',
      clientName: map['clientName'] ?? '',
      maidId: map['maidId'] ?? '',
      maidName: map['maidName'] ?? '',
      type: InquiryType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => InquiryType.hire,
      ),
      status: InquiryStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => InquiryStatus.pending,
      ),
      createdAt: (map['createdAt'] as Timestamp?)?.toDate(),
      notes: map['notes'] ?? '',
      assignedTo: map['assignedTo'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'clientId': clientId,
      'clientName': clientName,
      'maidId': maidId,
      'maidName': maidName,
      'type': type.name,
      'status': status.name,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
      'notes': notes,
      'assignedTo': assignedTo,
    };
  }
}

// ── Analytics ─────────────────────────────────────────────────────────────────

class AnalyticsSnapshot {
  const AnalyticsSnapshot({
    required this.totalUsers,
    required this.activeMaids,
    required this.activeRequests,
    required this.conversions,
    required this.pendingApprovals,
    required this.thisMonthRegistrations,
  });
  final int totalUsers;
  final int activeMaids;
  final int activeRequests;
  final int conversions;
  final int pendingApprovals;
  final int thisMonthRegistrations;
}
