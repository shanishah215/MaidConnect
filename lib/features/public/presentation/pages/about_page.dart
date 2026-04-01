import 'package:flutter/material.dart';

import '../../../../app/router/app_routes.dart';
import '../widgets/public_site_components.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PublicSiteScaffold(
      currentRoute: AppRoutes.about,
      title: 'About Us',
      sections: <Widget>[
        SectionTitle(
          title: 'About MaidConnect',
          subtitle:
              'We are a maid agency platform focused on safe, respectful, and professional home staffing for modern families.',
        ),
        SizedBox(height: 12),
        _AboutStoryCard(),
        SizedBox(height: 24),
        SectionTitle(
          title: 'Our credibility',
          subtitle:
              'Processes built for safety and trust across every household placement.',
        ),
        SizedBox(height: 12),
        _AboutTrustGrid(),
      ],
    );
  }
}

class _AboutStoryCard extends StatelessWidget {
  const _AboutStoryCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5EAF3)),
      ),
      child: const Text(
        'MaidConnect was created to bridge the trust gap between households and domestic staffing agencies. Our mission is to make the hiring journey more transparent through verified profiles, professional screening, and guided placements. We support families from the first consultation to successful onboarding.',
        style: TextStyle(height: 1.5),
      ),
    );
  }
}

class _AboutTrustGrid extends StatelessWidget {
  const _AboutTrustGrid();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final int columns = constraints.maxWidth < 820 ? 1 : 2;
        return GridView.count(
          crossAxisCount: columns,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: columns == 1 ? 2.5 : 2.1,
          children: const <Widget>[
            FeatureCard(
              icon: Icons.rule_folder_outlined,
              title: 'Standardized Screening',
              description:
                  'Each candidate passes identity and experience checks before listing.',
            ),
            FeatureCard(
              icon: Icons.handshake_outlined,
              title: 'Ethical Hiring Approach',
              description:
                  'We promote transparent terms and respectful working conditions.',
            ),
            FeatureCard(
              icon: Icons.groups_2_outlined,
              title: 'Placement Expertise',
              description:
                  'Our team handles matching based on role fit, schedule, and preferences.',
            ),
            FeatureCard(
              icon: Icons.star_outline,
              title: 'Long-Term Satisfaction',
              description:
                  'Post-placement follow-up helps ensure stable and positive outcomes.',
            ),
          ],
        );
      },
    );
  }
}
