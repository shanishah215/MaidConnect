import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../app/router/auth_state.dart';

// ── Navigation item model ─────────────────────────────────────────────────────

class AdminNavItem {
  const AdminNavItem({
    required this.label,
    required this.route,
    required this.icon,
  });
  final String label;
  final String route;
  final IconData icon;
}

// ── Shell ─────────────────────────────────────────────────────────────────────

/// Navigation shell for the Admin Panel.
/// Dark navy sidebar, white topbar — wraps all protected admin pages.
class AdminPanelShell extends StatelessWidget {
  const AdminPanelShell({super.key, required this.child});

  final Widget child;

  static const List<_NavSection> _sections = <_NavSection>[
    _NavSection(
      title: 'MAIN',
      items: <AdminNavItem>[
        AdminNavItem(
          label: 'Dashboard',
          route: AppRoutes.adminDashboard,
          icon: Icons.grid_view_rounded,
        ),
      ],
    ),
    _NavSection(
      title: 'MANAGEMENT',
      items: <AdminNavItem>[
        AdminNavItem(
          label: 'Maid Profiles',
          route: AppRoutes.maidProfileManagement,
          icon: Icons.badge_outlined,
        ),
        AdminNavItem(
          label: 'Clients',
          route: AppRoutes.adminClients,
          icon: Icons.people_outline_rounded,
        ),
        AdminNavItem(
          label: 'Requests',
          route: AppRoutes.requestsManagement,
          icon: Icons.inbox_outlined,
        ),
      ],
    ),
    _NavSection(
      title: 'TOOLS',
      items: <AdminNavItem>[
        AdminNavItem(
          label: 'Bulk Upload',
          route: AppRoutes.bulkUpload,
          icon: Icons.upload_file_outlined,
        ),
      ],
    ),
  ];

  String _getTitle(BuildContext context) {
    final path = GoRouterState.of(context).uri.path;
    if (path.startsWith(AppRoutes.maidProfileManagement))
      return 'Maid Profiles';
    if (path.startsWith(AppRoutes.adminMaidAdd)) return 'Add Maid';
    if (path.startsWith(AppRoutes.adminClients)) return 'Clients';
    if (path.startsWith(AppRoutes.requestsManagement))
      return 'Requests & Inquiries';
    if (path.startsWith(AppRoutes.bulkUpload)) return 'Bulk Upload';
    return 'Admin';
  }

  void _signOut(BuildContext context) {
    AuthState.instance.signOut();
    context.go(AppRoutes.adminLogin);
  }

  bool _isSelected(BuildContext context, String route) {
    final path = GoRouterState.of(context).uri.path;
    return path.startsWith(route);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 900;
    final title = _getTitle(context);

    if (isMobile) {
      return _MobileShell(
        title: title,
        sections: _sections,
        isSelected: (r) => _isSelected(context, r),
        onSignOut: () => _signOut(context),
        child: child,
      );
    }

    return _DesktopShell(
      title: title,
      sections: _sections,
      isSelected: (r) => _isSelected(context, r),
      onSignOut: () => _signOut(context),
      child: child,
    );
  }
}

class _NavSection {
  const _NavSection({required this.title, required this.items});
  final String title;
  final List<AdminNavItem> items;
}

// ── Desktop layout ────────────────────────────────────────────────────────────

class _DesktopShell extends StatelessWidget {
  const _DesktopShell({
    required this.title,
    required this.sections,
    required this.isSelected,
    required this.onSignOut,
    required this.child,
  });

