import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:confetti/confetti.dart';
import '../l10n/app_localizations.dart';

class LakesPhysicalGeographyPage extends StatefulWidget {
  const LakesPhysicalGeographyPage({super.key});

  @override
  State<LakesPhysicalGeographyPage> createState() => _LakesPhysicalGeographyPageState();
}

class _LakesPhysicalGeographyPageState extends State<LakesPhysicalGeographyPage>
    with TickerProviderStateMixin {
  static const String _mapAssetPath = 'lib/Images/lakes_counrty.png';

  // Bounding box of Kazakhstan used to project lat/lng to image
  static const double _bboxMinLat = 40.56;
  static const double _bboxMaxLat = 55.59;
  static const double _bboxMinLng = 46.50;
  static const double _bboxMaxLng = 87.30;

  static const List<({
    String id,
    String nameRu,
    String nameKk,
    double lat,
    double lng,
    int? areaKm2,
  })> _lakes = [
    (id: 'lake_caspian', nameRu: 'Каспийское море', nameKk: 'Каспий теңізі', lat: 45.2, lng: 51.5, areaKm2: 371000),
    (id: 'lake_balkhash', nameRu: 'Балхаш', nameKk: 'Балқаш', lat: 46.2, lng: 74.5, areaKm2: 16400),
    (id: 'lake_aral', nameRu: 'Аральское море', nameKk: 'Арал теңізі', lat: 45.0, lng: 59.0, areaKm2: 13900),
    (id: 'lake_north_aral', nameRu: 'Северный Арал', nameKk: 'Солтүстік Арал', lat: 46.2, lng: 61.2, areaKm2: 3300),
    (id: 'lake_alakol', nameRu: 'Алаколь', nameKk: 'Алакөл', lat: 46.2, lng: 81.6, areaKm2: 2200),
    (id: 'lake_zaysan', nameRu: 'Зайсан', nameKk: 'Зайсан', lat: 47.5, lng: 84.8, areaKm2: 1810),
    (id: 'lake_tengiz', nameRu: 'Тенгиз', nameKk: 'Теңіз көлі', lat: 50.5, lng: 69.0, areaKm2: 1590),
    (id: 'lake_sileti', nameRu: 'Силетитеңіз', nameKk: 'Сілетітеңіз', lat: 50.8, lng: 66.6, areaKm2: 750),
    (id: 'lake_sasykkol', nameRu: 'Сасыкколь', nameKk: 'Сасыккөл', lat: 45.6, lng: 79.8, areaKm2: 736),
  ];

  Size? _mapImageSize;
  bool _mapSizeResolved = false;
  final double _tapSize = 32; // larger touch target for mobile

  // Insets for inner content area (same as cities screen)
  static const double _insetLeft = 0.02;
  static const double _insetRight = 0.02;
  static const double _insetTop = 0.03;
  static const double _insetBottom = 0.03;

  late List<int> _order;
  int _currentIndex = 0;
  int _score = 0;
  final Set<String> _correct = {};
  final Set<String> _wrong = {};

  bool _rulesShownOnce = false;

  final List<_Plus> _pluses = [];
  final Map<String, Offset> _screenCenters = {};
  // Persistent choices and attempts per lake for current game session
  final Map<String, List<String>> _choicesByLakeId = {};
  final Map<String, int> _attemptsByLakeId = {};
  int _totalAttempts = 0;
  bool _finishedShown = false;
  late ConfettiController _confetti;

  ({String id, String nameRu, String nameKk, double lat, double lng, int? areaKm2}) get _currentLake =>
      _lakes[_order[_currentIndex]];

  @override
  void initState() {
    super.initState();
    _confetti = ConfettiController(duration: const Duration(seconds: 3));
    _resolveMapImageSize();
    _startGame();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted || _rulesShownOnce) return;
      _rulesShownOnce = true;
      _showRulesDialog();
    });
  }

  void _resolveMapImageSize() {
    final img = AssetImage(_mapAssetPath);
    final cfg = const ImageConfiguration();
    final stream = img.resolve(cfg);
    ImageStreamListener? listener;
    listener = ImageStreamListener((info, _) {
      _mapImageSize = Size(info.image.width.toDouble(), info.image.height.toDouble());
      _mapSizeResolved = true;
      stream.removeListener(listener!);
      if (mounted) setState(() {});
    }, onError: (error, stackTrace) {
      _mapSizeResolved = false;
      try {
        stream.removeListener(listener!);
      } catch (_) {}
      if (mounted) setState(() {});
    });
    stream.addListener(listener);
  }

  void _startGame() {
    _order = List<int>.generate(_lakes.length, (i) => i)..shuffle();
    _currentIndex = 0;
    _score = 0;
    _totalAttempts = 0;
    _finishedShown = false;
    _correct.clear();
    _wrong.clear();
    _choicesByLakeId.clear();
    _attemptsByLakeId.clear();
    final allIds = _lakes.map((e) => e.id).toList();
    for (final id in allIds) {
      final pool = allIds.where((x) => x != id).toList()..shuffle();
      final wrong = pool.take(2).toList();
      final opts = [...wrong, id]..shuffle();
      _choicesByLakeId[id] = opts;
      _attemptsByLakeId[id] = 0;
    }
    setState(() {});
  }

  @override
  void dispose() {
    for (final p in _pluses) {
      p.ctrl.dispose();
    }
    _pluses.clear();
    _confetti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(t.lakes),
        actions: [
          IconButton(
            tooltip: t.rules,
            icon: const Icon(Icons.help_outline),
            onPressed: _showRulesDialog,
          ),
          IconButton(
            tooltip: _infoLabel(context),
            icon: const Icon(Icons.info_outline),
            onPressed: _showInfoDialog,
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(children: [
          Column(children: [
            _buildHeader(context),
            Expanded(child: Padding(padding: const EdgeInsets.all(12), child: _buildMap())),
          ]),
          Positioned.fill(
            child: IgnorePointer(
              child: Align(
                alignment: Alignment.topCenter,
                child: ConfettiWidget(
                  confettiController: _confetti,
                  blastDirectionality: BlastDirectionality.explosive,
                  emissionFrequency: 0.02,
                  numberOfParticles: 12,
                  maxBlastForce: 20,
                  minBlastForce: 6,
                  gravity: 0.3,
                  colors: [
                    Theme.of(context).colorScheme.primary,
                    Theme.of(context).colorScheme.secondary,
                    Theme.of(context).colorScheme.tertiary,
                    Colors.white,
                  ],
                ),
              ),
            ),
          ),
        ]),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
      child: Container(
        decoration: BoxDecoration(
          color: cs.surface,
          borderRadius: BorderRadius.zero,
          boxShadow: [
            BoxShadow(color: cs.shadow.withOpacity(0.08), blurRadius: 10, offset: const Offset(0, 4)),
          ],
          border: Border.all(color: cs.outlineVariant),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(color: cs.primaryContainer, borderRadius: BorderRadius.circular(999)),
            child: Text(
              _scoreLabel(context, _score),
              style: TextStyle(color: cs.onPrimaryContainer, fontWeight: FontWeight.w700),
            ),
          ),
          const Spacer(),
          FilledButton.tonal(onPressed: _restart, child: Text(_restartLabel(context))),
        ]),
      ),
    );
  }

  Widget _buildSidebar(BuildContext context) {
    final locale = Localizations.localeOf(context).languageCode;
    String nameFor(int i) => locale == 'kk' ? _lakes[i].nameKk : _lakes[i].nameRu;
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            locale == 'kk' ? 'Көлдер туралы мәлімет' : 'Информация о озёрах',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
          ),
          const SizedBox(height: 8),
          Text(
            locale == 'kk'
                ? 'Қазақстанда 48 262 көл бар. Ниже — несколько крупнейших.'
                : 'В Казахстане 48 262 озера. Ниже — несколько крупнейших.',
          ),
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              itemCount: _lakes.length,
              separatorBuilder: (_, __) => const Divider(height: 12),
              itemBuilder: (context, i) {
                final l = _lakes[i];
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${i + 1}. ', style: const TextStyle(fontWeight: FontWeight.w600)),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            nameFor(i),
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                          if (l.areaKm2 != null)
                            Text((locale == 'kk') ? 'Ауданы: ${l.areaKm2} км²' : 'Площадь: ${l.areaKm2} км²'),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMap() {
    return LayoutBuilder(builder: (context, constraints) {
      final maxW = constraints.maxWidth;
      final maxH = constraints.maxHeight;
      double contentW = maxW, contentH = maxH, offsetX = 0, offsetY = 0;
      if (_mapSizeResolved && _mapImageSize != null && _mapImageSize!.width > 0 && _mapImageSize!.height > 0) {
        final scale = _containScale(_mapImageSize!.width, _mapImageSize!.height, maxW, maxH);
        contentW = _mapImageSize!.width * scale;
        contentH = _mapImageSize!.height * scale;
        offsetX = (maxW - contentW) / 2;
        offsetY = (maxH - contentH) / 2;
      }
      return InteractiveViewer(
        minScale: 1,
        maxScale: 4,
        boundaryMargin: const EdgeInsets.all(48),
        child: Stack(children: [
          Positioned.fill(
            child: Image.asset(
              _mapAssetPath,
              fit: BoxFit.contain,
              alignment: Alignment.center,
              errorBuilder: (context, _, __) => const Center(child: Text('Изображение карты не найдено: lib/Images/lakes_counrty.png')),
            ),
          ),
          if (_mapSizeResolved && _mapImageSize != null)
            ..._buildLakeOverlays(offsetX, offsetY, contentW, contentH),
          Positioned.fill(child: IgnorePointer(child: CustomPaint(painter: _PlusPainter(pluses: _pluses)))),
        ]),
      );
    });
  }

  List<Widget> _buildLakeOverlays(double offsetX, double offsetY, double contentW, double contentH) {
    final List<Widget> children = [];
    final innerLeft = offsetX + contentW * _insetLeft;
    final innerTop = offsetY + contentH * _insetTop;
    final innerW = contentW * (1 - _insetLeft - _insetRight);
    final innerH = contentH * (1 - _insetTop - _insetBottom);

    // Optional per-lake screen nudge (to keep markers inside country silhouette)
    final Map<String, Offset> nudges = {
      'lake_aral': const Offset(18, 6),
      // Сдвиги по просьбе: левее/правее/выше
      'lake_caspian': const Offset(-12, 6), // левее
      'lake_balkhash': const Offset(-8, 2), // левее
      'lake_alakol': const Offset(10, 0), // правее
      'lake_zaysan': const Offset(-10, -6), // левее и чуть выше
      'lake_tengiz': const Offset(0, -6), // оставить как есть
      'lake_sileti': const Offset(0, -6),
      'lake_sasykkol': const Offset(-6, 0),
      'lake_north_aral': const Offset(-2, -2), // чуть левее и вверх
    };

    final List<({String id, Offset pos})> centers = _lakes
        .map((l) {
          final x = ((l.lng - _bboxMinLng) / (_bboxMaxLng - _bboxMinLng)).clamp(0.0, 1.0) * innerW;
          final y = ((_bboxMaxLat - l.lat) / (_bboxMaxLat - _bboxMinLat)).clamp(0.0, 1.0) * innerH;
          final nudge = nudges[l.id] ?? Offset.zero;
          final pos = Offset(x, y) + nudge;
          final clamped = Offset(
            pos.dx.clamp(_tapSize / 2, innerW - _tapSize / 2),
            pos.dy.clamp(_tapSize / 2, innerH - _tapSize / 2),
          );
          return (id: l.id, pos: clamped);
        })
        .toList();

    final placed = <({String id, Offset pos})>[];
    final minDist = _tapSize * 1.05;
    for (final item in centers) {
      Offset p = item.pos;
      bool ok() => placed.every((e) => (e.pos - p).distance >= minDist);
      if (!ok()) {
        const int maxSteps = 120;
        double r = 2;
        double angle = 0;
        for (int i = 0; i < maxSteps && !ok(); i++) {
          angle += math.pi / 12;
          r += 1.5;
          final cand = item.pos + Offset(r * math.cos(angle), r * math.sin(angle));
          final clamped = Offset(
            cand.dx.clamp(_tapSize / 2, innerW - _tapSize / 2),
            cand.dy.clamp(_tapSize / 2, innerH - _tapSize / 2),
          );
          p = clamped;
        }
      }
      placed.add((id: item.id, pos: p));
    }

    _screenCenters
      ..clear()
      ..addEntries(placed.map((e) => MapEntry(e.id, Offset(innerLeft + e.pos.dx, innerTop + e.pos.dy))));

    for (final e in placed) {
      final id = e.id;
      final center = Offset(innerLeft + e.pos.dx, innerTop + e.pos.dy);
      final isCorrect = _correct.contains(id);
      final isWrong = _wrong.contains(id);
      children.add(Positioned(
        left: center.dx - _tapSize / 2,
        top: center.dy - _tapSize / 2,
        width: _tapSize,
        height: _tapSize,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: isCorrect ? null : () => _onLakeTap(id),
          child: Container(
            decoration: BoxDecoration(
              color: () {
                if (isCorrect) return Colors.green;
                if (isWrong) return Colors.redAccent;
                return Colors.grey;
              }(),
              borderRadius: BorderRadius.circular(6),
              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 3, offset: Offset(0, 1))],
            ),
          ),
        ),
      ));
    }
    return children;
  }

  void _restart() {
    _startGame();
  }

  String _restartLabel(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'kk' ? 'Қайтадан' : 'Заново';

  void _onLakeTap(String id) {
    _showChoicesForTapPersist(id);
  }

  Future<void> _showChoicesForTapPersist(String tappedId) async {
    final targetId = tappedId;
    // Persistent choices prepared at game start
    List<String> choices = List<String>.from(_choicesByLakeId[targetId] ?? const []);
    if (choices.isEmpty) {
      final pool = _lakes.map((e) => e.id).where((x) => x != targetId).toList()..shuffle();
      final wrong = pool.take(2).toList();
      choices = [...wrong, targetId]..shuffle();
      _choicesByLakeId[targetId] = List<String>.from(choices);
    }

    final locale = Localizations.localeOf(context).languageCode;
    String labelOf(String id) => _lakeNameForLocale(context, id);

    final selected = await showDialog<String>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(locale == 'kk' ? 'Қай көл?' : 'Какое это озеро?'),
        children: [
          for (final opt in choices)
            SimpleDialogOption(
              onPressed: () => Navigator.of(ctx).pop(opt),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Text(labelOf(opt)),
              ),
            ),
        ],
      ),
    );

    if (selected == null) return; // dismissed
    _totalAttempts += 1;
    _attemptsByLakeId[targetId] = (_attemptsByLakeId[targetId] ?? 0) + 1;

    final isCorrect = selected == targetId;
    if (isCorrect) {
      setState(() {
        _score += 1;
        _correct.add(tappedId);
        _wrong.clear();
        _spawnPlusAt(tappedId);
        if (_correct.length == _lakes.length && !_finishedShown) {
          _finishedShown = true;
          _confetti.play();
          _showFinishDialogStats();
        }
      });
    } else {
      _wrong.add(tappedId);
      try {
        HapticFeedback.heavyImpact();
      } catch (_) {}
      setState(() {});
    }
  }

  Future<void> _showFinishDialogStats() async {
    final locale = Localizations.localeOf(context).languageCode;
    final total = _lakes.length;
    final avg = total == 0 ? 0 : (_totalAttempts / total);
    final lines = locale == 'kk'
        ? 'Ұпай: $_score / $total\nБарлығы әрекет: $_totalAttempts\nОрташа әрекет: ${avg.toStringAsFixed(2)}'
        : 'Очки: $_score / $total\nВсего попыток: $_totalAttempts\nСреднее на озеро: ${avg.toStringAsFixed(2)}';
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(locale == 'kk' ? 'Дайын!' : 'Готово!'),
        content: Text(lines),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _startGame();
            },
            child: Text(AppLocalizations.of(ctx)!.playAgain),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(AppLocalizations.of(ctx)!.btnCancel),
          ),
        ],
      ),
    );
  }

  Future<void> _showChoicesForTap(String tappedId) async {
    final targetId = tappedId;
    // Pick two random wrong lakes from the remaining pool (exclude target)
    final pool = _lakes.map((e) => e.id).where((x) => x != targetId).toList();
    pool.shuffle();
    final wrong = pool.take(2).toList();
    final orderedChoices = [...wrong, targetId]..shuffle(); // random order
    final locale = Localizations.localeOf(context).languageCode;

    String labelOf(String id) => _lakeNameForLocale(context, id);

    final selected = await showDialog<String>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(locale == 'kk' ? 'Қай көл?' : 'Какое это озеро?'),
        children: [
          for (final opt in orderedChoices)
            SimpleDialogOption(
              onPressed: () => Navigator.of(ctx).pop(opt),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Text(labelOf(opt)),
              ),
            ),
        ],
      ),
    );

    if (selected == null) return; // dismissed

    final isCorrect = selected == targetId;
    if (isCorrect) {
      setState(() {
        _score += 1;
        _correct.add(tappedId);
        _wrong.clear();
        _spawnPlusAt(tappedId);
        // No fixed order/finish; user свободно выбирает озёра
      });
    } else {
      _wrong.add(tappedId);
      try {
        HapticFeedback.heavyImpact();
      } catch (_) {}
      setState(() {});
    }
  }

  Future<void> _showFinishDialog() async {
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(ctx)!.lakes),
        content: Text(AppLocalizations.of(ctx)!.resultDisplay(_score, _lakes.length)),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _startGame();
            },
            child: Text(AppLocalizations.of(ctx)!.playAgain),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(AppLocalizations.of(ctx)!.btnCancel),
          ),
        ],
      ),
    );
  }

  double _containScale(double srcW, double srcH, double dstW, double dstH) {
    if (srcW <= 0 || srcH <= 0) return 1.0;
    final sx = dstW / srcW;
    final sy = dstH / srcH;
    return sx < sy ? sx : sy;
  }

  void _showRulesDialog() {
    final locale = Localizations.localeOf(context).languageCode;
    final text = (locale == 'kk')
        ? 'Экранда көл атауы шығады.\nКартадан керек көлді тауып, басқаннан кейін 3 нұсқадан дұрыс атауды таңдаңыз.\n\n+1 ұпай — дұрыс жауапқа. Қате таңдаулар қызылмен белгіленеді.'
        : 'На экране показано название озера.\nНайдите его на карте, затем после нажатия выберите правильное название из 3 вариантов.\n\n+1 балл за правильный ответ. Неверные клики подсветятся красным.';
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(ctx)!.rules),
        content: Text(text),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: Text(AppLocalizations.of(ctx)!.btnOk)),
        ],
      ),
    );
  }

  void _showInfoDialog() {
    final locale = Localizations.localeOf(context).languageCode;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(locale == 'kk' ? 'Көлдер туралы мәлімет' : 'Информация о озёрах'),
        content: SizedBox(
          width: 420,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                for (int i = 0; i < _lakes.length; i++)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('${i + 1}. '),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(_lakeNameForLocale(context, _lakes[i].id), style: const TextStyle(fontWeight: FontWeight.w600)),
                              if (_lakes[i].areaKm2 != null)
                                Text(locale == 'kk' ? 'Ауданы: ${_lakes[i].areaKm2} км²' : 'Площадь: ${_lakes[i].areaKm2} км²'),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
              ],
            ),
          ),
        ),
        actions: [TextButton(onPressed: () => Navigator.of(ctx).pop(), child: Text(AppLocalizations.of(ctx)!.btnOk))],
      ),
    );
  }

  String _infoLabel(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'kk' ? 'Ақпарат' : 'Инфо';

  String _findLakePrompt(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'kk' ? 'Картадан көлді табыңыз:' : 'Найдите на карте озеро:';

  String _lakeNameForLocale(BuildContext context, String id) {
    final locale = Localizations.localeOf(context).languageCode;
    final entry = _lakes.firstWhere((e) => e.id == id);
    return locale == 'kk' ? entry.nameKk : entry.nameRu;
  }

  String _scoreLabel(BuildContext context, int score) {
    switch (Localizations.localeOf(context).languageCode) {
      case 'kk':
        return 'Ұпай: $score';
      case 'ru':
        return 'Счёт: $score';
      default:
        return 'Score: $score';
    }
  }

  void _spawnPlusAt(String id) {
    final center = _screenCenters[id];
    if (center == null) return;
    final controller = AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
    controller.addListener(() => setState(() {}));
    controller.addStatusListener((st) {
      if (st == AnimationStatus.completed) {
        controller.dispose();
        _pluses.removeWhere((p) => p.ctrl == controller);
        if (mounted) setState(() {});
      }
    });
    controller.forward();
    _pluses.add(_Plus(origin: center, ctrl: controller));
  }
}

class _Plus {
  _Plus({required this.origin, required this.ctrl});
  final Offset origin;
  final AnimationController ctrl; // 0..1
}

class _PlusPainter extends CustomPainter {
  _PlusPainter({required this.pluses});
  final List<_Plus> pluses;

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in pluses) {
      final t = p.ctrl.value;
      final dy = 40.0 * t;
      final opacity = (1.0 - t).clamp(0.0, 1.0);
      final tp = TextPainter(
        text: TextSpan(
          text: '+1',
          style: TextStyle(
            color: Colors.green.withOpacity(opacity),
            fontSize: 24 + 4 * (1 - t),
            fontWeight: FontWeight.w800,
            shadows: const [Shadow(blurRadius: 2, color: Colors.black26, offset: Offset(0, 1))],
          ),
        ),
        textDirection: TextDirection.ltr,
      );
      tp.layout();
      final offset = p.origin - Offset(tp.width / 2, tp.height / 2 + dy);
      tp.paint(canvas, offset);
    }
  }

  @override
  bool shouldRepaint(covariant _PlusPainter oldDelegate) => oldDelegate.pluses != pluses;
}
