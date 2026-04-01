import 'package:flutter/material.dart';

import 'client_dashboard_page.dart';
import 'maid_listing_page.dart';
import 'request_status_page.dart';
import 'shortlist_page.dart';

class ClientPages {
  ClientPages._();

  static Widget dashboard() => const ClientDashboardPage();

  static Widget maidListing() => const MaidListingPage();

  static Widget shortlist() => const ShortlistPage();

  static Widget requestStatus() => const RequestStatusPage();
}
