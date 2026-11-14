import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/note.dart';

/// Kartu ringkas untuk satu catatan di daftar.
class NoteCard extends StatelessWidget {
  /// Catatan yang ditampilkan.
  final Note note;

  /// Dipanggil saat kartu ditekan (melihat detail).
  final VoidCallback onTap;

  /// Dipanggil saat tombol hapus ditekan.
  final VoidCallback onDelete;

  static final DateFormat _dateFormat = DateFormat('dd MMM yyyy, HH:mm');

  /// Membuat [NoteCard].
  const NoteCard({
    super.key,
    required this.note,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        onTap: onTap,
        leading: const Icon(Icons.sticky_note_2_outlined),
        title: Text(note.title, maxLines: 1, overflow: TextOverflow.ellipsis),
        subtitle: Text(_dateFormat.format(note.createdAt)),
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline),
          tooltip: 'Hapus catatan',
          onPressed: onDelete,
        ),
      ),
    );
  }
}
