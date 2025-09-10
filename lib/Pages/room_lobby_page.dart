import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bilimdler/rooms/game_picker_page.dart';
import '../Services/room_services.dart';

// если хочешь сразу маппить на реальные экраны игр — см. _mapToGame ниже
class RoomLobbyPage extends StatefulWidget {
  final String roomId;
  const RoomLobbyPage({super.key, required this.roomId});

  @override
  State<RoomLobbyPage> createState() => _RoomLobbyPageState();
}

class _RoomLobbyPageState extends State<RoomLobbyPage> {
  bool _navigated = false;

  void _navigateToGame(String subject, String gameId) {
    if (_navigated || !mounted) return;
    _navigated = true;

    final page = _GamePlaceholder(subject: subject, gameId: gameId);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => page),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Комната ожидания')),
      body: StreamBuilder(
        stream: RoomService.roomStream(widget.roomId),
        builder: (context, roomSnap) {
          if (!roomSnap.hasData)
            return const Center(child: CircularProgressIndicator());
          final room = roomSnap.data!.data();
          if (room == null) return const Center(child: Text('Комната удалена'));

          final code = (room['code'] ?? '') as String;
          final isOpen = room['isOpen'] == true;
          final status =
              (room['status'] ?? 'waiting') as String; // waiting | playing
          final subject =
              (room['subject'] ?? 'physical') as String; // physical | economic
          final max = (room['maxMembers'] ?? 0) as int;
          final count = (room['memberCount'] ?? 0) as int;
          final owner = (room['ownerUid'] ?? '') as String;
          final myUid = FirebaseAuth.instance.currentUser?.uid ?? '';
          final iAmOwner = owner == myUid;

          final currentGame = (room['currentGame']?['id']) as String?;

          // если игра уже идёт — уходим всем в игру
          if (status == 'playing' && currentGame != null) {
            _navigateToGame(subject, currentGame);
          }

          return Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Код: $code',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.copy),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: code));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Код скопирован')),
                        );
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  children: [
                    Chip(label: Text(isOpen ? 'Открыта' : 'Закрыта')),
                    Chip(label: Text('Участники: $count / $max')),
                    Chip(
                      label: Text(
                        'Статус: ${status == 'waiting' ? 'ожидание' : 'в игре'}',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                Expanded(
                  child: StreamBuilder(
                    stream: RoomService.membersStream(widget.roomId),
                    builder: (context, membersSnap) {
                      if (!membersSnap.hasData)
                        return const Center(child: CircularProgressIndicator());
                      final docs = membersSnap.data!.docs;
                      if (docs.isEmpty)
                        return const Center(child: Text('Пока никого нет'));
                      return ListView.separated(
                        itemCount: docs.length,
                        separatorBuilder: (_, __) => const Divider(height: 1),
                        itemBuilder: (_, i) {
                          final m = docs[i].data();
                          final role = (m['role'] ?? 'member') as String;
                          final tag = (m['tag'] ?? '??????') as String;
                          return ListTile(
                            leading: CircleAvatar(
                              child: Text(tag.substring(0, 2)),
                            ),
                            title: Text(
                              role == 'owner' ? 'Владелец' : 'Участник',
                            ),
                            subtitle: Text('ID: $tag'),
                          );
                        },
                      );
                    },
                  ),
                ),

                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton.icon(
                        onPressed: () async {
                          await RoomService.leaveRoom(widget.roomId);
                          if (mounted) Navigator.pop(context);
                        },
                        icon: const Icon(Icons.exit_to_app),
                        label: const Text('Выйти'),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: iAmOwner && count >= max
                            ? () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => GamePickerPage(
                                      roomId: widget.roomId,
                                      subject: subject,
                                    ),
                                  ),
                                );
                              }
                            : null,
                        icon: const Icon(Icons.sports_esports),
                        label: const Text('Выбрать игру'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Временная заглушка экрана игры
class _GamePlaceholder extends StatelessWidget {
  final String subject;
  final String gameId;
  const _GamePlaceholder({required this.subject, required this.gameId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Игра: $gameId')),
      body: Center(
        child: Text('Запущена игра "$gameId" для предмета "$subject"'),
      ),
    );
  }
}
