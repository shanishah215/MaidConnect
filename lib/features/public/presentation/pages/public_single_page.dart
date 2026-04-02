import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/public_site_components.dart';

enum PublicSection { home, about, services, pricing, contact, faqs }

class PublicSinglePage extends StatefulWidget {
  const PublicSinglePage({super.key, this.initialSection = PublicSection.home});

  final PublicSection initialSection;

  @override
  State<PublicSinglePage> createState() => _PublicSinglePageState();
}

class _PublicSinglePageState extends State<PublicSinglePage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _homeKey = GlobalKey();
  final GlobalKey _aboutKey = GlobalKey();
  final GlobalKey _servicesKey = GlobalKey();
  final GlobalKey _pricingKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();
  final GlobalKey _faqsKey = GlobalKey();

  void _scrollTo(GlobalKey key) {
    final BuildContext? context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOut,
        alignment: 0.06,
      );
    }
  }

  void _scrollToSection(PublicSection section) {
    switch (section) {
      case PublicSection.home:
        _scrollTo(_homeKey);
      case PublicSection.about:
        _scrollTo(_aboutKey);
      case PublicSection.services:
        _scrollTo(_servicesKey);
      case PublicSection.pricing:
        _scrollTo(_pricingKey);
      case PublicSection.contact:
        _scrollTo(_contactKey);
      case PublicSection.faqs:
        _scrollTo(_faqsKey);
    }
  }

  void _goToRouteOrScroll({required String route, required GlobalKey key}) {
    final String? currentRoute = ModalRoute.of(context)?.settings.name;
    if (currentRoute == route) {
      _scrollTo(key);
      return;
    }
    context.go(route);
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 450),
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _scrollToSection(widget.initialSection);
    });
  }

  List<_OnePageNavItem> get _navItems => <_OnePageNavItem>[
    _OnePageNavItem(
      label: 'Home',
      isSelected: widget.initialSection == PublicSection.home,
      onTap: () => _goToRouteOrScroll(route: '/', key: _homeKey),
    ),
    _OnePageNavItem(
      label: 'About Us',
      isSelected: widget.initialSection == PublicSection.about,
      onTap: () => _goToRouteOrScroll(route: '/about', key: _aboutKey),
    ),
    _OnePageNavItem(
      label: 'Services',
      isSelected: widget.initialSection == PublicSection.services,
      onTap: () => _goToRouteOrScroll(route: '/services', key: _servicesKey),
    ),
    _OnePageNavItem(
      label: 'Pricing',
      isSelected: widget.initialSection == PublicSection.pricing,
      onTap: () => _goToRouteOrScroll(route: '/pricing', key: _pricingKey),
    ),
    _OnePageNavItem(
      label: 'Contact Us',
      isSelected: widget.initialSection == PublicSection.contact,
      onTap: () => _goToRouteOrScroll(route: '/contact', key: _contactKey),
    ),
    _OnePageNavItem(
      label: 'FAQs',
      isSelected: widget.initialSection == PublicSection.faqs,
      onTap: () => _goToRouteOrScroll(route: '/faqs', key: _faqsKey),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7F9FC),
      drawer: _OnePageDrawer(navItems: _navItems),
      floatingActionButton: FloatingActionButton(
        onPressed: _scrollToTop,
        tooltip: 'Scroll to top',
        child: const Icon(Icons.arrow_upward),
      ),
      body: CustomScrollView(
        controller: _scrollController,
        slivers: <Widget>[
          SliverToBoxAdapter(child: _OnePageHeader(navItems: _navItems)),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
              child: Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 1140),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      _SectionContainer(
                        key: _homeKey,
                        title: 'Home',
                        subtitle:
                            'A trusted maid agency platform for modern households',
                        child: PublicHeroSection(
                          headline: 'Trusted Maids for Every Home',
                          subheading:
                              'MaidConnect helps families hire verified and skilled maids with confidence. Discover candidates that match your schedule, needs, and budget.',
                          onFindMaid: () => context.go('/client/register'),
                          onContactUs: () => _scrollTo(_contactKey),
                        ),
                      ),
                      _SectionContainer(
                        key: _aboutKey,
                        title: 'About Us',
                        badge: 'Why MaidConnect',
                        subtitle:
                            'Professional, verified, and transparent domestic staffing',
                        child: const _SimpleCardText(
                          text:
                              'MaidConnect is a public-facing maid agency platform focused on safety, transparency, and reliable placements for families.',
                        ),
                      ),
                      _SectionContainer(
                        key: _servicesKey,
                        title: 'Services',
                        badge: 'What We Offer',
                        subtitle:
                            'Flexible staffing options for families and homes',
                        child: const _FeatureWrap(
                          items: <FeatureCard>[
                            FeatureCard(
                              icon: Icons.cleaning_services_outlined,
                              title: 'Housekeeping',
                              description:
                                  'Daily and weekly support for cleaning and laundry.',
                            ),
                            FeatureCard(
                              icon: Icons.child_care_outlined,
                              title: 'Childcare Support',
                              description:
                                  'Reliable childcare assistants for busy homes.',
                            ),
                            FeatureCard(
                              icon: Icons.restaurant_outlined,
                              title: 'Cooking Support',
                              description:
                                  'Skilled cooks for family meal preparation.',
                            ),
                          ],
                        ),
                      ),
                      _SectionContainer(
                        key: _pricingKey,
                        title: 'Pricing / Plans',
                        badge: 'Transparent Plans',
                        subtitle:
                            'Simple plans designed for every household hiring need',
                        child: const _PricingPlansGrid(),
                      ),
                      _SectionContainer(
                        key: _contactKey,
                        title: 'Contact Us',
                        badge: 'Talk To Our Team',
                        subtitle:
                            'Share your requirements and get matched quickly',
                        child: const ContactSection(),
                      ),
                      _SectionContainer(
                        key: _faqsKey,
                        title: 'FAQs',
                        badge: 'Need Answers?',
                        subtitle:
                            'Everything families ask before hiring through us',
                        child: const FaqAccordionSection(
                          items: <FaqItem>[
                            FaqItem(
                              question: 'How do you verify maids?',
                              answer:
                                  'Identity and background checks are completed before listing candidates.',
                            ),
                            FaqItem(
                              question: 'Can I interview candidates?',
                              answer:
                                  'Yes, we help schedule interviews before placement.',
                            ),
                            FaqItem(
                              question: 'Is there backend integration now?',
                              answer:
                                  'No, this version is UI-only for the public marketing website.',
                            ),
                          ],
                        ),
                      ),
                    ],
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

class _SectionContainer extends StatelessWidget {
  const _SectionContainer({
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
      padding: const EdgeInsets.only(bottom: 26),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SectionTitle(title: title, subtitle: subtitle, badge: badge),
          const SizedBox(height: 8),
          child,
        ],
      ),
    );
  }
}

