import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Penyimpanan terenkripsi untuk isi catatan.
///
/// Di Android data dienkripsi dengan Android Keystore,
/// di iOS disimpan di Keychain.
class SecureStorageService {
  /// Awalan key untuk isi catatan: `note_content_<id>`.
  static const String keyPrefix = 'note_content_';

  final FlutterSecureStorage _storage;

  /// Membuat service; [storage] bisa diganti untuk keperluan pengujian.
  SecureStorageService({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  String _key(String noteId) => '$keyPrefix$noteId';

  /// Menyimpan [content] catatan [noteId] secara terenkripsi.
  Future<void> saveContent(String noteId, String content) =>
      _storage.write(key: _key(noteId), value: content);

  /// Membaca isi catatan [noteId], atau `null` jika tidak ada.
  Future<String?> getContent(String noteId) =>
      _storage.read(key: _key(noteId));

  /// Menghapus isi catatan [noteId].
  Future<void> deleteContent(String noteId) =>
      _storage.delete(key: _key(noteId));
}
