// lib/rooms/create_room_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bilimdler/Pages/room_lobby_page.dart';
import 'package:flutter_bilimdler/Services/room_services.dart'; // RoomService

class CreateRoomPage extends StatefulWidget {
  const CreateRoomPage({super.key});

  @override
  State<CreateRoomPage> createState() => _CreateRoomPageState();
}

class _CreateRoomPageState extends State<CreateRoomPage> {
  final List<int> options = const [2, 3, 4, 5, 6, 7];
  int maxMembers = 2;

  // 'physical' | 'economic'
  String subject = 'physical';

  bool loading = false;

  Future<void> _create() async {
    if (loading) return;
    setState(() => loading = true);

    try {
      // Если у тебя в RoomService.createRoom НЕТ параметра subject,
      // просто убери `subject: subject,` из вызова ниже.
      final ref = await RoomService.createRoom(
        maxMembers: maxMembers,
        subject: subject,
      );

      if (!mounted) return;

      // Переход в лобби
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => RoomLobbyPage(roomId: ref.id)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Ошибка создания: $e')));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(title: const Text('Создать комнату')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // Выбор предмета
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Предмет',
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const SizedBox(height: 8),
            SegmentedButton<String>(
              segments: const [
                ButtonSegment(value: 'physical', label: Text('Физ. география')),
                ButtonSegment(value: 'economic', label: Text('Эко. география')),
              ],
              selected: {subject},
              onSelectionChanged: (s) => setState(() => subject = s.first),
            ),

            const SizedBox(height: 24),

            // Лимит участников
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Лимит участников',
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

            // Кнопка создать
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
                label: Text(loading ? '...' : 'Создать'),
              ),
            ),

            const SizedBox(height: 12),

            // Подсказка
            Text(
              'После создания поделитесь кодом комнаты из лобби.',
              style: TextStyle(color: cs.onSurfaceVariant),
            ),
          ],
        ),
      ),
    );
  }
}
