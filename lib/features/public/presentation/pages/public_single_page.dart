import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../widgets/public_site_components.dart';

enum PublicSection { home, services, pricing, contact, faqs }

class PublicSinglePage extends StatefulWidget {
  const PublicSinglePage({super.key, this.initialSection = PublicSection.home});

  final PublicSection initialSection;

  @override
  State<PublicSinglePage> createState() => _PublicSinglePageState();
}

class _PublicSinglePageState extends State<PublicSinglePage> {
  final ScrollController _scrollController = ScrollController();
  final GlobalKey _homeKey = GlobalKey();
  final GlobalKey _servicesKey = GlobalKey();
  final GlobalKey _pricingKey = GlobalKey();
  final GlobalKey _contactKey = GlobalKey();
  final GlobalKey _faqsKey = GlobalKey();
  
  // Track the active section locally to avoid route rebuilds on every click
  PublicSection? _activeSection;

  void _scrollTo(GlobalKey key) {
    final BuildContext? context = key.currentContext;
    if (context != null) {
      Scrollable.ensureVisible(
        context,
        duration: const Duration(milliseconds: 800),
        curve: Curves.easeInOutExpo,
        alignment: 0.0, // Changed to 0.0 to align exactly at the top
        alignmentPolicy: ScrollPositionAlignmentPolicy.explicit,
      );
    }
  }

