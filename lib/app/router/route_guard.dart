import 'app_routes.dart';
import 'auth_state.dart';

class RouteGuard {
  RouteGuard._();

  static String? redirectFor(String routeName) {
    final RouteAccess access =
        AppRoutes.accessControl[routeName] ?? RouteAccess.public;
    final AuthState authState = AuthState.instance;

    switch (access) {
      case RouteAccess.public:
        return null;
      case RouteAccess.clientOnly:
        return authState.isClientAuthenticated ? null : AppRoutes.clientLogin;
      case RouteAccess.adminOnly:
        return authState.isAdminAuthenticated ? null : AppRoutes.adminLogin;
    }
  }
}
