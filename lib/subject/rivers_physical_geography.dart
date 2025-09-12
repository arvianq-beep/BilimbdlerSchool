import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:confetti/confetti.dart';
import '../l10n/app_localizations.dart';

/// Временная заготовка игры про реки в том же оформлении,
/// что и экран регионов: верхняя карточка со счётом и кнопкой
/// "Заново", область карты и конфетти-оверлей. Функционал
/// угадывания рек добавим далее.
class RiversPhysicalGeographyPage extends StatefulWidget {
  const RiversPhysicalGeographyPage({super.key});

  @override
  State<RiversPhysicalGeographyPage> createState() =>
      _RiversPhysicalGeographyPageState();
}

class _RiversPhysicalGeographyPageState
    extends State<RiversPhysicalGeographyPage> {
  int _score = 0;
  int _attempts = 0; // not shown; kept for future
  bool _endShown = false; // not used now
  late final ConfettiController _confettiCtrl = ConfettiController(
    duration: const Duration(seconds: 3),
  );

  // Map configuration (same as lakes screen)
  static const String _mapAssetPath = 'lib/Images/lakes_counrty.png';
  static const double _bboxMinLat = 40.56;
  static const double _bboxMaxLat = 55.59;
  static const double _bboxMinLng = 46.50;
  static const double _bboxMaxLng = 87.30;
  static const double _insetLeft = 0.02;
  static const double _insetRight = 0.02;
  static const double _insetTop = 0.03;
  static const double _insetBottom = 0.03;
  final double _tapSize = 20; // smaller marker radius per request

  Size? _mapImageSize;
  bool _mapSizeResolved = false;
  final Set<String> _correct = {};
  final Set<String> _wrong = {};
  final Map<String, List<String>> _choicesByRiverId = {};
  int _totalAttempts = 0;
  bool _finishedShown = false;
  // Fine-tune on-screen positions for specific rivers (dx, dy in px)
  static const Map<String, Offset> _riverNudges = {
    'river_shu': Offset(-10, 0), // Чу левее
    'river_lepsy': Offset(0, -10), // Лепсы выше
    'river_eshim': Offset(0, 10), // Ишим ниже
  };

  // Rivers list with approximate coordinates (lat/lng) within KZ bbox
  static const List<
    ({String id, String nameRu, String nameKk, double lat, double lng})
  >
  _rivers = [
    (id: 'river_nura', nameRu: 'Нура', nameKk: 'Нұра', lat: 50.7, lng: 71.2),
    (id: 'river_shar', nameRu: 'Шар', nameKk: 'Шар', lat: 49.6, lng: 83.6),
    (
      id: 'river_ayagoz',
      nameRu: 'Аягоз',
      nameKk: 'Аягөз',
      lat: 47.9,
      lng: 80.4,
    ),
    (id: 'river_lepsy', nameRu: 'Лепсы', nameKk: 'Лепсі', lat: 46.4, lng: 79.9),
    (id: 'river_shu', nameRu: 'Чу', nameKk: 'Шу', lat: 44.6, lng: 73.6),
    (id: 'river_ili', nameRu: 'Или', nameKk: 'Іле', lat: 45.0, lng: 75.3),
    (id: 'river_tobyl', nameRu: 'Тобол', nameKk: 'Тобыл', lat: 53.2, lng: 63.6),
    (
      id: 'river_torgai',
      nameRu: 'Торгай',
      nameKk: 'Торғай',
      lat: 49.6,
      lng: 63.3,
    ),
    (id: 'river_oiyl', nameRu: 'Ойыл', nameKk: 'Ойыл', lat: 48.7, lng: 57.2),
    (
      id: 'river_syrdarya',
      nameRu: 'Сырдарья',
      nameKk: 'Сырдария',
      lat: 44.8,
      lng: 66.3,
    ),
    (
      id: 'river_karatal',
      nameRu: 'Каратал',
      nameKk: 'Қаратал',
      lat: 45.1,
      lng: 79.8,
    ),
    (id: 'river_talas', nameRu: 'Талас', nameKk: 'Талас', lat: 42.9, lng: 71.4),
    (
      id: 'river_shiderty',
      nameRu: 'Шидерты',
      nameKk: 'Шідерті',
      lat: 52.3,
      lng: 75.4,
    ),
    (id: 'river_arys', nameRu: 'Арыс', nameKk: 'Арыс', lat: 42.4, lng: 69.5),
    (
      id: 'river_irtysh',
      nameRu: 'Иртыш',
      nameKk: 'Ертіс',
      lat: 51.7,
      lng: 76.9,
    ),
    (id: 'river_yrgyz', nameRu: 'Ыргыз', nameKk: 'Ырғыз', lat: 48.6, lng: 61.6),
    (
      id: 'river_zhem',
      nameRu: 'Жем (Эмба)',
      nameKk: 'Жем',
      lat: 48.9,
      lng: 58.5,
    ),
    (id: 'river_eshim', nameRu: 'Ишим', nameKk: 'Есіл', lat: 51.1, lng: 71.4),
    (id: 'river_ural', nameRu: 'Урал', nameKk: 'Жайық', lat: 51.2, lng: 51.4),
  ];
  @override
  void dispose() {
    _confettiCtrl.dispose();
    super.dispose();
  }

  void _restart() {
    setState(() {
      _score = 0;
      _attempts = 0;
      _endShown = false;
    });
  }

  @override
  void initState() {
    super.initState();
    _resolveMapImageSize();
    _startGame();
  }

  void _resolveMapImageSize() {
    final img = AssetImage(_mapAssetPath);
    final cfg = const ImageConfiguration();
    final stream = img.resolve(cfg);
    ImageStreamListener? listener;
    listener = ImageStreamListener(
      (info, _) {
        _mapImageSize = Size(
          info.image.width.toDouble(),
          info.image.height.toDouble(),
        );
        _mapSizeResolved = true;
        stream.removeListener(listener!);
        if (mounted) setState(() {});
      },
      onError: (error, stackTrace) {
        _mapSizeResolved = false;
        try {
          stream.removeListener(listener!);
        } catch (_) {}
        if (mounted) setState(() {});
      },
    );
    stream.addListener(listener);
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.rivers),
        actions: [
          IconButton(
            tooltip: t.rules,
            icon: const Icon(Icons.help_outline),
            onPressed: () => _showRulesDialog(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                // Верхняя карточка как в экране регионов
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                  child: Container(
                    decoration: BoxDecoration(
                      color: cs.surface,
                      borderRadius: BorderRadius.zero,
                      boxShadow: [
                        BoxShadow(
                          color: cs.shadow.withOpacity(0.08),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      border: Border.all(color: cs.outlineVariant),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: cs.primaryContainer,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            _scoreLabel(context, _score),
                            style: TextStyle(
                              color: cs.onPrimaryContainer,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const Spacer(),
                        FilledButton.tonal(
                          onPressed: _restart,
                          child: Text(_restartLabel(context)),
                        ),
                      ],
                    ),
                  ),
                ),

                // Область карты с точками рек
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: _buildMap(),
                  ),
                ),
              ],
            ),

            // Конфетти (на будущее, как в регионах)
            Positioned.fill(
              child: IgnorePointer(
                child: Align(
                  alignment: Alignment.topCenter,
                  child: ConfettiWidget(
                    confettiController: _confettiCtrl,
                    blastDirectionality: BlastDirectionality.explosive,
                    emissionFrequency: 0.02,
                    numberOfParticles: 12,
                    maxBlastForce: 20,
                    minBlastForce: 6,
                    gravity: 0.3,
                    colors: [
                      cs.primary,
                      cs.secondary,
                      cs.tertiary,
                      Colors.white,
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // == Map building with points ==
  Widget _buildMap() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxW = constraints.maxWidth;
        final maxH = constraints.maxHeight;
        double contentW = maxW, contentH = maxH, offsetX = 0, offsetY = 0;
        if (_mapSizeResolved &&
            _mapImageSize != null &&
            _mapImageSize!.width > 0 &&
            _mapImageSize!.height > 0) {
          final scale = _containScale(
            _mapImageSize!.width,
            _mapImageSize!.height,
            maxW,
            maxH,
          );
          contentW = _mapImageSize!.width * scale;
          contentH = _mapImageSize!.height * scale;
          offsetX = (maxW - contentW) / 2;
          offsetY = (maxH - contentH) / 2;
        }
        return InteractiveViewer(
          minScale: 1,
          maxScale: 4,
          boundaryMargin: const EdgeInsets.all(48),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.asset(
                  _mapAssetPath,
                  fit: BoxFit.contain,
                  alignment: Alignment.center,
                  errorBuilder: (context, _, __) => const Center(
                    child: Text(
                      'Карта не найдена: lib/Images/lakes_counrty.png',
                    ),
                  ),
                ),
              ),
              if (_mapSizeResolved && _mapImageSize != null)
                ..._buildRiverOverlays(offsetX, offsetY, contentW, contentH),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildRiverOverlays(
    double offsetX,
    double offsetY,
    double contentW,
    double contentH,
  ) {
    final List<Widget> children = [];
    final innerLeft = offsetX + contentW * _insetLeft;
    final innerTop = offsetY + contentH * _insetTop;
    final innerW = contentW * (1 - _insetLeft - _insetRight);
    final innerH = contentH * (1 - _insetTop - _insetBottom);

    final centers = _rivers.map((r) {
      final x =
          ((r.lng - _bboxMinLng) / (_bboxMaxLng - _bboxMinLng)).clamp(
            0.0,
            1.0,
          ) *
          innerW;
      final y =
          ((_bboxMaxLat - r.lat) / (_bboxMaxLat - _bboxMinLat)).clamp(
            0.0,
            1.0,
          ) *
          innerH;
      final base = Offset(x, y);
      final nudge = _riverNudges[r.id] ?? Offset.zero;
      return (id: r.id, pos: base + nudge);
    }).toList();

    // Spread points slightly to avoid overlaps
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
          final cand =
              item.pos + Offset(r * math.cos(angle), r * math.sin(angle));
          final clamped = Offset(
            cand.dx.clamp(_tapSize / 2, innerW - _tapSize / 2),
            cand.dy.clamp(_tapSize / 2, innerH - _tapSize / 2),
          );
          p = clamped;
        }
      }
      placed.add((id: item.id, pos: p));
    }

    for (final e in placed) {
      final id = e.id;
      final center = Offset(innerLeft + e.pos.dx, innerTop + e.pos.dy);
      final isCorrect = _correct.contains(id);
      final isWrong = _wrong.contains(id);
      children.add(
        Positioned(
          left: center.dx - _tapSize / 2,
          top: center.dy - _tapSize / 2,
          width: _tapSize,
          height: _tapSize,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: isCorrect ? null : () => _onRiverTap(id),
            child: Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: () {
                  if (isCorrect) return Colors.green;
                  if (isWrong) return Colors.redAccent;
                  return Colors.grey;
                }(),
                border: Border.all(color: Colors.black, width: 1.2),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return children;
  }

  double _containScale(double srcW, double srcH, double dstW, double dstH) {
    if (srcW <= 0 || srcH <= 0) return 1.0;
    final sx = dstW / srcW;
    final sy = dstH / srcH;
    return sx < sy ? sx : sy;
  }

  void _startGame() {
    _score = 0;
    _correct.clear();
    _wrong.clear();
    _choicesByRiverId.clear();
    _totalAttempts = 0;
    _finishedShown = false;
    final ids = _rivers.map((r) => r.id).toList();
    for (final id in ids) {
      final pool = ids.where((x) => x != id).toList()..shuffle();
      final wrong = pool.take(2).toList();
      final opts = [...wrong, id]..shuffle();
      _choicesByRiverId[id] = opts;
    }
    setState(() {});
  }

  String _riverNameForLocale(BuildContext context, String id) {
    final loc = Localizations.localeOf(context).languageCode;
    final r = _rivers.firstWhere((e) => e.id == id);
    return loc == 'kk' ? r.nameKk : r.nameRu;
  }

  Future<void> _onRiverTap(String id) async {
    final choices = List<String>.from(_choicesByRiverId[id] ?? <String>[]);
    if (choices.isEmpty) return;
    final selected = await showDialog<String>(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: Text(
          Localizations.localeOf(ctx).languageCode == 'kk'
              ? 'Қай өзен?'
              : 'Какая это река?',
        ),
        children: [
          for (final opt in choices)
            SimpleDialogOption(
              onPressed: () => Navigator.of(ctx).pop(opt),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 6),
                child: Text(_riverNameForLocale(ctx, opt)),
              ),
            ),
        ],
      ),
    );
    if (selected == null) return;
    _totalAttempts += 1;
    final isCorrect = selected == id;
    if (isCorrect) {
      setState(() {
        _score += 1;
        _correct.add(id);
        _wrong.clear();
        if (_correct.length == _rivers.length && !_finishedShown) {
          _finishedShown = true;
          _confettiCtrl.play();
          _showFinishDialogStats();
        }
      });
    } else {
      _wrong.add(id);
      try {
        HapticFeedback.heavyImpact();
      } catch (_) {}
      setState(() {});
    }
  }

  Future<void> _showFinishDialogStats() async {
    final lang = Localizations.localeOf(context).languageCode;
    final total = _rivers.length;
    final avg = total == 0 ? 0 : (_totalAttempts / total);
    final lines = lang == 'kk'
        ? 'Ұпай: $_score / $total\nБарлығы әрекет: $_totalAttempts\nОрташа әрекет: ${avg.toStringAsFixed(2)}'
        : 'Очки: $_score / $total\nВсего попыток: $_totalAttempts\nСреднее на реку: ${avg.toStringAsFixed(2)}';
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(lang == 'kk' ? 'Дайын!' : 'Готово!'),
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

  void _showRulesDialog(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.rules),
        content: Text(
          'Экран рек собирает те же механики, что и озёра: кликаете по точке на карте и выбираете название из 3 вариантов.\n\n'
          'Этот экран — заготовка: добавим точки и логику угадывания в следующем шаге.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(t.btnOk),
          ),
        ],
      ),
    );
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

  String _restartLabel(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'kk'
      ? 'Қайтадан'
      : 'Заново';
}
