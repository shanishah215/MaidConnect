import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class NavItem {
  const NavItem({
    required this.label,
    required this.route,
    this.icon = Icons.circle_outlined,
  });

  final String label;
  final String route;
  final IconData icon;
}

class ResponsiveNavigationShell extends StatelessWidget {
  const ResponsiveNavigationShell({
    super.key,
    required this.title,
    required this.navItems,
    required this.child,
    this.appBarActions = const <Widget>[],
  });

  final String title;
  final List<NavItem> navItems;
  final Widget child;
  final List<Widget> appBarActions;

  bool _isSelected(BuildContext context, String route) {
    // Use GoRouter's current URI path for accurate selection state
    final String location = GoRouterState.of(context).uri.path;
    return location == route;
  }

  void _goTo(BuildContext context, String route) {
    final String current = GoRouterState.of(context).uri.path;
    if (current != route) {
      context.go(route);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 900;

    return Scaffold(
      appBar: AppBar(title: Text(title), actions: appBarActions, elevation: 0),
      drawer: isMobile
          ? Drawer(
              child: ListView(
                children: navItems
                    .map(
                      (item) => ListTile(
                        selected: _isSelected(context, item.route),
                        leading: Icon(item.icon),
                        title: Text(item.label),
                        onTap: () {
                          Navigator.pop(context); // close drawer
                          _goTo(context, item.route);
                        },
                      ),
                    )
                    .toList(),
              ),
            )
          : null,
      body: isMobile
          ? child
          : Row(
              children: [
                NavigationRail(
                  backgroundColor: Colors.white,
                  selectedIndex: () {
                    final int idx = navItems.indexWhere(
                      (item) => _isSelected(context, item.route),
                    );
                    return idx < 0 ? 0 : idx;
                  }(),
                  onDestinationSelected: (index) {
                    _goTo(context, navItems[index].route);
                  },
                  labelType: NavigationRailLabelType.all,
                  destinations: navItems
                      .map(
                        (item) => NavigationRailDestination(
                          icon: Icon(item.icon),
                          selectedIcon: Icon(
                            item.icon,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          label: Text(item.label),
                        ),
                      )
                      .toList(),
                ),
                const VerticalDivider(width: 1),
                Expanded(child: child),
              ],
            ),
    );
  }
}
