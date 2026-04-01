import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../state/client_portal_store.dart';
import '../widgets/client_portal_shell.dart';
import '../widgets/client_ui_states.dart';
import '../../../../shared/presentation/widgets/responsive_navigation_shell.dart';

class ClientDashboardPage extends StatefulWidget {
  const ClientDashboardPage({super.key, required this.navItems});

  final List<NavItem> navItems;

  @override
  State<ClientDashboardPage> createState() => _ClientDashboardPageState();
}

class _ClientDashboardPageState extends State<ClientDashboardPage> {
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
        title: 'Client Dashboard',
        navItems: widget.navItems,
        child: const ClientLoadingState(),
      );
    }

    final store = ClientPortalStore.instance;
    return ClientPortalShell(
      title: 'Client Dashboard',
      navItems: widget.navItems,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _HeroHeader(
            onSearchTap: () => context.go(AppRoutes.maidListing),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: [
              _MetricCard(
                label: 'Available maids',
                value: '${store.maids.length}',
              ),
              _MetricCard(
                label: 'Shortlisted',
                value: '${store.shortlist.length}',
              ),
              _MetricCard(label: 'Requests', value: '${store.requests.length}'),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            'Popular service bundles',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 8),
          const _CategoryRow(),
          const SizedBox(height: 18),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Start a new request',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Browse verified profiles and send callback or hire requests.',
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => context.go(AppRoutes.maidListing),
                    child: const Text('Explore maid profiles'),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 18),
          if (store.requests.isNotEmpty) ...[
            Text(
              'Recent request',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            _RequestSnippet(
              requestId: store.requests.first.id,
              maidName: store.requests.first.maidName,
            ),
          ],
        ],
      ),
    );
  }
}

class _MetricCard extends StatelessWidget {
  const _MetricCard({required this.label, required this.value});
  final String label;
  final String value;
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 220,
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(label),
            ],
          ),
        ),
      ),
    );
  }
}

class _RequestSnippet extends StatelessWidget {
  const _RequestSnippet({required this.requestId, required this.maidName});
  final String requestId;
  final String maidName;
  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text('$requestId - $maidName'),
        subtitle: const Text(
          'Tap Request Status Tracking in menu to view timeline.',
        ),
      ),
    );
  }
}

class _HeroHeader extends StatelessWidget {
  const _HeroHeader({required this.onSearchTap});
  final VoidCallback onSearchTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFF1F4F99), Color(0xFF356ECB)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Welcome back, Priya',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Book trusted home help with transparent profiles and request tracking.',
            style: TextStyle(color: Colors.white70),
          ),
          const SizedBox(height: 12),
          Material(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            child: InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: onSearchTap,
              child: const Padding(
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Row(
                  children: [
                    Icon(Icons.search),
                    SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Search for maids by skill, language, availability',
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CategoryRow extends StatelessWidget {
  const _CategoryRow();
  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 10,
      runSpacing: 10,
      children: const [
        _CategoryTile(icon: Icons.child_care_outlined, label: 'Child Care'),
        _CategoryTile(icon: Icons.elderly_outlined, label: 'Elder Support'),
        _CategoryTile(
          icon: Icons.cleaning_services_outlined,
          label: 'Deep Cleaning',
        ),
        _CategoryTile(icon: Icons.restaurant_menu_outlined, label: 'Cooking'),
      ],
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.icon, required this.label});
  final IconData icon;
  final String label;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 160,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFDDE4F1)),
      ),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF1F4F99)),
          const SizedBox(width: 8),
          Expanded(child: Text(label)),
        ],
      ),
    );
  }
}
