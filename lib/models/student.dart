/// Data profil mahasiswa.
class Student {
  /// Nama lengkap mahasiswa.
  final String name;

  /// Nomor Induk Mahasiswa.
  final String nim;

  /// Program studi mahasiswa.
  final String programStudi;

  /// Alamat email mahasiswa.
  final String email;

  /// Membuat [Student] baru.
  const Student({
    required this.name,
    required this.nim,
    required this.programStudi,
    required this.email,
  });

  /// Profil awal yang dipakai sebelum pengguna mengisi datanya sendiri.
  static const Student placeholder = Student(
    name: 'Nama Mahasiswa',
    nim: '00.00.0000',
    programStudi: 'S1 Informatika',
    email: 'mahasiswa@example.com',
  );

  /// Inisial nama (maksimal 2 huruf) untuk ditampilkan di avatar.
  String get initials {
    final parts =
        name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty).toList();
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return (parts.first[0] + parts.last[0]).toUpperCase();
  }

  /// Membuat salinan dengan field tertentu diganti.
  Student copyWith({
    String? name,
    String? nim,
    String? programStudi,
    String? email,
  }) {
    return Student(
      name: name ?? this.name,
      nim: nim ?? this.nim,
      programStudi: programStudi ?? this.programStudi,
      email: email ?? this.email,
    );
  }

  /// Mengubah objek menjadi Map untuk disimpan sebagai JSON.
  Map<String, dynamic> toJson() => {
        'name': name,
        'nim': nim,
        'programStudi': programStudi,
        'email': email,
      };

  /// Membuat [Student] dari Map hasil decode JSON.
  factory Student.fromJson(Map<String, dynamic> json) => Student(
        name: json['name'] as String? ?? '',
        nim: json['nim'] as String? ?? '',
        programStudi: json['programStudi'] as String? ?? '',
        email: json['email'] as String? ?? '',
      );
}
