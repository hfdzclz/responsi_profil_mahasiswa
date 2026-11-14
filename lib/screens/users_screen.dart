import 'package:flutter/material.dart';

import '../models/api_user.dart';
import '../services/api_service.dart';
import '../widgets/empty_state.dart';

/// Halaman yang menampilkan data dari API publik (HTTP GET `/users`).
class UsersScreen extends StatefulWidget {
  /// Service HTTP; bisa diganti untuk pengujian.
  final ApiService? apiService;

  /// Membuat [UsersScreen].
  const UsersScreen({super.key, this.apiService});

  @override
  State<UsersScreen> createState() => _UsersScreenState();
}

class _UsersScreenState extends State<UsersScreen> {
  late final ApiService _api = widget.apiService ?? ApiService();
  late Future<List<ApiUser>> _future = _api.fetchUsers();

  void _retry() => setState(() => _future = _api.fetchUsers());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Data API Publik')),
      body: FutureBuilder<List<ApiUser>>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            final error = snapshot.error;
            return EmptyState(
              icon: Icons.cloud_off,
              title: 'Gagal memuat data',
              message: error is ApiException
                  ? error.message
                  : 'Terjadi kesalahan tidak terduga',
              actionLabel: 'Coba Lagi',
              onAction: _retry,
            );
          }
          final users = snapshot.data ?? const [];
          if (users.isEmpty) {
            return const EmptyState(
              icon: Icons.people_outline,
              title: 'Tidak ada data',
              message: 'Server tidak mengembalikan pengguna.',
            );
          }
          return RefreshIndicator(
            onRefresh: () async {
              _retry();
              await _future.catchError((_) => <ApiUser>[]);
            },
            child: ListView.builder(
              itemCount: users.length,
              itemBuilder: (context, index) {
                final user = users[index];
                return Card(
                  child: ListTile(
                    leading: CircleAvatar(child: Text('${user.id}')),
                    title: Text(user.name),
                    subtitle: Text('${user.email}\n${user.company}'),
                    isThreeLine: true,
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
