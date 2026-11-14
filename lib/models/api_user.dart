/// Pengguna dari API publik (JSONPlaceholder `/users`).
class ApiUser {
  /// ID pengguna.
  final int id;

  /// Nama pengguna.
  final String name;

  /// Email pengguna.
  final String email;

  /// Nama perusahaan pengguna.
  final String company;

  /// Membuat [ApiUser] baru.
  const ApiUser({
    required this.id,
    required this.name,
    required this.email,
    required this.company,
  });

  /// Membuat [ApiUser] dari JSON respons API.
  factory ApiUser.fromJson(Map<String, dynamic> json) => ApiUser(
        id: json['id'] as int,
        name: json['name'] as String? ?? '-',
        email: json['email'] as String? ?? '-',
        company:
            (json['company'] as Map<String, dynamic>?)?['name'] as String? ??
                '-',
      );
}
