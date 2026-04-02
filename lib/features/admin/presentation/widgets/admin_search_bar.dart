import 'package:flutter/material.dart';

/// Styled search/filter bar used above tables
class AdminSearchBar extends StatelessWidget {
  const AdminSearchBar({
    super.key,
    required this.controller,
    this.hintText = 'Search...',
    this.onChanged,
    this.trailing = const <Widget>[],
  });

  final TextEditingController controller;
  final String hintText;
  final ValueChanged<String>? onChanged;
  final List<Widget> trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: SizedBox(
            height: 44,
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              style: const TextStyle(fontSize: 14),
              decoration: InputDecoration(
                hintText: hintText,
                hintStyle: const TextStyle(color: Color(0xFF94A3B8), fontSize: 14),
                prefixIcon: const Icon(Icons.search, size: 18, color: Color(0xFF94A3B8)),
                contentPadding: const EdgeInsets.symmetric(vertical: 0, horizontal: 16),
                filled: true,
                fillColor: const Color(0xFFF8FAFC),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide(
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ),
        ),
        if (trailing.isNotEmpty) ...<Widget>[
          const SizedBox(width: 12),
          ...trailing,
        ],
      ],
    );
  }
}
