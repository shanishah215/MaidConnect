import 'package:cloud_firestore/cloud_firestore.dart';

/// Enum representing maid availability stages
enum MaidAvailability { immediate, thisWeek, thisMonth }

/// Enum representing types of client requests
enum ClientRequestType { callback, hire }

/// Enum representing the status of a client's request
enum ClientRequestStatus {
  submitted,
  underReview,
  interviewScheduled,
  approved,
  hired,
  rejected,
  completed,
}

/// Data model representing a maid's profile
class MaidProfile {
  /// Default constructor for MaidProfile
  const MaidProfile({
    required this.id,
    required this.name,
    required this.age,
    required this.experienceYears,
    required this.skills,
    required this.languages,
    required this.availability,
    required this.bio,
    required this.location,
    required this.monthlyRate,
    required this.rating,
  });

  /// Unique identifier for the maid
  final String id;

  /// Full name of the maid
  final String name;

  /// Age of the maid
  final int age;

  /// Number of years of experience
  final int experienceYears;

  /// List of professional skills
  final List<String> skills;

  /// List of languages spoken
  final List<String> languages;

  /// Availability status of the maid
  final MaidAvailability availability;

  /// Detailed biography of the maid
  final String bio;

  /// Current location or nationality
  final String location;

  /// Monthly salary rate
  final int monthlyRate;

  /// Performance rating out of 5.0
  final double rating;

  /// Creates a MaidProfile from a Firestore document map
  factory MaidProfile.fromMap(Map<String, dynamic> map, String docId) {
    return MaidProfile(
      id: docId,
      name: map['name'] ?? '',
      age: map['age'] ?? 0,
      experienceYears: map['experienceYears'] ?? 0,
      skills: List<String>.from(map['skills'] ?? []),
      languages: List<String>.from(map['languages'] ?? []),
      availability: MaidAvailability.values.firstWhere(
        (e) =>
            e.name == map['availabilityStatus'] ||
            e.name == map['availability'],
        orElse: () => MaidAvailability.immediate,
      ),
      bio: map['bio'] ?? '',
      location: map['location'] ?? map['nationality'] ?? '',
      monthlyRate: map['monthlyRate'] ?? 0,
      rating: (map['rating'] ?? 5.0).toDouble(),
    );
  }

  /// Converts the profile instance into a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'experienceYears': experienceYears,
      'skills': skills,
      'languages': languages,
      'availability': availability.name,
      'bio': bio,
      'location': location,
      'monthlyRate': monthlyRate,
      'rating': rating,
    };
  }
}

/// Data model representing a service request from a client
class ClientRequest {
  /// Default constructor for ClientRequest
  const ClientRequest({
    required this.id,
    required this.maidId,
    required this.maidName,
    required this.type,
    required this.status,
    required this.createdAtLabel,
    required this.notes,
    this.createdAt,
    this.assignedTo,
    this.clientId,
    this.clientName,
  });

  /// Unique identifier for the request
  final String id;

  /// ID of the maid requested
  final String maidId;

  /// Name of the maid requested
  final String maidName;

  /// Type of request (hire or callback)
  final ClientRequestType type;

  /// Current status of the request
  final ClientRequestStatus status;

  /// User-friendly label for the creation date
  final String createdAtLabel;

  /// Additional notes from the client
  final String notes;

  /// Precise timestamp of when the request was made
  final DateTime? createdAt;

  /// ID of the maid assigned (if any)
  final String? assignedTo;

  /// ID of the client who made the request
  final String? clientId;

  /// Name of the client who made the request
  final String? clientName;

  /// Creates a ClientRequest from a Firestore document map
  factory ClientRequest.fromMap(Map<String, dynamic> map, String docId) {
    final DateTime? date = (map['createdAt'] as Timestamp?)?.toDate();
    return ClientRequest(
      id: docId,
      maidId: map['maidId'] ?? '',
      maidName: map['maidName'] ?? '',
      type: ClientRequestType.values.firstWhere(
        (e) => e.name == map['type'],
        orElse: () => ClientRequestType.hire,
      ),
      status: _mapInquiryStatusToClient(map['status']),
      createdAtLabel: _formatDate(date),
      notes: map['notes'] ?? '',
      createdAt: date,
      assignedTo: map['assignedTo'],
      clientId: map['clientId'],
      clientName: map['clientName'],
    );
  }

  /// Maps internal Firestore status strings to ClientRequestStatus enum
  static ClientRequestStatus _mapInquiryStatusToClient(dynamic status) {
    if (status == 'pending') return ClientRequestStatus.submitted;
    if (status == 'approved') return ClientRequestStatus.approved;
    if (status == 'assigned') return ClientRequestStatus.hired;
    if (status == 'rejected') return ClientRequestStatus.rejected;
    if (status == 'completed') return ClientRequestStatus.completed;
    return ClientRequestStatus.values.firstWhere(
      (e) => e.name == status,
      orElse: () => ClientRequestStatus.submitted,
    );
  }

  /// Formats a DateTime into a relative time string (e.g., "2h ago")
  static String _formatDate(DateTime? date) {
    if (date == null) return 'Unknown';
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${date.day}/${date.month}/${date.year}';
  }

  /// Converts the request instance into a Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'maidId': maidId,
      'maidName': maidName,
      'type': type.name,
      'status': status.name,
      'notes': notes,
      'createdAt': createdAt != null
          ? Timestamp.fromDate(createdAt!)
          : FieldValue.serverTimestamp(),
      'assignedTo': assignedTo,
      'clientId': clientId,
      'clientName': clientName,
    };
  }
}

class MaidFilter {
  const MaidFilter({
    this.minAge,
    this.maxAge,
    this.minExperience,
    this.skill,
    this.language,
    this.availability,
  });

  final int? minAge;
  final int? maxAge;
  final int? minExperience;
  final String? skill;
  final String? language;
  final MaidAvailability? availability;

  MaidFilter copyWith({
    int? minAge,
    int? maxAge,
    int? minExperience,
    String? skill,
    String? language,
    MaidAvailability? availability,
    bool clearAvailability = false,
    bool clearSkill = false,
    bool clearLanguage = false,
  }) {
    return MaidFilter(
      minAge: minAge ?? this.minAge,
      maxAge: maxAge ?? this.maxAge,
      minExperience: minExperience ?? this.minExperience,
      skill: clearSkill ? null : (skill ?? this.skill),
      language: clearLanguage ? null : (language ?? this.language),
      availability: clearAvailability
          ? null
          : (availability ?? this.availability),
    );
  }
}
