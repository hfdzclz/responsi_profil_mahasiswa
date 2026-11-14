import 'dart:convert';
import 'dart:developer' as developer;

import 'package:shared_preferences/shared_preferences.dart';

import '../models/note.dart';
import '../models/student.dart';
import '../services/secure_storage_service.dart';

/// Repository untuk semua akses data lokal aplikasi.
///
/// - Metadata catatan (id, judul, tanggal) → SharedPreferences (JSON list).
/// - Isi catatan → [SecureStorageService] (terenkripsi).
/// - Profil mahasiswa → SharedPreferences (JSON).
///
/// UI dan provider tidak pernah menyentuh storage secara langsung.
class NoteRepository {
  static const String _notesKey = 'notes_metadata';
  static const String _studentKey = 'student_profile';

  final SecureStorageService _secureStorage;

  /// Membuat repository; [secureStorage] bisa diganti untuk pengujian.
  NoteRepository({SecureStorageService? secureStorage})
      : _secureStorage = secureStorage ?? SecureStorageService();

  /// Mengambil semua catatan (metadata + isi), terbaru di atas.
  Future<List<Note>> getNotes() async {
    final metadata = await _readMetadata();
    final notes = <Note>[];
    for (final item in metadata) {
      final id = item['id'] as String;
      final content = await _secureStorage.getContent(id) ?? '';
      notes.add(Note.fromMetadataJson(item, content));
    }
    notes.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    _log('Memuat ${notes.length} catatan');
    return notes;
  }

  /// Menyimpan catatan baru.
  ///
  /// Isi disimpan lebih dulu, sehingga metadata tidak pernah menunjuk
  /// ke isi yang belum ada.
  Future<void> addNote(Note note) async {
    await _secureStorage.saveContent(note.id, note.content);
    final metadata = await _readMetadata();
    metadata.add(note.toMetadataJson());
    await _writeMetadata(metadata);
    _log('Catatan ditambahkan (id: ${note.id})');
  }

  /// Menghapus catatan [id] beserta isinya.
  Future<void> deleteNote(String id) async {
    final metadata = await _readMetadata();
    metadata.removeWhere((item) => item['id'] == id);
    await _writeMetadata(metadata);
    await _secureStorage.deleteContent(id);
    _log('Catatan dihapus (id: $id)');
  }

  /// Membaca profil mahasiswa, atau `null` jika belum pernah disimpan.
  Future<Student?> getStudent() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_studentKey);
    if (raw == null) return null;
    try {
      return Student.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    } on FormatException {
      _log('Data profil rusak, memakai profil default');
      return null;
    }
  }

  /// Menyimpan profil mahasiswa.
  Future<void> saveStudent(Student student) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_studentKey, jsonEncode(student.toJson()));
    _log('Profil disimpan');
  }

  Future<List<Map<String, dynamic>>> _readMetadata() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_notesKey);
    if (raw == null) return [];
    try {
      return (jsonDecode(raw) as List).cast<Map<String, dynamic>>();
    } on FormatException {
      _log('Metadata catatan rusak, diabaikan');
      return [];
    }
  }

  Future<void> _writeMetadata(List<Map<String, dynamic>> metadata) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_notesKey, jsonEncode(metadata));
  }

  /// Log aman: hanya ID dan jumlah, tidak pernah isi catatan.
  void _log(String message) =>
      developer.log(message, name: 'NoteRepository');
}
