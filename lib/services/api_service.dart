import 'dart:async';
import 'dart:convert';
import 'dart:developer' as developer;
import 'dart:io';

import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import '../models/api_user.dart';

/// Error HTTP dengan pesan yang aman ditampilkan ke pengguna.
class ApiException implements Exception {
  /// Pesan yang bisa ditampilkan di UI.
  final String message;

  /// Membuat [ApiException] dengan [message].
  const ApiException(this.message);

  @override
  String toString() => message;
}

/// Service untuk request HTTP ke API publik.
class ApiService {
  final http.Client _client;

  /// Membuat service; [client] bisa diganti untuk pengujian.
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  /// Mengambil daftar pengguna dari endpoint `/users`.
  ///
  /// Melempar [ApiException] jika tidak ada koneksi, timeout,
  /// atau server mengembalikan error.
  Future<List<ApiUser>> fetchUsers() async {
    if (AppConfig.baseUrl.isEmpty) {
      throw const ApiException('BASE_URL belum diatur di file .env');
    }
    final uri = Uri.parse('${AppConfig.baseUrl}/users');
    try {
      final response = await _client.get(uri, headers: {
        'Accept': 'application/json',
        'x-api-key': AppConfig.apiKey,
      }).timeout(AppConfig.requestTimeout);

      // Log aman: hanya path & status, tanpa header/API key/body.
      _log('GET ${uri.path} -> ${response.statusCode}');

      if (response.statusCode != 200) {
        throw ApiException('Server error (${response.statusCode})');
      }
      final data = jsonDecode(response.body) as List;
      return data
          .map((e) => ApiUser.fromJson(e as Map<String, dynamic>))
          .toList();
    } on SocketException {
      _log('GET ${uri.path} gagal: tidak ada koneksi');
      throw const ApiException('Tidak ada koneksi internet');
    } on TimeoutException {
      _log('GET ${uri.path} gagal: timeout');
      throw const ApiException('Server tidak merespons, coba lagi');
    } on FormatException {
      _log('GET ${uri.path} gagal: format respons tidak valid');
      throw const ApiException('Format data dari server tidak valid');
    } on http.ClientException {
      _log('GET ${uri.path} gagal: client error');
      throw const ApiException('Gagal menghubungi server');
    }
  }

  void _log(String message) => developer.log(message, name: 'ApiService');
}
