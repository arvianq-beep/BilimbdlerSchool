import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class FactoriesPage extends StatefulWidget {
  const FactoriesPage({super.key});

  @override
  State<FactoriesPage> createState() => _FactoriesPageState();
}

class _FactoriesPageState extends State<FactoriesPage> {
  // Индексы правильных ответов (по порядку вопросов)
  final List<int> _correct = [1, 0, 1];

  int _current = 0;
  int _score = 0;

  void _answer(int selected) {
    if (selected == _correct[_current]) _score++;
    setState(() => _current++);
  }

  List<Map<String, Object>> _buildQuestions(AppLocalizations t) => [
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
  ];

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final questions = _buildQuestions(t);
    final total = questions.length;

    return Scaffold(
      appBar: AppBar(title: Text(t.factoriesTestTitle)),
      body: SafeArea(
        // <- защищаемся от вырезов/домов кнопки
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: _current < total
              ? Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Прогресс
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

                    // Карточка вопроса
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

                    // ПРОКРУЧИВАЕМЫЕ варианты ответов
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
