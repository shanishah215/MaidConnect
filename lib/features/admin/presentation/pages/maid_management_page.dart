import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../app/router/app_routes.dart';
import '../../domain/entities/admin_models.dart';
import '../state/admin_portal_store.dart';
import '../widgets/admin_search_bar.dart';
import '../widgets/admin_status_chip.dart';
import '../widgets/admin_dialog.dart';

class MaidManagementPage extends StatefulWidget {
  const MaidManagementPage({super.key});

  @override
  State<MaidManagementPage> createState() => _MaidManagementPageState();
}

class _MaidManagementPageState extends State<MaidManagementPage> {
  final TextEditingController _searchController = TextEditingController();
  List<AdminMaidProfile> _filteredMaids = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await AdminPortalStore.instance.ensureLoaded();
    if (mounted) {
      setState(() {
        _filteredMaids = AdminPortalStore.instance.maids;
        _isLoading = false;
      });
    }
  }

  void _onSearch(String query) {
    setState(() {
      _filteredMaids = AdminPortalStore.instance.searchMaids(query);
    });
  }

  Future<void> _deleteMaid(AdminMaidProfile maid) async {
    final confirmed = await AdminDialog.confirm(
      context,
      title: 'Delete Maid Profile',
      message: 'Are you sure you want to delete ${maid.name}? This action cannot be undone.',
      confirmLabel: 'Delete',
    );

    if (confirmed) {
      setState(() {
        AdminPortalStore.instance.deleteMaid(maid.id);
        _onSearch(_searchController.text);
      });
      if (mounted) AdminDialog.showSnack(context, '${maid.name} deleted successfully.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Text(
                'Maid Profile Management',
                style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const Spacer(),
              FilledButton.icon(
                onPressed: () => context.go(AppRoutes.adminMaidAdd),
                icon: const Icon(Icons.add),
                label: const Text('Add New Maid'),
              ),
            ],
          ),
          const SizedBox(height: 32),

          // Search and Filters
          AdminSearchBar(
            controller: _searchController,
            hintText: 'Search by name, nationality or skill...',
            onChanged: _onSearch,
            trailing: [
              IconButton(
                onPressed: () {},
                icon: const Icon(Icons.filter_list),
                tooltip: 'Show Filters',
              ),
            ],
          ),
          const SizedBox(height: 24),

          // Table
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _filteredMaids.isEmpty
                      ? const Center(child: Text('No profiles found Match search.'))
                      : SingleChildScrollView(
                          child: DataTable(
                            horizontalMargin: 24,
                            columnSpacing: 24,
                            columns: const [
                              DataColumn(label: Text('Name', style: TextStyle(fontWeight: FontWeight.w700))),
                              DataColumn(label: Text('Nationality', style: TextStyle(fontWeight: FontWeight.w700))),
                              DataColumn(label: Text('Experience', style: TextStyle(fontWeight: FontWeight.w700))),
                              DataColumn(label: Text('Status', style: TextStyle(fontWeight: FontWeight.w700))),
                              DataColumn(label: Text('Actions', style: TextStyle(fontWeight: FontWeight.w700))),
                            ],
                            rows: _filteredMaids.map((maid) {
                              return DataRow(cells: [
                                DataCell(Text(maid.name, style: const TextStyle(fontWeight: FontWeight.w600))),
                                DataCell(Text(maid.nationality)),
                                DataCell(Text('${maid.experienceYears} Years')),
                                DataCell(AdminStatusChip(
                                  label: _getStatusLabel(maid.availabilityStatus),
                                  color: _getStatusColor(maid.availabilityStatus),
                                )),
                                DataCell(Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.edit_outlined, size: 20, color: Color(0xFF64748B)),
                                      onPressed: () => context.go('${AppRoutes.adminMaidEdit}/${maid.id}'),
                                      tooltip: 'Edit',
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline, size: 20, color: Color(0xFFEF4444)),
                                      onPressed: () => _deleteMaid(maid),
                                      tooltip: 'Delete',
                                    ),
                                  ],
                                )),
                              ]);
                            }).toList(),
                          ),
                        ),
            ),
          ),
        ],
      ),
    );
  }

  String _getStatusLabel(AdminMaidAvailability status) {
    if (status == AdminMaidAvailability.available) return 'Available';
    if (status == AdminMaidAvailability.unavailable) return 'Unavailable';
    return 'On Leave';
  }

  Color _getStatusColor(AdminMaidAvailability status) {
    if (status == AdminMaidAvailability.available) return const Color(0xFF10B981);
    if (status == AdminMaidAvailability.unavailable) return const Color(0xFFEF4444);
    return const Color(0xFFF59E0B);
  }
}
