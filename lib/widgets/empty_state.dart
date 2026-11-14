import 'package:flutter/material.dart';

/// Tampilan informatif saat tidak ada data atau terjadi error.
class EmptyState extends StatelessWidget {
  /// Ikon besar di bagian atas.
  final IconData icon;

  /// Judul pesan.
  final String title;

  /// Penjelasan tambahan.
  final String message;

  /// Label tombol aksi; tombol disembunyikan jika `null`.
  final String? actionLabel;

  /// Dipanggil saat tombol aksi ditekan.
  final VoidCallback? onAction;

  /// Membuat [EmptyState].
  const EmptyState({
    super.key,
    this.icon = Icons.note_alt_outlined,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 72, color: theme.colorScheme.outline),
            const SizedBox(height: 16),
            Text(title,
                style: theme.textTheme.titleMedium, textAlign: TextAlign.center),
            const SizedBox(height: 8),
            Text(message,
                style: theme.textTheme.bodyMedium, textAlign: TextAlign.center),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 16),
              FilledButton(onPressed: onAction, child: Text(actionLabel!)),
            ],
          ],
        ),
      ),
    );
  }
}
