/// Kumpulan fungsi validasi dan sanitasi input pengguna.
///
/// Setiap fungsi `validate*` mengikuti kontrak [FormFieldValidator]:
/// mengembalikan pesan error jika input tidak valid, atau `null` jika valid.
class Validators {
  Validators._();

  /// Pola karakter berbahaya yang dibuang oleh [sanitize].
  static final RegExp _dangerousChars = RegExp(r'''[<>"']''');

  /// Pola email sederhana: `nama@domain.tld`.
  static final RegExp _emailPattern = RegExp(r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$');

  /// Pola NIM: angka, boleh dipisah titik (contoh: `22.11.1234`).
  static final RegExp _nimPattern = RegExp(r'^\d+(\.\d+)*$');

  /// Memvalidasi judul catatan: wajib diisi, 3–50 karakter.
  static String? validateTitle(String? value) =>
      _validateLength(value, label: 'Judul', min: 3, max: 50);

  /// Memvalidasi isi catatan: wajib diisi, 10–1000 karakter.
  static String? validateContent(String? value) =>
      _validateLength(value, label: 'Isi catatan', min: 10, max: 1000);

  /// Memvalidasi nama mahasiswa: wajib diisi, 3–100 karakter.
  static String? validateName(String? value) =>
      _validateLength(value, label: 'Nama', min: 3, max: 100);

  /// Memvalidasi program studi: wajib diisi, 2–100 karakter.
  static String? validateProgramStudi(String? value) =>
      _validateLength(value, label: 'Program studi', min: 2, max: 100);

  /// Memvalidasi NIM: wajib diisi dan hanya berisi angka/titik.
  static String? validateNim(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'NIM wajib diisi';
    if (!_nimPattern.hasMatch(text)) {
      return 'NIM hanya boleh berisi angka dan titik';
    }
    if (text.length > 20) return 'NIM maksimal 20 karakter';
    return null;
  }

  /// Memvalidasi email: wajib diisi dan berformat `nama@domain.tld`.
  static String? validateEmail(String? value) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return 'Email wajib diisi';
    if (!_emailPattern.hasMatch(text)) return 'Format email tidak valid';
    return null;
  }

  /// Membersihkan input dari karakter berbahaya (`<`, `>`, `"`, `'`)
  /// lalu memangkas spasi di awal dan akhir.
  static String sanitize(String input) =>
      input.replaceAll(_dangerousChars, '').trim();

  static String? _validateLength(
    String? value, {
    required String label,
    required int min,
    required int max,
  }) {
    final text = value?.trim() ?? '';
    if (text.isEmpty) return '$label wajib diisi';
    if (text.length < min) return '$label minimal $min karakter';
    if (text.length > max) return '$label maksimal $max karakter';
    return null;
  }
}
