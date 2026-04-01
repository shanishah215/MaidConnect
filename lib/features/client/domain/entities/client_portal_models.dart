enum MaidAvailability { immediate, thisWeek, thisMonth }

enum ClientRequestType { callback, hire }

enum ClientRequestStatus {
  submitted,
  underReview,
  interviewScheduled,
  approved,
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
  });

  final String id;
  final String maidId;
  final String maidName;
  final ClientRequestType type;
  final ClientRequestStatus status;
  final String createdAtLabel;
  final String notes;
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
