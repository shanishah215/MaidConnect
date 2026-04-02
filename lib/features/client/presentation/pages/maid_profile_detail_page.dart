import 'package:flutter/material.dart';

import '../state/client_portal_store.dart';
import '../../domain/entities/client_portal_models.dart';

class MaidProfileDetailPage extends StatefulWidget {
  const MaidProfileDetailPage({super.key, required this.maid});
  final MaidProfile maid;

  @override
  State<MaidProfileDetailPage> createState() => _MaidProfileDetailPageState();
}

class _MaidProfileDetailPageState extends State<MaidProfileDetailPage> {
  final TextEditingController _notesController = TextEditingController();
  ClientRequestType _type = ClientRequestType.callback;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final store = ClientPortalStore.instance;
    final maid = widget.maid;

    return Scaffold(
      appBar: AppBar(title: Text(maid.name)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    maid.name,
                    style: Theme.of(context).textTheme.headlineSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '${maid.age} years old · ${maid.experienceYears} years experience',
                  ),
                  Text('Location: ${maid.location}'),
                  Text('Expected rate: \$${maid.monthlyRate}/month'),
                  const SizedBox(height: 12),
                  Text(maid.bio),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: maid.skills
                        .map((e) => Chip(label: Text(e)))
                        .toList(),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: maid.languages
                        .map((e) => Chip(label: Text(e)))
                        .toList(),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Request callback / hire',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 10),
                  SegmentedButton<ClientRequestType>(
                    segments: const <ButtonSegment<ClientRequestType>>[
                      ButtonSegment<ClientRequestType>(
                        value: ClientRequestType.callback,
                        label: Text('Callback'),
                      ),
                      ButtonSegment<ClientRequestType>(
                        value: ClientRequestType.hire,
                        label: Text('Hire request'),
                      ),
                    ],
                    selected: <ClientRequestType>{_type},
                    onSelectionChanged: (value) =>
                        setState(() => _type = value.first),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _notesController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      labelText: 'Notes (optional)',
                      hintText:
                          'Preferred time, household needs, schedule, etc.',
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      OutlinedButton.icon(
                        onPressed: () {
                          store.toggleShortlist(maid.id);
                          setState(() {});
                        },
                        icon: Icon(
                          store.isShortlisted(maid.id)
                              ? Icons.favorite
                              : Icons.favorite_border,
                          color: store.isShortlisted(maid.id)
                              ? Colors.red
                              : null,
                        ),
                        label: Text(
                          store.isShortlisted(maid.id)
                              ? 'Saved in shortlist'
                              : 'Save to shortlist',
                        ),
                      ),
                      FilledButton(
                        onPressed: () async {
                          final messenger = ScaffoldMessenger.of(context);
                          final navigator = Navigator.of(context);
                          
                          await store.createRequest(
                            maid: maid,
                            type: _type,
                            notes: _notesController.text.trim(),
                          );
                          
                          messenger.showSnackBar(
                            const SnackBar(
                              content: Text('Request submitted successfully.'),
                            ),
                          );
                          navigator.pop();
                        },
                        child: const Text('Submit request'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
