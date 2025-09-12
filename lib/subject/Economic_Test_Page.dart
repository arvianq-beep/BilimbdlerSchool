// lib/subject/economic_test_page.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class EconomicTestPage extends StatefulWidget {
  const EconomicTestPage({super.key});

  @override
  State<EconomicTestPage> createState() => _EconomicTestPageState();
}

class _EconomicTestPageState extends State<EconomicTestPage> {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> _questions = [];
  final Map<String, String> _selected = {}; // docId -> 'A'/'B'/'C'/'D'
  bool _loading = true;
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    _loadQuestions(); // грузим 30 по порядку из 'econom'
  }

  // Надёжно приводим значение к int (если в БД 'number' строкой)
  int _asInt(dynamic v) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) {
      final s = v.replaceAll(RegExp(r'[^0-9]'), '');
      return int.tryParse(s) ?? 0;
    }
    return 0;
  }

  // Мини-локализация без ARB
  String _t(
    BuildContext context, {
    required String kk,
    required String ru,
    String? en,
  }) {
    final code = Localizations.localeOf(context).languageCode;
    if (code == 'kk') return kk;
    if (code == 'ru') return ru;
    return en ?? ru;
  }

  // Загружаем ВСЕ из 'econom', сортируем по number и берём первые 30
  Future<void> _loadQuestions() async {
    setState(() {
      _loading = true;
      _submitted = false;
      _selected.clear();
    });

    final snap = await FirebaseFirestore.instance.collection('econom').get();

    final all =
        List<QueryDocumentSnapshot<Map<String, dynamic>>>.from(snap.docs)
          ..sort((a, b) {
            final an = _asInt(a.data()['number']);
            final bn = _asInt(b.data()['number']);
            return an.compareTo(bn);
          });

    final first30 = all.take(30).toList();

    setState(() {
      _questions = first30;
      _loading = false;
    });
  }

  void _finishTest() {
    setState(() => _submitted = true);

    int correct = 0;
    for (final doc in _questions) {
      final data = doc.data();
      final right = (data['correct'] ?? '').toString().toUpperCase();
      final picked = (_selected[doc.id] ?? '').toUpperCase();
      if (right.isNotEmpty && picked == right) correct++;
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(
          _t(
            context,
            kk: 'Тест аяқталды',
            ru: 'Тест завершён',
            en: 'Test finished',
          ),
        ),
        content: Text(
          _t(
            context,
            kk: 'Нәтиже: $correct / ${_questions.length}',
            ru: 'Результат: $correct из ${_questions.length}',
            en: 'Score: $correct of ${_questions.length}',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(_t(context, kk: 'ОК', ru: 'ОК', en: 'OK')),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _loadQuestions(); // перезагрузить 30 по порядку
            },
            child: Text(
              _t(context, kk: 'Қайтадан', ru: 'Ещё раз', en: 'Again'),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(
          _t(
            context,
            kk: 'Экономикалық география — тест',
            ru: 'Экономическая география — тест',
            en: 'Economic geography — test',
          ),
        ),
      ),
      body: ListView.builder(
        itemCount: _questions.length,
        itemBuilder: (context, index) {
          final doc = _questions[index];
          final q = doc.data();
          final id = doc.id;

          final options = Map<String, dynamic>.from(q['options'] ?? {});
          final keys = ['A', 'B', 'C', 'D'].where(options.containsKey).toList();
          final selected = _selected[id];
          final correctKey = (q['correct'] ?? '').toString().toUpperCase();

          return Card(
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${index + 1}. ${q['question'] ?? ''}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 12),
                  for (final k in keys)
                    RadioListTile<String>(
                      title: Text('$k. ${options[k]}'),
                      value: k,
                      groupValue: selected,
                      onChanged: _submitted
                          ? null
                          : (val) => setState(() => _selected[id] = val!),
                      selected: _submitted && selected == k,
                      activeColor: (_submitted && k == correctKey)
                          ? Colors.green
                          : null,
                      subtitle: !_submitted
                          ? null
                          : (k == correctKey)
                          ? Text(
                              _t(
                                context,
                                kk: 'Дұрыс жауап',
                                ru: 'Верный ответ',
                                en: 'Correct',
                              ),
                              style: const TextStyle(color: Colors.green),
                            )
                          : (selected == k)
                          ? Text(
                              _t(
                                context,
                                kk: 'Қате',
                                ru: 'Неверно',
                                en: 'Wrong',
                              ),
                              style: const TextStyle(color: Colors.red),
                            )
                          : null,
                    ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: ElevatedButton(
            onPressed: _submitted ? null : _finishTest,
            child: Text(
              _t(
                context,
                kk: 'Тесті аяқтау',
                ru: 'Завершить тест',
                en: 'Finish test',
              ),
            ),
          ),
        ),
      ),
    );
  }
}
