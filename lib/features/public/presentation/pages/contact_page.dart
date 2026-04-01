import 'package:flutter/material.dart';

import '../../../../app/router/app_routes.dart';
import '../widgets/public_site_components.dart';

class ContactPage extends StatelessWidget {
  const ContactPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PublicSiteScaffold(
      currentRoute: AppRoutes.contact,
      title: 'Contact Us',
      sections: <Widget>[
        SectionTitle(
          title: 'Contact Us',
          subtitle:
              'Tell us what kind of support you need and our agency team will reach out with suitable options.',
        ),
        SizedBox(height: 12),
        ContactSection(),
        SizedBox(height: 24),
        _ContactCtaCard(),
      ],
    );
  }
}

class _ContactCtaCard extends StatelessWidget {
  const _ContactCtaCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFF1F4F99),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Need urgent placement?',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 22,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Speak with our team for priority matching and interview scheduling support.',
            style: TextStyle(color: Color(0xFFDCEAFF)),
          ),
          const SizedBox(height: 16),
          FilledButton(
            style: FilledButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: const Color(0xFF1F4F99),
            ),
            onPressed: () {},
            child: const Text('Request a Callback'),
          ),
        ],
      ),
    );
  }
}
