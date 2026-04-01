import 'package:flutter/material.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../shared/presentation/widgets/placeholder_page.dart';
import '../../../../shared/presentation/widgets/responsive_navigation_shell.dart';

class AdminPages {
  AdminPages._();

  static final List<NavItem> _nav = <NavItem>[
    const NavItem(label: 'Admin Dashboard', route: AppRoutes.adminDashboard),
    const NavItem(
      label: 'Maid Profile Management',
      route: AppRoutes.maidProfileManagement,
    ),
    const NavItem(
      label: 'Requests/Inquiries Management',
      route: AppRoutes.requestsManagement,
    ),
    const NavItem(
      label: 'Analytics Dashboard',
      route: AppRoutes.analyticsDashboard,
    ),
  ];

  static Widget dashboard() => PlaceholderPage(
        title: 'Admin Dashboard',
        navItems: _nav,
      );

  static Widget maidProfileManagement() => PlaceholderPage(
        title: 'Maid Profile Management',
        navItems: _nav,
      );

  static Widget requestsManagement() => PlaceholderPage(
        title: 'Requests / Inquiries Management',
        navItems: _nav,
      );

  static Widget analyticsDashboard() => PlaceholderPage(
        title: 'Analytics Dashboard',
        navItems: _nav,
      );
}
