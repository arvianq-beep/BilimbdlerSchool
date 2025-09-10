import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

/// Меню "Физическая география": 6 квадратов как на скрине.
class PhysicalGeographyMenuPage extends StatelessWidget {
  const PhysicalGeographyMenuPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(t.physicalGeography)),
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
                    const cross = 3; // 3 columns
                    const rows = 2; // 2 rows
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
                      icon: Icons.terrain,
                      label: t.mountains,
                      onTap: () => _open(context, const MountainsPage()),
                    ),
                    _MenuSquare(
                      index: 2,
                      icon: Icons.water,
                      label: t.lakes,
                      onTap: () => _open(context, const LakesPage()),
                    ),
                    _MenuSquare(
                      index: 3,
                      icon: Icons.landscape,
                      label: t.deserts,
                      onTap: () => _open(context, const DesertsPage()),
                    ),
                    _MenuSquare(
                      index: 4,
                      icon: Icons.waves,
                      label: t.rivers,
                      onTap: () => _open(context, const RiversPage()),
                    ),
                    _MenuSquare(
                      index: 5,
                      icon: Icons.park,
                      label: t.reserves,
                      onTap: () => _open(context, const ReservesPage()),
                    ),
                    _MenuSquare(
                      index: 6,
                      icon: Icons.quiz,
                      label: t.testLabel,
                      onTap: () => _open(context, const PhysicalTestPage()),
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
    // Цвета по теме: нечетные — желтые, четные — синие
    final Color bg = () {
      if (isDark) return isOdd ? cs.primary : cs.secondaryContainer; // yellow / blue
      return isOdd ? cs.secondaryContainer : cs.primaryContainer; // yellow / blue (светлые контейнеры)
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

// Заглушки для 6 направлений. Можно наполнить контентом позже.
class MountainsPage extends StatelessWidget {
  const MountainsPage({super.key});
  @override
  Widget build(BuildContext context) => _StubScaffold(title: AppLocalizations.of(context)!.mountains);
}

class LakesPage extends StatelessWidget {
  const LakesPage({super.key});
  @override
  Widget build(BuildContext context) => _StubScaffold(title: AppLocalizations.of(context)!.lakes);
}

class DesertsPage extends StatelessWidget {
  const DesertsPage({super.key});
  @override
  Widget build(BuildContext context) => _StubScaffold(title: AppLocalizations.of(context)!.deserts);
}

class RiversPage extends StatelessWidget {
  const RiversPage({super.key});
  @override
  Widget build(BuildContext context) => _StubScaffold(title: AppLocalizations.of(context)!.rivers);
}

class ReservesPage extends StatelessWidget {
  const ReservesPage({super.key});
  @override
  Widget build(BuildContext context) => _StubScaffold(title: AppLocalizations.of(context)!.reserves);
}

class PhysicalTestPage extends StatelessWidget {
  const PhysicalTestPage({super.key});
  @override
  Widget build(BuildContext context) => _StubScaffold(title: AppLocalizations.of(context)!.testLabel);
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
          'Страница "${title}" — контент скоро',
          style: TextStyle(color: cs.onSurface, fontSize: 16),
        ),
      ),
    );
  }
}
