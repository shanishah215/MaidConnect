import 'package:flutter/material.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../shared/presentation/widgets/responsive_navigation_shell.dart';
import '../state/client_portal_store.dart';
import '../widgets/client_portal_shell.dart';
import '../widgets/client_ui_states.dart';
import '../widgets/maid_profile_card.dart';
import 'maid_profile_detail_page.dart';

class ShortlistPage extends StatefulWidget {
  const ShortlistPage({super.key, required this.navItems});
  final List<NavItem> navItems;

  @override
  State<ShortlistPage> createState() => _ShortlistPageState();
}

class _ShortlistPageState extends State<ShortlistPage> {
  bool _isLoading = true;

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

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return ClientPortalShell(
        title: 'Shortlist',
        navItems: widget.navItems,
        child: const ClientLoadingState(),
      );
    }
    final store = ClientPortalStore.instance;
    final shortlist = store.shortlist;
    return ClientPortalShell(
      title: 'Shortlist',
      navItems: widget.navItems,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (shortlist.isEmpty)
            ClientEmptyState(
              title: 'No saved maids yet',
              subtitle:
                  'Use shortlist to quickly compare and revisit your favorite profiles.',
              icon: Icons.favorite_border,
              action: FilledButton.tonal(
                onPressed: () => Navigator.pushReplacementNamed(
                  context,
                  AppRoutes.maidListing,
                ),
                child: const Text('Browse profiles'),
              ),
            )
          else
            ...shortlist.map(
              (maid) => Padding(
                padding: const EdgeInsets.only(bottom: 10),
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
      ),
    );
  }
}
