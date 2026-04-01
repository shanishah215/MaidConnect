import 'package:flutter/material.dart';

class NavItem {
  const NavItem({
    required this.label,
    required this.route,
  });

  final String label;
  final String route;
}

class ResponsiveNavigationShell extends StatelessWidget {
  const ResponsiveNavigationShell({
    super.key,
    required this.title,
    required this.navItems,
    required this.child,
  });

  final String title;
  final List<NavItem> navItems;
  final Widget child;

  bool _isSelected(BuildContext context, String route) {
    final String? current = ModalRoute.of(context)?.settings.name;
    return current == route;
  }

  void _goTo(BuildContext context, String route) {
    final String? current = ModalRoute.of(context)?.settings.name;
    if (current != route) {
      Navigator.pushReplacementNamed(context, route);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isMobile = MediaQuery.of(context).size.width < 900;

    return Scaffold(
      appBar: AppBar(title: Text(title)),
      drawer: isMobile
          ? Drawer(
              child: ListView(
                children: navItems
                    .map(
                      (item) => ListTile(
                        selected: _isSelected(context, item.route),
                        title: Text(item.label),
                        onTap: () {
                          Navigator.pop(context);
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
                  selectedIndex: navItems.indexWhere(
                    (item) => _isSelected(context, item.route),
                  ),
                  onDestinationSelected: (index) {
                    _goTo(context, navItems[index].route);
                  },
                  labelType: NavigationRailLabelType.all,
                  destinations: navItems
                      .map(
                        (item) => NavigationRailDestination(
                          icon: const Icon(Icons.circle_outlined, size: 12),
                          selectedIcon:
                              const Icon(Icons.circle, size: 12),
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
