import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../state/client_portal_store.dart';
import '../widgets/client_ui_states.dart';
import '../widgets/maid_profile_card.dart';
import 'maid_profile_detail_page.dart';

class ShortlistPage extends StatefulWidget {
  const ShortlistPage({super.key});

  @override
  State<ShortlistPage> createState() => _ShortlistPageState();
}

class _ShortlistPageState extends State<ShortlistPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    ClientPortalStore.instance.addListener(_onStoreChanged);
    _load();
  }

  @override
  void dispose() {
    ClientPortalStore.instance.removeListener(_onStoreChanged);
    super.dispose();
  }

  void _onStoreChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _load() async {
    await ClientPortalStore.instance.ensureLoaded();
    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const ClientLoadingState();
    }
    final store = ClientPortalStore.instance;
    final shortlist = store.shortlist;
    return ListView(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
        children: [
          Container(
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
                    Icon(Icons.favorite_rounded, color: Color(0xFFF43F5E)),
                    SizedBox(width: 8),
                    Text(
                      'Your Favorites',
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.w700, color: Color(0xFFF43F5E)),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                Text(
                  'Shortlisted Profiles',
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF0F172A),
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Review and compare the profiles you have saved before sending a request.',
                  style: TextStyle(color: Color(0xFF64748B), fontSize: 16),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          if (shortlist.isEmpty)
            ClientEmptyState(
              title: 'No saved maids yet',
              subtitle:
                  'Use shortlist to quickly compare and revisit your favorite profiles.',
              icon: Icons.favorite_border,
              action: FilledButton(
                style: FilledButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                onPressed: () => context.go(AppRoutes.maidListing),
                child: const Text('Browse profiles', style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            )
          else
            ...shortlist.map(
              (maid) => Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: MaidProfileCard(
                  maid: maid,
                  isShortlisted: true,
                  onShortlistTap: () {
                    store.toggleShortlist(maid.id);
                    setState(() {});
                  },
                  onViewDetailsTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute<void>(
                        builder: (_) => MaidProfileDetailPage(maid: maid),
                      ),
                    ).then((_) => setState(() {}));
                  },
                ),
              ),
            ),
        ],
      );
  }
}
