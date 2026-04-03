import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';

class PublicNavigationItem {
  const PublicNavigationItem({
    required this.label,
    this.route,
    this.onTap,
    this.isSelected = false,
  });

  final String label;
  final String? route;
  final VoidCallback? onTap;
  final bool isSelected;
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

  static const List<PublicNavigationItem> navLinks = <PublicNavigationItem>[
    PublicNavigationItem(label: 'Home', route: AppRoutes.home),
    PublicNavigationItem(label: 'Services', route: AppRoutes.services),
    PublicNavigationItem(label: 'Pricing', route: AppRoutes.pricing),
    PublicNavigationItem(label: 'Contact', route: AppRoutes.contact),
    PublicNavigationItem(label: 'FAQs', route: AppRoutes.faqs),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      drawer: PublicSiteDrawer(currentRoute: currentRoute, items: navLinks),
      body: Scrollbar(
        child: CustomScrollView(
          physics: const BouncingScrollPhysics(
            parent: AlwaysScrollableScrollPhysics(),
          ),
          slivers: <Widget>[
            SliverAppBar(
              floating: false,
              pinned: true,
              elevation: 0,
              toolbarHeight: 80,
              backgroundColor: Colors.transparent,
              flexibleSpace: ClipRect(
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                  child: Container(
                    color: Colors.white.withOpacity(0.85),
                    child: PublicSiteHeader(
                      items: navLinks
                          .map(
                            (link) => PublicNavigationItem(
                              label: link.label,
                              route: link.route,
                              isSelected: currentRoute == link.route,
                            ),
                          )
                          .toList(),
                    ),
                  ),
                ),
              ),
              automaticallyImplyLeading: false,
            ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1200),
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
    ),
  );
}
}

class PublicSiteHeader extends StatelessWidget {
  const PublicSiteHeader({super.key, required this.items});

  final List<PublicNavigationItem> items;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: false,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        child: LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            final bool compact = constraints.maxWidth < 850;

            return Row(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.home_work_rounded,
                    color: Color(0xFF6366F1),
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                const Text(
                  'MaidConnect',
                  style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                    letterSpacing: -0.5,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const Spacer(),
                if (!compact)
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9).withOpacity(0.5),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: items
                          .map(
                            (PublicNavigationItem item) => Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 2,
                              ),
                              child: _HeaderLinkButton(item: item),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                if (!compact) ...[
                  const SizedBox(width: 16),
                  ElevatedButton(
                    onPressed: () => context.go('/client/register'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6366F1),
                      foregroundColor: Colors.white,
                      elevation: 0,

                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100),
                      ),
                    ),
                    child: const Text(
                      'Get Started',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
                if (compact)
                  Builder(
                    builder: (BuildContext context) => IconButton(
                      icon: const Icon(
                        Icons.menu_rounded,
                        color: Color(0xFF1E293B),
                      ),
                      onPressed: () => Scaffold.of(context).openDrawer(),
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}

class PublicSiteDrawer extends StatelessWidget {
  const PublicSiteDrawer({super.key, this.currentRoute, required this.items});

  final String? currentRoute;
  final List<PublicNavigationItem> items;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: Colors.white,
      child: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.home_work_rounded,
                      color: Color(0xFF6366F1),
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'MaidConnect',
                    style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                  ),
                ],
              ),
            ),
            const Divider(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                children: items.map((PublicNavigationItem item) {
                  final bool isSelected =
                      item.isSelected ||
                      (item.route != null && item.route == currentRoute);
                  return ListTile(
                    title: Text(
                      item.label,
                      style: TextStyle(
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: isSelected
                            ? const Color(0xFF6366F1)
                            : const Color(0xFF475569),
                      ),
                    ),
                    selected: isSelected,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    selectedTileColor: const Color(
                      0xFF6366F1,
                    ).withOpacity(0.05),
                    onTap: () {
                      Navigator.pop(context);
                      if (item.onTap != null) {
                        item.onTap!();
                      } else if (item.route != null &&
                          item.route != currentRoute) {
                        context.go(item.route!);
                      }
                    },
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _HeaderLinkButton extends StatelessWidget {
  const _HeaderLinkButton({required this.item});

  final PublicNavigationItem item;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        if (item.onTap != null) {
          item.onTap!();
        } else if (item.route != null) {
          context.go(item.route!);
        }
      },
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(100)),
        backgroundColor: item.isSelected ? Colors.white : Colors.transparent,
        foregroundColor: item.isSelected
            ? const Color(0xFF6366F1)
            : const Color(0xFF64748B),
        elevation: item.isSelected ? 2 : 0,
        shadowColor: Colors.black.withOpacity(0.1),
      ),
      child: Text(
        item.label,
        style: TextStyle(
          fontSize: 14,
          fontWeight: item.isSelected ? FontWeight.w700 : FontWeight.w600,
        ),
      ),
    );
  }
}

