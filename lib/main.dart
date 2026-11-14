import 'dart:developer' as developer;

import 'package:flutter/material.dart';

import 'config/app_config.dart';
import 'providers/app_provider.dart';
import 'screens/home_screen.dart';

/// Titik masuk aplikasi: memuat `.env` lalu menjalankan aplikasi.
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    await AppConfig.load();
  } catch (e) {
    // Aplikasi tetap jalan; fitur API akan menampilkan error state.
    developer.log('File .env tidak dapat dimuat: ${e.runtimeType}',
        name: 'main');
  }
  runApp(const AppProviderWrapper(child: ProfilMahasiswaApp()));
}

/// Root widget aplikasi Profil Mahasiswa dengan Catatan Kuliah.
class ProfilMahasiswaApp extends StatelessWidget {
  /// Membuat [ProfilMahasiswaApp].
  const ProfilMahasiswaApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profil Mahasiswa',
      debugShowCheckedModeBanner: false,
      theme: AppConfig.theme,
      home: const HomeScreen(),
    );
  }
}
