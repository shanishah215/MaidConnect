import '../../domain/entities/admin_models.dart';
import '../../domain/repositories/admin_repository.dart';

class AdminRepositoryImpl implements AdminRepository {
  @override
  Future<List<AdminMaidProfile>> getMaidProfiles() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return _seedMaids;
  }

  @override
  Future<List<AdminClient>> getClients() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return _seedClients;
  }

  @override
  Future<List<ClientInquiry>> getInquiries() async {
    await Future<void>.delayed(const Duration(milliseconds: 300));
    return _seedInquiries;
  }

  @override
  Future<AnalyticsSnapshot> getAnalytics() async {
    await Future<void>.delayed(const Duration(milliseconds: 200));
    return const AnalyticsSnapshot(
      totalUsers: 142,
      activeMaids: 38,
      activeRequests: 24,
      conversions: 87,
      pendingApprovals: 7,
      thisMonthRegistrations: 19,
    );
  }
}

// ── Seed Maid Profiles ────────────────────────────────────────────────────────

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
    createdAt: '2024-01-15',
    documents: const <MaidDocument>[
      MaidDocument(name: 'Passport_Anita.pdf', type: AdminMaidDocType.passport, uploadedAt: '2024-01-15'),
      MaidDocument(name: 'Medical_Cert.pdf', type: AdminMaidDocType.medicalCert, uploadedAt: '2024-01-16'),
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
    createdAt: '2023-11-03',
    documents: const <MaidDocument>[
      MaidDocument(name: 'Passport_Maya.pdf', type: AdminMaidDocType.passport, uploadedAt: '2023-11-03'),
      MaidDocument(name: 'Work_Permit.pdf', type: AdminMaidDocType.workPermit, uploadedAt: '2023-11-04'),
      MaidDocument(name: 'Reference_Letter.pdf', type: AdminMaidDocType.reference, uploadedAt: '2023-11-05'),
    ],
  ),
  AdminMaidProfile(
    id: 'maid-03',
    name: 'Roshni Silva',
    age: 26,
    nationality: 'Sri Lankan',
    skills: <String>['Pet Care', 'Cooking', 'Deep Cleaning'],
    experienceYears: 4,
    languages: <String>['English'],
    availabilityStatus: AdminMaidAvailability.unavailable,
    bio: 'Detail-oriented professional who keeps homes organized and hygienic.',
    monthlyRate: 500,
    createdAt: '2024-03-08',
  ),
  AdminMaidProfile(
    id: 'maid-04',
    name: 'Dilani Jayasinghe',
    age: 32,
    nationality: 'Sri Lankan',
    skills: <String>['Childcare', 'Tutoring Support', 'Meal Prep'],
    experienceYears: 8,
    languages: <String>['English', 'Sinhala', 'Hindi'],
    availabilityStatus: AdminMaidAvailability.available,
    bio: 'Trusted household support specialist with strong childcare routine.',
    monthlyRate: 620,
    createdAt: '2023-09-20',
    documents: const <MaidDocument>[
      MaidDocument(name: 'Passport_Dilani.pdf', type: AdminMaidDocType.passport, uploadedAt: '2023-09-20'),
    ],
  ),
  AdminMaidProfile(
    id: 'maid-05',
    name: 'Fathima Azeez',
    age: 30,
    nationality: 'Sri Lankan',
    skills: <String>['Housekeeping', 'Laundry', 'Infant Care'],
    experienceYears: 7,
    languages: <String>['English', 'Tamil'],
    availabilityStatus: AdminMaidAvailability.onLeave,
    bio: 'Patient and organized, with experience supporting busy families.',
    monthlyRate: 590,
    createdAt: '2024-02-11',
  ),
  AdminMaidProfile(
    id: 'maid-06',
    name: 'Nirmala Kumari',
    age: 38,
    nationality: 'Indian',
    skills: <String>['Housekeeping', 'Cooking', 'Grocery Shopping'],
    experienceYears: 12,
    languages: <String>['English', 'Hindi', 'Tamil'],
    availabilityStatus: AdminMaidAvailability.available,
    bio: 'Reliable and experienced, skilled in all household tasks.',
    monthlyRate: 720,
    createdAt: '2023-07-01',
    documents: const <MaidDocument>[
      MaidDocument(name: 'Passport_Nirmala.pdf', type: AdminMaidDocType.passport, uploadedAt: '2023-07-01'),
      MaidDocument(name: 'Work_Permit.pdf', type: AdminMaidDocType.workPermit, uploadedAt: '2023-07-02'),
    ],
  ),
  AdminMaidProfile(
    id: 'maid-07',
    name: 'Santha Weerasinghe',
    age: 42,
    nationality: 'Sri Lankan',
    skills: <String>['Elder Care', 'Childcare', 'Driving'],
    experienceYears: 15,
    languages: <String>['English', 'Sinhala'],
    availabilityStatus: AdminMaidAvailability.available,
    bio: 'Highly experienced with excellent references from previous employers.',
    monthlyRate: 800,
    createdAt: '2023-05-14',
  ),
  AdminMaidProfile(
    id: 'maid-08',
    name: 'Priya Nadarajan',
    age: 27,
    nationality: 'Sri Lankan',
    skills: <String>['Infant Care', 'Cooking', 'Laundry'],
    experienceYears: 3,
    languages: <String>['Tamil', 'English'],
    availabilityStatus: AdminMaidAvailability.unavailable,
    bio: 'Young and energetic, quick learner with passion for childcare.',
    monthlyRate: 480,
    createdAt: '2024-04-01',
  ),
];

