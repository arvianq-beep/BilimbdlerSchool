import 'package:flutter/material.dart';
import 'package:flutter_bilimdler/Pages/room_lobby_page.dart';
import 'package:flutter_bilimdler/Services/room_services.dart';

class JoinRoomPage extends StatefulWidget {
  const JoinRoomPage({super.key});

  @override
  State<JoinRoomPage> createState() => _JoinRoomPageState();
}

class _JoinRoomPageState extends State<JoinRoomPage> {
  final ctrl = TextEditingController();
  bool loading = false;

  @override
  void dispose() {
    ctrl.dispose();
    super.dispose();
  }

  Future<void> _join() async {
    final code = ctrl.text.trim().toUpperCase();
    if (code.isEmpty) return;
    setState(() => loading = true);
    try {
      final ref = await RoomService.joinByCode(code);
      if (!mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => RoomLobbyPage(roomId: ref.id)),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Ошибка входа: $e')));
    } finally {
      if (mounted) setState(() => loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Войти по коду')),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: ctrl,
              textCapitalization: TextCapitalization.characters,
              decoration: const InputDecoration(
                labelText: 'Код комнаты',
                hintText: 'ABC123',
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: loading ? null : _join,
              child: Text(loading ? '...' : 'Войти'),
            ),
          ],
        ),
      ),
    );
  }
}