  final String title;
  final List<_NavSection> sections;
  final bool Function(String) isSelected;
  final VoidCallback onSignOut;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          // ── Dark sidebar ──────────────────────────────────────────────────
          Container(
            width: 260,
            color: const Color(0xFF0F172A),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Brand
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 28, 24, 0),
                  child: Row(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: <Color>[
                              Color(0xFF6366F1),
                              Color(0xFF2563EB),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Icon(
                          Icons.cleaning_services_rounded,
                          color: Colors.white,
                          size: 18,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Text(
                            'MaidConnect',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                              fontSize: 14,
                              letterSpacing: -0.3,
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 1,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF6366F1).withOpacity(0.3),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: const Text(
                              'Admin',
                              style: TextStyle(
                                color: Color(0xFFA5B4FC),
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 32),
                // Nav sections
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    children: sections.map((_NavSection sec) {
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.fromLTRB(12, 12, 12, 6),
                            child: Text(
                              sec.title,
                              style: const TextStyle(
                                color: Color(0xFF475569),
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.2,
                              ),
                            ),
                          ),
                          ...sec.items.map(
                            (AdminNavItem item) => _SidebarNavItem(
                              item: item,
                              isSelected: isSelected(item.route),
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                      );
                    }).toList(),
                  ),
                ),
                // Admin user footer
                Container(
                  margin: const EdgeInsets.all(12),
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: <Color>[
                              Color(0xFF6366F1),
                              Color(0xFF2563EB),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Center(
                          child: Text(
                            'A',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Admin User',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            Text(
                              'admin@maidconnect.lk',
                              style: TextStyle(
                                color: Color(0xFF94A3B8),
                                fontSize: 11,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                      IconButton(
                        onPressed: onSignOut,
                        icon: const Icon(
                          Icons.logout,
                          color: Color(0xFF64748B),
                          size: 18,
                        ),
                        tooltip: 'Sign out',
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // ── Main content area ─────────────────────────────────────────────
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // Topbar
                Container(
                  height: 68,
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    border: Border(
                      bottom: BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                  ),
                  child: Row(
                    children: <Widget>[
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: -0.5,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      const Spacer(),
                      OutlinedButton.icon(
                        onPressed: onSignOut,
                        icon: const Icon(Icons.logout, size: 16),
                        label: const Text('Sign Out'),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF64748B),
                          side: const BorderSide(color: Color(0xFFE2E8F0)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 8,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Page body
                Expanded(child: child),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ── Mobile layout ─────────────────────────────────────────────────────────────

class _MobileShell extends StatelessWidget {
  const _MobileShell({
    required this.title,
    required this.sections,
    required this.isSelected,
    required this.onSignOut,
    required this.child,
  });

  final String title;
  final List<_NavSection> sections;
  final bool Function(String) isSelected;
  final VoidCallback onSignOut;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18),
        ),
        elevation: 0,
        bottom: const PreferredSize(
          preferredSize: Size.fromHeight(1),
          child: Divider(height: 1, color: Color(0xFFE2E8F0)),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.logout, color: Color(0xFF64748B)),
            onPressed: onSignOut,
          ),
        ],
      ),
      drawer: Drawer(
        backgroundColor: const Color(0xFF0F172A),
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 8, 12, 20),
                child: Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(7),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: <Color>[Color(0xFF6366F1), Color(0xFF2563EB)],
                        ),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.cleaning_services_rounded,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 10),
                    const Text(
                      'MaidConnect Admin',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ),
              ...sections.expand(
                (_NavSection sec) => <Widget>[
                  Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 4),
                    child: Text(
                      sec.title,
                      style: const TextStyle(
                        color: Color(0xFF475569),
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 1.2,
                      ),
                    ),
                  ),
                  ...sec.items.map(
                    (AdminNavItem item) => _SidebarNavItem(
                      item: item,
                      isSelected: isSelected(item.route),
                      onTap: () => Navigator.pop(context),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
      backgroundColor: const Color(0xFFF8FAFC),
      body: child,
    );
  }
}

// ── Sidebar nav item ──────────────────────────────────────────────────────────

class _SidebarNavItem extends StatefulWidget {
  const _SidebarNavItem({
    required this.item,
    required this.isSelected,
    this.onTap,
  });

  final AdminNavItem item;
  final bool isSelected;
  final VoidCallback? onTap;

  @override
  State<_SidebarNavItem> createState() => _SidebarNavItemState();
}

class _SidebarNavItemState extends State<_SidebarNavItem> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap ?? () => context.go(widget.item.route),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          margin: const EdgeInsets.only(bottom: 2),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: widget.isSelected
                ? const Color(0xFF1E293B)
                : _hovered
                ? const Color(0xFF1E293B).withOpacity(0.5)
                : Colors.transparent,
          ),
          child: Row(
            children: <Widget>[
              if (widget.isSelected)
                Container(
                  width: 3,
                  height: 18,
                  margin: const EdgeInsets.only(right: 11),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: <Color>[Color(0xFF6366F1), Color(0xFF2563EB)],
                    ),
                    borderRadius: BorderRadius.circular(2),
                  ),
                )
              else
                const SizedBox(width: 14),
              Icon(
                widget.item.icon,
                size: 18,
                color: widget.isSelected
                    ? const Color(0xFFA5B4FC)
                    : const Color(0xFF64748B),
              ),
              const SizedBox(width: 12),
              Text(
                widget.item.label,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: widget.isSelected
                      ? FontWeight.w600
                      : FontWeight.w400,
                  color: widget.isSelected
                      ? Colors.white
                      : const Color(0xFF94A3B8),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
