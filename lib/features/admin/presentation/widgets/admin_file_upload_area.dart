import 'package:flutter/material.dart';

/// Drag-and-drop styled file upload zone.
/// Pure UI — does not perform actual file I/O.
class AdminFileUploadArea extends StatefulWidget {
  const AdminFileUploadArea({
    super.key,
    required this.label,
    required this.hint,
    required this.icon,
    this.acceptedFormats = '',
    this.onTap,
    this.uploadedFileNames = const <String>[],
    this.onRemove,
  });

  final String label;
  final String hint;
  final IconData icon;
  final String acceptedFormats;
  final VoidCallback? onTap;
  final List<String> uploadedFileNames;
  final ValueChanged<int>? onRemove;

  @override
  State<AdminFileUploadArea> createState() => _AdminFileUploadAreaState();
}

class _AdminFileUploadAreaState extends State<AdminFileUploadArea> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final primary = Theme.of(context).colorScheme.primary;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        MouseRegion(
          onEnter: (_) => setState(() => _hovered = true),
          onExit: (_) => setState(() => _hovered = false),
          child: GestureDetector(
            onTap: widget.onTap,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 32, horizontal: 24),
              decoration: BoxDecoration(
                color: _hovered
                    ? primary.withOpacity(0.04)
                    : const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: _hovered ? primary : const Color(0xFFCBD5E1),
                  width: _hovered ? 2 : 1.5,
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: primary.withOpacity(0.08),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(widget.icon, color: primary, size: 28),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    widget.label,
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: _hovered ? primary : const Color(0xFF334155),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    widget.hint,
                    style: const TextStyle(
                      fontSize: 12,
                      color: Color(0xFF94A3B8),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  if (widget.acceptedFormats.isNotEmpty) ...<Widget>[
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE2E8F0),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        widget.acceptedFormats,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF64748B),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
        if (widget.uploadedFileNames.isNotEmpty) ...<Widget>[
          const SizedBox(height: 12),
          ...widget.uploadedFileNames.asMap().entries.map((entry) {
            final i = entry.key;
            final name = entry.value;
            return Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: <Widget>[
                  const Icon(
                    Icons.insert_drive_file_outlined,
                    size: 18,
                    color: Color(0xFF6366F1),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Text(
                      name,
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  if (widget.onRemove != null)
                    IconButton(
                      icon: const Icon(
                        Icons.close,
                        size: 16,
                        color: Color(0xFF94A3B8),
                      ),
                      onPressed: () => widget.onRemove?.call(i),
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(),
                    ),
                ],
              ),
            );
          }),
        ],
      ],
    );
  }
}