  void _scrollToSection(PublicSection section) {
    switch (section) {
      case PublicSection.home:
        _scrollTo(_homeKey);
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

  void _goToRouteOrScroll({required String route, required PublicSection section, required GlobalKey key}) {
    // If we are already on this page (which we are), just scroll and update state
    setState(() {
      _activeSection = section;
    });
    _scrollTo(key);
    
    // We update the URL silently so the browser history is correct, 
    // but avoid rebuilding the entire page state.
    // Note: context.go(route) would rebuild the state, starting scroll from 0.
    // For a single-page site, it's better to stay in this state.
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 600),
      curve: Curves.easeOutQuint,
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
    _activeSection = widget.initialSection;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _scrollToSection(widget.initialSection);
    });
  }

  List<PublicNavigationItem> get _navItems => <PublicNavigationItem>[
    PublicNavigationItem(
      label: 'Home',
      isSelected: _activeSection == PublicSection.home,
      onTap: () => _goToRouteOrScroll(route: '/', section: PublicSection.home, key: _homeKey),
    ),
    PublicNavigationItem(
      label: 'Services',
      isSelected: _activeSection == PublicSection.services,
      onTap: () => _goToRouteOrScroll(route: '/services', section: PublicSection.services, key: _servicesKey),
    ),
    PublicNavigationItem(
      label: 'Pricing',
      isSelected: _activeSection == PublicSection.pricing,
      onTap: () => _goToRouteOrScroll(route: '/pricing', section: PublicSection.pricing, key: _pricingKey),
    ),
    PublicNavigationItem(
      label: 'Contact',
      isSelected: _activeSection == PublicSection.contact,
      onTap: () => _goToRouteOrScroll(route: '/contact', section: PublicSection.contact, key: _contactKey),
    ),
    PublicNavigationItem(
      label: 'FAQs',
      isSelected: _activeSection == PublicSection.faqs,
      onTap: () => _goToRouteOrScroll(route: '/faqs', section: PublicSection.faqs, key: _faqsKey),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF9FAFB),
      drawer: PublicSiteDrawer(items: _navItems),
      floatingActionButton: FloatingActionButton(
        onPressed: _scrollToTop,
        backgroundColor: const Color(0xFF6366F1),
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.arrow_upward_rounded),
      ),
      body: Scrollbar(
        controller: _scrollController,
        thickness: 8,
        radius: const Radius.circular(10),
        interactive: true,
        child: Stack(
        children: [
          // Background decorative elements
          Positioned(
            top: -100,
            right: -100,
            child: Container(
              width: 400,
              height: 400,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF6366F1).withOpacity(0.05),
              ),
            ),
          ),
          Positioned(
            bottom: 200,
            left: -150,
            child: Container(
              width: 500,
              height: 500,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFBDC3C7).withOpacity(0.03),
              ),
            ),
          ),
          CustomScrollView(
            controller: _scrollController,
            physics: const BouncingScrollPhysics(
              parent: AlwaysScrollableScrollPhysics(),
            ),
            slivers: <Widget>[
              SliverAppBar(
                floating: false,
                pinned: true,
                elevation: 0,
                toolbarHeight: 80, // Explicit height for the header
                backgroundColor: Colors.transparent,
                flexibleSpace: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                    child: Container(
                      color: Colors.white.withOpacity(0.85),
                      child: PublicSiteHeader(items: _navItems),
                    ),
                  ),
                ),
                automaticallyImplyLeading: false,
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 32,
                  ),
                  child: Center(
                    child: ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 1200),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: <Widget>[
                          // Home Section (Hero)
                          Padding(
                            key: _homeKey,
                            padding: const EdgeInsets.only(bottom: 40),
                            child: LayoutBuilder(
                              builder: (context, constraints) {
                                final bool isMobile =
                                    constraints.maxWidth < 900;

                                final Widget description = Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Trusted Maids for Every Home',
                                      style: TextStyle(
                                        fontSize: 48,
                                        fontWeight: FontWeight.w900,
                                        height: 1.1,
                                        color: Color(0xFF1E293B),
                                        letterSpacing: -1,
                                      ),
                                    ),
                                    const SizedBox(height: 24),
                                    const Text(
                                      'MaidConnect helps families hire verified and skilled maids with confidence. We bridge the gap between busy households and verified domestic professionals, focusing on safety, transparency, and reliable placements. Our mission is to make the hiring journey seamless through professional screening and guided match-making.',
                                      style: TextStyle(
                                        fontSize: 18,
                                        height: 1.6,
                                        color: Color(0xFF64748B),
                                      ),
                                    ),
                                    const SizedBox(height: 40),
                                    Row(
                                      children: [
                                        ElevatedButton(
                                          onPressed: () => context.go(
                                            '/client/register',
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: const Color(
                                              0xFF6366F1,
                                            ),
                                            foregroundColor: Colors.white,
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 32,
                                              vertical: 20,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                          ),
                                          child: const Text(
                                            'Find a Maid',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 16),
                                        OutlinedButton(
                                          onPressed:
                                              () => _scrollTo(_contactKey),
                                          style: OutlinedButton.styleFrom(
                                            foregroundColor: const Color(
                                              0xFF6366F1,
                                            ),
                                            side: const BorderSide(
                                              color: Color(0xFF6366F1),
                                            ),
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 32,
                                              vertical: 20,
                                            ),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(16),
                                            ),
                                          ),
                                          child: const Text(
                                            'Contact Us',
                                            style: TextStyle(
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                );

                                if (isMobile) {
                                  return Column(
                                    children: [
                                      description,
                                      const SizedBox(height: 48),
                                      const PurpleHeroCard(),
                                    ],
                                  );
                                }

                                return Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Expanded(flex: 3, child: description),
                                    const SizedBox(width: 64),
                                    const Expanded(
                                      flex: 2,
                                      child: PurpleHeroCard(),
                                    ),
                                  ],
                                );
                              },
                            ),
                          ),
                          const SizedBox(height: 40),
                          PublicSiteSection(
                            key: _servicesKey,
                            title: 'Services',
                            badge: 'What We Offer',
                            subtitle:
                                'Flexible staffing options for families and homes',
                            child: const PublicFeatureGrid(
                              items: <FeatureCard>[
                                FeatureCard(
                                  icon: Icons.cleaning_services_rounded,
                                  title: 'Housekeeping',
                                  description:
                                      'Daily and weekly support for cleaning and laundry services.',
                                ),
                                FeatureCard(
                                  icon: Icons.child_care_rounded,
                                  title: 'Childcare Support',
                                  description:
                                      'Reliable childcare assistants for busy homes and growing families.',
                                ),
                                FeatureCard(
                                  icon: Icons.restaurant_rounded,
                                  title: 'Cooking Support',
                                  description:
                                      'Skilled cooks for family meal preparation and kitchen management.',
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40),
                          PublicSiteSection(
                            key: _pricingKey,
                            title: 'Pricing / Plans',
                            badge: 'Transparent Plans',
                            subtitle:
                                'Simple plans designed for every household hiring need',
                            child: const PublicPricingGrid(),
                          ),
                          const SizedBox(height: 40),
                          PublicSiteSection(
                            key: _contactKey,
                            title: 'Contact Us',
                            badge: 'Talk To Our Team',
                            subtitle:
                                'Share your requirements and get matched quickly',
                            child: const ContactSection(),
                          ),
                          const SizedBox(height: 40),
                          PublicSiteSection(
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
                                      'Identity and background checks are completed before listing candidates to ensure safety for your home.',
                                ),
                                FaqItem(
                                  question: 'Can I interview candidates?',
                                  answer:
                                      'Yes, we help schedule interviews before placement so you can find the perfect match.',
                                ),
                                FaqItem(
                                  question: 'Is there a trial period?',
                                  answer:
                                      'Yes, we offer a trial period to ensure the candidate meets your household expectations.',
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 48),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SliverToBoxAdapter(child: PublicFooter()),
            ],
          ),
        ],
      ),
    ),
  );
}
}
