import 'package:cloud_firestore/cloud_firestore.dart';

enum MaidAvailability { immediate, thisWeek, thisMonth }

enum ClientRequestType { callback, hire }

enum ClientRequestStatus {
  submitted,
  underReview,
  interviewScheduled,
  approved,
  hired,
  rejected,
  completed,
}

class MaidProfile {
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

  final String id;
  final String name;
  final int age;
  final int experienceYears;
  final List<String> skills;
  final List<String> languages;
  final MaidAvailability availability;
  final String bio;
  final String location;
  final int monthlyRate;
  final double rating;

  factory MaidProfile.fromMap(Map<String, dynamic> map, String docId) {
    return MaidProfile(
      id: docId,
      name: map['name'] ?? '',
      age: map['age'] ?? 0,
      experienceYears: map['experienceYears'] ?? 0,
      skills: List<String>.from(map['skills'] ?? []),
      languages: List<String>.from(map['languages'] ?? []),
      availability: MaidAvailability.values.firstWhere(
        (e) => e.name == map['availabilityStatus'] || e.name == map['availability'],
        orElse: () => MaidAvailability.immediate,
      ),
      bio: map['bio'] ?? '',
      location: map['location'] ?? map['nationality'] ?? '',
      monthlyRate: map['monthlyRate'] ?? 0,
      rating: (map['rating'] ?? 5.0).toDouble(),
    );
  }

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

class ClientRequest {
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

  final String id;
  final String maidId;
  final String maidName;
  final ClientRequestType type;
  final ClientRequestStatus status;
  final String createdAtLabel;
  final String notes;
  final DateTime? createdAt;
  final String? assignedTo;
  final String? clientId;
  final String? clientName;

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

  static String _formatDate(DateTime? date) {
    if (date == null) return 'Unknown';
    final now = DateTime.now();
    final diff = now.difference(date);
    if (diff.inMinutes < 60) return '${diff.inMinutes}m ago';
    if (diff.inHours < 24) return '${diff.inHours}h ago';
    if (diff.inDays < 7) return '${diff.inDays}d ago';
    return '${date.day}/${date.month}/${date.year}';
  }

  Map<String, dynamic> toMap() {
    return {
      'maidId': maidId,
      'maidName': maidName,
      'type': type.name,
      'status': status.name,
      'notes': notes,
      'createdAt': createdAt != null ? Timestamp.fromDate(createdAt!) : FieldValue.serverTimestamp(),
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
