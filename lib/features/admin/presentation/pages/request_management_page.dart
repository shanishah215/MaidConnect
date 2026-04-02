import 'package:flutter/material.dart';
import '../../domain/entities/admin_models.dart';
import '../state/admin_portal_store.dart';
import '../widgets/admin_search_bar.dart';
import '../widgets/admin_status_chip.dart';
import '../widgets/admin_dialog.dart';

class RequestManagementPage extends StatefulWidget {
  const RequestManagementPage({super.key});

  @override
  State<RequestManagementPage> createState() => _RequestManagementPageState();
}

class _RequestManagementPageState extends State<RequestManagementPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  final TextEditingController _searchController = TextEditingController();
  List<ClientInquiry> _displayInquiries = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
    _tabController.addListener(_handleTabChange);
    AdminPortalStore.instance.addListener(_onStoreChanged);
    _load();
  }

  @override
  void dispose() {
    AdminPortalStore.instance.removeListener(_onStoreChanged);
    _tabController.dispose();
    super.dispose();
  }

  void _onStoreChanged() {
    if (mounted) _updateDisplay();
  }

  Future<void> _load() async {
    await AdminPortalStore.instance.ensureLoaded();
    if (mounted) {
      _updateDisplay();
      setState(() => _isLoading = false);
    }
  }

  void _handleTabChange() {
    if (_tabController.indexIsChanging) return;
    _updateDisplay();
  }

  void _updateDisplay() {
    final status = _getStatusFromTabIndex(_tabController.index);
    setState(() {
      _displayInquiries = AdminPortalStore.instance.getInquiriesByStatus(
        status,
      );
      if (_searchController.text.isNotEmpty) {
        final query = _searchController.text.toLowerCase();
        _displayInquiries = _displayInquiries
            .where(
              (i) =>
                  i.clientName.toLowerCase().contains(query) ||
                  i.maidName.toLowerCase().contains(query),
            )
            .toList();
      }
    });
  }

  InquiryStatus? _getStatusFromTabIndex(int index) {
    switch (index) {
      case 1:
        return InquiryStatus.pending;
      case 2:
        return InquiryStatus.approved;
      case 3:
        return InquiryStatus.rejected;
      case 4:
        return InquiryStatus.assigned;
      case 5:
        return InquiryStatus.completed;
      default:
        return null;
    }
  }

  Future<void> _approve(ClientInquiry inq) async {
    final ok = await AdminDialog.confirm(
      context,
      title: 'Approve & Hire',
      message:
          'Approve request from ${inq.clientName} and assign ${inq.maidName} as the primary professional?',
      confirmLabel: 'Approve & Hire',
      confirmColor: const Color(0xFF10B981),
      icon: Icons.verified_user_outlined,
    );
    if (ok) {
      await AdminPortalStore.instance.assignInquiry(inq.id, inq.maidName);
      _updateDisplay();
      if (mounted)
        AdminDialog.showSnack(
          context,
          'Request approved and ${inq.maidName} assigned.',
        );
    }
  }

  Future<void> _reject(ClientInquiry inq) async {
    final ok = await AdminDialog.confirm(
      context,
      title: 'Reject Inquiry',
      message: 'Are you sure you want to reject this request?',
      confirmLabel: 'Reject',
    );
    if (ok) {
      await AdminPortalStore.instance.rejectInquiry(inq.id);
      _updateDisplay();
      if (mounted) AdminDialog.showSnack(context, 'Inquiry rejected.');
    }
  }

  Future<void> _assign(ClientInquiry inq) async {
    final maids = AdminPortalStore.instance.maids
        .where((m) => m.availabilityStatus == AdminMaidAvailability.available)
        .map((m) => m.name)
        .toList();

    if (maids.isEmpty) {
      AdminDialog.showSnack(
        context,
        'No available maids to assign.',
        isError: true,
      );
      return;
    }

    final selectedMaid = await AdminDialog.assignMaid(
      context,
      maidNames: maids,
    );
    if (selectedMaid != null) {
      await AdminPortalStore.instance.assignInquiry(inq.id, selectedMaid);
      _updateDisplay();
      if (mounted)
        AdminDialog.showSnack(context, 'Assigned $selectedMaid to inquiry.');
    }
  }

  Future<void> _complete(ClientInquiry inq) async {
    final ok = await AdminDialog.confirm(
      context,
      title: 'Complete Request',
      message: 'Mark request from ${inq.clientName} as successfully completed?',
      confirmLabel: 'Complete',
      confirmColor: const Color(0xFF6366F1),
      icon: Icons.task_alt_rounded,
    );
    if (ok) {
      await AdminPortalStore.instance.completeInquiry(inq.id);
      _updateDisplay();
      if (mounted)
        AdminDialog.showSnack(context, 'Request marked as completed.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Request & Inquiry Management',
            style: Theme.of(
              context,
            ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 24),

          // Filters TabBar
          TabBar(
            controller: _tabController,
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: const Color(0xFF64748B),
            indicatorSize: TabBarIndicatorSize.tab,
            tabs: const [
              Tab(text: 'All Requests'),
              Tab(text: 'Pending'),
              Tab(text: 'Approved'),
              Tab(text: 'Rejected'),
              Tab(text: 'Assigned'),
            ],
          ),
          const SizedBox(height: 24),

          // Search
          AdminSearchBar(
            controller: _searchController,
            hintText: 'Search by client or maid name...',
            onChanged: (v) => _updateDisplay(),
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
                  : _displayInquiries.isEmpty
                  ? const Center(
                      child: Text('No inquiries found in this category.'),
                    )
                  : SingleChildScrollView(
                      child: DataTable(
                        horizontalMargin: 24,
                        columnSpacing: 24,
                        columns: const [
                          DataColumn(
                            label: Text(
                              'Inquiry ID',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Client',
                              style: TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ),
                          DataColumn(
                            label: Text(
                              'Maid Preferred',
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
                              'Assigned Maid',
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
                        rows: _displayInquiries.map((inq) {
                          return DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  inq.id,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 13,
                                  ),
                                ),
                              ),
                              DataCell(Text(inq.clientName)),
                              DataCell(Text(inq.maidName)),
                              DataCell(
                                AdminStatusChip(
                                  label:
                                      inq.status.name
                                          .substring(0, 1)
                                          .toUpperCase() +
                                      inq.status.name.substring(1),
                                  color: _getStatusColor(inq.status),
                                ),
                              ),
                              DataCell(
                                Text(
                                  inq.assignedTo ?? '-',
                                  style: TextStyle(
                                    color: inq.assignedTo != null
                                        ? const Color(0xFF6366F1)
                                        : Colors.black,
                                  ),
                                ),
                              ),
                              DataCell(
                                Row(
                                  children: [
                                    if (inq.status ==
                                        InquiryStatus.pending) ...[
                                      IconButton(
                                        icon: const Icon(
                                          Icons.check_circle_outline,
                                          color: Color(0xFF10B981),
                                          size: 20,
                                        ),
                                        onPressed: () => _approve(inq),
                                        tooltip: 'Approve',
                                      ),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.cancel_outlined,
                                          color: Color(0xFFEF4444),
                                          size: 20,
                                        ),
                                        onPressed: () => _reject(inq),
                                        tooltip: 'Reject',
                                      ),
                                    ],
                                    if (inq.status == InquiryStatus.approved)
                                      IconButton(
                                        icon: const Icon(
                                          Icons.assignment_ind_outlined,
                                          color: Color(0xFF6366F1),
                                          size: 20,
                                        ),
                                        onPressed: () => _assign(inq),
                                        tooltip: 'Assign Maid',
                                      ),
                                    if (inq.status == InquiryStatus.assigned)
                                      IconButton(
                                        icon: const Icon(
                                          Icons.check_circle,
                                          color: Color(0xFF6366F1),
                                          size: 20,
                                        ),
                                        onPressed: () => _complete(inq),
                                        tooltip: 'Mark Completed',
                                      ),
                                    IconButton(
                                      icon: const Icon(
                                        Icons.visibility_outlined,
                                        size: 20,
                                        color: Color(0xFF64748B),
                                      ),
                                      onPressed: () => AdminDialog.showSnack(
                                        context,
                                        'Note: ${inq.notes}',
                                      ),
                                      tooltip: 'View Notes',
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

  Color _getStatusColor(InquiryStatus status) {
    switch (status) {
      case InquiryStatus.pending:
        return const Color(0xFFF59E0B);
      case InquiryStatus.approved:
        return const Color(0xFF10B981);
      case InquiryStatus.rejected:
        return const Color(0xFFEF4444);
      case InquiryStatus.assigned:
        return const Color(0xFF6366F1);
      case InquiryStatus.completed:
        return const Color(0xFF5A36C9);
    }
  }
}
