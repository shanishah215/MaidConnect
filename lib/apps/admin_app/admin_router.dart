import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:maidconnect/apps/admin_app/pages/admin_login_page.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/router/auth_state.dart';
import '../../../features/admin/presentation/pages/admin_pages.dart';

/// All routes that belong exclusively to the Admin Panel.
///
/// URL prefix: `/admin`
/// Guards: unauthenticated access to protected routes → redirect to `/admin/login`
/// Isolation: zero imports from public_app or client_app modules.
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
      path: AppRoutes.requestsManagement,
      redirect: _adminGuard,
      builder: (context, state) => AdminPages.requestsManagement(),
    ),
    GoRoute(
      path: AppRoutes.analyticsDashboard,
      redirect: _adminGuard,
      builder: (context, state) => AdminPages.analyticsDashboard(),
    ),
  ];

  /// Redirect unauthenticated admins to the admin login screen.
  static String? _adminGuard(BuildContext context, GoRouterState state) {
    return AuthState.instance.isAdminAuthenticated
        ? null
        : AppRoutes.adminLogin;
  }
}
