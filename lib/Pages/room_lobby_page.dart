// lib/rooms/room_lobby_page.dart
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import '../Services/room_services.dart';
import '../subject/physical_geography_menu.dart';
import '../subject/economic_geography_menu.dart';

class RoomLobbyPage extends StatefulWidget {
  final String roomId;
  const RoomLobbyPage({super.key, required this.roomId});

  @override
  State<RoomLobbyPage> createState() => _RoomLobbyPageState();
}

class _RoomLobbyPageState extends State<RoomLobbyPage> {
  bool _navigated = false;

  void _navigateToSubject(String subject) {
    if (_navigated || !mounted) return;
    _navigated = true;
    final page = (subject == 'economic')
        ? const EconomicGeographyMenuPage()
        : const PhysicalGeographyMenuPage();

    // заменяем лобби экраном предмета
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
          if (!roomSnap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final room = roomSnap.data!.data();
          if (room == null) {
            return const Center(child: Text('Комната удалена'));
          }

          final code = (room['code'] ?? '') as String;
          final isOpen = room['isOpen'] == true;
          final status = (room['status'] ?? 'waiting') as String;
          final subject = (room['subject'] ?? 'physical') as String;
          final max = (room['maxMembers'] ?? 0) as int;
          final count = (room['memberCount'] ?? 0) as int;
          final owner = (room['ownerUid'] ?? '') as String;
          final myUid = FirebaseAuth.instance.currentUser?.uid ?? '';
          final iAmOwner = owner == myUid;

          // если владелец нажал "Запустить" — всем перейти в предмет
          if (status == 'started') {
            _navigateToSubject(subject);
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
                Row(
                  children: [
                    Chip(label: Text(isOpen ? 'Открыта' : 'Закрыта')),
                    const SizedBox(width: 8),
                    Chip(label: Text('Участники: $count / $max')),
                    const SizedBox(width: 8),
                    Chip(label: Text('Режим: ожидание')),
                  ],
                ),
                const SizedBox(height: 12),

                Expanded(
                  child: StreamBuilder(
                    stream: RoomService.membersStream(widget.roomId),
                    builder: (context, membersSnap) {
                      if (!membersSnap.hasData) {
                        return const Center(child: CircularProgressIndicator());
                      }
                      final docs = membersSnap.data!.docs;
                      if (docs.isEmpty) {
                        return const Center(child: Text('Пока никого нет'));
                      }
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
                            ? () => RoomService.startRoom(widget.roomId)
                            : null,
                        icon: const Icon(Icons.play_arrow),
                        label: const Text('Запустить'),
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
