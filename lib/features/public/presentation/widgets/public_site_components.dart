import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';

class PublicNavLink {
  const PublicNavLink({required this.label, required this.route});

  final String label;
  final String route;
}

class PublicSiteScaffold extends StatelessWidget {
  const PublicSiteScaffold({
    super.key,
    required this.currentRoute,
    required this.title,
    required this.sections,
  });

  final String currentRoute;
  final String title;
  final List<Widget> sections;

  static const List<PublicNavLink> navLinks = <PublicNavLink>[
    PublicNavLink(label: 'Home', route: AppRoutes.home),
    PublicNavLink(label: 'About Us', route: AppRoutes.about),
    PublicNavLink(label: 'Services', route: AppRoutes.services),
    PublicNavLink(label: 'Pricing', route: AppRoutes.pricing),
    PublicNavLink(label: 'Contact Us', route: AppRoutes.contact),
    PublicNavLink(label: 'FAQs', route: AppRoutes.faqs),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      drawer: PublicHeaderDrawer(currentRoute: currentRoute, links: navLinks),
      body: CustomScrollView(
        slivers: <Widget>[
          SliverToBoxAdapter(
            child: PublicHeader(currentRoute: currentRoute, links: navLinks),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1140),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: sections,
                  ),
                ),
              ),
            ),
          ),
          const SliverToBoxAdapter(child: PublicFooter()),
        ],
      ),
    );
  }
}

class PublicHeader extends StatelessWidget {
  const PublicHeader({
    super.key,
    required this.currentRoute,
    required this.links,
  });

  final String currentRoute;
  final List<PublicNavLink> links;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Color(0x11000000),
            blurRadius: 14,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final bool compact = constraints.maxWidth < 850;

              return Row(
                children: <Widget>[
                  const Icon(
                    Icons.home_work_outlined,
                    color: Color(0xFF1F4F99),
                  ),
                  const SizedBox(width: 10),
                  const Text(
                    'MaidConnect',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 19),
                  ),
                  const Spacer(),
                  if (!compact)
                    Wrap(
                      spacing: 6,
                      children: links
                          .map(
                            (PublicNavLink link) => _HeaderLinkButton(
                              label: link.label,
                              route: link.route,
                              selected: currentRoute == link.route,
                            ),
                          )
                          .toList(),
                    ),
                  if (compact)
                    Builder(
                      builder: (BuildContext context) => IconButton(
                        icon: const Icon(Icons.menu),
                        onPressed: () => Scaffold.of(context).openDrawer(),
                      ),
                    ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

class PublicHeaderDrawer extends StatelessWidget {
  const PublicHeaderDrawer({
    super.key,
    required this.currentRoute,
    required this.links,
  });

  final String currentRoute;
  final List<PublicNavLink> links;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          children: links
              .map(
                (PublicNavLink link) => ListTile(
                  title: Text(link.label),
                  selected: link.route == currentRoute,
                  onTap: () {
                    Navigator.pop(context);
                    if (link.route != currentRoute) {
                      context.go(link.route);
                    }
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}

class _HeaderLinkButton extends StatelessWidget {
  const _HeaderLinkButton({
    required this.label,
    required this.route,
    required this.selected,
  });

  final String label;
  final String route;
  final bool selected;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () => context.go(route),
      child: Text(
        label,
        style: TextStyle(
          fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
          color: selected ? const Color(0xFF1F4F99) : const Color(0xFF1F2937),
        ),
      ),
    );
  }
}

class PublicHeroSection extends StatelessWidget {
  const PublicHeroSection({
    super.key,
    required this.headline,
    required this.subheading,
    this.onFindMaid,
    this.onContactUs,
  });

  final String headline;
  final String subheading;
  final VoidCallback? onFindMaid;
  final VoidCallback? onContactUs;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(28),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: <Color>[Color(0xFF1F4F99), Color(0xFF2F80ED)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final bool narrow = constraints.maxWidth < 760;
          return Flex(
            direction: narrow ? Axis.vertical : Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Expanded(
                flex: narrow ? 0 : 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      headline,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 34,
                        height: 1.2,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      subheading,
                      style: const TextStyle(
                        color: Color(0xFFDDEBFF),
                        fontSize: 16,
                        height: 1.45,
                      ),
                    ),
                    const SizedBox(height: 22),
                    Wrap(
                      spacing: 12,
                      runSpacing: 12,
                      children: <Widget>[
                        FilledButton(
                          style: FilledButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF1F4F99),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 22,
                              vertical: 14,
                            ),
                          ),
                          onPressed:
                              onFindMaid ?? () => context.go(AppRoutes.contact),
                          child: const Text('Find a Maid'),
                        ),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: const BorderSide(color: Colors.white70),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 22,
                              vertical: 14,
                            ),
                          ),
                          onPressed:
                              onContactUs ??
                              () => context.go(AppRoutes.contact),
                          child: const Text('Contact Us'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              if (!narrow) const SizedBox(width: 26),
              Container(
                width: narrow ? double.infinity : 290,
                margin: EdgeInsets.only(top: narrow ? 20 : 0),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0x33FFFFFF),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Why families trust us',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w700,
                        fontSize: 16,
                      ),
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Verified backgrounds\nSkill-matched profiles\nTransparent pricing',
                      style: TextStyle(color: Color(0xFFF3F8FF), height: 1.5),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class FeatureCard extends StatelessWidget {
  const FeatureCard({
    super.key,
    required this.icon,
    required this.title,
    required this.description,
  });

  final IconData icon;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5EAF3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Icon(icon, color: const Color(0xFF1F4F99), size: 28),
          const SizedBox(height: 12),
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 8),
          Text(description, style: const TextStyle(height: 1.45)),
        ],
      ),
    );
  }
}

