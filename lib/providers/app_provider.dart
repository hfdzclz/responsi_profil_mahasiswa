import 'dart:developer' as developer;

import 'package:flutter/widgets.dart';

import '../models/note.dart';
import '../models/student.dart';
import '../repositories/note_repository.dart';

/// Menyediakan state aplikasi (profil & catatan) ke seluruh subtree.
///
/// Widget ini immutable; state sebenarnya dikelola [AppProviderWrapper].
class AppProvider extends InheritedWidget {
  /// Profil mahasiswa saat ini.
  final Student student;

  /// Daftar catatan, terbaru di atas.
  final List<Note> notes;

  /// `true` selama data awal sedang dimuat.
  final bool isLoading;

  /// Pesan error saat memuat data, atau `null` jika tidak ada error.
  final String? errorMessage;

  /// Mengganti profil mahasiswa.
  final Future<void> Function(Student student) updateStudent;

  /// Menambahkan catatan baru.
  final Future<void> Function(Note note) addNote;

  /// Menghapus catatan berdasarkan ID.
  final Future<void> Function(String id) deleteNote;

  /// Memuat ulang semua data dari penyimpanan.
  final Future<void> Function() reload;

  /// Membuat [AppProvider]. Gunakan lewat [AppProviderWrapper].
  const AppProvider({
    super.key,
    required this.student,
    required this.notes,
    required this.isLoading,
    required this.errorMessage,
    required this.updateStudent,
    required this.addNote,
    required this.deleteNote,
    required this.reload,
    required super.child,
  });

  /// Mengambil [AppProvider] terdekat dan mendaftarkan [context]
  /// agar di-rebuild saat state berubah.
  static AppProvider of(BuildContext context) {
    final provider =
        context.dependOnInheritedWidgetOfExactType<AppProvider>();
    assert(provider != null, 'AppProvider tidak ditemukan di atas widget ini');
    return provider!;
  }

  @override
  bool updateShouldNotify(AppProvider oldWidget) =>
      student != oldWidget.student ||
      notes != oldWidget.notes ||
      isLoading != oldWidget.isLoading ||
      errorMessage != oldWidget.errorMessage;
}

/// Pemegang state aplikasi yang menyediakan [AppProvider] ke [child].
class AppProviderWrapper extends StatefulWidget {
  /// Subtree yang dapat mengakses [AppProvider].
  final Widget child;

  /// Repository data; bisa diganti untuk pengujian.
  final NoteRepository? repository;

  /// Membuat [AppProviderWrapper].
  const AppProviderWrapper({super.key, required this.child, this.repository});

  @override
  State<AppProviderWrapper> createState() => _AppProviderWrapperState();
}

class _AppProviderWrapperState extends State<AppProviderWrapper> {
  late final NoteRepository _repository =
      widget.repository ?? NoteRepository();

  Student _student = Student.placeholder;
  List<Note> _notes = const [];
  bool _isLoading = true;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      final student = await _repository.getStudent();
      final notes = await _repository.getNotes();
      if (!mounted) return;
      setState(() {
        _student = student ?? Student.placeholder;
        _notes = notes;
        _isLoading = false;
      });
    } catch (e) {
      developer.log('Gagal memuat data: ${e.runtimeType}', name: 'AppProvider');
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _errorMessage = 'Gagal memuat data. Coba lagi.';
      });
    }
  }

  // Least privilege: setiap aksi hanya mengubah field yang terkait.

  Future<void> _updateStudent(Student student) async {
    await _repository.saveStudent(student);
    if (!mounted) return;
    setState(() => _student = student);
  }

  Future<void> _addNote(Note note) async {
    await _repository.addNote(note);
    if (!mounted) return;
    setState(() => _notes = [note, ..._notes]);
  }

  Future<void> _deleteNote(String id) async {
    await _repository.deleteNote(id);
    if (!mounted) return;
    setState(() => _notes = _notes.where((n) => n.id != id).toList());
  }

  @override
  Widget build(BuildContext context) {
    return AppProvider(
      student: _student,
      notes: _notes,
      isLoading: _isLoading,
      errorMessage: _errorMessage,
      updateStudent: _updateStudent,
      addNote: _addNote,
      deleteNote: _deleteNote,
      reload: _load,
      child: widget.child,
    );
  }
}
