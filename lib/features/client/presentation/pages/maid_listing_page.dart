import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../domain/entities/client_portal_models.dart';
import '../state/client_portal_store.dart';
import '../widgets/client_ui_states.dart';
import '../widgets/maid_filter_panel.dart';
import '../widgets/maid_profile_card.dart';
import 'maid_profile_detail_page.dart';

class MaidListingPage extends StatefulWidget {
  const MaidListingPage({super.key});

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
      return const ClientLoadingState();
    }
    final store = ClientPortalStore.instance;
    final List<String> allSkills =
        store.maids.expand((e) => e.skills).toSet().toList()..sort();
    final List<String> allLanguages =
        store.maids.expand((e) => e.languages).toSet().toList()..sort();
    final filtered = _applyFilters(store.maids);
    final bool isMobile = MediaQuery.of(context).size.width < 960;

    return Padding(
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
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search_rounded, color: Color(0xFF94A3B8)),
              hintText: 'Search by name, tags, or skills...',
              hintStyle: TextStyle(color: Color(0xFF94A3B8)),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
            onChanged: onQueryChanged,
          ),
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
        _ResultCards(
          filtered: filtered,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
        ),
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
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: TextField(
            decoration: const InputDecoration(
              prefixIcon: Icon(Icons.search_rounded, color: Color(0xFF94A3B8)),
              hintText: 'Search by name, tags, or skills...',
              hintStyle: TextStyle(color: Color(0xFF94A3B8)),
              border: InputBorder.none,
              contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
            ),
            onChanged: onQueryChanged,
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: _ResultCards(
            filtered: filtered,
            shrinkWrap: false,
            physics: const AlwaysScrollableScrollPhysics(),
          ),
        ),
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
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.stars_rounded, color: Color(0xFFF59E0B)),
              SizedBox(width: 8),
              Text(
                'Explore the Network',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFFF59E0B)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Verified Professionals',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w800,
              color: const Color(0xFF0F172A),
              letterSpacing: -0.5,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Filter by experience, languages, or specialized skills to find your perfect match.',
            style: TextStyle(color: Color(0xFF64748B), fontSize: 16),
          ),
        ],
      ),
    );
  }
}

class _ResultCards extends StatefulWidget {
  const _ResultCards({
    required this.filtered,
    required this.shrinkWrap,
    required this.physics,
  });
  final List<MaidProfile> filtered;
  final bool shrinkWrap;
  final ScrollPhysics physics;

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
          onPressed: () => context.go(AppRoutes.maidListing),
          icon: const Icon(Icons.restart_alt),
          label: const Text('Reset view'),
        ),
      );
    }
    return ListView.separated(
      shrinkWrap: widget.shrinkWrap,
      physics: widget.physics,
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
