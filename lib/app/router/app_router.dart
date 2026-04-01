import 'package:flutter/material.dart';

import '../../features/admin/presentation/pages/admin_pages.dart';
import '../../features/auth/presentation/pages/auth_pages.dart';
import '../../features/client/presentation/pages/client_pages.dart';
import '../../features/public/presentation/pages/public_pages.dart';
import '../../shared/presentation/screens/not_found_screen.dart';
import 'app_routes.dart';
import 'route_guard.dart';

class AppRouter {
  AppRouter._();

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final String routeName = settings.name ?? AppRoutes.home;
    final String? redirect = RouteGuard.redirectFor(routeName);

    if (redirect != null && redirect != routeName) {
      return MaterialPageRoute<void>(
        settings: RouteSettings(name: redirect),
        builder: (_) => _buildPage(redirect),
      );
    }

    return MaterialPageRoute<void>(
      settings: settings,
      builder: (_) => _buildPage(routeName),
    );
  }

  static Widget _buildPage(String routeName) {
    switch (routeName) {
      case AppRoutes.home:
        return PublicPages.home();
      case AppRoutes.about:
        return PublicPages.about();
      case AppRoutes.services:
        return PublicPages.services();
      case AppRoutes.pricing:
        return PublicPages.pricing();
      case AppRoutes.contact:
        return PublicPages.contact();
      case AppRoutes.faqs:
        return PublicPages.faqs();
      case AppRoutes.clientLogin:
        return AuthPages.clientLogin();
      case AppRoutes.clientRegister:
        return AuthPages.clientRegister();
      case AppRoutes.clientDashboard:
        return ClientPages.dashboard();
      case AppRoutes.maidListing:
        return ClientPages.maidListing();
      case AppRoutes.shortlist:
        return ClientPages.shortlist();
      case AppRoutes.requestStatus:
        return ClientPages.requestStatus();
      case AppRoutes.adminLogin:
        return AuthPages.adminLogin();
      case AppRoutes.adminDashboard:
        return AdminPages.dashboard();
      case AppRoutes.maidProfileManagement:
        return AdminPages.maidProfileManagement();
      case AppRoutes.requestsManagement:
        return AdminPages.requestsManagement();
      case AppRoutes.analyticsDashboard:
        return AdminPages.analyticsDashboard();
      default:
        return const NotFoundScreen();
    }
  }
}
