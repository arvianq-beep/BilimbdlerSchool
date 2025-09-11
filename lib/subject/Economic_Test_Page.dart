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
    _loadQuestions();
  }

  // аккуратный парсер номера (int/num/string)
  int _asInt(dynamic v) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) {
      // выкинем всё, что не цифра (на всякий случай)
      final s = v.replaceAll(RegExp(r'[^0-9]'), '');
      return int.tryParse(s) ?? 0;
    }
    return 0;
  }

  Future<void> _loadQuestions() async {
    setState(() {
      _loading = true;
      _submitted = false;
      _selected.clear();
    });

    // 1) забрали все документы (ничего в БД не меняем)
    final snap = await FirebaseFirestore.instance.collection('questions').get();

    // 2) перемешали и взяли 30
    final all = snap.docs.toList()..shuffle();
    final picked = all.take(30).toList();

    // 3) теперь ОТСОРТИРОВАЛИ выбранные 30 по полю "number"
    picked.sort((a, b) {
      final na = _asInt(a.data()['number']);
      final nb = _asInt(b.data()['number']);
      return na.compareTo(nb);
    });

    setState(() {
      _questions = picked;
      _loading = false;
    });
  }

  void _finishTest() {
    setState(() => _submitted = true);

    // если в документе есть поле "correct" (A/B/C/D) — посчитаем баллы
    int correct = 0;
    for (final doc in _questions) {
      final data = doc.data();
      final right = (data['correct'] ?? '').toString().toUpperCase();
      final picked = (_selected[doc.id] ?? '').toUpperCase();
      if (right.isNotEmpty && picked == right) {
        correct++;
      }
    }

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Тест завершён'),
        content: Text('Результат: $correct из ${_questions.length}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Ок'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _loadQuestions(); // новая случайная, но отсортированная выборка
            },
            child: const Text('Ещё раз'),
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
      appBar: AppBar(title: const Text('Экономика — тест')),
      body: ListView.builder(
        itemCount: _questions.length,
        itemBuilder: (context, index) {
          final doc = _questions[index];
          final q = doc.data();
          final id = doc.id;

          final options = (q['options'] as Map<String, dynamic>? ?? {});
          // порядок вариантов A..D
          final keys = ['A', 'B', 'C', 'D'].where(options.containsKey).toList();
          final selected = _selected[id];
          final correctKey = (q['correct'] ?? '').toString().toUpperCase();

          // локальная нумерация 1..N (чтобы не было "66." в начале)
          final title = '${index + 1}. ${q['question'] ?? ''}';

          return Card(
            margin: const EdgeInsets.all(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
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
                          ? const Text(
                              'Верный ответ',
                              style: TextStyle(color: Colors.green),
                            )
                          : (selected == k)
                          ? const Text(
                              'Неверно',
                              style: TextStyle(color: Colors.red),
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
            child: const Text('Завершить тест'),
          ),
        ),
      ),
    );
  }
}
