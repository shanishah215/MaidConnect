import 'package:flutter/material.dart';

import '../../../../app/router/app_routes.dart';
import '../widgets/public_site_components.dart';

/// The primary landing page for the MaidConnect public website
class HomePage extends StatelessWidget {
  /// Default constructor for HomePage
  const HomePage({super.key});

  @override
  /// Builds the home page layout using a scaffold of stacked sections
  Widget build(BuildContext context) {
    return const PublicSiteScaffold(
      currentRoute: AppRoutes.home,
      title: 'Home',
      sections: <Widget>[
        PublicHeroSection(
          headline: 'Trusted Maids for Every Home',
          subheading:
              'MaidConnect helps families hire verified and skilled maids with confidence. Discover candidates that match your schedule, needs, and budget.',
        ),
        SizedBox(height: 28),
        SectionTitle(
          title: 'Why choose MaidConnect',
          subtitle:
              'We combine strict screening, transparent communication, and fast profile matching to make household hiring simple and trustworthy.',
        ),
        SizedBox(height: 12),
        _HomeFeatureGrid(),
        SizedBox(height: 28),
        ContactSection(),
      ],
    );
  }
}

/// A responsive grid showcasing key features of the MaidConnect service
class _HomeFeatureGrid extends StatelessWidget {
  /// Default constructor for _HomeFeatureGrid
  const _HomeFeatureGrid();

  @override
  /// Builds a grid that adjusts column count based on available horizontal space
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final int columns = constraints.maxWidth < 700
            ? 1
            : constraints.maxWidth < 1000
            ? 2
            : 3;
        return GridView.count(
          crossAxisCount: columns,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: columns == 1 ? 2.7 : 1.5,
          children: const <Widget>[
            FeatureCard(
              icon: Icons.verified_user_outlined,
              title: 'Verified Professionals',
              description:
                  'Background checks and document validation for every listed maid profile.',
            ),
            FeatureCard(
              icon: Icons.support_agent_outlined,
              title: 'Agency Support',
              description:
                  'Dedicated support from consultation to final onboarding.',
            ),
            FeatureCard(
              icon: Icons.event_available_outlined,
              title: 'Faster Hiring',
              description:
                  'Get matched profiles quickly and schedule interviews at your convenience.',
            ),
          ],
        );
      },
    );
  }
}
