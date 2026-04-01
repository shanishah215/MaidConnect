import 'package:go_router/go_router.dart';

import '../../app/router/app_routes.dart';
import '../../features/public/presentation/pages/public_pages.dart';

/// Routes that belong exclusively to the public-facing website.
/// Accessible at `/`, `/about`, `/services`, `/pricing`, `/contact`, `/faqs`.
/// No authentication required. No client or admin references.
class PublicRouter {
  PublicRouter._();

  static List<GoRoute> get routes => <GoRoute>[
    GoRoute(
      path: AppRoutes.home,
      builder: (context, state) => PublicPages.home(),
    ),
    GoRoute(
      path: AppRoutes.about,
      builder: (context, state) => PublicPages.about(),
    ),
    GoRoute(
      path: AppRoutes.services,
      builder: (context, state) => PublicPages.services(),
    ),
    GoRoute(
      path: AppRoutes.pricing,
      builder: (context, state) => PublicPages.pricing(),
    ),
    GoRoute(
      path: AppRoutes.contact,
      builder: (context, state) => PublicPages.contact(),
    ),
    GoRoute(
      path: AppRoutes.faqs,
      builder: (context, state) => PublicPages.faqs(),
    ),
  ];
}