// ── Seed Clients ──────────────────────────────────────────────────────────────

const List<AdminClient> _seedClients = <AdminClient>[
  AdminClient(
    id: 'cli-01',
    name: 'Priya Sharma',
    email: 'priya.sharma@gmail.com',
    phone: '+94 77 123 4567',
    registeredAt: '2024-01-20',
    status: AdminClientStatus.active,
    totalRequests: 3,
  ),
  AdminClient(
    id: 'cli-02',
    name: 'Rohan Mendis',
    email: 'rohan.m@outlook.com',
    phone: '+94 71 234 5678',
    registeredAt: '2024-02-05',
    status: AdminClientStatus.active,
    totalRequests: 1,
  ),
  AdminClient(
    id: 'cli-03',
    name: 'Aisha Farook',
    email: 'aisha.f@yahoo.com',
    phone: '+94 76 345 6789',
    registeredAt: '2024-02-18',
    status: AdminClientStatus.active,
    totalRequests: 2,
  ),
  AdminClient(
    id: 'cli-04',
    name: 'Kumara Bandara',
    email: 'k.bandara@gmail.com',
    phone: '+94 72 456 7890',
    registeredAt: '2023-12-10',
    status: AdminClientStatus.suspended,
    totalRequests: 0,
  ),
  AdminClient(
    id: 'cli-05',
    name: 'Sandya Perera',
    email: 'sandya.p@gmail.com',
    phone: '+94 70 567 8901',
    registeredAt: '2024-03-01',
    status: AdminClientStatus.active,
    totalRequests: 1,
  ),
  AdminClient(
    id: 'cli-06',
    name: 'Malik Cassim',
    email: 'malik.c@gmail.com',
    phone: '+94 75 678 9012',
    registeredAt: '2024-03-22',
    status: AdminClientStatus.active,
    totalRequests: 2,
  ),
];

// ── Seed Inquiries ────────────────────────────────────────────────────────────

final List<ClientInquiry> _seedInquiries = <ClientInquiry>[
  ClientInquiry(
    id: 'INQ-1001',
    clientId: 'cli-01',
    clientName: 'Priya Sharma',
    maidId: 'maid-02',
    maidName: 'Maya Fernando',
    type: InquiryType.hire,
    status: InquiryStatus.approved,
    createdAt: '2024-03-28',
    notes: 'Prefers weekday morning interview.',
    assignedTo: 'Maya Fernando',
  ),
  ClientInquiry(
    id: 'INQ-1002',
    clientId: 'cli-01',
    clientName: 'Priya Sharma',
    maidId: 'maid-04',
    maidName: 'Dilani Jayasinghe',
    type: InquiryType.callback,
    status: InquiryStatus.pending,
    createdAt: '2024-03-30',
    notes: 'Needs bilingual support for children.',
  ),
  ClientInquiry(
    id: 'INQ-1003',
    clientId: 'cli-02',
    clientName: 'Rohan Mendis',
    maidId: 'maid-01',
    maidName: 'Anita Perera',
    type: InquiryType.hire,
    status: InquiryStatus.pending,
    createdAt: '2024-03-31',
    notes: 'Looking for full-time helper.',
  ),
  ClientInquiry(
    id: 'INQ-1004',
    clientId: 'cli-03',
    clientName: 'Aisha Farook',
    maidId: 'maid-06',
    maidName: 'Nirmala Kumari',
    type: InquiryType.hire,
    status: InquiryStatus.assigned,
    createdAt: '2024-03-25',
    notes: 'Requires cooking skills essential.',
    assignedTo: 'Nirmala Kumari',
  ),
  ClientInquiry(
    id: 'INQ-1005',
    clientId: 'cli-05',
    clientName: 'Sandya Perera',
    maidId: 'maid-07',
    maidName: 'Santha Weerasinghe',
    type: InquiryType.callback,
    status: InquiryStatus.rejected,
    createdAt: '2024-03-20',
    notes: 'Budget constraint.',
  ),
  ClientInquiry(
    id: 'INQ-1006',
    clientId: 'cli-06',
    clientName: 'Malik Cassim',
    maidId: 'maid-05',
    maidName: 'Fathima Azeez',
    type: InquiryType.hire,
    status: InquiryStatus.pending,
    createdAt: '2024-04-01',
    notes: 'Wants Tamil speaking maid.',
  ),
  ClientInquiry(
    id: 'INQ-1007',
    clientId: 'cli-06',
    clientName: 'Malik Cassim',
    maidId: 'maid-03',
    maidName: 'Roshni Silva',
    type: InquiryType.callback,
    status: InquiryStatus.approved,
    createdAt: '2024-03-15',
    notes: 'Pet-friendly home.',
  ),
  ClientInquiry(
    id: 'INQ-1008',
    clientId: 'cli-02',
    clientName: 'Rohan Mendis',
    maidId: 'maid-08',
    maidName: 'Priya Nadarajan',
    type: InquiryType.hire,
    status: InquiryStatus.pending,
    createdAt: '2024-04-02',
    notes: 'Young family with infant.',
  ),
];
