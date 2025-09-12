import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // для FirebaseException
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
    final code = await showModalBottomSheet<String>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Theme.of(context).colorScheme.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) {
        final t = AppLocalizations.of(ctx)!;
        final c = TextEditingController();

        final bottomInset = MediaQuery.of(
          ctx,
        ).viewInsets.bottom; // высота клавы

        return SafeArea(
          top: false, // верх не нужен
          child: Padding(
            // учитываем клавиатуру + небольшой запас
            padding: EdgeInsets.only(bottom: bottomInset + 24),
            child: SingleChildScrollView(
              // тащит контент вверх и позволяет прокручивать при нехватке места
              reverse: true,
              keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // хэндл сверху
                  Center(
                    child: Container(
                      width: 36,
                      height: 4,
                      margin: const EdgeInsets.only(bottom: 12),
                      decoration: BoxDecoration(
                        color: Theme.of(ctx).dividerColor,
                        borderRadius: BorderRadius.circular(2),
                      ),
                    ),
                  ),
                  Text(
                    t.joinByCode,
                    style: Theme.of(ctx).textTheme.titleLarge,
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: c,
                    autofocus: true,
                    textCapitalization: TextCapitalization.characters,
                    textInputAction: TextInputAction.done,
                    onSubmitted: (_) =>
                        Navigator.pop(ctx, c.text.trim().toUpperCase()),
                    decoration: InputDecoration(hintText: t.enterCodeHint),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      TextButton(
                        onPressed: () => Navigator.pop(ctx),
                        child: Text(t.btnCancel),
                      ),
                      const SizedBox(width: 8),
                      FilledButton(
                        onPressed: () =>
                            Navigator.pop(ctx, c.text.trim().toUpperCase()),
                        child: Text(t.btnJoin),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
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
      if (!context.mounted) return;
      Navigator.pop(context);

      final t = AppLocalizations.of(context)!;
      String msg = t.unknownError;
      if (e is FirebaseException) {
        final map = {
          'codeGenerationFailed': t.codeGenerationFailed,
          'roomNotFound': t.roomNotFound,
          'roomAlreadyStarted': t.roomAlreadyStarted,
          'roomIsClosed': t.roomIsClosed,
          'roomIsFull': t.roomIsFull,
        };
        msg = map[e.code] ?? t.unknownError;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${t.joinFailed}: $msg')));
    }
  }

  Future<_Mode?> _askMode(BuildContext context) {
    return showDialog<_Mode>(
      context: context,
      barrierDismissible: true,
      useSafeArea: true,
      builder: (ctx) {
        final t = AppLocalizations.of(ctx)!;
        return AlertDialog(
          scrollable: true,
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
      barrierDismissible: true,
      useSafeArea: true,
      builder: (ctx) {
        final t = AppLocalizations.of(ctx)!;
        return StatefulBuilder(
          builder: (ctx, setState) => AlertDialog(
            scrollable: true,
            title: Text(t.chooseParticipantsTitle),
            content: DropdownButton<int>(
              value: value,
              isExpanded: true,
              items: const [2, 3, 4, 5, 6, 7]
                  .map((v) => DropdownMenuItem(value: v, child: Text('$v')))
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
      if (!context.mounted) return;
      Navigator.pop(context);

      final t = AppLocalizations.of(context)!;
      String msg = t.unknownError;
      if (e is FirebaseException) {
        final map = {
          'codeGenerationFailed': t.codeGenerationFailed,
          'roomNotFound': t.roomNotFound,
          'roomAlreadyStarted': t.roomAlreadyStarted,
          'roomIsClosed': t.roomIsClosed,
          'roomIsFull': t.roomIsFull,
        };
        msg = map[e.code] ?? t.unknownError;
      }

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('${t.createRoomFailed}: $msg')));
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      resizeToAvoidBottomInset: false, // не подпрыгивать фону при клавиатуре
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
