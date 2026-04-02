import 'package:flutter/material.dart';

/// Confirmation / action dialog used throughout the admin portal.
class AdminDialog {
  AdminDialog._();

  /// Show a simple confirmation dialog (delete, etc.)
  static Future<bool> confirm(
    BuildContext context, {
    required String title,
    required String message,
    String confirmLabel = 'Confirm',
    Color confirmColor = const Color(0xFFEF4444),
    IconData icon = Icons.warning_amber_rounded,
  }) async {
    final result = await showDialog<bool>(
      context: context,
      builder: (ctx) => _ConfirmDialog(
        title: title,
        message: message,
        confirmLabel: confirmLabel,
        confirmColor: confirmColor,
        icon: icon,
      ),
    );
    return result ?? false;
  }

  /// Show assign maid dialog — returns selected maid name or null
  static Future<String?> assignMaid(
    BuildContext context, {
    required List<String> maidNames,
  }) async {
    return showDialog<String>(
      context: context,
      builder: (ctx) => _AssignMaidDialog(maidNames: maidNames),
    );
  }

  /// Show a simple info/success snackbar
  static void showSnack(BuildContext context, String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: <Widget>[
            Icon(
              isError ? Icons.error_outline : Icons.check_circle_outline,
              color: Colors.white,
              size: 18,
            ),
            const SizedBox(width: 10),
            Text(message),
          ],
        ),
        backgroundColor: isError ? const Color(0xFFEF4444) : const Color(0xFF10B981),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
        duration: const Duration(seconds: 3),
      ),
    );
  }
}

// ── Private widgets ───────────────────────────────────────────────────────────

class _ConfirmDialog extends StatelessWidget {
  const _ConfirmDialog({
    required this.title,
    required this.message,
    required this.confirmLabel,
    required this.confirmColor,
    required this.icon,
  });

  final String title;
  final String message;
  final String confirmLabel;
  final Color confirmColor;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SizedBox(
        width: 420,
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: confirmColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: confirmColor, size: 24),
              ),
              const SizedBox(height: 16),
              Text(
                title,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                message,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: const Color(0xFF64748B),
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context, false),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  FilledButton(
                    onPressed: () => Navigator.pop(context, true),
                    style: FilledButton.styleFrom(
                      backgroundColor: confirmColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(confirmLabel),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AssignMaidDialog extends StatefulWidget {
  const _AssignMaidDialog({required this.maidNames});
  final List<String> maidNames;

  @override
  State<_AssignMaidDialog> createState() => _AssignMaidDialogState();
}

class _AssignMaidDialogState extends State<_AssignMaidDialog> {
  String? _selected;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: SizedBox(
        width: 440,
        child: Padding(
          padding: const EdgeInsets.all(28),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF6366F1).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.assignment_ind_outlined, color: Color(0xFF6366F1)),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Assign Maid',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Select a maid to assign to this inquiry.',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(color: const Color(0xFF64748B)),
              ),
              const SizedBox(height: 20),
              ...widget.maidNames.map((name) => RadioListTile<String>(
                title: Text(name, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
                value: name,
                groupValue: _selected,
                onChanged: (v) => setState(() => _selected = v),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                contentPadding: const EdgeInsets.symmetric(horizontal: 8),
              )),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Cancel'),
                  ),
                  const SizedBox(width: 12),
                  FilledButton(
                    onPressed: _selected == null ? null : () => Navigator.pop(context, _selected),
                    style: FilledButton.styleFrom(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    child: const Text('Assign'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
