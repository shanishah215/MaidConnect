import 'package:flutter/material.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/router/auth_state.dart';
import '../../../../shared/presentation/widgets/responsive_navigation_shell.dart';

class ClientPortalShell extends StatelessWidget {
  const ClientPortalShell({
    super.key,
    required this.title,
    required this.navItems,
    required this.child,
  });

  final String title;
  final List<NavItem> navItems;
  final Widget child;

  void _goToLogin(BuildContext context) {
    AuthState.instance.signOut();
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.clientLogin,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _goToLogin(context);
        }
      },
      child: ResponsiveNavigationShell(
        title: title,
        navItems: navItems,
        appBarActions: <Widget>[
          TextButton.icon(
            onPressed: () => _goToLogin(context),
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
          ),
          const SizedBox(width: 8),
        ],
        child: child,
      ),
    );
  }
}
