import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/router/auth_state.dart';
import '../../../../shared/presentation/widgets/responsive_navigation_shell.dart';

/// Navigation shell for the Client Portal.
/// Sign-out redirects to /client/login — strictly within the client module.
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

  void _signOut(BuildContext context) {
    AuthState.instance.signOut();
    context.go(AppRoutes.clientLogin);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          _signOut(context);
        }
      },
      child: ResponsiveNavigationShell(
        title: title,
        navItems: navItems,
        appBarActions: <Widget>[
          TextButton.icon(
            onPressed: () => _signOut(context),
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
