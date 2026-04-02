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
            clipBehavior: Clip.antiAlias,
            elevation: 0,
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: const BorderSide(color: Color(0xFFF1F5F9), width: 1.5),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (maid.photoUrl != null)
                  Container(
                    height: 350,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF8FAFC),
                      image: DecorationImage(
                        image: NetworkImage(maid.photoUrl!),
                        fit: BoxFit.cover,
                        alignment: Alignment.topCenter, // Focus on the face
                      ),
                    ),
                  ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  maid.name,
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w800,
                                        color: const Color(0xFF0F172A),
                                      ),
                                ),
                                const SizedBox(height: 6),
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.location_on_outlined,
                                      size: 16,
                                      color: Color(0xFF64748B),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      maid.location,
                                      style: const TextStyle(
                                        color: Color(0xFF64748B),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                    const SizedBox(width: 16),
                                    const Icon(
                                      Icons.cake_outlined,
                                      size: 16,
                                      color: Color(0xFF64748B),
                                    ),
                                    const SizedBox(width: 4),
                                    Text(
                                      '${maid.age} Years old',
                                      style: const TextStyle(
                                        color: Color(0xFF64748B),
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF0F9FF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              '\$${maid.monthlyRate}/mo',
                              style: const TextStyle(
                                color: Color(0xFF0EA5E9),
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),
                      const Text(
                        'Professional Profile',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF475569),
                          letterSpacing: 0.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                      Text(
                        maid.bio,
                        style: const TextStyle(
                          color: Color(0xFF334155),
                          height: 1.6,
                          fontSize: 15,
                        ),
                      ),
                      const SizedBox(height: 24),
                      _sectionLabel('Core Skills'),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: maid.skills
                            .map((e) => _customChip(e, const Color(0xFF6366F1)))
                            .toList(),
                      ),
                      const SizedBox(height: 20),
                      _sectionLabel('Languages'),
                      const SizedBox(height: 12),
                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: maid.languages
                            .map((e) => _customChip(e, const Color(0xFF10B981)))
                            .toList(),
                      ),
                    ],
                  ),
                ),
              ],
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

  Widget _sectionLabel(String text) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: Color(0xFF475569),
        letterSpacing: 0.5,
      ),
    );
  }

  Widget _customChip(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
