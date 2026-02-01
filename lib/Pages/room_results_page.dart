import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bilimdler/Services/room_services.dart';
import 'package:flutter_bilimdler/l10n/app_localizations.dart';
import 'package:flutter_bilimdler/rooms/game_picker_page.dart';

class RoomResultsPage extends StatelessWidget {
  final String roomId;
  const RoomResultsPage({super.key, required this.roomId});

  Stream<DocumentSnapshot<Map<String, dynamic>>> _roomStream() {
    return FirebaseFirestore.instance.collection('rooms').doc(roomId).snapshots();
  }

  Stream<QuerySnapshot<Map<String, dynamic>>> _membersStream() {
    return FirebaseFirestore.instance
        .collection('rooms')
        .doc(roomId)
        .collection('members')
        .snapshots();
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(t.resultsTitle)),
      body: StreamBuilder(
        stream: _roomStream(),
        builder: (
          context,
          AsyncSnapshot<DocumentSnapshot<Map<String, dynamic>>> roomSnap,
        ) {
          return StreamBuilder(
            stream: _membersStream(),
            builder: (
              context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> memSnap,
            ) {
              if (!roomSnap.hasData || !memSnap.hasData) {
                return const Center(child: CircularProgressIndicator());
              }

              final room = roomSnap.data!.data() ?? {};
              final subject = (room['subject'] ?? 'physical') as String;
              final maxMembers = (room['maxMembers'] ?? 0) as int;

              final members = memSnap.data!.docs.map((d) {
                final m = d.data();
                final name = (m['name'] ?? m['displayName'] ?? m['tag'] ?? d.id).toString();
                final score = (m['score'] ?? 0) as int;
                final total = (m['total'] ?? 0) as int;
                final finishedAt = m['finishedAt']; // Timestamp?
                return {
                  'id': d.id,
                  'name': name,
                  'score': score,
                  'total': total,
                  'finishedAt': finishedAt,
                };
              }).toList();

              // Сортировка: по баллам (desc), при равенстве — кто сдал раньше (asc)
              members.sort((a, b) {
                final s = (b['score'] as int).compareTo(a['score'] as int);
                if (s != 0) return s;
                final fa = a['finishedAt'];
                final fb = b['finishedAt'];
                if (fa is Timestamp && fb is Timestamp) {
                  return fa.compareTo(fb);
                }
                return 0;
              });

              final finishedCount = members.where((m) => (m['total'] as int) > 0).length;

              return Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    // шапка
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text('${t.room}: $roomId', style: TextStyle(color: cs.outline)),
                        Text('${t.finished}: $finishedCount / $maxMembers'),
                      ],
                    ),
                    const SizedBox(height: 12),

                    // таблица результатов
                    Expanded(
                      child: ListView.separated(
                        itemCount: members.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 8),
                        itemBuilder: (context, i) {
                          final m = members[i];
                          final place = i + 1;
                          final score = m['score'] as int;
                          final total = m['total'] as int;
                          return Material(
                            color: i == 0 ? cs.primaryContainer : cs.surfaceVariant,
                            borderRadius: BorderRadius.circular(12),
                            child: ListTile(
                              leading: CircleAvatar(child: Text(place.toString())),
                              title: Text(
                                m['name'] as String,
                                style: TextStyle(fontWeight: i == 0 ? FontWeight.w800 : FontWeight.w600),
                              ),
                              subtitle: Text('${t.scoreShort}: $score / $total'),
                              trailing: i == 0 ? const Icon(Icons.emoji_events) : null,
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 8),

                    // кнопки
                    Row(
                      children: [
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: () => Navigator.pop(context),
                            icon: const Icon(Icons.arrow_back),
                            label: Text(t.back),
                          ),
                        ),
                        const SizedBox(width: 12),

                        // Следующая игра — очищаем очки и возвращаемся к выбору
                        Expanded(
                          child: FilledButton.icon(
                            onPressed: () async {
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (_) => const Center(child: CircularProgressIndicator()),
                              );
                              try {
                                await RoomService.prepareNextGame(roomId);
                                if (!context.mounted) return;
                                Navigator.pop(context); // закрыть лоадер
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => GamePickerPage(roomId: roomId, subject: subject),
                                  ),
                                );
                              } catch (_) {
                                if (!context.mounted) return;
                                Navigator.pop(context);
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(SnackBar(content: Text(t.startGameFailed)));
                              }
                            },
                            icon: const Icon(Icons.skip_next),
                            label: Text(t.nextGame),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}
