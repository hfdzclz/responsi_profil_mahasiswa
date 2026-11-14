import 'package:flutter/material.dart';

import '../models/note.dart';
import '../providers/app_provider.dart';
import '../utils/validators.dart';

/// Form untuk menambah catatan baru.
///
/// Mengembalikan `true` lewat `Navigator.pop` jika catatan berhasil disimpan.
class NoteFormScreen extends StatefulWidget {
  /// Membuat [NoteFormScreen].
  const NoteFormScreen({super.key});

  @override
  State<NoteFormScreen> createState() => _NoteFormScreenState();
}

class _NoteFormScreenState extends State<NoteFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();
  bool _isSaving = false;

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _save(AppProvider provider) async {
    if (!_formKey.currentState!.validate()) return;

    final title = Validators.sanitize(_titleController.text);
    final content = Validators.sanitize(_contentController.text);
    // Validasi ulang setelah sanitasi (karakter terbuang bisa membuat
    // teks jadi terlalu pendek).
    final error =
        Validators.validateTitle(title) ?? Validators.validateContent(content);
    if (error != null) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('$error setelah karakter berbahaya dihapus')));
      return;
    }

    setState(() => _isSaving = true);
    try {
      await provider.addNote(Note.create(title: title, content: content));
      if (!mounted) return;
      Navigator.pop(context, true);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan catatan')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = AppProvider.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Tambah Catatan')),
      body: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            TextFormField(
              controller: _titleController,
              decoration: const InputDecoration(
                labelText: 'Judul',
                hintText: 'Contoh: Pertemuan 3 - State Management',
              ),
              maxLength: 50,
              textInputAction: TextInputAction.next,
              validator: Validators.validateTitle,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _contentController,
              decoration: const InputDecoration(
                labelText: 'Isi Catatan',
                alignLabelWithHint: true,
              ),
              maxLength: 1000,
              minLines: 6,
              maxLines: 12,
              validator: Validators.validateContent,
            ),
            const SizedBox(height: 16),
            FilledButton.icon(
              onPressed: _isSaving ? null : () => _save(provider),
              icon: _isSaving
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save),
              label: Text(_isSaving ? 'Menyimpan...' : 'Simpan'),
            ),
          ],
        ),
      ),
    );
  }
}
