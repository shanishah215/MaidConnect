import 'package:flutter/material.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/router/auth_state.dart';
import '../../../../shared/presentation/widgets/placeholder_page.dart';
import '../../../../shared/presentation/widgets/responsive_navigation_shell.dart';

class AuthPages {
  AuthPages._();

  static final List<NavItem> _publicNav = <NavItem>[
    const NavItem(label: 'Home', route: AppRoutes.home),
    const NavItem(label: 'Client Login', route: AppRoutes.clientLogin),
    const NavItem(label: 'Client Register', route: AppRoutes.clientRegister),
    const NavItem(label: 'Admin Login', route: AppRoutes.adminLogin),
  ];

  static Widget clientLogin() => PlaceholderPage(
        title: 'Client Login',
        navItems: _publicNav,
        actions: [
          ElevatedButton(
            onPressed: () {
              AuthState.instance.signInClient();
            },
            child: const Text('Demo Sign In as Client'),
          ),
          ElevatedButton(
            onPressed: () {},
            child: const Text('Continue to Dashboard'),
          ),
          Builder(
            builder: (context) => FilledButton(
              onPressed: () {
                AuthState.instance.signInClient();
                Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.clientDashboard,
                );
              },
              child: const Text('Sign In + Go'),
            ),
          ),
        ],
      );

  static Widget clientRegister() => PlaceholderPage(
        title: 'Client Register',
        navItems: _publicNav,
      );

  static Widget adminLogin() => PlaceholderPage(
        title: 'Admin Login',
        navItems: _publicNav,
        actions: [
          Builder(
            builder: (context) => FilledButton(
              onPressed: () {
                AuthState.instance.signInAdmin();
                Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.adminDashboard,
                );
              },
              child: const Text('Sign In as Admin + Go'),
            ),
          ),
        ],
      );
}
