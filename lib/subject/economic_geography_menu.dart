import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';
import 'economicGeography.dart';
import 'citiesGeography.dart';

/// Меню "Экономическая география": 6 квадратов по макету.
class EconomicGeographyMenuPage extends StatelessWidget {
  const EconomicGeographyMenuPage({super.key});

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
                child: GridView.count(
                  crossAxisCount: 3,
                  mainAxisSpacing: 28,
                  crossAxisSpacing: 28,
                  childAspectRatio: 1,
                  children: [
                    _MenuSquare(
                      index: 1,
                      icon: Icons.map,
                      label: t.regions,
                      onTap: () => _open(context, const EconomicGeographyPage()),
                    ),
                    _MenuSquare(
                      index: 2,
                      icon: Icons.location_city,
                      label: t.cities,
                      onTap: () => _open(context, const CitiesGeographyPage()),
                    ),
                    _MenuSquare(
                      index: 3,
                      icon: Icons.menu_book,
                      label: t.legend,
                      onTap: () => _open(context, const LegendPage()),
                    ),
                    _MenuSquare(
                      index: 4,
                      icon: Icons.precision_manufacturing,
                      label: t.factories,
                      onTap: () => _open(context, const FactoriesPage()),
                    ),
                    _MenuSquare(
                      index: 5,
                      icon: Icons.menu_book,
                      label: '${t.legend} ${t.testLabel}',
                      onTap: () => _open(context, const LegendPage()),
                    ),
                    _MenuSquare(
                      index: 6,
                      icon: Icons.quiz,
                      label: t.testLabel,
                      onTap: () => _open(context, const EconomicTestPage()),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static void _open(BuildContext context, Widget page) {
    Navigator.of(context).push(MaterialPageRoute(builder: (_) => page));
  }
}

class _MenuSquare extends StatelessWidget {
  const _MenuSquare({required this.label, required this.onTap, required this.icon, required this.index});
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
      if (isDark) return isOdd ? cs.primary : cs.secondaryContainer; // yellow / blue
      return isOdd ? cs.secondaryContainer : cs.primaryContainer; // yellow / blue
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
                style: TextStyle(color: fg, fontSize: 16, fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// placeholder больше не используется

// Заглушки экранов
class RegionsPage extends StatelessWidget {
  const RegionsPage({super.key});
  @override
  Widget build(BuildContext context) => _Stub(title: AppLocalizations.of(context)!.regions);
}

class CitiesPage extends StatelessWidget {
  const CitiesPage({super.key});
  @override
  Widget build(BuildContext context) => _Stub(title: AppLocalizations.of(context)!.cities);
}

class FactoriesPage extends StatelessWidget {
  const FactoriesPage({super.key});
  @override
  Widget build(BuildContext context) => _Stub(title: AppLocalizations.of(context)!.factories);
}

class LegendPage extends StatelessWidget {
  const LegendPage({super.key});
  @override
  Widget build(BuildContext context) => _Stub(title: AppLocalizations.of(context)!.legend);
}

class EconomicTestPage extends StatelessWidget {
  const EconomicTestPage({super.key});
  @override
  Widget build(BuildContext context) => _Stub(title: AppLocalizations.of(context)!.testLabel);
}

class _Stub extends StatelessWidget {
  const _Stub({required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          t.comingSoon(title),
          style: TextStyle(color: cs.onSurface, fontSize: 16),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
