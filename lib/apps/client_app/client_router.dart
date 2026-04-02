import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:maidconnect/apps/client_app/pages/client_login_page.dart';
import 'package:maidconnect/apps/client_app/pages/client_register_page.dart';

import '../../../app/router/app_routes.dart';
import '../../../app/router/auth_state.dart';
import '../../../features/client/presentation/pages/client_pages.dart';
import '../../../features/client/presentation/widgets/client_portal_shell.dart';

/// All routes that belong exclusively to the Client Portal.
///
/// URL prefix: `/client`
/// Guards: unauthenticated access to protected routes → redirect to `/client/login`
/// Isolation: zero imports from public_app or admin_app modules.
class ClientRouter {
  ClientRouter._();

  static List<RouteBase> get routes => <RouteBase>[
    // Bare /client → smart redirect based on auth state
    GoRoute(
      path: '/client',
      redirect: (context, state) => AuthState.instance.isClientAuthenticated
          ? AppRoutes.clientDashboard
          : AppRoutes.clientLogin,
    ),

    // ── Public (unauthenticated) client routes ───────────────────────────────
    GoRoute(
      path: AppRoutes.clientLogin,
      builder: (context, state) => const ClientLoginPage(),
    ),
    GoRoute(
      path: AppRoutes.clientRegister,
      builder: (context, state) => const ClientRegisterPage(),
    ),

    // ── Protected client routes (requires client auth) ───────────────────────
    ShellRoute(
      builder: (context, state, child) {
        return ClientPortalShell(child: child);
      },
      routes: [
        GoRoute(
          path: AppRoutes.clientDashboard,
          redirect: _clientGuard,
          builder: (context, state) => ClientPages.dashboard(),
        ),
        GoRoute(
          path: AppRoutes.maidListing,
          redirect: _clientGuard,
          builder: (context, state) => ClientPages.maidListing(),
        ),
        GoRoute(
          path: AppRoutes.shortlist,
          redirect: _clientGuard,
          builder: (context, state) => ClientPages.shortlist(),
        ),
        GoRoute(
          path: AppRoutes.requestStatus,
          redirect: _clientGuard,
          builder: (context, state) => ClientPages.requestStatus(),
        ),
      ],
    ),
  ];

  /// Redirect unauthenticated clients to the client login screen.
  static String? _clientGuard(BuildContext context, GoRouterState state) {
    if (AuthState.instance.isInitialising) return null; // Wait for init

    if (!AuthState.instance.isClientAuthenticated) {
      return AppRoutes.clientLogin;
    }
    return null;
  }
}
