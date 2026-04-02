import '../entities/admin_models.dart';

abstract class AdminRepository {
  Future<List<AdminMaidProfile>> getMaidProfiles();
  Stream<List<AdminMaidProfile>> getMaidProfilesStream();
  Future<List<AdminClient>> getClients();
  Future<List<ClientInquiry>> getInquiries();
  Stream<List<ClientInquiry>> getInquiriesStream();
  Future<AnalyticsSnapshot> getAnalytics();

  // CRUD Operations for Maids
  Future<String> createMaidProfile(AdminMaidProfile maid);
  Future<void> updateMaidProfile(AdminMaidProfile maid);
  Future<void> deleteMaidProfile(String id);

  // Inquiry Management
  Future<void> updateInquiryStatus(String id, InquiryStatus status, {String? assignedTo});
}
