/// Catatan kuliah.
///
/// Metadata ([id], [title], [createdAt]) disimpan di SharedPreferences,
/// sedangkan [content] disimpan terenkripsi di secure storage.
class Note {
  /// ID unik catatan.
  final String id;

  /// Judul catatan.
  final String title;

  /// Waktu catatan dibuat.
  final DateTime createdAt;

  /// Isi catatan (data sensitif — jangan pernah dicetak ke log).
  final String content;

  /// Membuat [Note] baru.
  const Note({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.content,
  });

  /// Membuat catatan baru dengan ID berbasis waktu saat ini.
  factory Note.create({required String title, required String content}) {
    final now = DateTime.now();
    return Note(
      id: now.microsecondsSinceEpoch.toString(),
      title: title,
      createdAt: now,
      content: content,
    );
  }

  /// Mengubah metadata menjadi Map untuk SharedPreferences.
  ///
  /// [content] sengaja TIDAK disertakan agar tidak tersimpan tanpa enkripsi.
  Map<String, dynamic> toMetadataJson() => {
        'id': id,
        'title': title,
        'createdAt': createdAt.toIso8601String(),
      };

  /// Membuat [Note] dari metadata JSON dan isi dari secure storage.
  factory Note.fromMetadataJson(Map<String, dynamic> json, String content) =>
      Note(
        id: json['id'] as String,
        title: json['title'] as String,
        createdAt: DateTime.parse(json['createdAt'] as String),
        content: content,
      );

  /// Representasi teks yang aman untuk log (tanpa isi catatan).
  @override
  String toString() => 'Note(id: $id)';
}
