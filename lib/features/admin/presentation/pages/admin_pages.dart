import 'package:flutter/material.dart';

import 'admin_dashboard_page.dart';
import 'maid_management_page.dart';
import 'maid_form_page.dart';
import 'client_management_page.dart';
import 'request_management_page.dart';
import 'bulk_upload_page.dart';

class AdminPages {
  AdminPages._();

  static Widget dashboard() => const AdminDashboardPage();

  static Widget maidProfileManagement() => const MaidManagementPage();

  static Widget maidForm({String? maidId}) => MaidFormPage(maidId: maidId);

  static Widget clientManagement() => const ClientManagementPage();

  static Widget requestsManagement() => const RequestManagementPage();

  static Widget bulkUpload() => const BulkUploadPage();

  static Widget analyticsDashboard() => const Center(
    child: Text(
      'Analytics Detailed View - Coming Soon',
      style: TextStyle(fontSize: 18, color: Color(0xFF64748B)),
    ),
  );
}