class SectionTitle extends StatelessWidget {
  const SectionTitle({
    super.key,
    required this.title,
    required this.subtitle,
    this.badge,
  });

  final String title;
  final String subtitle;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (badge != null) ...<Widget>[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F1FF),
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                badge!,
                style: const TextStyle(
                  color: Color(0xFF1F4F99),
                  fontWeight: FontWeight.w700,
                  fontSize: 12,
                ),
              ),
            ),
            const SizedBox(height: 10),
          ],
          Text(
            title,
            style: Theme.of(
              context,
            ).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 6),
          Text(subtitle, style: const TextStyle(height: 1.45)),
        ],
      ),
    );
  }
}

class PricingPlanCard extends StatelessWidget {
  const PricingPlanCard({
    super.key,
    required this.name,
    required this.price,
    required this.features,
    this.highlighted = false,
    this.tag,
  });

  final String name;
  final String price;
  final List<String> features;
  final bool highlighted;
  final String? tag;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: highlighted ? const Color(0xFFF0F6FF) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: highlighted
              ? const Color(0xFF2F80ED)
              : const Color(0xFFE5EAF3),
          width: highlighted ? 1.4 : 1,
        ),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x120F172A),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const Spacer(),
              if (tag != null)
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 4,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1F4F99),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    tag!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 12),
          RichText(
            text: TextSpan(
              style: const TextStyle(color: Color(0xFF0F172A)),
              children: <TextSpan>[
                const TextSpan(
                  text: 'INR ',
                  style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
                TextSpan(
                  text: price,
                  style: const TextStyle(
                    fontSize: 34,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          ...features.map(
            (String item) => Padding(
              padding: const EdgeInsets.only(bottom: 9),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Padding(
                    padding: EdgeInsets.only(top: 3, right: 8),
                    child: Icon(
                      Icons.check_circle_rounded,
                      color: Color(0xFF2F80ED),
                      size: 16,
                    ),
                  ),
                  Expanded(child: Text(item)),
                ],
              ),
            ),
          ),
          const Spacer(),
          SizedBox(
            width: double.infinity,
            child: FilledButton(
              onPressed: () => context.go(AppRoutes.contact),
              child: const Text('Get Started'),
            ),
          ),
        ],
      ),
    );
  }
}

class FaqItem {
  const FaqItem({required this.question, required this.answer});

  final String question;
  final String answer;
}

class FaqAccordionSection extends StatelessWidget {
  const FaqAccordionSection({super.key, required this.items});

  final List<FaqItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5EAF3)),
      ),
      child: ExpansionPanelList.radio(
        expandedHeaderPadding: EdgeInsets.zero,
        children: items
            .asMap()
            .entries
            .map(
              (MapEntry<int, FaqItem> entry) => ExpansionPanelRadio(
                value: entry.key,
                headerBuilder: (_, bool isExpanded) => ListTile(
                  title: Text(
                    entry.value.question,
                    style: const TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                body: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Text(entry.value.answer),
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5EAF3)),
      ),
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          final bool narrow = constraints.maxWidth < 760;
          return Flex(
            direction: narrow ? Axis.vertical : Axis.horizontal,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Expanded(
                child: _ContactInfoColumn(
                  title: 'Contact our team',
                  rows: const <String>[
                    'Phone: +91 90000 12345',
                    'Email: hello@maidconnect.com',
                    'Office: MG Road, Bengaluru',
                    'Hours: Mon-Sat, 9:00 AM - 7:00 PM',
                  ],
                ),
              ),
              if (!narrow) const SizedBox(width: 18),
              Expanded(
                child: _ContactInfoColumn(
                  title: 'Next steps',
                  rows: const <String>[
                    '1. Share your household requirements',
                    '2. Get matched maid profiles',
                    '3. Schedule interviews',
                    '4. Complete onboarding quickly',
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _ContactInfoColumn extends StatelessWidget {
  const _ContactInfoColumn({required this.title, required this.rows});

  final String title;
  final List<String> rows;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
        const SizedBox(height: 10),
        ...rows.map(
          (String row) => Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Text(row),
          ),
        ),
      ],
    );
  }
}

class PublicFooter extends StatelessWidget {
  const PublicFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 26),
      color: const Color(0xFF101B2D),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1140),
          child: const Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'MaidConnect',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
              SizedBox(height: 8),
              Text(
                'Trusted maid agency platform for safe, reliable, and professional home staffing.',
                style: TextStyle(color: Color(0xFFB9C4D7)),
              ),
              SizedBox(height: 16),
              Text(
                'Copyright 2026 MaidConnect. All rights reserved.',
                style: TextStyle(color: Color(0xFF7D8BA3), fontSize: 12),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
