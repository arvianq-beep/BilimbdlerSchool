import 'package:flutter/material.dart';
import 'package:flutter_bilimdler/Services/room_services.dart';

import '../l10n/app_localizations.dart';
import 'physical_geography_menu.dart';
import 'economic_geography_menu.dart';
import '../Pages/room_lobby_page.dart';

enum _Mode { solo, group }

class GeographyPage extends StatelessWidget {
  const GeographyPage({super.key});

  // ---- Войти по коду (нижняя кнопка) ----
  Future<void> _joinByCode(BuildContext context) async {
    final code = await showDialog<String>(
      context: context,
      builder: (ctx) {
        final t = AppLocalizations.of(ctx)!;
        final c = TextEditingController();
        return AlertDialog(
          title: Text(t.joinByCode),
          content: TextField(
            controller: c,
            textCapitalization: TextCapitalization.characters,
            decoration: InputDecoration(hintText: t.enterCodeHint),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(t.btnCancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, c.text.trim().toUpperCase()),
              child: Text(t.btnJoin),
            ),
          ],
        );
      },
    );
    if (code == null || code.isEmpty) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final ref = await RoomService.joinByCode(code);
      if (context.mounted) Navigator.pop(context); // закрыть лоадер
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => RoomLobbyPage(roomId: ref.id)),
        );
      }
    } catch (e) {
      if (context.mounted) {
        final t = AppLocalizations.of(context)!;
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${t.joinFailed}: $e')));
      }
    }
  }

  Future<_Mode?> _askMode(BuildContext context) {
    return showDialog<_Mode>(
      context: context,
      builder: (ctx) {
        final t = AppLocalizations.of(ctx)!;
        return AlertDialog(
          title: Text(t.howToPlayTitle),
          content: Text(t.howToPlayBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx, _Mode.solo),
              child: Text(t.modeSolo),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(ctx, _Mode.group),
              child: Text(t.modeGroup),
            ),
          ],
        );
      },
    );
  }

  Future<int?> _askLimit(BuildContext context) async {
    int value = 2;
    return showDialog<int>(
      context: context,
      builder: (ctx) {
        final t = AppLocalizations.of(ctx)!;
        return StatefulBuilder(
          builder: (ctx, setState) => AlertDialog(
            title: Text(t.chooseParticipantsTitle),
            content: DropdownButton<int>(
              value: value,
              isExpanded: true,
              items: const [2, 3, 4, 5, 6, 7]
                  .map(
                    (v) =>
                        DropdownMenuItem(value: v, child: Text(v.toString())),
                  )
                  .toList(),
              onChanged: (v) => setState(() => value = v ?? 2),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx),
                child: Text(t.btnCancel),
              ),
              FilledButton(
                onPressed: () => Navigator.pop(ctx, value),
                child: Text(t.btnOk),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _openSubject(
    BuildContext context, {
    required String subject, // 'physical' | 'economic'
    required Widget targetPageSolo,
  }) async {
    final mode = await _askMode(context);
    if (mode == null) return;

    if (mode == _Mode.solo) {
      if (!context.mounted) return;
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => targetPageSolo),
      );
      return;
    }

    final limit = await _askLimit(context);
    if (limit == null) return;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );

    try {
      final ref = await RoomService.createRoom(
        maxMembers: limit,
        subject: subject,
      );
      if (context.mounted) Navigator.pop(context);
      if (context.mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => RoomLobbyPage(roomId: ref.id)),
        );
      }
    } catch (e) {
      if (context.mounted) {
        final t = AppLocalizations.of(context)!;
        Navigator.pop(context);
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('${t.createRoomFailed}: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      backgroundColor: cs.background,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        scrolledUnderElevation: 0,
        automaticallyImplyLeading: true,
        title: const SizedBox.shrink(),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              Expanded(
                child: Center(
                  child: Text(
                    t.geography.toUpperCase(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: cs.inversePrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 42,
                      letterSpacing: 1.2,
                    ),
                  ),
                ),
              ),
              Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: FilledButton.icon(
                          onPressed: () => _openSubject(
                            context,
                            subject: 'physical',
                            targetPageSolo: const PhysicalGeographyMenuPage(),
                          ),
                          icon: const Icon(Icons.public),
                          label: Text(t.physicalGeography),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton.tonalIcon(
                          onPressed: () => _openSubject(
                            context,
                            subject: 'economic',
                            targetPageSolo: const EconomicGeographyMenuPage(),
                          ),
                          icon: const Icon(Icons.trending_up),
                          label: Text(t.economicGeography),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  TextButton.icon(
                    onPressed: () => _joinByCode(context),
                    icon: const Icon(Icons.login),
                    label: Text(t.joinByCode),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
