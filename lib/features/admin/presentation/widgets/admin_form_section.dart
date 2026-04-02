import 'package:flutter/material.dart';

/// Reusable grouped form section card with title + optional description.
class AdminFormSection extends StatelessWidget {
  const AdminFormSection({
    super.key,
    required this.title,
    required this.child,
    this.description,
    this.trailing,
  });

  final String title;
  final String? description;
  final Widget child;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      if (description != null) ...<Widget>[
                        const SizedBox(height: 2),
                        Text(
                          description!,
                          style: Theme.of(context).textTheme.bodySmall
                              ?.copyWith(color: const Color(0xFF64748B)),
                        ),
                      ],
                    ],
                  ),
                ),
                ?trailing,
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFE2E8F0)),
          Padding(padding: const EdgeInsets.all(24), child: child),
        ],
      ),
    );
  }
}
