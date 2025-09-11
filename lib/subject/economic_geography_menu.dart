import 'package:flutter/material.dart';
import 'package:flutter_bilimdler/Services/room_services.dart';
import '../l10n/app_localizations.dart';

import 'region_economic_geography.dart'; // твой файл/класс
import 'cities_economic_geography.dart'; // твой файл/класс
import 'symbols_economic_geography.dart';

/// Экономическая география — меню из 6 пунктов.
/// Если [roomId] != null — запуск игры через RoomService.startGame.
class EconomicGeographyMenuPage extends StatelessWidget {
  final String? roomId;
  const EconomicGeographyMenuPage({super.key, this.roomId});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(t.economicGeography)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 8),
              Expanded(
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    const cross = 3;
                    const rows = 2;
                    const vSpace = 28.0;
                    const hSpace = 28.0;

                    final gridW = constraints.maxWidth;
                    final gridH = constraints.maxHeight;
                    final itemW = (gridW - (cross - 1) * hSpace) / cross;
                    final itemH = (gridH - (rows - 1) * vSpace) / rows;
                    final ratio = itemW / itemH;

                    return GridView.count(
                      physics: const NeverScrollableScrollPhysics(),
                      padding: EdgeInsets.zero,
                      crossAxisCount: cross,
                      mainAxisSpacing: vSpace,
                      crossAxisSpacing: hSpace,
                      childAspectRatio: ratio,
                      children: [
                        _MenuSquare(
                          index: 1,
                          icon: Icons.map,
                          label: t.regions,
                          onTap: () => _startOrOpen(
                            context,
                            gameId: 'regions',
                            page:
                                const PhysicalGeographyPage(), // как у тебя было
                          ),
                        ),
                        _MenuSquare(
                          index: 2,
                          icon: Icons.location_city,
                          label: t.cities,
                          onTap: () => _startOrOpen(
                            context,
                            gameId: 'cities',
                            page: const CitiesPage(), // обёртка ниже
                          ),
                        ),
                        _MenuSquare(
                          index: 3,
                          icon: Icons.legend_toggle,
                          label: t.symbols,
                          onTap: () => _startOrOpen(
                            context,
                            gameId: 'symbols',
                            page: const SymbolsPage(),
                          ),
                        ),
                        _MenuSquare(
                          index: 4,
                          icon: Icons.factory,
                          label: t.factories,
                          onTap: () => _startOrOpen(
                            context,
                            gameId: 'factories',
                            page: const FactoriesPage(),
                          ),
                        ),
                        _MenuSquare(
                          index: 5,
                          icon: Icons.quiz,
                          label: t.symbolsTest,
                          onTap: () => _startOrOpen(
                            context,
                            gameId: 'symbols_test',
                            page: const SymbolsTestPage(),
                          ),
                        ),
                        _MenuSquare(
                          index: 6,
                          icon: Icons.quiz_outlined,
                          label: t.testLabel,
                          onTap: () => _startOrOpen(
                            context,
                            gameId: 'economic_test',
                            page: const EconomicTestPage(),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _startOrOpen(
    BuildContext context, {
    required String gameId,
    required Widget page,
  }) async {
    if (roomId == null) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
      return;
    }
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    try {
      await RoomService.startGame(roomId: roomId!, gameId: gameId);
      if (context.mounted) Navigator.pop(context);
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => page),
        );
      }
    } catch (e) {
      if (context.mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Не удалось запустить игру: $e')),
        );
      }
    }
  }
}

class _MenuSquare extends StatelessWidget {
  const _MenuSquare({
    required this.label,
    required this.onTap,
    required this.icon,
    required this.index,
  });
  final String label;
  final VoidCallback onTap;
  final IconData icon;
  final int index;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bool isOdd = index % 2 == 1;
    final Color bg = () {
      if (isDark) return isOdd ? cs.primary : cs.secondaryContainer;
      return isOdd ? cs.secondaryContainer : cs.primaryContainer;
    }();
    final Color fg = () {
      if (isDark) return isOdd ? cs.onPrimary : cs.onSecondaryContainer;
      return isOdd ? cs.onSecondaryContainer : cs.onPrimaryContainer;
    }();
    return Material(
      color: bg,
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: cs.outline.withOpacity(0.35), width: 1),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(16),
        splashColor: cs.primary.withOpacity(0.12),
        highlightColor: Colors.transparent,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 36, color: fg),
              const SizedBox(height: 12),
              Text(
                label,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: fg,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ===== Экран из твоего файла cities_economic_geography.dart
class CitiesPage extends StatelessWidget {
  const CitiesPage({super.key});
  @override
  Widget build(BuildContext context) => const CitiesEconomicGeographyPage();
}

// ===== Остальные заглушки (замени своими экранами при готовности) =====
class SymbolsPage extends StatelessWidget {
  const SymbolsPage({super.key});
  @override
  Widget build(BuildContext context) => const SymbolsEconomicGeographyPage();
}

class FactoriesPage extends StatelessWidget {
  const FactoriesPage({super.key});
  @override
  Widget build(BuildContext context) => const _StubScaffold(title: 'заводы');
}

class SymbolsTestPage extends StatelessWidget {
  const SymbolsTestPage({super.key});
  @override
  Widget build(BuildContext context) =>
      const _StubScaffold(title: 'условные знаки тест');
}

class EconomicTestPage extends StatelessWidget {
  const EconomicTestPage({super.key});
  @override
  Widget build(BuildContext context) => const _StubScaffold(title: 'тест');
}

class _StubScaffold extends StatelessWidget {
  const _StubScaffold({required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          'Раздел "$title" пока в разработке',
          style: TextStyle(color: cs.onSurface, fontSize: 16),
        ),
      ),
    );
  }
}
