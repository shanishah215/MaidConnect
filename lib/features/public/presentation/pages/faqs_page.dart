import 'package:flutter/material.dart';

import '../../../../app/router/app_routes.dart';
import '../widgets/public_site_components.dart';

class FaqsPage extends StatelessWidget {
  const FaqsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PublicSiteScaffold(
      currentRoute: AppRoutes.faqs,
      title: 'FAQs',
      sections: <Widget>[
        SectionTitle(
          title: 'Frequently Asked Questions',
          subtitle:
              'Answers to common questions from families exploring maid placement services.',
        ),
        SizedBox(height: 12),
        FaqAccordionSection(
          items: <FaqItem>[
            FaqItem(
              question: 'How do you verify maids?',
              answer:
                  'We conduct document checks, identity verification, and profile screening before listing candidates.',
            ),
            FaqItem(
              question: 'How long does matching usually take?',
              answer:
                  'It typically takes a few days depending on your requirements and availability.',
            ),
            FaqItem(
              question: 'Can I interview candidates before hiring?',
              answer:
                  'Yes. We support interview scheduling so families can evaluate fit before final onboarding.',
            ),
            FaqItem(
              question: 'Do you provide post-placement support?',
              answer:
                  'Yes. Our team remains available to assist with onboarding and early-stage placement concerns.',
            ),
          ],
        ),
      ],
    );
  }
}
