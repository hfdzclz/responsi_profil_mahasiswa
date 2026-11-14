import 'package:flutter/material.dart';

import '../models/note.dart';
import '../providers/app_provider.dart';
import '../widgets/empty_state.dart';
import '../widgets/note_card.dart';
import 'note_form_screen.dart';
import 'profile_screen.dart';
import 'users_screen.dart';

/// Halaman utama: profil singkat dan daftar catatan kuliah.
class HomeScreen extends StatelessWidget {
  /// Membuat [HomeScreen].
  const HomeScreen({super.key});

  Future<void> _openForm(BuildContext context) async {
    final saved = await Navigator.push<bool>(
      context,
      MaterialPageRoute(builder: (_) => const NoteFormScreen()),
    );
    if (saved == true && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Catatan berhasil disimpan')),
      );
    }
  }

  Future<void> _confirmDelete(
      BuildContext context, AppProvider provider, Note note) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Hapus Catatan?'),
        content: Text('Catatan "${note.title}" akan dihapus permanen.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Batal'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;
    try {
      await provider.deleteNote(note.id);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Catatan dihapus')),
      );
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menghapus catatan')),
      );
    }
  }

  void _showDetail(BuildContext context, Note note) {
    showDialog<void>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: Text(note.title),
        content: SingleChildScrollView(child: Text(note.content)),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext),
            child: const Text('Tutup'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final provider = AppProvider.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Catatan Kuliah'),
        actions: [
          IconButton(
            icon: const Icon(Icons.cloud_download_outlined),
            tooltip: 'Data API',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const UsersScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.person),
            tooltip: 'Profil',
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const ProfileScreen()),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: provider.isLoading ? null : () => _openForm(context),
        icon: const Icon(Icons.add),
        label: const Text('Catatan'),
      ),
      body: _buildBody(context, provider),
    );
  }

  Widget _buildBody(BuildContext context, AppProvider provider) {
    if (provider.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (provider.errorMessage != null) {
      return EmptyState(
        icon: Icons.error_outline,
        title: 'Terjadi Kesalahan',
        message: provider.errorMessage!,
        actionLabel: 'Coba Lagi',
        onAction: provider.reload,
      );
    }
    return Column(
      children: [
        _ProfileSummary(name: provider.student.name, nim: provider.student.nim),
        Expanded(
          child: provider.notes.isEmpty
              ? const EmptyState(
                  title: 'Belum ada catatan',
                  message: 'Tekan tombol "+ Catatan" untuk menambahkan.',
                )
              : ListView.builder(
                  padding: const EdgeInsets.only(bottom: 88),
                  itemCount: provider.notes.length,
                  itemBuilder: (context, index) {
                    final note = provider.notes[index];
                    return NoteCard(
                      key: ValueKey(note.id),
                      note: note,
                      onTap: () => _showDetail(context, note),
                      onDelete: () => _confirmDelete(context, provider, note),
                    );
                  },
                ),
        ),
      ],
    );
  }
}

/// Ringkasan profil (nama & NIM) di bagian atas HomeScreen.
class _ProfileSummary extends StatelessWidget {
  final String name;
  final String nim;

  const _ProfileSummary({required this.name, required this.nim});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
      color: theme.colorScheme.primaryContainer,
      child: Row(
        children: [
          Icon(Icons.account_circle,
              size: 40, color: theme.colorScheme.onPrimaryContainer),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name,
                    style: theme.textTheme.titleMedium?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer)),
                Text('NIM: $nim',
                    style: theme.textTheme.bodyMedium?.copyWith(
                        color: theme.colorScheme.onPrimaryContainer)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