class PurpleHeroCard extends StatelessWidget {
  const PurpleHeroCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 400,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(32),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF6366F1), Color(0xFF4F46E5), Color(0xFF3730A3)],
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF4F46E5).withOpacity(0.3),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
        children: [
          Positioned(
            top: -50,
            right: -50,
            child: Container(
              width: 200,
              height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
          ),
          Positioned(
            bottom: -30,
            left: -30,
            child: Container(
              width: 150,
              height: 150,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.05),
              ),
            ),
          ),
          Center(
            child: Padding(
              padding: const EdgeInsets.all(40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.15),
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: Colors.white.withOpacity(0.2),
                        width: 1,
                      ),
                    ),
                    child: const Icon(
                      Icons.verified_user_rounded,
                      color: Colors.white,
                      size: 64,
                    ),
                  ),
                  const SizedBox(height: 32),
                  const Text(
                    '100% Verified',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -0.5,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Background checks completed for every professional candidate.',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.8),
                      fontSize: 16,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
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
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.8), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Icon(icon, color: const Color(0xFF6366F1), size: 32),
                ),
                const SizedBox(height: 24),
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 20,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  description,
                  style: TextStyle(
                    height: 1.6,
                    fontSize: 15,
                    color: const Color(0xFF475569).withOpacity(0.9),
                  ),
                ),
              ],
            ),
          ),
        ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (badge != null) ...<Widget>[
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1).withOpacity(0.1),
              borderRadius: BorderRadius.circular(100),
            ),
            child: Text(
              badge!.toUpperCase(),
              style: const TextStyle(
                color: Color(0xFF6366F1),
                fontWeight: FontWeight.w800,
                fontSize: 11,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: 16),
        ],
        LayoutBuilder(
          builder: (context, constraints) {
            final bool narrow = constraints.maxWidth < 600;
            return Text(
              title,
              style: TextStyle(
                fontSize: narrow ? 28 : 36,
                fontWeight: FontWeight.w900,
                letterSpacing: -0.5,
                color: const Color(0xFF1E293B),
              ),
            );
          },
        ),
        const SizedBox(height: 12),
        Text(
          subtitle,
          style: TextStyle(
            height: 1.6,
            fontSize: 18,
            color: const Color(0xFF475569).withOpacity(0.8),
          ),
        ),
      ],
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
      decoration: BoxDecoration(
        color: highlighted ? Colors.white : Colors.white.withOpacity(0.5),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(
          color: highlighted
              ? const Color(0xFF6366F1)
              : Colors.white.withOpacity(0.8),
          width: highlighted ? 2 : 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: highlighted
                ? const Color(0xFF6366F1).withOpacity(0.15)
                : Colors.black.withOpacity(0.03),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    name,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 1,
                      color: highlighted
                          ? const Color(0xFF6366F1)
                          : const Color(0xFF64748B),
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
                        color: const Color(0xFF6366F1),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      child: Text(
                        tag!,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 24),
              RichText(
                text: TextSpan(
                  style: const TextStyle(color: Color(0xFF1E293B)),
                  children: <TextSpan>[
                    const TextSpan(
                      text: '\$ ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    TextSpan(
                      text: price,
                      style: const TextStyle(
                        fontSize: 44,
                        fontWeight: FontWeight.w900,
                        letterSpacing: -1,
                      ),
                    ),
                    const TextSpan(
                      text: ' /mo',
                      style: TextStyle(
                        fontSize: 16,
                        color: Color(0xFF64748B),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 32),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: features
                    .map(
                      (String item) => Padding(
                        padding: const EdgeInsets.only(bottom: 16),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.all(2),
                              decoration: const BoxDecoration(
                                color: Color(0xFFE0E7FF),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.check_rounded,
                                color: Color(0xFF6366F1),
                                size: 14,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                item,
                                style: const TextStyle(
                                  fontSize: 15,
                                  color: Color(0xFF475569),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => context.go(AppRoutes.contact),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: highlighted
                        ? const Color(0xFF6366F1)
                        : Colors.white,
                    foregroundColor: highlighted
                        ? Colors.white
                        : const Color(0xFF1E293B),
                    elevation: highlighted ? 4 : 0,
                    shadowColor: const Color(0xFF6366F1).withOpacity(0.4),
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                      side: highlighted
                          ? BorderSide.none
                          : const BorderSide(
                              color: Color(0xFFE2E8F0),
                              width: 1.5,
                            ),
                    ),
                  ),
                  child: const Text(
                    'Get Started',
                    style: TextStyle(fontWeight: FontWeight.w800),
                  ),
                ),
              ),
            ],
          ),
        ),
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
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withOpacity(0.8), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      clipBehavior: Clip.antiAlias,
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
        child: Column(
          children: items.asMap().entries.map((entry) {
            final isLast = entry.key == items.length - 1;
            return Column(
              children: [
                ExpansionTile(
                  tilePadding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 8,
                  ),
                  childrenPadding: const EdgeInsets.fromLTRB(24, 0, 24, 24),
                  iconColor: const Color(0xFF6366F1),
                  collapsedIconColor: const Color(0xFF64748B),
                  title: Text(
                    entry.value.question,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 17,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                  shape: const RoundedRectangleBorder(side: BorderSide.none),
                  collapsedShape: const RoundedRectangleBorder(
                    side: BorderSide.none,
                  ),
                  children: [
                    Text(
                      entry.value.answer,
                      style: const TextStyle(
                        height: 1.6,
                        fontSize: 16,
                        color: Color(0xFF475569),
                      ),
                    ),
                  ],
                ),
                if (!isLast)
                  Divider(
                    height: 1,
                    indent: 24,
                    endIndent: 24,
                    color: const Color(0xFFE2E8F0).withOpacity(0.5),
                  ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

class ContactSection extends StatelessWidget {
  const ContactSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(40),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: Colors.white.withOpacity(0.8), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 30,
            offset: const Offset(0, 15),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              final bool narrow = constraints.maxWidth < 800;
              return Flex(
                direction: narrow ? Axis.vertical : Axis.horizontal,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  if (narrow)
                    _ContactInfoColumn(
                      title: 'Direct Support',
                      rows: const [
                        _ContactRow(
                          icon: Icons.phone_rounded,
                          text: '+91 90000 12345',
                        ),
                        _ContactRow(
                          icon: Icons.email_rounded,
                          text: 'hello@maidconnect.com',
                        ),
                        _ContactRow(
                          icon: Icons.location_on_rounded,
                          text: 'MG Road, Bengaluru',
                        ),
                        _ContactRow(
                          icon: Icons.access_time_filled_rounded,
                          text: 'Mon-Sat, 9 AM - 7 PM',
                        ),
                      ],
                    )
                  else
                    const Expanded(
                      flex: 1,
                      child: _ContactInfoColumn(
                        title: 'Direct Support',
                        rows: [
                          _ContactRow(
                            icon: Icons.phone_rounded,
                            text: '+91 90000 12345',
                          ),
                          _ContactRow(
                            icon: Icons.email_rounded,
                            text: 'hello@maidconnect.com',
                          ),
                          _ContactRow(
                            icon: Icons.location_on_rounded,
                            text: 'MG Road, Bengaluru',
                          ),
                          _ContactRow(
                            icon: Icons.access_time_filled_rounded,
                            text: 'Mon-Sat, 9 AM - 7 PM',
                          ),
                        ],
                      ),
                    ),
                  if (!narrow) ...[
                    const SizedBox(width: 40),
                    Container(
                      width: 1,
                      height: 180,
                      color: const Color(0xFFE2E8F0),
                    ),
                    const SizedBox(width: 40),
                  ],
                  if (narrow) const SizedBox(height: 48),
                  if (narrow)
                    _ContactInfoColumn(
                      title: 'Quick Process',
                      rows: const [
                        _ContactRow(
                          icon: Icons.looks_one_rounded,
                          text: 'Share requirements',
                        ),
                        _ContactRow(
                          icon: Icons.looks_two_rounded,
                          text: 'Get handpicked matches',
                        ),
                        _ContactRow(
                          icon: Icons.looks_3_rounded,
                          text: 'Interview candidates',
                        ),
                        _ContactRow(
                          icon: Icons.looks_4_rounded,
                          text: 'Quick onboarding',
                        ),
                      ],
                    )
                  else
                    const Expanded(
                      flex: 1,
                      child: _ContactInfoColumn(
                        title: 'Quick Process',
                        rows: [
                          _ContactRow(
                            icon: Icons.looks_one_rounded,
                            text: 'Share requirements',
                          ),
                          _ContactRow(
                            icon: Icons.looks_two_rounded,
                            text: 'Get handpicked matches',
                          ),
                          _ContactRow(
                            icon: Icons.looks_3_rounded,
                            text: 'Interview candidates',
                          ),
                          _ContactRow(
                            icon: Icons.looks_4_rounded,
                            text: 'Quick onboarding',
                          ),
                        ],
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

class _ContactRow extends StatelessWidget {
  const _ContactRow({required this.icon, required this.text});
  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFF6366F1).withOpacity(0.05),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFF6366F1), size: 20),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Color(0xFF475569),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _ContactInfoColumn extends StatelessWidget {
  const _ContactInfoColumn({required this.title, required this.rows});

  final String title;
  final List<Widget> rows;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 22,
            color: Color(0xFF1E293B),
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 32),
        ...rows,
      ],
    );
  }
}

class PublicFooter extends StatelessWidget {
  const PublicFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 80),
      color: const Color(0xFF0F172A),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: Column(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.home_work_rounded,
                      color: Colors.white,
                      size: 24,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Text(
                    'MaidConnect',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      letterSpacing: -1,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 500),
                child: Text(
                  'Trusted maid agency platform for safe, reliable, and professional home staffing solutions.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 16,
                    height: 1.6,
                  ),
                ),
              ),
              const SizedBox(height: 48),
              Container(
                width: 60,
                height: 1,
                color: Colors.white.withOpacity(0.1),
              ),
              const SizedBox(height: 48),
              const Text(
                '© 2026 MaidConnect. Crafted with ❤️ for modern homes.',
                style: TextStyle(
                  color: Color(0xFF64748B),
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PublicSiteSection extends StatelessWidget {
  const PublicSiteSection({
    super.key,
    required this.title,
    required this.child,
    required this.subtitle,
    this.badge,
  });

  final String title;
  final Widget child;
  final String subtitle;
  final String? badge;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SectionTitle(title: title, subtitle: subtitle, badge: badge),
          const SizedBox(height: 24),
          child,
        ],
      ),
    );
  }
}

class PublicAboutTextCard extends StatelessWidget {
  const PublicAboutTextCard({super.key, required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.6),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.white.withOpacity(0.8), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(10),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
          child: Text(
            text,
            style: const TextStyle(
              height: 1.6,
              fontSize: 16,
              color: Color(0xFF475569),
            ),
          ),
        ),
      ),
    );
  }
}

class PublicFeatureGrid extends StatelessWidget {
  const PublicFeatureGrid({super.key, required this.items});

  final List<FeatureCard> items;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final int columns = constraints.maxWidth < 700 ? 1 : 3;
        if (columns == 1) {
          return Column(
            children: [
              for (var i = 0; i < items.length; i++) ...[
                items[i],
                if (i < items.length - 1) const SizedBox(height: 20),
              ],
            ],
          );
        }

        return GridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 20,
          crossAxisSpacing: 20,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 1.1,
          children: items,
        );
      },
    );
  }
}

