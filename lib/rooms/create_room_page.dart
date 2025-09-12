import 'package:flutter/material.dart';
import 'package:flutter_bilimdler/Pages/room_lobby_page.dart';
import 'package:flutter_bilimdler/Services/room_services.dart';
import 'package:flutter_bilimdler/l10n/app_localizations.dart';

class CreateRoomPage extends StatefulWidget {
  const CreateRoomPage({super.key});

  @override
  State<CreateRoomPage> createState() => _CreateRoomPageState();
}

class _CreateRoomPageState extends State<CreateRoomPage> {
  final List<int> options = const [2, 3, 4, 5, 6, 7];
  int maxMembers = 2;
  String subject = 'physical';
  bool loading = false;

  Future<void> _create() async {
    if (loading) return;
    setState(() => loading = true);

    try {
      final ref = await RoomService.createRoom(
        maxMembers: maxMembers,
        subject: subject,
      );
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => RoomLobbyPage(roomId: ref.id)),
      );
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalizations.of(context)!.createRoomFailed)),
      );
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: Text(t.createRoomTitle)),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                t.subjects,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: [
                ButtonSegment(
                  value: 'physical',
                  label: Text(t.physicalGeography),
                ),
                ButtonSegment(
                  value: 'economic',
                  label: Text(t.economicGeography),
                ),
              ],
              selected: {subject},
              onSelectionChanged: (s) => setState(() => subject = s.first),
            ),

            const SizedBox(height: 24),

            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                t.participantsLimit,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 8),
            DropdownButton<int>(
              value: maxMembers,
              isExpanded: true,
              items: options
                  .map(
                    (v) =>
                        DropdownMenuItem(value: v, child: Text(v.toString())),
                  )
                  .toList(),
              onChanged: (v) => setState(() => maxMembers = v ?? 2),
            ),

            const Spacer(),

            SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                onPressed: loading ? null : _create,
                icon: loading
                    ? const SizedBox(
                        width: 18,
                        height: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.add),
                label: Text(loading ? '...' : t.btnCreate),
              ),
            ),

            const SizedBox(height: 12),

            Text(t.shareCodeHint, style: TextStyle(color: cs.onSurfaceVariant)),
          ],
        ),
      ),
    );
  }
}
