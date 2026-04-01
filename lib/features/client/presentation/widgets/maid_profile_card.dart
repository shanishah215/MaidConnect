import 'package:flutter/material.dart';

import '../../domain/entities/client_portal_models.dart';

class MaidProfileCard extends StatelessWidget {
  const MaidProfileCard({
    super.key,
    required this.maid,
    required this.isShortlisted,
    required this.onShortlistTap,
    required this.onViewDetailsTap,
  });

  final MaidProfile maid;
  final bool isShortlisted;
  final VoidCallback onShortlistTap;
  final VoidCallback onViewDetailsTap;

  String _availabilityLabel(MaidAvailability availability) {
    switch (availability) {
      case MaidAvailability.immediate:
        return 'Immediate';
      case MaidAvailability.thisWeek:
        return 'This week';
      case MaidAvailability.thisMonth:
        return 'This month';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(14),
        side: const BorderSide(color: Color(0xFFDDE4F1)),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 22,
                  child: Text(maid.name.substring(0, 1)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        maid.name,
                        style: Theme.of(context).textTheme.titleMedium
                            ?.copyWith(fontWeight: FontWeight.w700),
                      ),
                      Text(
                        '${maid.location}  |  ${maid.experienceYears} yrs exp',
                      ),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: onShortlistTap,
                  icon: Icon(
                    isShortlisted ? Icons.favorite : Icons.favorite_border,
                    color: isShortlisted ? const Color(0xFFE53935) : null,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Text(maid.bio, maxLines: 2, overflow: TextOverflow.ellipsis),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                Chip(label: Text('${maid.age} yrs')),
                Chip(label: Text(_availabilityLabel(maid.availability))),
                Chip(label: Text('\$${maid.monthlyRate}/month')),
                Chip(label: Text('⭐ ${maid.rating.toStringAsFixed(1)}')),
              ],
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: maid.skills
                  .take(3)
                  .map((skill) => Chip(label: Text(skill)))
                  .toList(),
            ),
            const SizedBox(height: 12),
            Align(
              alignment: Alignment.centerRight,
              child: FilledButton.tonal(
                onPressed: onViewDetailsTap,
                child: const Text('View profile'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
