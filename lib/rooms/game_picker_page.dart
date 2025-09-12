import 'package:flutter/material.dart';
import 'package:flutter_bilimdler/Services/room_services.dart';
import 'package:flutter_bilimdler/l10n/app_localizations.dart';

class GamePickerPage extends StatelessWidget {
  final String roomId;
  final String subject; // 'physical' | 'economic'
  const GamePickerPage({
    super.key,
    required this.roomId,
    required this.subject,
  });

  List<_GameItem> _games(AppLocalizations t) {
    if (subject == 'economic') {
      return [
        _GameItem('markets', t.markets),
        _GameItem('gdp_quiz', t.gdpQuiz),
        _GameItem('trade_routes', t.tradeRoutes),
        _GameItem('industry', t.industry),
        _GameItem('resources', t.resources),
        _GameItem('population', t.population),
      ];
    }
    return [
      _GameItem('capitals', t.capitals),
      _GameItem('flags', t.flags),
      _GameItem('rivers', t.rivers),
      _GameItem(
        'mounts',
        t.mountains,
      ), // id 'mounts', текст — локализованный "Mountains"
      _GameItem('climate', t.climate),
      _GameItem('regions', t.regions),
    ];
  }

  Future<void> _start(BuildContext context, String gameId) async {
    final t = AppLocalizations.of(context)!;
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    try {
      await RoomService.startGame(roomId: roomId, gameId: gameId);
      if (context.mounted) Navigator.pop(context);
      if (context.mounted) Navigator.pop(context);
    } catch (_) {
      if (!context.mounted) return;
      Navigator.pop(context);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(t.startGameFailed)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final items = _games(t);
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(t.chooseGame)),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: items.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 12,
          crossAxisSpacing: 12,
          childAspectRatio: 1.2,
        ),
        itemBuilder: (_, i) {
          final g = items[i];
          return Material(
            color: cs.primaryContainer,
            borderRadius: BorderRadius.circular(16),
            child: InkWell(
              onTap: () => _start(context, g.id),
              borderRadius: BorderRadius.circular(16),
              child: Center(
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(
                    g.title,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: cs.onPrimaryContainer,
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _GameItem {
  final String id;
  final String title;
  const _GameItem(this.id, this.title);
}
