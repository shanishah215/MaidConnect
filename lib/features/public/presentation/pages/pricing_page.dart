import 'package:flutter/material.dart';

import '../../../../app/router/app_routes.dart';
import '../widgets/public_site_components.dart';

class PricingPage extends StatelessWidget {
  const PricingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return const PublicSiteScaffold(
      currentRoute: AppRoutes.pricing,
      title: 'Pricing',
      sections: <Widget>[
        SectionTitle(
          title: 'Pricing and Plans',
          subtitle:
              'Choose a plan based on your hiring urgency and support needs. No backend checkout is enabled yet.',
        ),
        SizedBox(height: 12),
        _PricingGrid(),
      ],
    );
  }
}

class _PricingGrid extends StatelessWidget {
  const _PricingGrid();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final int columns = constraints.maxWidth < 900 ? 1 : 3;
        return GridView.count(
          crossAxisCount: columns,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: columns == 1 ? 2.2 : 0.95,
          children: const <Widget>[
            _PlanCard(
              title: 'Basic',
              price: 'INR 2,999',
              items: <String>[
                '1 profile shortlist',
                'Phone consultation',
                'Email support',
              ],
            ),
            _PlanCard(
              title: 'Standard',
              price: 'INR 5,999',
              isHighlighted: true,
              items: <String>[
                'Up to 3 profile matches',
                'Interview scheduling support',
                'Priority agency assistance',
              ],
            ),
            _PlanCard(
              title: 'Premium',
              price: 'INR 9,999',
              items: <String>[
                'Dedicated placement specialist',
                'Expanded profile pool access',
                'Post-placement follow-up',
              ],
            ),
          ],
        );
      },
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.title,
    required this.price,
    required this.items,
    this.isHighlighted = false,
  });

  final String title;
  final String price;
  final List<String> items;
  final bool isHighlighted;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: isHighlighted ? const Color(0xFFEEF5FF) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isHighlighted ? const Color(0xFF2F80ED) : const Color(0xFFE5EAF3),
          width: isHighlighted ? 1.4 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 10),
          Text(
            price,
            style: const TextStyle(
              fontSize: 30,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1F4F99),
            ),
          ),
          const SizedBox(height: 14),
          ...items.map(
            (String item) => Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Text('- $item'),
            ),
          ),
          const Spacer(),
          FilledButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.contact),
            child: const Text('Contact Us'),
          ),
        ],
      ),
    );
  }
}
