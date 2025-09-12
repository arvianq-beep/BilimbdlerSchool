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
    _loadQuestionsEconom();
  }

  // Р°РєРєСѓСЂР°С‚РЅС‹Р№ РїР°СЂСЃРµСЂ РЅРѕРјРµСЂР° (int/num/string)
  int _asInt(dynamic v) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) {
      // РІС‹РєРёРЅРµРј РІСЃС‘, С‡С‚Рѕ РЅРµ С†РёС„СЂР° (РЅР° РІСЃСЏРєРёР№ СЃР»СѓС‡Р°Р№)
      final s = v.replaceAll(RegExp(r'[^0-9]'), '');
      return int.tryParse(s) ?? 0;
    }
    return 0;
  }

  // Р­РєРѕРЅРѕРјРёРєР°Р»С‹Т› РіРµРѕРіСЂР°С„РёСЏ: Р·Р°РіСЂСѓР·РєР° РІРѕРїСЂРѕСЃРѕРІ РёР· 'econom' РїРѕ РІРѕР·СЂР°СЃС‚Р°РЅРёСЋ РЅРѕРјРµСЂР°
  Future<void> _loadQuestionsEconom() async {
    setState(() {
      _loading = true;
      _submitted = false;
      _selected.clear();
    });

    final snapshotEconom = await FirebaseFirestore.instance
        .collection('econom')
        .orderBy('number')
        .get();

    setState(() {
      _questions = snapshotEconom.docs;
      _loading = false;
    });
  }

  Future<void> _loadQuestions() async {
    setState(() {
      _loading = true;
      _submitted = false;
      _selected.clear();
    });

    // 1) Р·Р°Р±СЂР°Р»Рё РІСЃРµ РґРѕРєСѓРјРµРЅС‚С‹ (РЅРёС‡РµРіРѕ РІ Р‘Р” РЅРµ РјРµРЅСЏРµРј)
    final snap = await FirebaseFirestore.instance.collection('questions').get();

    // 2) РїРµСЂРµРјРµС€Р°Р»Рё Рё РІР·СЏР»Рё 30
    final all = snap.docs.toList()..shuffle();
    final picked = all.take(30).toList();

    // 3) С‚РµРїРµСЂСЊ РћРўРЎРћР РўРР РћР’РђР›Р РІС‹Р±СЂР°РЅРЅС‹Рµ 30 РїРѕ РїРѕР»СЋ "number"
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

    // РµСЃР»Рё РІ РґРѕРєСѓРјРµРЅС‚Рµ РµСЃС‚СЊ РїРѕР»Рµ "correct" (A/B/C/D) вЂ” РїРѕСЃС‡РёС‚Р°РµРј Р±Р°Р»Р»С‹
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
        title: const Text('РўРµСЃС‚ Р·Р°РІРµСЂС€С‘РЅ'),
        content: Text('Р РµР·СѓР»СЊС‚Р°С‚: $correct РёР· ${_questions.length}'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('РћРє'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _loadQuestions(); // РЅРѕРІР°СЏ СЃР»СѓС‡Р°Р№РЅР°СЏ, РЅРѕ РѕС‚СЃРѕСЂС‚РёСЂРѕРІР°РЅРЅР°СЏ РІС‹Р±РѕСЂРєР°
            },
            child: const Text('Р•С‰С‘ СЂР°Р·'),
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
      appBar: AppBar(title: const Text('Р­РєРѕРЅРѕРјРёРєР° вЂ” С‚РµСЃС‚')),
      body: ListView.builder(
        itemCount: _questions.length,
        itemBuilder: (context, index) {
          final doc = _questions[index];
          final q = doc.data();
          final id = doc.id;

          final options = (q['options'] as Map<String, dynamic>? ?? {});
          // РїРѕСЂСЏРґРѕРє РІР°СЂРёР°РЅС‚РѕРІ A..D
          final keys = ['A', 'B', 'C', 'D'].where(options.containsKey).toList();
          final selected = _selected[id];
          final correctKey = (q['correct'] ?? '').toString().toUpperCase();

          // Р»РѕРєР°Р»СЊРЅР°СЏ РЅСѓРјРµСЂР°С†РёСЏ 1..N (С‡С‚РѕР±С‹ РЅРµ Р±С‹Р»Рѕ "66." РІ РЅР°С‡Р°Р»Рµ)
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
                              'Р’РµСЂРЅС‹Р№ РѕС‚РІРµС‚',
                              style: TextStyle(color: Colors.green),
                            )
                          : (selected == k)
                          ? const Text(
                              'РќРµРІРµСЂРЅРѕ',
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
            child: const Text('Р—Р°РІРµСЂС€РёС‚СЊ С‚РµСЃС‚'),
          ),
        ),
      ),
    );
  }
}
