// lib/Pages/FactoriesPagesGeography.dart
import 'package:flutter/material.dart';

import 'package:flutter_bilimdler/rooms/game_result.dart';
import '../l10n/app_localizations.dart';

class FactoriesPage extends StatefulWidget {
  final String? roomId; // null = соло, не null = группа (сабмит в комнату)
  const FactoriesPage({super.key, this.roomId});

  @override
  State<FactoriesPage> createState() => _FactoriesPageState();
}

class _FactoriesPageState extends State<FactoriesPage> {
  // Правильные ответы: Q1..Q7
  final List<int> _correct = [1, 0, 1, 3, 0, 0, 2];

  int _current = 0;
  int _score = 0;

  void _answer(int selected) async {
    if (selected == _correct[_current]) _score++;

    final total = _questions(AppLocalizations.of(context)!).length;
    final isLast = _current + 1 >= total;

    if (isLast) {
      // ГРУППА: отправляем результат в комнату
      if ((widget.roomId ?? '').isNotEmpty) {
        try {
          await GameResult.submit(
            context: context,
            score: _score,
            total: total,
            roomId: widget.roomId,
          );
          return; // GameResult сам покажет табло (если настроено)
        } catch (e) {
          if (!mounted) return;
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Не удалось отправить результат: $e')),
          );
        }
      }

      // СОЛО: показать локальный итог
      setState(() => _current++);
      return;
    }

    setState(() => _current++);
  }

  List<Map<String, Object>> _questions(AppLocalizations t) => [
    {
      'q': t.factoriesQ1,
      'a': [t.factoriesQ1A1, t.factoriesQ1A2, t.factoriesQ1A3, t.factoriesQ1A4],
    },
    {
      'q': t.factoriesQ2,
      'a': [t.factoriesQ2A1, t.factoriesQ2A2, t.factoriesQ2A3, t.factoriesQ2A4],
    },
    {
      'q': t.factoriesQ3,
      'a': [t.factoriesQ3A1, t.factoriesQ3A2, t.factoriesQ3A3, t.factoriesQ3A4],
    },
    {
      'q': t.factoriesQ4,
      'a': [t.factoriesQ4A1, t.factoriesQ4A2, t.factoriesQ4A3, t.factoriesQ4A4],
    },
    {
      'q': t.factoriesQ5,
      'a': [t.factoriesQ5A1, t.factoriesQ5A2, t.factoriesQ5A3, t.factoriesQ5A4],
    },
    {
      'q': t.factoriesQ6,
      'a': [t.factoriesQ6A1, t.factoriesQ6A2, t.factoriesQ6A3, t.factoriesQ6A4],
    },
    {
      'q': t.factoriesQ7,
      'a': [t.factoriesQ7A1, t.factoriesQ7A2, t.factoriesQ7A3, t.factoriesQ7A4],
    },
  ];

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final questions = _questions(t);
    final total = questions.length;
    final inQuiz = _current < total;

    return Scaffold(
      appBar: AppBar(title: Text(t.factoriesTestTitle)),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: inQuiz
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      t.questionOfTotal('${_current + 1}', '$total'),
                      style: TextStyle(
                        color: cs.onSurface.withOpacity(.9),
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: LinearProgressIndicator(
                        value: (_current) / total,
                        minHeight: 8,
                        backgroundColor: cs.secondaryContainer,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Material(
                      color: Theme.of(context).brightness == Brightness.dark
                          ? cs.primaryContainer
                          : cs.tertiary,
                      elevation: 2,
                      borderRadius: BorderRadius.circular(16),
                      child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Text(
                          questions[_current]['q'] as String,
                          style: TextStyle(
                            color: cs.onSurface,
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    Expanded(
                      child: ListView.separated(
                        padding: EdgeInsets.only(
                          bottom: MediaQuery.of(context).padding.bottom + 8,
                        ),
                        itemCount:
                            (questions[_current]['a'] as List<String>).length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (_, i) => FilledButton.tonal(
                          onPressed: () => _answer(i),
                          style: FilledButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                              vertical: 14,
                              horizontal: 12,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              (questions[_current]['a'] as List<String>)[i],
                              style: TextStyle(
                                fontSize: 16,
                                color: cs.onSecondaryContainer,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )
              : Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        t.citiesEgFinishTitle,
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: cs.onSurface,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        t.resultDisplay(_score, total),
                        style: TextStyle(
                          fontSize: 16,
                          color: cs.onSurface.withOpacity(.9),
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      FilledButton(
                        onPressed: () => setState(() {
                          _current = 0;
                          _score = 0;
                        }),
                        child: Text(t.playAgain),
                      ),
                    ],
                  ),
                ),
        ),
      ),
    );
  }
}
