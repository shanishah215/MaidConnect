import 'package:flutter/material.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../shared/presentation/widgets/placeholder_page.dart';
import '../../../../shared/presentation/widgets/responsive_navigation_shell.dart';

class AdminPages {
  AdminPages._();

  static final List<NavItem> _nav = <NavItem>[
    const NavItem(
      label: 'Dashboard',
      route: AppRoutes.adminDashboard,
      icon: Icons.dashboard_outlined,
    ),
    const NavItem(
      label: 'Maid Profiles',
      route: AppRoutes.maidProfileManagement,
      icon: Icons.people_outline,
    ),
    const NavItem(
      label: 'Requests',
      route: AppRoutes.requestsManagement,
      icon: Icons.inbox_outlined,
    ),
    const NavItem(
      label: 'Analytics',
      route: AppRoutes.analyticsDashboard,
      icon: Icons.bar_chart_outlined,
    ),
  ];

  static Widget dashboard() => PlaceholderPage(
        title: 'Admin Dashboard',
        navItems: _nav,
        signOutRoute: AppRoutes.adminLogin,
      );

  static Widget maidProfileManagement() => PlaceholderPage(
        title: 'Maid Profile Management',
        navItems: _nav,
        signOutRoute: AppRoutes.adminLogin,
      );

  static Widget requestsManagement() => PlaceholderPage(
        title: 'Requests / Inquiries Management',
        navItems: _nav,
        signOutRoute: AppRoutes.adminLogin,
      );

  static Widget analyticsDashboard() => PlaceholderPage(
        title: 'Analytics Dashboard',
        navItems: _nav,
        signOutRoute: AppRoutes.adminLogin,
      );
}
