import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router/app_routes.dart';
import '../../../../shared/presentation/widgets/responsive_navigation_shell.dart';
import '../../domain/entities/client_portal_models.dart';
import '../state/client_portal_store.dart';
import '../widgets/client_portal_shell.dart';
import '../widgets/client_status_chip.dart';
import '../widgets/client_ui_states.dart';
import '../widgets/request_timeline.dart';

class RequestStatusPage extends StatefulWidget {
  const RequestStatusPage({super.key, required this.navItems});
  final List<NavItem> navItems;

  @override
  State<RequestStatusPage> createState() => _RequestStatusPageState();
}

class _RequestStatusPageState extends State<RequestStatusPage> {
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
      return ClientPortalShell(
        title: 'Request Status',
        navItems: widget.navItems,
        child: const ClientLoadingState(),
      );
    }
    final requests = ClientPortalStore.instance.requests;
    return ClientPortalShell(
      title: 'Request Status',
      navItems: widget.navItems,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (requests.isEmpty)
            ClientEmptyState(
              title: 'No active requests',
              subtitle:
                  'Submit a callback or hire request from any maid profile to start tracking.',
              icon: Icons.track_changes_outlined,
              action: FilledButton.tonal(
                onPressed: () => context.go(AppRoutes.maidListing),
                child: const Text('Find profiles'),
              ),
            )
          else
            ...requests.map(
              (request) => Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  request.id,
                                  style: Theme.of(
                                    context,
                                  ).textTheme.titleMedium,
                                ),
                                Text(
                                  '${_requestTypeLabel(request.type)} for ${request.maidName}',
                                ),
                                Text('Created ${request.createdAtLabel}'),
                              ],
                            ),
                          ),
                          ClientStatusChip(status: request.status),
                        ],
                      ),
                      const SizedBox(height: 12),
                      RequestTimeline(status: request.status),
                      if (request.notes.isNotEmpty) ...[
                        const SizedBox(height: 10),
                        Text('Notes: ${request.notes}'),
                      ],
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
