enum RouteAccess {
  public,
  clientOnly,
  adminOnly,
}

class AppRoutes {
  AppRoutes._();

  static const String home = '/';
  static const String about = '/about';
  static const String services = '/services';
  static const String pricing = '/pricing';
  static const String contact = '/contact';
  static const String faqs = '/faqs';

  static const String clientLogin = '/client/login';
  static const String clientRegister = '/client/register';
  static const String clientDashboard = '/client/dashboard';
  static const String maidListing = '/client/maids';
  static const String shortlist = '/client/shortlist';
  static const String requestStatus = '/client/requests/status';

  static const String adminLogin = '/admin/login';
  static const String adminDashboard = '/admin/dashboard';
  static const String maidProfileManagement = '/admin/maids';
  static const String requestsManagement = '/admin/requests';
  static const String analyticsDashboard = '/admin/analytics';

  static const String notFound = '/404';

  static const Map<String, RouteAccess> accessControl = <String, RouteAccess>{
    home: RouteAccess.public,
    about: RouteAccess.public,
    services: RouteAccess.public,
    pricing: RouteAccess.public,
    contact: RouteAccess.public,
    faqs: RouteAccess.public,
    clientLogin: RouteAccess.public,
    clientRegister: RouteAccess.public,
    adminLogin: RouteAccess.public,
    clientDashboard: RouteAccess.clientOnly,
    maidListing: RouteAccess.clientOnly,
    shortlist: RouteAccess.clientOnly,
    requestStatus: RouteAccess.clientOnly,
    adminDashboard: RouteAccess.adminOnly,
    maidProfileManagement: RouteAccess.adminOnly,
    requestsManagement: RouteAccess.adminOnly,
    analyticsDashboard: RouteAccess.adminOnly,
  };
}
