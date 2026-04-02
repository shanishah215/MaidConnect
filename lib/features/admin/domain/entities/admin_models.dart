import 'package:cloud_firestore/cloud_firestore.dart';

// ── Enums ────────────────────────────────────────────────────────────────────

/// Enum representing availability status for maids in the admin panel
enum AdminMaidAvailability { available, unavailable, onLeave }

/// Enum representing types of documents a maid can have
enum AdminMaidDocType { passport, workPermit, medicalCert, reference, other }

/// Enum representing management status of a client
enum AdminClientStatus { active, suspended }

/// Enum representing types of inquiries from clients
enum InquiryType { callback, hire }

/// Enum representing the workflow status of an inquiry
enum InquiryStatus { pending, approved, rejected, assigned, completed }

// ── Maid Profile ─────────────────────────────────────────────────────────────

/// Comprehensive data model for a maid's profile as seen by admins
class AdminMaidProfile {
  /// Default constructor for AdminMaidProfile
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

  /// Unique identifier for the maid document in Firestore
  final String id;

  /// Maid's full name
  String name;

  /// Maid's current age
  int age;

  /// Maid's nationality
  String nationality;

  /// List of professional skills or services offered
  List<String> skills;

  /// Number of years of professional experience
  int experienceYears;

  /// Languages the maid can speak fluently
  List<String> languages;

  /// Current availability of the maid
  AdminMaidAvailability availabilityStatus;

  /// Biography or professional summary
  String bio;

  /// Expected monthly base salary
  int monthlyRate;

  /// Timestamp of when the profile was first created
  final DateTime? createdAt;

  /// URL to the maid's profile photo
  String? photoUrl;

  /// List of supporting documents attached to the profile
  List<MaidDocument> documents;

  /// Creates an AdminMaidProfile from a Firestore document map
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

  /// Converts the profile instance into a Map for Firestore storage
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
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'photoUrl': photoUrl,
      'documents': documents.map((d) => d.toMap()).toList(),
    };
  }

  /// Creates a copy of the profile with optional field overrides
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

/// Data model for a document associated with a maid's profile
class MaidDocument {
  /// Default constructor for MaidDocument
  const MaidDocument({required this.name, required this.type, this.uploadedAt});

  /// Human-readable name of the document
  final String name;

  /// Categorized type of the document
  final AdminMaidDocType type;

  /// Timestamp of when the document was uploaded
  final DateTime? uploadedAt;

  /// Creates a MaidDocument from a map
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

  /// Converts the document instance into a Map
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'type': type.name,
      'uploadedAt': uploadedAt != null
          ? Timestamp.fromDate(uploadedAt!)
          : FieldValue.serverTimestamp(),
    };
  }
}

// ── Client ────────────────────────────────────────────────────────────────────

/// Data model representing a client in the admin management portal
class AdminClient {
  /// Default constructor for AdminClient
  const AdminClient({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.registeredAt,
    required this.status,
    this.totalRequests = 0,
  });

  /// Unique identifier of the client
  final String id;

  /// Client's full name or email display name
  final String name;

  /// Client's primary email address
  final String email;

  /// Optional contact phone number
  final String? phone;

  /// Timestamp of when the client registered
  final DateTime? registeredAt;

  /// Management status of the client
  final AdminClientStatus status;

  /// Historical count of service requests made by the client
  final int totalRequests;

  /// Creates an AdminClient from a Firestore document map
  factory AdminClient.fromMap(Map<String, dynamic> map, String docId) {
    return AdminClient(
      id: docId,
      name: map['name'] ?? map['email'] ?? 'Unknown',
      email: map['email'] ?? '',
      phone: map['phone'],
      registeredAt: (map['registeredAt'] ?? map['createdAt'] as Timestamp?)
          ?.toDate(),
      status: AdminClientStatus.values.firstWhere(
        (e) => e.name == map['status'],
        orElse: () => AdminClientStatus.active,
      ),
      totalRequests: map['totalRequests'] ?? 0,
    );
  }
}

// ── Inquiry ───────────────────────────────────────────────────────────────────

/// Data model for a service inquiry as handled by the admin
class ClientInquiry {
  /// Default constructor for ClientInquiry
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

  /// Unique identifier of the inquiry
  final String id;

  /// ID of the client who submitted the inquiry
  final String clientId;

  /// Name of the client who submitted the inquiry
  final String clientName;

  /// ID of the maid requested
  final String maidId;

  /// Name of the maid requested
  final String maidName;

  /// Purpose of the request (callback or hire)
  final InquiryType type;

  /// Administrative status of the inquiry
  InquiryStatus status;

  /// Timestamp of when the inquiry was received
  final DateTime? createdAt;

  /// Comments provided by the client
  final String notes;

  /// ID of the person or maid assigned to this inquiry
  String? assignedTo;

  /// Creates a ClientInquiry from a Firestore document map
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

  /// Converts the inquiry instance into a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'clientId': clientId,
      'clientName': clientName,
      'maidId': maidId,
      'maidName': maidName,
      'type': type.name,
      'status': status.name,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'notes': notes,
      'assignedTo': assignedTo,
    };
  }
}

// ── Analytics ─────────────────────────────────────────────────────────────────

/// Data snapshot representing administrative analytics metrics
class AnalyticsSnapshot {
  /// Default constructor for AnalyticsSnapshot
  const AnalyticsSnapshot({
    required this.totalUsers,
    required this.activeMaids,
    required this.activeRequests,
    required this.conversions,
    required this.pendingApprovals,
    required this.thisMonthRegistrations,
  });

  /// Total count of users in the system
  final int totalUsers;

  /// Count of maids currently marked as available
  final int activeMaids;

  /// Count of service requests currently in progress
  final int activeRequests;

  /// Percentage or count of successful hires
  final int conversions;

  /// Count of inquiries awaiting administrative review
  final int pendingApprovals;

  /// Count of new client registrations this month
  final int thisMonthRegistrations;
}
