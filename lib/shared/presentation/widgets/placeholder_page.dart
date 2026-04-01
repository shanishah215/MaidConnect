import 'package:flutter/material.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/router/auth_state.dart';
import 'responsive_navigation_shell.dart';

class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({
    super.key,
    required this.title,
    required this.navItems,
    this.actions = const <Widget>[],
  });

  final String title;
  final List<NavItem> navItems;
  final List<Widget> actions;

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
                  const SizedBox(height: 16),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: actions,
                  ),
                  const SizedBox(height: 16),
                  OutlinedButton(
                    onPressed: () {
                      AuthState.instance.signOut();
                      Navigator.pushReplacementNamed(context, AppRoutes.home);
                    },
                    child: const Text('Sign out (demo)'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
