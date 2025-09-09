// lib/subjects/geography.dart
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'physical_geography_menu.dart';
import 'economic_geography_menu.dart';

class GeographyPage extends StatelessWidget {
  const GeographyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        // без заголовка — только системная кнопка "назад"
        automaticallyImplyLeading: true,
        title: const SizedBox.shrink(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              // большой заголовок по центру
              Expanded(
                child: Center(
                  child: Text(
                    t.geography.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: cs.inversePrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 42,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
              // две кнопки снизу
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const PhysicalGeographyMenuPage(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.public),
                      label: Text(t.physicalGeography),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: FilledButton.tonalIcon(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const EconomicGeographyMenuPage(),
                          ),
                        );
                      },
                      icon: const Icon(Icons.trending_up),
                      label: Text(t.economicGeography),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// --- Заглушки разделов: потом заменишь на реальные страницы ---

// PhysicalGeographyPage is implemented in lib/subject/physicalGeography.dart

// Экран Экономической географии вынесен в
// lib/subject/economic_geography_menu.dart
