import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PhysicalTestPage extends StatefulWidget {
  const PhysicalTestPage({super.key});

  @override
  State<PhysicalTestPage> createState() => _PhysicalTestPageState();
}

class _PhysicalTestPageState extends State<PhysicalTestPage> {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> _questions = [];
  final Map<String, String> _selected = {}; // docId -> 'A'/'B'/'C'/'D'
  bool _loading = true;
  bool _submitted = false;

  // РµСЃР»Рё РІ Р‘Р” РЅРµС‚ subject='physical', РїРѕРїСЂРѕР±СѓРµРј РїРѕ СЂР°Р·РґРµР»Р°Рј
  static const Set<String> _physicalSections = {
    'РђС‚РјРѕСЃС„РµСЂР°',
    'Р“РёРґСЂРѕСЃС„РµСЂР°',
    'Р›РёС‚РѕСЃС„РµСЂР°',
    'Р‘РёРѕСЃС„РµСЂР°',
  };

  @override
  void initState() {
    super.initState();
    _loadQuestions();
  }

  int _asInt(dynamic v) {
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) {
      final s = v.replaceAll(RegExp(r'[^0-9]'), '');
      return int.tryParse(s) ?? 0;
    }
    return 0;
  }


  // Физикалық география: загрузка вопросов по возрастанию номера
  Future<void> _loadQuestions() async {
    setState(() {
      _loading = true;
      _submitted = false;
      _selected.clear();
    });

    final snapshotPhys = await FirebaseFirestore.instance
        .collection('questions')
        .orderBy('number')
        .get();

    setState(() {
      _questions = snapshotPhys.docs;
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
      appBar: AppBar(title: const Text('Р¤РёР·РёС‡РµСЃРєР°СЏ РіРµРѕРіСЂР°С„РёСЏ вЂ” С‚РµСЃС‚')),
      body: ListView.builder(
        itemCount: _questions.length,
        itemBuilder: (context, index) {
          final doc = _questions[index];
          final q = doc.data();
          final id = doc.id;

          final options = (q['options'] as Map<String, dynamic>? ?? {});
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
                    '${index + 1}. ${q['question'] ?? ''}', // Р»РѕРєР°Р»СЊРЅР°СЏ РЅСѓРјРµСЂР°С†РёСЏ 1..N
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
