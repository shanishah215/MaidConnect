import 'package:flutter/material.dart';

import '../../domain/entities/client_portal_models.dart';

class RequestTimeline extends StatelessWidget {
  const RequestTimeline({super.key, required this.status});

  final ClientRequestStatus status;

  static const List<ClientRequestStatus> _steps = <ClientRequestStatus>[
    ClientRequestStatus.submitted,
    ClientRequestStatus.underReview,
    ClientRequestStatus.interviewScheduled,
    ClientRequestStatus.approved,
    ClientRequestStatus.hired,
    ClientRequestStatus.rejected,
    ClientRequestStatus.completed,
  ];

  String _label(ClientRequestStatus value) {
    switch (value) {
      case ClientRequestStatus.submitted:
        return 'Submitted';
      case ClientRequestStatus.underReview:
        return 'Under review';
      case ClientRequestStatus.interviewScheduled:
        return 'Interview';
      case ClientRequestStatus.approved:
        return 'Approved';
      case ClientRequestStatus.hired:
        return 'Hired';
      case ClientRequestStatus.rejected:
        return 'Rejected';
      case ClientRequestStatus.completed:
        return 'Completed';
    }
  }

  @override
  Widget build(BuildContext context) {
    final int activeIndex = _steps.indexOf(status);
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: _steps.asMap().entries.map((entry) {
        final int index = entry.key;
        final bool isActive = index <= activeIndex;
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
          decoration: BoxDecoration(
            color: isActive ? const Color(0xFFE8F0FE) : Colors.white,
            border: Border.all(
              color: isActive
                  ? const Color(0xFF1A4FA3)
                  : const Color(0xFFDCE3F0),
            ),
            borderRadius: BorderRadius.circular(999),
          ),
          child: Text(
            _label(entry.value),
            style: TextStyle(
              fontSize: 12,
              color: isActive
                  ? const Color(0xFF1A4FA3)
                  : const Color(0xFF5E6785),
              fontWeight: FontWeight.w600,
            ),
          ),
        );
      }).toList(),
    );
  }
}
