import 'package:go_router/go_router.dart';

import '../../apps/admin_app/admin_router.dart';
import '../../apps/client_app/client_router.dart';
import '../../apps/public_app/public_router.dart';
import 'auth_state.dart';

/// Root GoRouter — the single entry point that dispatches to the three
/// isolated app routers based on URL prefix:
///
///   /         → Public Website   (PublicRouter)
///   /client/* → Client Portal    (ClientRouter)
///   /admin/*  → Admin Panel      (AdminRouter)
///
/// [refreshListenable] is wired to [AuthState] so that GoRouter automatically
/// re-evaluates all redirect guards whenever auth state changes (sign-in/out).
final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  refreshListenable: AuthState.instance,
  routes: <RouteBase>[
    // ── Public website (no auth required) ────────────────────────────────────
    ...PublicRouter.routes,

    // ── Client Portal (/client/*) ─────────────────────────────────────────────
    ...ClientRouter.routes,

    // ── Admin Panel (/admin/*) ────────────────────────────────────────────────
    ...AdminRouter.routes,
  ],
);
