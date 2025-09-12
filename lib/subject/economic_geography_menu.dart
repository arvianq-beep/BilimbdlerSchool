import 'package:flutter/material.dart';
import 'package:flutter_bilimdler/Pages/FactoriesPagesGeography.dart';
import 'package:flutter_bilimdler/Services/room_services.dart';
import '../l10n/app_localizations.dart';

import 'economic_test_page.dart';
import 'region_economic_geography.dart';
import 'cities_economic_geography.dart';
import 'symbols_economic_geography.dart';
import 'physical_geography_menu.dart';

class EconomicGeographyMenuPage extends StatelessWidget {
  final String? roomId; // null = соло, не null = группа
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
                            page: PhysicalGeographyPage(),
                          ),
                        ),
                        _MenuSquare(
                          index: 2,
                          icon: Icons.location_city,
                          label: t.cities,
                          onTap: () => _startOrOpen(
                            context,
                            gameId: 'cities',
                            page: const CitiesEconomicGeographyPage(),
                          ),
                        ),
                        _MenuSquare(
                          index: 3,
                          icon: Icons.legend_toggle,
                          label: t.symbols,
                          onTap: () => _startOrOpen(
                            context,
                            gameId: 'symbols',
                            page: const SymbolsEconomicGeographyPage(),
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
                            page: const _StubScaffold(
                              title: 'условные знаки тест',
                            ),
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
    // Соло: просто открыть экран
    if (roomId == null) {
      Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
      return;
    }

    // Группа: отмечаем выбранную игру и открываем экран
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
