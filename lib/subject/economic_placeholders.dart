import 'package:flutter/material.dart';

class FactoriesPage extends StatelessWidget {
  const FactoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Заводы')),
      body: Center(
        child: Text(
          'Раздел "заводы" пока в разработке',
          style: TextStyle(color: cs.onSurface, fontSize: 16),
        ),
      ),
    );
  }
}

class SymbolsTestPage extends StatelessWidget {
  const SymbolsTestPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(title: const Text('Условные знаки — тест')),
      body: Center(
        child: Text(
          'Раздел "условные знаки тест" пока в разработке',
          style: TextStyle(color: cs.onSurface, fontSize: 16),
        ),
      ),
    );
  }
}
