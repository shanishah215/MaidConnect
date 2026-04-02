import 'package:flutter/material.dart';

/// Color-coded status chip for admin tables and cards.
class AdminStatusChip extends StatelessWidget {
  const AdminStatusChip({super.key, required this.label, required this.color});

  final String label;
  final Color color;

  /// Pre-built variants
  static AdminStatusChip available() =>
      const AdminStatusChip(label: 'Available', color: Color(0xFF10B981));
  static AdminStatusChip unavailable() =>
      const AdminStatusChip(label: 'Unavailable', color: Color(0xFFEF4444));
  static AdminStatusChip onLeave() =>
      const AdminStatusChip(label: 'On Leave', color: Color(0xFFF59E0B));
  static AdminStatusChip pending() =>
      const AdminStatusChip(label: 'Pending', color: Color(0xFFF59E0B));
  static AdminStatusChip approved() =>
      const AdminStatusChip(label: 'Approved', color: Color(0xFF10B981));
  static AdminStatusChip rejected() =>
      const AdminStatusChip(label: 'Rejected', color: Color(0xFFEF4444));
  static AdminStatusChip assigned() =>
      const AdminStatusChip(label: 'Assigned', color: Color(0xFF6366F1));
  static AdminStatusChip active() =>
      const AdminStatusChip(label: 'Active', color: Color(0xFF10B981));
  static AdminStatusChip suspended() =>
      const AdminStatusChip(label: 'Suspended', color: Color(0xFFEF4444));

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 12,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
