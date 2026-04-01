import '../../domain/repositories/client_repository.dart';
import '../../domain/entities/client_portal_models.dart';

class ClientRepositoryImpl implements ClientRepository {
  @override
  Future<List<MaidProfile>> getMaidProfiles() async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return _maids;
  }

  @override
  Future<List<ClientRequest>> getClientRequests() async {
    await Future<void>.delayed(const Duration(milliseconds: 350));
    return _seedRequests;
  }
}

const List<MaidProfile> _maids = <MaidProfile>[
  MaidProfile(
    id: 'maid-01',
    name: 'Anita Perera',
    age: 29,
    experienceYears: 6,
    skills: <String>['Childcare', 'Cooking', 'Laundry'],
    languages: <String>['English', 'Sinhala'],
    availability: MaidAvailability.immediate,
    bio: 'Warm and dependable caregiver with strong childcare experience.',
    location: 'Colombo 05',
    monthlyRate: 550,
    rating: 4.8,
  ),
  MaidProfile(
    id: 'maid-02',
    name: 'Maya Fernando',
    age: 35,
    experienceYears: 10,
    skills: <String>['Elder care', 'Medication reminders', 'Housekeeping'],
    languages: <String>['English', 'Tamil'],
    availability: MaidAvailability.thisWeek,
    bio: 'Experienced in elder support, cleanliness, and calm communication.',
    location: 'Dehiwala',
    monthlyRate: 680,
    rating: 4.9,
  ),
  MaidProfile(
    id: 'maid-03',
    name: 'Roshni Silva',
    age: 26,
    experienceYears: 4,
    skills: <String>['Pet care', 'Cooking', 'Deep cleaning'],
    languages: <String>['English'],
    availability: MaidAvailability.thisMonth,
    bio: 'Detail-oriented professional who keeps homes organized and hygienic.',
    location: 'Nugegoda',
    monthlyRate: 500,
    rating: 4.6,
  ),
  MaidProfile(
    id: 'maid-04',
    name: 'Dilani Jayasinghe',
    age: 32,
    experienceYears: 8,
    skills: <String>['Childcare', 'Tutoring support', 'Meal prep'],
    languages: <String>['English', 'Sinhala', 'Hindi'],
    availability: MaidAvailability.immediate,
    bio: 'Trusted household support specialist with strong childcare routine.',
    location: 'Rajagiriya',
    monthlyRate: 620,
    rating: 4.7,
  ),
  MaidProfile(
    id: 'maid-05',
    name: 'Fathima Azeez',
    age: 30,
    experienceYears: 7,
    skills: <String>['Housekeeping', 'Laundry', 'Infant care'],
    languages: <String>['English', 'Tamil'],
    availability: MaidAvailability.thisWeek,
    bio: 'Patient and organized, with experience supporting busy families.',
    location: 'Mount Lavinia',
    monthlyRate: 590,
    rating: 4.8,
  ),
];

const List<ClientRequest> _seedRequests = <ClientRequest>[
  ClientRequest(
    id: 'REQ-1001',
    maidId: 'maid-02',
    maidName: 'Maya Fernando',
    type: ClientRequestType.hire,
    status: ClientRequestStatus.interviewScheduled,
    createdAtLabel: '2 days ago',
    notes: 'Prefers weekday morning interview.',
  ),
  ClientRequest(
    id: 'REQ-1002',
    maidId: 'maid-04',
    maidName: 'Dilani Jayasinghe',
    type: ClientRequestType.callback,
    status: ClientRequestStatus.underReview,
    createdAtLabel: 'Today',
    notes: 'Needs bilingual support.',
  ),
];
