// ── Enums ────────────────────────────────────────────────────────────────────

enum AdminMaidAvailability { available, unavailable, onLeave }

enum AdminMaidDocType { passport, workPermit, medicalCert, reference, other }

enum AdminClientStatus { active, suspended }

enum InquiryType { callback, hire }

enum InquiryStatus { pending, approved, rejected, assigned }

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
    required this.createdAt,
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
  final String createdAt;
  String? photoUrl;
  List<MaidDocument> documents;

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
    this.uploadedAt = 'Just now',
  });
  final String name;
  final AdminMaidDocType type;
  final String uploadedAt;
}

// ── Client ────────────────────────────────────────────────────────────────────

class AdminClient {
  const AdminClient({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    required this.registeredAt,
    required this.status,
    this.totalRequests = 0,
  });
  final String id;
  final String name;
  final String email;
  final String phone;
  final String registeredAt;
  final AdminClientStatus status;
  final int totalRequests;
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
    required this.createdAt,
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
  final String createdAt;
  final String notes;
  String? assignedTo;
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
