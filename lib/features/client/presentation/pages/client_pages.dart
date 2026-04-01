import 'package:flutter/material.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../shared/presentation/widgets/responsive_navigation_shell.dart';
import 'client_dashboard_page.dart';
import 'maid_listing_page.dart';
import 'request_status_page.dart';
import 'shortlist_page.dart';

class ClientPages {
  ClientPages._();

  static final List<NavItem> _nav = <NavItem>[
    const NavItem(
      label: 'Dashboard',
      route: AppRoutes.clientDashboard,
      icon: Icons.grid_view_rounded,
    ),
    const NavItem(
      label: 'Find Maids',
      route: AppRoutes.maidListing,
      icon: Icons.search_rounded,
    ),
    const NavItem(
      label: 'Shortlist',
      route: AppRoutes.shortlist,
      icon: Icons.favorite_outline_rounded,
    ),
    const NavItem(
      label: 'Request Status',
      route: AppRoutes.requestStatus,
      icon: Icons.track_changes_outlined,
    ),
  ];

  static Widget dashboard() => ClientDashboardPage(navItems: _nav);

  static Widget maidListing() => MaidListingPage(navItems: _nav);

  static Widget shortlist() => ShortlistPage(navItems: _nav);

  static Widget requestStatus() => RequestStatusPage(navItems: _nav);
}
