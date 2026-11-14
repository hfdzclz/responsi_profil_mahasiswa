import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Konfigurasi aplikasi yang dibaca dari file `.env`.
///
/// Tidak ada credential yang ditulis langsung di kode.
class AppConfig {
  AppConfig._();

  /// Batas waktu setiap request HTTP.
  static const Duration requestTimeout = Duration(seconds: 10);

  /// Memuat file `.env`. Dipanggil sekali di `main()` sebelum `runApp`.
  static Future<void> load() => dotenv.load(fileName: '.env');

  /// URL dasar API, contoh `https://jsonplaceholder.typicode.com`.
  static String get baseUrl => dotenv.get('BASE_URL', fallback: '');

  /// API key (dummy). Jangan pernah dicetak ke log.
  static String get apiKey => dotenv.get('API_KEY', fallback: '');

  /// Tema aplikasi terpusat.
  static ThemeData get theme {
    final scheme = ColorScheme.fromSeed(seedColor: const Color(0xFF3949AB));
    return ThemeData(
      colorScheme: scheme,
      useMaterial3: true,
      appBarTheme: AppBarTheme(
        backgroundColor: scheme.primary,
        foregroundColor: scheme.onPrimary,
        centerTitle: false,
      ),
      cardTheme: const CardThemeData(
        margin: EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        border: OutlineInputBorder(),
      ),
    );
  }
}
