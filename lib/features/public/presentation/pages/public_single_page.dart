import 'dart:ui';
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
        duration: const Duration(milliseconds: 600),
        curve: Curves.easeOut,
        alignment: 0.1,
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
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _scrollToSection(widget.initialSection);
    });
  }

  List<PublicNavigationItem> get _navItems => <PublicNavigationItem>[
    PublicNavigationItem(
      label: 'Home',
      isSelected: widget.initialSection == PublicSection.home,
      onTap: () => _goToRouteOrScroll(route: '/', key: _homeKey),
    ),
    PublicNavigationItem(
      label: 'About',
      isSelected: widget.initialSection == PublicSection.about,
      onTap: () => _goToRouteOrScroll(route: '/about', key: _aboutKey),
    ),
    PublicNavigationItem(
      label: 'Services',
      isSelected: widget.initialSection == PublicSection.services,
      onTap: () => _goToRouteOrScroll(route: '/services', key: _servicesKey),
    ),
    PublicNavigationItem(
      label: 'Pricing',
      isSelected: widget.initialSection == PublicSection.pricing,
      onTap: () => _goToRouteOrScroll(route: '/pricing', key: _pricingKey),
    ),
    PublicNavigationItem(
      label: 'Contact',
      isSelected: widget.initialSection == PublicSection.contact,
      onTap: () => _goToRouteOrScroll(route: '/contact', key: _contactKey),
    ),
    PublicNavigationItem(
      label: 'FAQs',
      isSelected: widget.initialSection == PublicSection.faqs,
      onTap: () => _goToRouteOrScroll(route: '/faqs', key: _faqsKey),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: const Color(0xFFF9FAFB),
      drawer: PublicSiteDrawer(items: _navItems),
      floatingActionButton: FloatingActionButton(
        onPressed: _scrollToTop,
        backgroundColor: const Color(0xFF6366F1),
        foregroundColor: Colors.white,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: const Icon(Icons.keyboard_arrow_up_rounded),
      ),
      body: Stack(
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
            slivers: <Widget>[
              SliverAppBar(
                floating: true,
                pinned: true,
                elevation: 0,
                backgroundColor: Colors.transparent,
                flexibleSpace: ClipRect(
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                    child: Container(
                      color: Colors.white.withOpacity(0.7),
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
                          PublicSiteSection(
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
                          const SizedBox(height: 40),
                          PublicSiteSection(
                            key: _aboutKey,
                            title: 'About Us',
                            badge: 'Why MaidConnect',
                            subtitle:
                                'Professional, verified, and transparent domestic staffing',
                            child: const PublicAboutTextCard(
                              text:
                                  'MaidConnect is a public-facing maid agency platform focused on safety, transparency, and reliable placements for families. We bridge the gap between busy households and verified domestic professionals.',
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
    );
  }
}
