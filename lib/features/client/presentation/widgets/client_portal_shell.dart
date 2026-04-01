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
    required this.child,
  });

  final Widget child;
  
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

  String _getTitle(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    if (location.startsWith(AppRoutes.maidListing)) return 'Find Maids';
    if (location.startsWith(AppRoutes.shortlist)) return 'Shortlist';
    if (location.startsWith(AppRoutes.requestStatus)) return 'Request Status';
    return 'Dashboard';
  }

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
        title: _getTitle(context),
        navItems: _nav,
        appBarActions: <Widget>[
          TextButton.icon(
            onPressed: () => _signOut(context),
            icon: const Icon(Icons.logout),
            label: const Text('Logout'),
          ),
          const SizedBox(width: 8),
        ],
        child: child, // Side-by-side content injected here
      ),
    );
  }
}
