import 'package:flutter/material.dart';
import '../Services/room_services.dart';

class GamePickerPage extends StatelessWidget {
  final String roomId;
  final String subject; // 'physical' | 'economic'
  const GamePickerPage({
    super.key,
    required this.roomId,
    required this.subject,
  });

  List<_GameItem> _games() {
    if (subject == 'economic') {
      return const [
        _GameItem('markets', 'Рынки'),
        _GameItem('gdp_quiz', 'ВВП-викторина'),
        _GameItem('trade_routes', 'Торговые пути'),
        _GameItem('industry', 'Отрасли'),
        _GameItem('resources', 'Ресурсы'),
        _GameItem('population', 'Население'),
      ];
    }
    // physical
    return const [
      _GameItem('capitals', 'Столицы'),
      _GameItem('flags', 'Флаги'),
      _GameItem('rivers', 'Реки'),
      _GameItem('mounts', 'Горы'),
      _GameItem('climate', 'Климат'),
      _GameItem('regions', 'Регионы'),
    ];
  }

  Future<void> _start(BuildContext context, String gameId) async {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    try {
      await RoomService.startGame(roomId: roomId, gameId: gameId);
      if (context.mounted) Navigator.pop(context); // закрыть лоадер
      if (context.mounted)
        Navigator.pop(context); // вернуться в лобби (всех перекинет)
    } catch (e) {
      if (!context.mounted) return;
      Navigator.pop(context); // закрыть лоадер
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Не удалось запустить игру: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final items = _games();
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Выбери игру')),
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