class PublicPricingGrid extends StatelessWidget {
  const PublicPricingGrid({super.key});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final int columns = constraints.maxWidth < 980 ? 1 : 3;
        if (columns == 1) {
          return const Column(
            children: [
              PricingPlanCard(
                name: 'Basic',
                price: '39',
                features: <String>[
                  '1 profile shortlist',
                  'Consultation call with agency',
                  'Email support',
                ],
              ),
              SizedBox(height: 24),
              PricingPlanCard(
                name: 'Standard',
                price: '79',
                tag: 'Most Popular',
                highlighted: true,
                features: <String>[
                  'Up to 3 profile matches',
                  'Interview scheduling support',
                  'Priority response and follow-up',
                ],
              ),
              SizedBox(height: 24),
              PricingPlanCard(
                name: 'Premium',
                price: '149',
                features: <String>[
                  'Dedicated placement specialist',
                  'Expanded candidate access',
                  'Post-placement support',
                ],
              ),
            ],
          );
        }

        return GridView.count(
          crossAxisCount: 3,
          mainAxisSpacing: 24,
          crossAxisSpacing: 24,
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: 0.72,
          children: const <Widget>[
            PricingPlanCard(
              name: 'Basic',
              price: '39',
              features: <String>[
                '1 profile shortlist',
                'Consultation call with agency',
                'Email support',
              ],
            ),
            PricingPlanCard(
              name: 'Standard',
              price: '79',
              tag: 'Most Popular',
              highlighted: true,
              features: <String>[
                'Up to 3 profile matches',
                'Interview scheduling support',
                'Priority response and follow-up',
              ],
            ),
            PricingPlanCard(
              name: 'Premium',
              price: '149',
              features: <String>[
                'Dedicated placement specialist',
                'Expanded candidate access',
                'Post-placement support',
              ],
            ),
          ],
        );
      },
    );
  }
}
