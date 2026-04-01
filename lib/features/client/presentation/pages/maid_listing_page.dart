import 'package:flutter/material.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../shared/presentation/widgets/responsive_navigation_shell.dart';
import '../../domain/entities/client_portal_models.dart';
import '../state/client_portal_store.dart';
import '../widgets/client_portal_shell.dart';
import '../widgets/client_ui_states.dart';
import '../widgets/maid_filter_panel.dart';
import '../widgets/maid_profile_card.dart';
import 'maid_profile_detail_page.dart';

class MaidListingPage extends StatefulWidget {
  const MaidListingPage({super.key, required this.navItems});
  final List<NavItem> navItems;

  @override
  State<MaidListingPage> createState() => _MaidListingPageState();
}

class _MaidListingPageState extends State<MaidListingPage> {
  bool _isLoading = true;
  String _query = '';
  MaidFilter _filter = const MaidFilter();

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await ClientPortalStore.instance.ensureLoaded();
    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  List<MaidProfile> _applyFilters(List<MaidProfile> input) {
    return input.where((maid) {
      final bool queryMatches =
          _query.isEmpty ||
          maid.name.toLowerCase().contains(_query.toLowerCase()) ||
          maid.skills.any(
            (s) => s.toLowerCase().contains(_query.toLowerCase()),
          );
      final bool ageMatches =
          (_filter.minAge == null || maid.age >= _filter.minAge!) &&
          (_filter.maxAge == null || maid.age <= _filter.maxAge!);
      final bool expMatches =
          _filter.minExperience == null ||
          maid.experienceYears >= _filter.minExperience!;
      final bool skillMatches =
          _filter.skill == null || maid.skills.contains(_filter.skill);
      final bool languageMatches =
          _filter.language == null || maid.languages.contains(_filter.language);
      final bool availabilityMatches =
          _filter.availability == null ||
          maid.availability == _filter.availability;
      return queryMatches &&
          ageMatches &&
          expMatches &&
          skillMatches &&
          languageMatches &&
          availabilityMatches;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return ClientPortalShell(
        title: 'Find Maids',
        navItems: widget.navItems,
        child: const ClientLoadingState(),
      );
    }
    final store = ClientPortalStore.instance;
    final List<String> allSkills =
        store.maids.expand((e) => e.skills).toSet().toList()..sort();
    final List<String> allLanguages =
        store.maids.expand((e) => e.languages).toSet().toList()..sort();
    final filtered = _applyFilters(store.maids);
    final bool isMobile = MediaQuery.of(context).size.width < 960;

    return ClientPortalShell(
      title: 'Find Maids',
      navItems: widget.navItems,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: isMobile
            ? _MobileListing(
                query: _query,
                onQueryChanged: (v) => setState(() => _query = v),
                filtered: filtered,
                filter: _filter,
                allSkills: allSkills,
                allLanguages: allLanguages,
                onFilterChanged: (value) => setState(() => _filter = value),
              )
            : Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 300,
                    child: MaidFilterPanel(
                      filter: _filter,
                      allSkills: allSkills,
                      allLanguages: allLanguages,
                      onFilterChanged: (value) =>
                          setState(() => _filter = value),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: _ListingResults(
                      query: _query,
                      onQueryChanged: (v) => setState(() => _query = v),
                      filtered: filtered,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _MobileListing extends StatelessWidget {
  const _MobileListing({
    required this.query,
    required this.onQueryChanged,
    required this.filtered,
    required this.filter,
    required this.allSkills,
    required this.allLanguages,
    required this.onFilterChanged,
  });

  final String query;
  final ValueChanged<String> onQueryChanged;
  final List<MaidProfile> filtered;
  final MaidFilter filter;
  final List<String> allSkills;
  final List<String> allLanguages;
  final ValueChanged<MaidFilter> onFilterChanged;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        const _ListingHeader(),
        const SizedBox(height: 12),
        TextField(
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: 'Search by name or skill',
          ),
          onChanged: onQueryChanged,
        ),
        const SizedBox(height: 12),
        ExpansionTile(
          tilePadding: EdgeInsets.zero,
          title: const Text('Show advanced filters'),
          children: [
            MaidFilterPanel(
              filter: filter,
              allSkills: allSkills,
              allLanguages: allLanguages,
              onFilterChanged: onFilterChanged,
            ),
          ],
        ),
        const SizedBox(height: 8),
        _ResultCards(filtered: filtered),
      ],
    );
  }
}

class _ListingResults extends StatelessWidget {
  const _ListingResults({
    required this.query,
    required this.onQueryChanged,
    required this.filtered,
  });

  final String query;
  final ValueChanged<String> onQueryChanged;
  final List<MaidProfile> filtered;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _ListingHeader(),
        const SizedBox(height: 12),
        TextField(
          decoration: const InputDecoration(
            prefixIcon: Icon(Icons.search),
            hintText: 'Search by name or skill',
          ),
          onChanged: onQueryChanged,
        ),
        const SizedBox(height: 12),
        Expanded(child: _ResultCards(filtered: filtered)),
      ],
    );
  }
}

class _ListingHeader extends StatelessWidget {
  const _ListingHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFDDE4F1)),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Verified professionals',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
          SizedBox(height: 4),
          Text(
            'Compare experience, skills, languages, and send requests in minutes.',
          ),
        ],
      ),
    );
  }
}

class _ResultCards extends StatefulWidget {
  const _ResultCards({required this.filtered});
  final List<MaidProfile> filtered;

  @override
  State<_ResultCards> createState() => _ResultCardsState();
}

class _ResultCardsState extends State<_ResultCards> {
  @override
  Widget build(BuildContext context) {
    final store = ClientPortalStore.instance;
    if (widget.filtered.isEmpty) {
      return ClientEmptyState(
        title: 'No matching profiles',
        subtitle:
            'Try broadening age or availability filters, or clear the search query.',
        icon: Icons.search_off,
        action: FilledButton.tonalIcon(
          onPressed: () =>
              Navigator.pushReplacementNamed(context, AppRoutes.maidListing),
          icon: const Icon(Icons.restart_alt),
          label: const Text('Reset view'),
        ),
      );
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: widget.filtered.length,
      separatorBuilder: (_, itemIndex) => const SizedBox(height: 10),
      itemBuilder: (context, index) {
        final maid = widget.filtered[index];
        return MaidProfileCard(
          maid: maid,
          isShortlisted: store.isShortlisted(maid.id),
          onShortlistTap: () {
            store.toggleShortlist(maid.id);
            setState(() {});
          },
          onViewDetailsTap: () {
            Navigator.push(
              context,
              MaterialPageRoute<void>(
                builder: (context) => MaidProfileDetailPage(maid: maid),
              ),
            ).then((_) => setState(() {}));
          },
        );
      },
    );
  }
}
