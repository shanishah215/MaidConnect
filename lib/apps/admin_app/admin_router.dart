import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:maidconnect/apps/admin_app/pages/admin_login_page.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/router/auth_state.dart';
import '../../../features/admin/presentation/pages/admin_pages.dart';
import '../../../features/admin/presentation/widgets/admin_panel_shell.dart';

/// All routes that belong exclusively to the Admin Panel.
///
/// URL prefix: `/admin`
/// Guards: unauthenticated access to protected routes → redirect to `/admin/login`
class AdminRouter {
  AdminRouter._();

  static List<RouteBase> get routes => <RouteBase>[
    // Bare /admin → smart redirect based on auth state
    GoRoute(
      path: '/admin',
      redirect: (context, state) => AuthState.instance.isAdminAuthenticated
          ? AppRoutes.adminDashboard
          : AppRoutes.adminLogin,
    ),

    // ── Public (unauthenticated) admin routes ────────────────────────────────
    GoRoute(
      path: AppRoutes.adminLogin,
      builder: (context, state) => const AdminLoginPage(),
    ),

    // ── Protected admin routes (requires admin auth) ─────────────────────────
    ShellRoute(
      builder: (context, state, child) {
        return AdminPanelShell(child: child);
      },
      routes: [
        GoRoute(
          path: AppRoutes.adminDashboard,
          redirect: _adminGuard,
          builder: (context, state) => AdminPages.dashboard(),
        ),
        GoRoute(
          path: AppRoutes.maidProfileManagement,
          redirect: _adminGuard,
          builder: (context, state) => AdminPages.maidProfileManagement(),
        ),
        GoRoute(
          path: AppRoutes.adminMaidAdd,
          redirect: _adminGuard,
          builder: (context, state) => AdminPages.maidForm(),
        ),
        GoRoute(
          path: '${AppRoutes.adminMaidEdit}/:id',
          redirect: _adminGuard,
          builder: (context, state) {
            final id = state.pathParameters['id'];
            return AdminPages.maidForm(maidId: id);
          },
        ),
        GoRoute(
          path: AppRoutes.adminClients,
          redirect: _adminGuard,
          builder: (context, state) => AdminPages.clientManagement(),
        ),
        GoRoute(
          path: AppRoutes.requestsManagement,
          redirect: _adminGuard,
          builder: (context, state) => AdminPages.requestsManagement(),
        ),
        GoRoute(
          path: AppRoutes.bulkUpload,
          redirect: _adminGuard,
          builder: (context, state) => AdminPages.bulkUpload(),
        ),
      ],
    ),
  ];

  /// Redirect unauthenticated admins to the admin login screen.
  static String? _adminGuard(BuildContext context, GoRouterState state) {
    if (AuthState.instance.isInitialising) return null; // Wait for init

    return AuthState.instance.isAdminAuthenticated
        ? null
        : AppRoutes.adminLogin;
  }
}
