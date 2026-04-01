import 'package:flutter/material.dart';

import '../../../../shared/presentation/widgets/placeholder_page.dart';
import '../../../../shared/presentation/widgets/responsive_navigation_shell.dart';
import '../../../../app/router/app_routes.dart';

class PublicPages {
  PublicPages._();

  static final List<NavItem> _nav = <NavItem>[
    const NavItem(label: 'Home', route: AppRoutes.home),
    const NavItem(label: 'About Us', route: AppRoutes.about),
    const NavItem(label: 'Services', route: AppRoutes.services),
    const NavItem(label: 'Pricing', route: AppRoutes.pricing),
    const NavItem(label: 'Contact Us', route: AppRoutes.contact),
    const NavItem(label: 'FAQs', route: AppRoutes.faqs),
    const NavItem(label: 'Client Login', route: AppRoutes.clientLogin),
    const NavItem(label: 'Admin Login', route: AppRoutes.adminLogin),
  ];

  static Widget home() => PlaceholderPage(
        title: 'Home',
        navItems: _nav,
      );

  static Widget about() => PlaceholderPage(
        title: 'About Us',
        navItems: _nav,
      );

  static Widget services() => PlaceholderPage(
        title: 'Services',
        navItems: _nav,
      );

  static Widget pricing() => PlaceholderPage(
        title: 'Pricing',
        navItems: _nav,
      );

  static Widget contact() => PlaceholderPage(
        title: 'Contact Us',
        navItems: _nav,
      );

  static Widget faqs() => PlaceholderPage(
        title: 'FAQs',
        navItems: _nav,
      );
}
