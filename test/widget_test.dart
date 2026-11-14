import 'package:flutter_test/flutter_test.dart';
import 'package:responsi_profil_mahasiswa/models/note.dart';
import 'package:responsi_profil_mahasiswa/models/student.dart';
import 'package:responsi_profil_mahasiswa/utils/validators.dart';

void main() {
  group('Validators.validateTitle', () {
    test('kosong ditolak', () {
      expect(Validators.validateTitle(''), isNotNull);
      expect(Validators.validateTitle('   '), isNotNull);
      expect(Validators.validateTitle(null), isNotNull);
    });
    test('batas 3–50 karakter', () {
      expect(Validators.validateTitle('ab'), isNotNull);
      expect(Validators.validateTitle('abc'), isNull);
      expect(Validators.validateTitle('a' * 50), isNull);
      expect(Validators.validateTitle('a' * 51), isNotNull);
    });
  });

  group('Validators.validateContent', () {
    test('batas 10–1000 karakter', () {
      expect(Validators.validateContent('a' * 9), isNotNull);
      expect(Validators.validateContent('a' * 10), isNull);
      expect(Validators.validateContent('a' * 1000), isNull);
      expect(Validators.validateContent('a' * 1001), isNotNull);
    });
  });

  test('sanitize membuang < > " \' dan spasi tepi', () {
    expect(Validators.sanitize(' <b>"halo"\'</b> '), 'bhalo/b');
  });

  test('validateEmail dan validateNim', () {
    expect(Validators.validateEmail('a@b.com'), isNull);
    expect(Validators.validateEmail('bukan-email'), isNotNull);
    expect(Validators.validateNim('22.11.1234'), isNull);
    expect(Validators.validateNim('22a'), isNotNull);
  });

  test('metadata catatan tidak menyimpan isi', () {
    final note = Note.create(title: 'Judul', content: 'Isi rahasia sekali');
    expect(note.toMetadataJson().containsKey('content'), isFalse);
    expect(note.toString().contains('rahasia'), isFalse);
  });

  test('inisial nama mahasiswa', () {
    expect(Student.placeholder.copyWith(name: 'Budi Santoso').initials, 'BS');
    expect(Student.placeholder.copyWith(name: 'budi').initials, 'B');
  });
}
