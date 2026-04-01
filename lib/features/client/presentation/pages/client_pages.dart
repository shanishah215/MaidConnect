import 'package:flutter/material.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../shared/presentation/widgets/placeholder_page.dart';
import '../../../../shared/presentation/widgets/responsive_navigation_shell.dart';

class ClientPages {
  ClientPages._();

  static final List<NavItem> _nav = <NavItem>[
    const NavItem(label: 'Client Dashboard', route: AppRoutes.clientDashboard),
    const NavItem(label: 'Maid Listing/Search', route: AppRoutes.maidListing),
    const NavItem(label: 'Shortlist/Favorites', route: AppRoutes.shortlist),
    const NavItem(
      label: 'Request Status Tracking',
      route: AppRoutes.requestStatus,
    ),
  ];

  static Widget dashboard() => PlaceholderPage(
        title: 'Client Dashboard',
        navItems: _nav,
      );

  static Widget maidListing() => PlaceholderPage(
        title: 'Maid Listing / Search',
        navItems: _nav,
      );

  static Widget shortlist() => PlaceholderPage(
        title: 'Shortlist / Favorites',
        navItems: _nav,
      );

  static Widget requestStatus() => PlaceholderPage(
        title: 'Request Status Tracking',
        navItems: _nav,
      );
}