class _PricingPlansGrid extends StatelessWidget {
  const _PricingPlansGrid();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final int columns = constraints.maxWidth < 980 ? 1 : 3;
        return GridView.count(
          crossAxisCount: columns,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: columns == 1 ? 2.05 : 0.77,
          children: const <Widget>[
            PricingPlanCard(
              name: 'Basic',
              price: '2,999',
              features: <String>[
                '1 profile shortlist',
                'Consultation call with agency',
                'Email support',
              ],
            ),
            PricingPlanCard(
              name: 'Standard',
              price: '5,999',
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
              price: '9,999',
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

class _SimpleCardText extends StatelessWidget {
  const _SimpleCardText({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE5EAF3)),
      ),
      child: Text(text, style: const TextStyle(height: 1.5)),
    );
  }
}

class _FeatureWrap extends StatelessWidget {
  const _FeatureWrap({required this.items});

  final List<FeatureCard> items;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final int columns = constraints.maxWidth < 700 ? 1 : 3;
        return GridView.count(
          crossAxisCount: columns,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          childAspectRatio: columns == 1 ? 2.5 : 1.3,
          children: items,
        );
      },
    );
  }
}

class _OnePageNavItem {
  const _OnePageNavItem({
    required this.label,
    required this.onTap,
    required this.isSelected,
  });

  final String label;
  final VoidCallback onTap;
  final bool isSelected;
}

class _OnePageHeader extends StatelessWidget {
  const _OnePageHeader({required this.navItems});

  final List<_OnePageNavItem> navItems;

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
                      children: navItems
                          .map(
                            (_OnePageNavItem item) => TextButton(
                              onPressed: item.onTap,
                              child: Text(
                                item.label,
                                style: TextStyle(
                                  color: item.isSelected
                                      ? const Color(0xFF1F4F99)
                                      : const Color(0xFF334155),
                                  fontWeight: item.isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w500,
                                ),
                              ),
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

class _OnePageDrawer extends StatelessWidget {
  const _OnePageDrawer({required this.navItems});

  final List<_OnePageNavItem> navItems;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: SafeArea(
        child: ListView(
          children: navItems
              .map(
                (_OnePageNavItem item) => ListTile(
                  title: Text(item.label),
                  selected: item.isSelected,
                  onTap: () {
                    Navigator.pop(context);
                    item.onTap();
                  },
                ),
              )
              .toList(),
        ),
      ),
    );
  }
}
