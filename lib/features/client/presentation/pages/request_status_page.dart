import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../domain/entities/client_portal_models.dart';
import '../state/client_portal_store.dart';
import '../widgets/client_status_chip.dart';
import '../widgets/client_ui_states.dart';
import '../widgets/request_timeline.dart';

class RequestStatusPage extends StatefulWidget {
  const RequestStatusPage({super.key});

  @override
  State<RequestStatusPage> createState() => _RequestStatusPageState();
}

class _RequestStatusPageState extends State<RequestStatusPage> {
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

  String _requestTypeLabel(ClientRequestType type) {
    switch (type) {
      case ClientRequestType.callback:
        return 'Callback';
      case ClientRequestType.hire:
        return 'Hire request';
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const ClientLoadingState();
    }
    final requests = ClientPortalStore.instance.requests;
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
                  Icon(
                    Icons.assignment_turned_in_rounded,
                    color: Color(0xFF10B981),
                  ),
                  SizedBox(width: 8),
                  Text(
                    'Applications & Requests',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF10B981),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                'Request Status',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF0F172A),
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Track the progress of your active callbacks or hiring requests in real-time.',
                style: TextStyle(color: Color(0xFF64748B), fontSize: 16),
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        if (requests.isEmpty)
          ClientEmptyState(
            title: 'No active requests',
            subtitle:
                'Submit a callback or hire request from any maid profile to start tracking.',
            icon: Icons.track_changes_outlined,
            action: FilledButton(
              style: FilledButton.styleFrom(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () => context.go(AppRoutes.maidListing),
              child: const Text(
                'Find profiles',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          )
        else
          ...requests.map(
            (request) => Container(
              margin: const EdgeInsets.only(bottom: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: const Color(0xFFE2E8F0)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.015),
                    blurRadius: 16,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          height: 48,
                          width: 48,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF1F5F9),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(
                            Icons.receipt_long_rounded,
                            color: Color(0xFF64748B),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(
                                    request.notes,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w700,
                                      fontSize: 16,
                                      color: Color(0xFF0F172A),
                                    ),
                                  ),
                                  const Spacer(),
                                  ClientStatusChip(status: request.status),
                                ],
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${_requestTypeLabel(request.type)} for ${request.maidName}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w500,
                                  color: Color(0xFF334155),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Created ${request.createdAtLabel}',
                                style: const TextStyle(
                                  color: Color(0xFF94A3B8),
                                  fontSize: 13,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 24),
                    RequestTimeline(status: request.status),
                    if (request.status == ClientRequestStatus.hired &&
                        request.assignedTo != null) ...[
                      const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 12,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF0F9FF),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(color: const Color(0xFFBAE6FD)),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.stars_rounded,
                              color: Color(0xFF0284C7),
                              size: 20,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              'Congratulations! ${request.assignedTo} has been assigned to your request.',
                              style: const TextStyle(
                                color: Color(0xFF0369A1),
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
