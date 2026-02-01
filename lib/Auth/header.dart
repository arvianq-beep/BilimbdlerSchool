import 'package:flutter/material.dart';
import 'package:flutter_bilimdler/l10n/app_localizations.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  const AuthHeader({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context)!;

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.public, size: 80, color: cs.inversePrimary),
        const SizedBox(height: 16),
        Text(
          t.brand,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w500,
            color: cs.inversePrimary,
          ),
        ),
        const SizedBox(height: 24),
        Text(
          title,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: cs.inversePrimary,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}
