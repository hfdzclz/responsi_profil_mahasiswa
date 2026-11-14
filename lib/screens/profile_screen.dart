import 'package:flutter/material.dart';

import '../models/student.dart';
import '../providers/app_provider.dart';
import '../utils/validators.dart';
import '../widgets/profile_card.dart';

/// Halaman profil mahasiswa dengan tombol edit.
class ProfileScreen extends StatelessWidget {
  /// Membuat [ProfileScreen].
  const ProfileScreen({super.key});

  Future<void> _openEditForm(BuildContext context, AppProvider provider) async {
    final updated = await showModalBottomSheet<Student>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _EditProfileForm(initial: provider.student),
    );
    if (updated == null || !context.mounted) return;
    try {
      await provider.updateStudent(updated);
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil berhasil diperbarui')),
      );
    } catch (_) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Gagal menyimpan profil')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = AppProvider.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Profil Mahasiswa')),
      body: ListView(
        children: [
          ProfileCard(student: provider.student),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: FilledButton.icon(
              onPressed: () => _openEditForm(context, provider),
              icon: const Icon(Icons.edit),
              label: const Text('Edit Profil'),
            ),
          ),
        ],
      ),
    );
  }
}

/// Form edit profil; mengembalikan [Student] baru lewat `Navigator.pop`.
class _EditProfileForm extends StatefulWidget {
  final Student initial;

  const _EditProfileForm({required this.initial});

  @override
  State<_EditProfileForm> createState() => _EditProfileFormState();
}

class _EditProfileFormState extends State<_EditProfileForm> {
  final _formKey = GlobalKey<FormState>();
  late final _name = TextEditingController(text: widget.initial.name);
  late final _nim = TextEditingController(text: widget.initial.nim);
  late final _prodi = TextEditingController(text: widget.initial.programStudi);
  late final _email = TextEditingController(text: widget.initial.email);

  @override
  void dispose() {
    for (final c in [_name, _nim, _prodi, _email]) {
      c.dispose();
    }
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(
      context,
      Student(
        name: Validators.sanitize(_name.text),
        nim: Validators.sanitize(_nim.text),
        programStudi: Validators.sanitize(_prodi.text),
        email: Validators.sanitize(_email.text),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
          16, 16, 16, MediaQuery.of(context).viewInsets.bottom + 16),
      child: Form(
        key: _formKey,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text('Edit Profil', style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 16),
            TextFormField(
              controller: _name,
              decoration: const InputDecoration(labelText: 'Nama'),
              validator: Validators.validateName,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _nim,
              decoration: const InputDecoration(labelText: 'NIM'),
              keyboardType: TextInputType.number,
              validator: Validators.validateNim,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _prodi,
              decoration: const InputDecoration(labelText: 'Program Studi'),
              validator: Validators.validateProgramStudi,
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _email,
              decoration: const InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              validator: Validators.validateEmail,
            ),
            const SizedBox(height: 16),
            FilledButton(onPressed: _submit, child: const Text('Simpan')),
          ],
        ),
      ),
    );
  }
}
