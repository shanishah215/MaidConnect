import 'package:flutter/material.dart';

import '../../../../app/router/app_routes.dart';
import '../widgets/public_site_components.dart';

class ServicesPage extends StatelessWidget {
  const ServicesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PublicSiteScaffold(
      currentRoute: AppRoutes.services,
      title: 'Services',
      sections: <Widget>[
        SectionTitle(
          title: 'Our Services',
          subtitle:
              'Flexible household staffing options designed for daily support, childcare assistance, and specialized home care.',
        ),
        SizedBox(height: 12),
        _ServicesGrid(),
        SizedBox(height: 24),
        ContactSection(),
      ],
    );
  }
}

class _ServicesGrid extends StatelessWidget {
  const _ServicesGrid();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final int columns = constraints.maxWidth < 720 ? 1 : 2;
        return GridView.count(
          crossAxisCount: columns,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: columns == 1 ? 2.4 : 1.8,
          children: const <Widget>[
            FeatureCard(
              icon: Icons.cleaning_services_outlined,
              title: 'Housekeeping Maids',
              description:
                  'Cleaning, laundry, and household maintenance for daily or weekly support.',
            ),
            FeatureCard(
              icon: Icons.child_care_outlined,
              title: 'Childcare Assistants',
              description:
                  'Reliable care assistants for families needing help with children.',
            ),
            FeatureCard(
              icon: Icons.restaurant_outlined,
              title: 'Cooking Support',
              description:
                  'Experienced cooks available for regular meals and dietary requirements.',
            ),
            FeatureCard(
              icon: Icons.elderly_outlined,
              title: 'Elderly Care Assistance',
              description:
                  'Compassionate attendants for non-medical support and daily routines.',
            ),
          ],
        );
      },
    );
  }
}
