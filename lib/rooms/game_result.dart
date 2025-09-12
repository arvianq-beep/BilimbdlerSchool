import 'package:flutter/material.dart';
import 'package:flutter_bilimdler/Services/room_services.dart';
import 'package:flutter_bilimdler/Pages/room_results_page.dart';
import 'package:flutter_bilimdler/l10n/app_localizations.dart';

class GameResult {
  /// Если есть roomId -> пишет результат в комнату и открывает общее табло.
  /// Если roomId нет -> показывает локальный диалог с результатом.
  static Future<void> submit({
    required BuildContext context,
    required int score,
    required int total,
    String? roomId,
    String? displayName,
  }) async {
    final t = AppLocalizations.of(context)!;

    if (roomId != null && roomId.isNotEmpty) {
      await RoomService.submitResult(
        roomId: roomId,
        score: score,
        total: total,
        displayName: displayName,
      );
      if (!context.mounted) return;
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => RoomResultsPage(roomId: roomId)),
      );
      return;
    }

    // Соло
    if (!context.mounted) return;
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(t.testFinished),
        content: Text('${t.result}: $score / $total'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(context), child: Text(t.btnOk)),
        ],
      ),
    );
  }
}
