import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bilimdler/Pages/FactoriesPagesGeography.dart';
import 'package:flutter_bilimdler/Pages/Symbols_test_page.dart';

import 'package:flutter_bilimdler/subject/physical_test_page.dart';
import 'package:flutter_bilimdler/subject/region_economic_geography.dart';
import 'package:flutter_bilimdler/l10n/app_localizations.dart';
import '../Services/room_services.dart';
import 'package:flutter_bilimdler/subject/cities_economic_geography.dart';
import 'package:flutter_bilimdler/subject/symbols_economic_geography.dart';
import 'package:flutter_bilimdler/subject/economic_test_page.dart';

// подключаем экраны игр из меню для автоперехода у участников
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

  Widget _mapToGame(String subject, String gameId) {
    if (subject == 'physical') {
      switch (gameId) {
        case 'mountains':
          return const MountainsPage();
        case 'lakes':
          return const LakesPage();
        case 'deserts':
          return const ReservesPage();
        case 'rivers':
          return const RiversPage();
        case 'reserves':
          return const ReservesPage();
        case 'physical_test':
          return const PhysicalTestPage();
      }
    } else {
      switch (gameId) {
        case 'regions':
          return const PhysicalGeographyPage();
        case 'cities':
          return const CitiesEconomicGeographyPage();
        case 'symbols':
          return const SymbolsEconomicGeographyPage();
        case 'factories':
          return const FactoriesPage();
        case 'symbols_test':
          return const SymbolsTestPage();
        case 'economic_test':
          return const EconomicTestPage();
      }
    }
    return _GamePlaceholder(subject: subject, gameId: gameId);
  }

  void _navigateToGame(String subject, String gameId) {
    if (_navigated || !mounted) return;
    _navigated = true;
    final page = _mapToGame(subject, gameId);
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
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(title: Text(t.waitingRoomTitle)),
      body: StreamBuilder(
        stream: RoomService.roomStream(widget.roomId),
        builder: (context, roomSnap) {
          if (!roomSnap.hasData) {
            return const Center(child: CircularProgressIndicator());
          }
          final room = roomSnap.data!.data();
          if (room == null) {
            return Center(child: Text(t.roomDeleted));
          }

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
                        t.codeLabel(code),
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
                        ScaffoldMessenger.of(
                          context,
                        ).showSnackBar(SnackBar(content: Text(t.codeCopied)));
                      },
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                Wrap(
                  spacing: 8,
                  children: [
                    Chip(label: Text(isOpen ? t.roomOpen : t.roomClosed)),
                    Chip(label: Text(t.membersCount(count, max))),
                    Chip(
                      label: Text(
                        '${t.statusLabel}: ${status == "waiting" ? t.statusWaiting : t.statusPlaying}',
                      ),
                    ),
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
                        return Center(child: Text(t.noMembersYet));
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
                            title: Text(role == 'owner' ? t.owner : t.member),
                            subtitle: Text(t.userIdDisplay(tag)),
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
                        label: Text(t.leave),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton.icon(
                        onPressed: iAmOwner && count >= max
                            ? () {
                                final Widget menu = (subject == 'economic')
                                    ? EconomicGeographyMenuPage(
                                        roomId: widget.roomId,
                                      )
                                    : PhysicalGeographyMenuPage(
                                        roomId: widget.roomId,
                                      );
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (_) => menu),
                                );
                              }
                            : null,
                        icon: const Icon(Icons.sports_esports),
                        label: Text(t.chooseGame),
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

class _GamePlaceholder extends StatelessWidget {
  final String subject;
  final String gameId;
  const _GamePlaceholder({required this.subject, required this.gameId});

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(t.gameTitle(gameId))),
      body: Center(child: Text(t.gameLaunched(gameId, subject))),
    );
  }
}
