import 'package:flutter/material.dart';
import '../../domain/entities/admin_models.dart';
import '../state/admin_portal_store.dart';
import '../widgets/admin_search_bar.dart';
import '../widgets/admin_status_chip.dart';
import '../widgets/admin_dialog.dart';

class ClientManagementPage extends StatefulWidget {
  const ClientManagementPage({super.key});

  @override
  State<ClientManagementPage> createState() => _ClientManagementPageState();
}

class _ClientManagementPageState extends State<ClientManagementPage> {
  final TextEditingController _searchController = TextEditingController();
  List<AdminClient> _filteredClients = [];
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
        _filteredClients = AdminPortalStore.instance.clients;
        _isLoading = false;
      });
    }
  }

  void _onSearch(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredClients = AdminPortalStore.instance.clients;
      } else {
        _filteredClients = AdminPortalStore.instance.clients
            .where(
              (c) =>
                  c.name.toLowerCase().contains(query.toLowerCase()) ||
                  c.email.toLowerCase().contains(query.toLowerCase()),
            )
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Text(
            'Client Management',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 32),

          // Search and Filters
          AdminSearchBar(
            controller: _searchController,
            hintText: 'Search by client name or email...',
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
                  : _filteredClients.isEmpty
                  ? const Center(child: Text('No clients found.'))
                  : SingleChildScrollView(
                      child: DataTable(
                        horizontalMargin: 24,
                        columnSpacing: 24,
                        columns: const [
                          DataColumn(
                            label: Text(
                              'Name',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Email',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Phone',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Status',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Actions',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                        rows: _filteredClients.map((client) {
                          return DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  client.name,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                              DataCell(Text(client.email)),
                              DataCell(Text(client.phone ?? '')),
                              DataCell(
                                AdminStatusChip(
                                  label:
                                      client.status == AdminClientStatus.active
                                      ? 'Active'
                                      : 'Suspended',
                                  color:
                                      client.status == AdminClientStatus.active
                                      ? const Color(0xFF10B981)
                                      : const Color(0xFFEF4444),
                                ),
                              ),
                              DataCell(
                                Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(
                                        Icons.visibility_outlined,
                                        size: 20,
                                        color: Color(0xFF64748B),
                                      ),
                                      onPressed: () => AdminDialog.showSnack(
                                        context,
                                        'Mock: View client details.',
                                      ),
                                      tooltip: 'View Details',
                                    ),
                                    Switch(
                                      value:
                                          client.status ==
                                          AdminClientStatus.active,
                                      onChanged: (v) => AdminDialog.showSnack(
                                        context,
                                        'Mock: Account status toggled.',
                                      ),
                                      activeThumbColor: const Color(0xFF10B981),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          );
                        }).toList(),
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}
