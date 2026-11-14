import 'package:flutter/material.dart';

import '../models/student.dart';

/// Kartu yang menampilkan profil lengkap mahasiswa.
class ProfileCard extends StatelessWidget {
  /// Data mahasiswa yang ditampilkan.
  final Student student;

  /// Membuat [ProfileCard] untuk [student].
  const ProfileCard({super.key, required this.student});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: theme.colorScheme.surfaceContainerHighest,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 44,
            backgroundColor: theme.colorScheme.primary,
            child: Text(
              student.initials,
              style: theme.textTheme.headlineMedium
                  ?.copyWith(color: theme.colorScheme.onPrimary),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            student.name,
            style: theme.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          _InfoRow(icon: Icons.badge_outlined, label: 'NIM', value: student.nim),
          _InfoRow(
            icon: Icons.school_outlined,
            label: 'Program Studi',
            value: student.programStudi,
          ),
          _InfoRow(
            icon: Icons.email_outlined,
            label: 'Email',
            value: student.email,
          ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(icon, color: theme.colorScheme.primary),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(label, style: theme.textTheme.labelMedium),
                Text(value, style: theme.textTheme.bodyLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
