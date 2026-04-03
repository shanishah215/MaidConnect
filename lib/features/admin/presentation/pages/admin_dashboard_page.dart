import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/app_routes.dart';
import '../state/admin_portal_store.dart';
import '../widgets/admin_stat_tile.dart';
import '../widgets/admin_status_chip.dart';

class AdminDashboardPage extends StatefulWidget {
  const AdminDashboardPage({super.key});

  @override
  State<AdminDashboardPage> createState() => _AdminDashboardPageState();
}

class _AdminDashboardPageState extends State<AdminDashboardPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    AdminPortalStore.instance.addListener(_onStoreChanged);
    _load();
  }

  @override
  void dispose() {
    AdminPortalStore.instance.removeListener(_onStoreChanged);
    super.dispose();
  }

  void _onStoreChanged() {
    if (mounted) setState(() {});
  }

  Future<void> _load() async {
    await AdminPortalStore.instance.ensureLoaded();
    if (mounted) setState(() => _isLoading = false);
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) return const Center(child: CircularProgressIndicator());

    final store = AdminPortalStore.instance;
    final stats = store.analytics;

    return ListView(
      padding: const EdgeInsets.all(32),
      children: [
        // ── Header ───────────────────────────────────────────────────────────
        Row(
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Overview',
                  style: Theme.of(
                    context,
                  ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
                ),
                Text(
                  'Welcome back to the MaidConnect admin panel.',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
            const Spacer(),
            FilledButton.icon(
              onPressed: () => context.go(AppRoutes.bulkUpload),
              icon: const Icon(Icons.upload_file),
              label: const Text('Bulk Import'),
            ),
          ],
        ),
        const SizedBox(height: 32),

        // ── Stats Section ────────────────────────────────────────────────────
        _buildStatsResponsive(context, stats),
        const SizedBox(height: 48),

        // ── Middle Section ───────────────────────────────────────────────────
        if (MediaQuery.of(context).size.width < 1100)
          Column(
            children: [
              _RecentInquiriesTable(),
              const SizedBox(height: 24),
              _QuickActionsCard(),
            ],
          )
        else
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Recent Inquiries
              Expanded(flex: 2, child: _RecentInquiriesTable()),
              const SizedBox(width: 32),
              // Quick Actions or Status
              Expanded(flex: 1, child: _QuickActionsCard()),
            ],
          ),
        const SizedBox(height: 48),
      ],
    );
  }

  Widget _buildStatsResponsive(BuildContext context, dynamic stats) {
    final width = MediaQuery.of(context).size.width;
    final isDesktop = width >= 1100;

    final tiles = [
      AdminStatTile(
        label: 'Total Clients',
        value: '${stats?.totalUsers ?? 0}',
        icon: Icons.people_outline,
        color: const Color(0xFF3B82F6),
      ),
      AdminStatTile(
        label: 'Active Maids',
        value: '${stats?.activeMaids ?? 0}',
        icon: Icons.badge_outlined,
        color: const Color(0xFF8B5CF6),
      ),
      AdminStatTile(
        label: 'Active Requests',
        value: '${stats?.activeRequests ?? 0}',
        icon: Icons.sync_alt,
        color: const Color(0xFF10B981),
      ),
      AdminStatTile(
        label: 'Pending Approvals',
        value: '${stats?.pendingApprovals ?? 0}',
        icon: Icons.pending_actions,
        color: const Color(0xFFF59E0B),
      ),
    ];

    if (isDesktop) {
      return GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 4,
        crossAxisSpacing: 24,
        mainAxisSpacing: 24,
        childAspectRatio: 1.4, // Adjusted from 1.8 to prevent overflow
        children: tiles,
      );
    } else {
      // Mobile/Tablet: keep it stacked and wide
      return Wrap(
        spacing: 24,
        runSpacing: 24,
        children: tiles.map((tile) => 
            SizedBox(
              width: width < 600 ? double.infinity : (width - 64 - 24) / 2, // 1 or 2 per row
              child: tile,
            )).toList(),
      );
    }
  }
}

class _RecentInquiriesTable extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final inquiries = AdminPortalStore.instance.inquiries.take(5).toList();

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Inquiries',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
              ),
              TextButton(
                onPressed: () => context.go(AppRoutes.requestsManagement),
                child: const Text('View All'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Table(
            columnWidths: const {
              0: FlexColumnWidth(2),
              1: FlexColumnWidth(2),
              2: FlexColumnWidth(1.5),
            },
            children: [
              // Header
              const TableRow(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'Client',
                      style: TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'Maid',
                      style: TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text(
                      'Status',
                      style: TextStyle(
                        color: Color(0xFF64748B),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              // Rows
              ...inquiries.map(
                (inq) => TableRow(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                        inq.clientName,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Row(
                        children: [
                          CircleAvatar(
                            radius: 12,
                            backgroundColor: const Color(0xFFF1F5F9),
                            backgroundImage: AdminPortalStore.instance
                                        .getMaidById(inq.maidId)
                                        ?.photoUrl !=
                                    null
                                ? NetworkImage(
                                    AdminPortalStore.instance
                                        .getMaidById(inq.maidId)!
                                        .photoUrl!,
                                  )
                                : null,
                            child: AdminPortalStore.instance
                                        .getMaidById(inq.maidId)
                                        ?.photoUrl ==
                                    null
                                ? const Icon(
                                    Icons.person,
                                    size: 12,
                                    color: Color(0xFF94A3B8),
                                  )
                                : null,
                          ),
                          const SizedBox(width: 8),
                          Text(
                            inq.maidName,
                            style: const TextStyle(fontSize: 14),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: AdminStatusChip(
                        label:
                            inq.status.name.substring(0, 1).toUpperCase() +
                            inq.status.name.substring(1),
                        color: _getStatusColor(inq.status),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getStatusColor(dynamic status) {
    switch (status.toString()) {
      case 'InquiryStatus.pending':
        return const Color(0xFFF59E0B);
      case 'InquiryStatus.approved':
        return const Color(0xFF10B981);
      case 'InquiryStatus.rejected':
        return const Color(0xFFEF4444);
      case 'InquiryStatus.assigned':
        return const Color(0xFF6366F1);
      default:
        return const Color(0xFF94A3B8);
    }
  }
}

class _QuickActionsCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A), // Dark navy like sidebar
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Quick Actions',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
              fontSize: 16,
            ),
          ),
          const SizedBox(height: 24),
          _ActionButton(
            label: 'Add New Maid',
            icon: Icons.add,
            onPressed: () => context.go(AppRoutes.adminMaidAdd),
          ),
          const SizedBox(height: 12),
          _ActionButton(
            label: 'Manage Clients',
            icon: Icons.people_outline,
            onPressed: () => context.go(AppRoutes.adminClients),
          ),
          // Analytics Action Removed
        ],
      ),
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.icon,
    required this.onPressed,
  });
  final String label;
  final IconData icon;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFF1E293B),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: const Color(0xFF334155)),
        ),
        child: Row(
          children: [
            Icon(icon, color: Colors.white, size: 20),
            const SizedBox(width: 12),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
                fontSize: 14,
              ),
            ),
            const Spacer(),
            Icon(Icons.chevron_right, color: Colors.grey[500], size: 16),
          ],
        ),
      ),
    );
  }
}
