import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/auth_state.dart';
import 'responsive_navigation_shell.dart';

/// Generic placeholder page used for admin panel sections.
///
/// [signOutRoute] is the route to navigate to after sign-out.
/// Pass the app-specific login route so there are no cross-app navigation
/// dependencies (e.g. admin passes `/admin/login`, client passes `/client/login`).
class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({
    super.key,
    required this.title,
    required this.navItems,
    this.actions = const <Widget>[],
    this.signOutRoute,
  });

  final String title;
  final List<NavItem> navItems;
  final List<Widget> actions;

  /// The route to navigate to after signing out.
  /// If null, no sign-out button is shown.
  final String? signOutRoute;

  @override
  Widget build(BuildContext context) {
    return ResponsiveNavigationShell(
      title: title,
      navItems: navItems,
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Placeholder page for navigation and architecture setup.',
                  ),
                  if (actions.isNotEmpty) ...[
                    const SizedBox(height: 16),
                    Wrap(spacing: 8, runSpacing: 8, children: actions),
                  ],
                  if (signOutRoute != null) ...[
                    const SizedBox(height: 16),
                    OutlinedButton(
                      onPressed: () {
                        AuthState.instance.signOut();
                        context.go(signOutRoute!);
                      },
                      child: const Text('Sign out (demo)'),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
