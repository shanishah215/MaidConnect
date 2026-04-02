import 'package:flutter/material.dart';

import '../../domain/entities/client_portal_models.dart';

class ClientStatusChip extends StatelessWidget {
  const ClientStatusChip({super.key, required this.status});

  final ClientRequestStatus status;

  @override
  Widget build(BuildContext context) {
    final (Color bg, Color fg, String label) = switch (status) {
      ClientRequestStatus.submitted => (
        const Color(0xFFE8F0FE),
        const Color(0xFF1A4FA3),
        'Submitted',
      ),
      ClientRequestStatus.underReview => (
        const Color(0xFFFFF4DB),
        const Color(0xFF9B6700),
        'Under review',
      ),
      ClientRequestStatus.interviewScheduled => (
        const Color(0xFFE6F4EA),
        const Color(0xFF1E7D3E),
        'Interview scheduled',
      ),
      ClientRequestStatus.approved => (
        const Color(0xFFE6F4EA),
        const Color(0xFF106C2A),
        'Approved',
      ),
      ClientRequestStatus.hired => (
        const Color(0xFFE0F2FE),
        const Color(0xFF0369A1),
        'Hired',
      ),
      ClientRequestStatus.rejected => (
        const Color(0xFFFEE2E2),
        const Color(0xFF991B1B),
        'Rejected',
      ),
      ClientRequestStatus.completed => (
        const Color(0xFFEEEAFD),
        const Color(0xFF5A36C9),
        'Completed',
      ),
    };

    return Chip(
      visualDensity: VisualDensity.compact,
      backgroundColor: bg,
      label: Text(
        label,
        style: TextStyle(color: fg, fontWeight: FontWeight.w600),
      ),
      side: BorderSide.none,
    );
  }
}
