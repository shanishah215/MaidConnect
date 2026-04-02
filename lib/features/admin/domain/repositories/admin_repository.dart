import '../entities/admin_models.dart';

abstract class AdminRepository {
  Future<List<AdminMaidProfile>> getMaidProfiles();
  Future<List<AdminClient>> getClients();
  Future<List<ClientInquiry>> getInquiries();
  Future<AnalyticsSnapshot> getAnalytics();
}
