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
        return 'Immediate availability';
      case MaidAvailability.thisWeek:
        return 'Available this week';
      case MaidAvailability.thisMonth:
        return 'Available this month';
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isAvailableNow = maid.availability == MaidAvailability.immediate;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFF1F5F9), width: 1.5),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.015),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(20),
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: onViewDetailsTap,
          hoverColor: const Color(0xFFF8FAFC),
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Modern Avatar
                    Container(
                      height: 56,
                      width: 56,
                      decoration: const BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xFFEFF6FF),
                      ),
                      child: Center(
                        child: Text(
                          maid.name.substring(0, 1).toUpperCase(),
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w700,
                            color: theme.colorScheme.primary,
                          ),
                        ),
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
                                maid.name,
                                style: theme.textTheme.titleLarge?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF0F172A),
                                ),
                              ),
                              const SizedBox(width: 8),
                              const Icon(
                                Icons.verified_rounded,
                                color: Color(0xFF10B981),
                                size: 18,
                              ),
                            ],
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${maid.location}  •  ${maid.experienceYears} years experience',
                            style: const TextStyle(
                              color: Color(0xFF64748B),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      onPressed: onShortlistTap,
                      icon: Icon(
                        isShortlisted ? Icons.favorite : Icons.favorite_border,
                        color: isShortlisted
                            ? const Color(0xFFF43F5E)
                            : const Color(0xFFCBD5E1),
                      ),
                      splashRadius: 24,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                Text(
                  maid.bio,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: Color(0xFF475569), height: 1.5),
                ),
                const SizedBox(height: 20),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    _Badge(
                      icon: Icons.star_rounded,
                      label: maid.rating.toStringAsFixed(1),
                      color: const Color(0xFFF59E0B),
                      bgColor: const Color(0xFFFEF3C7),
                    ),
                    _Badge(
                      icon: Icons.monetization_on_outlined,
                      label: '\$${maid.monthlyRate}/mo',
                      color: const Color(0xFF0EA5E9),
                      bgColor: const Color(0xFFE0F2FE),
                    ),
                    _Badge(
                      icon: Icons.calendar_today_outlined,
                      label: _availabilityLabel(maid.availability),
                      color: isAvailableNow
                          ? const Color(0xFF10B981)
                          : const Color(0xFF64748B),
                      bgColor: isAvailableNow
                          ? const Color(0xFFD1FAE5)
                          : const Color(0xFFF1F5F9),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                const Divider(color: Color(0xFFF1F5F9)),
                const SizedBox(height: 12),
                Row(
                  children: [
                    const Text(
                      'Top Skills: ',
                      style: TextStyle(
                        color: Color(0xFF94A3B8),
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Wrap(
                        spacing: 6,
                        runSpacing: 6,
                        children: maid.skills.take(4).map((skill) {
                          return Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF8FAFC),
                              border: Border.all(
                                color: const Color(0xFFE2E8F0),
                              ),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              skill,
                              style: const TextStyle(
                                fontSize: 12,
                                color: Color(0xFF334155),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          );
                        }).toList(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({
    required this.icon,
    required this.label,
    required this.color,
    required this.bgColor,
  });

  final IconData icon;
  final String label;
  final Color color;
  final Color bgColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 13,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
