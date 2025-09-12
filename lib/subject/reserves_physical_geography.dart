import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:confetti/confetti.dart';
import '../l10n/app_localizations.dart';

class ReservesPhysicalGeographyPage extends StatefulWidget {
  const ReservesPhysicalGeographyPage({super.key});

  @override
  State<ReservesPhysicalGeographyPage> createState() =>
      _ReservesPhysicalGeographyPageState();
}

class _ReservesPhysicalGeographyPageState
    extends State<ReservesPhysicalGeographyPage>
    with TickerProviderStateMixin {
  static const String _mapAssetPath = 'lib/Images/reserves_country.png';

  // Показать кнопку калибровки (для ручной подгонки точек)
  static const bool _showCalibrate = false;

  // Геобокс карты Казахстана (в проекции твоего PNG)
  static const double _bboxMinLat = 40.56;
  static const double _bboxMaxLat = 55.59;
  static const double _bboxMinLng = 46.50;
  static const double _bboxMaxLng = 87.30;

  // 10 заповедников (lat/lng) + названия на 3 языках
  static const List<
    ({
      String id,
      String nameRu,
      String nameKk,
      String nameEn,
      double lat,
      double lng,
    })
  >
  _reserves = [
    (
      id: 'reserve_aksu',
      nameRu: 'Аксу-Жабаглы',
      nameKk: 'Ақсу-Жабағлы',
      nameEn: 'Aksu-Zhabagly',
      lat: 42.45,
      lng: 70.75,
    ),
    (
      id: 'reserve_almaty',
      nameRu: 'Алматинский',
      nameKk: 'Алматы қорығы',
      nameEn: 'Almaty Nature Reserve',
      lat: 43.15,
      lng: 77.10,
    ),
    (
      id: 'reserve_karatau',
      nameRu: 'Каратау',
      nameKk: 'Қаратау қорығы',
      nameEn: 'Karatau Nature Reserve',
      lat: 43.35,
      lng: 69.10,
    ),
    (
      id: 'reserve_barsakelmes',
      nameRu: 'Барсакельмес',
      nameKk: 'Барсакелмес қорығы',
      nameEn: 'Barsakelmes Nature Reserve',
      lat: 45.00,
      lng: 59.00,
    ),
    (
      id: 'reserve_ustyurt',
      nameRu: 'Устюртский',
      nameKk: 'Үстірт қорығы',
      nameEn: 'Ustyurt Nature Reserve',
      lat: 44.00,
      lng: 55.90,
    ),
    (
      id: 'reserve_naurzum',
      nameRu: 'Наурзумский',
      nameKk: 'Наурызым қорығы',
      nameEn: 'Naurzum Nature Reserve',
      lat: 51.20,
      lng: 64.15,
    ),
    (
      id: 'reserve_korgalzhyn',
      nameRu: 'Коргалжынский',
      nameKk: 'Қорғалжын қорығы',
      nameEn: 'Korgalzhyn Nature Reserve',
      lat: 50.60,
      lng: 69.20,
    ),
    (
      id: 'reserve_markakol',
      nameRu: 'Маркакольский',
      nameKk: 'Марқакөл қорығы',
      nameEn: 'Markakol Nature Reserve',
      lat: 48.66,
      lng: 85.80,
    ),
    (
      id: 'reserve_alakol',
      nameRu: 'Алакольский',
      nameKk: 'Алакөл қорығы',
      nameEn: 'Alakol Nature Reserve',
      lat: 46.15,
      lng: 81.60,
    ),
    (
      id: 'reserve_altai',
      nameRu: 'Западно-Алтайский',
      nameKk: 'Батыс Алтай қорығы',
      nameEn: 'West Altai Nature Reserve',
      lat: 49.20,
      lng: 83.00,
    ),
  ];

  // Статическая подгонка под твою карту (px в системе содержимого)
  final Map<String, Offset> nudges = {
    'reserve_aksu': const Offset(-3.3, -2.4),
    'reserve_almaty': const Offset(-4.5, -0.7),
    'reserve_karatau': const Offset(0.1, -18.5),
    'reserve_barsakelmes': const Offset(6.8, -24.2),
    'reserve_ustyurt': const Offset(-28.1, 36.0),
    'reserve_naurzum': const Offset(-0.2, -9.8),
    'reserve_korgalzhyn': const Offset(-14.8, 10.8),
    'reserve_markakol': const Offset(-13.7, 0.3),
    'reserve_alakol': const Offset(-7.8, 12.2),
    'reserve_altai': const Offset(14.8, -21.4),
  };

  // === Доп. калибровка во время работы (поверх nudges) ===
  bool _calibrate = false;
  final Map<String, Offset> _dynamicNudges = {};
  double _lastInnerLeft = 0,
      _lastInnerTop = 0,
      _lastInnerW = 1,
      _lastInnerH = 1;

  // Внутренние поля (чтобы точки не упирались в рамку)
  static const double _insetLeft = 0.02;
  static const double _insetRight = 0.02;
  static const double _insetTop = 0.03;
  static const double _insetBottom = 0.03;

  Size? _mapImageSize;
  bool _mapSizeResolved = false;
  final double _tapSize = 24;

  int _score = 0;
  int _currentIndex = 0;
  final Set<String> _correct = {};
  final Set<String> _wrong = {};
  final List<_Plus> _pluses = [];
  final Map<String, Offset> _screenCenters = {};
  late ConfettiController _confetti;

  ({
    String id,
    String nameRu,
    String nameKk,
    String nameEn,
    double lat,
    double lng,
  })
  get _currentReserve => _reserves[_currentIndex];

  @override
  void initState() {
    super.initState();
    _confetti = ConfettiController(duration: const Duration(seconds: 3));
    _resolveMapImageSize();
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
      onError: (_, __) {
        _mapSizeResolved = false;
      },
    );
    stream.addListener(listener);
  }

  @override
  void dispose() {
    for (final p in _pluses) {
      p.ctrl.dispose();
    }
    _confetti.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(t.reserves)),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                '${_findReservePrompt(context)} ${_reserveNameForLocale(context, _currentReserve.id)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(child: _buildMap()),
          ],
        ),
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
          border: Border.all(color: cs.outlineVariant),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        child: Row(
          children: [
            Text(
              _scoreLabel(context, _score),
              style: TextStyle(
                color: cs.onSurface,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            if (_showCalibrate) ...[
              FilledButton.tonal(
                onPressed: () => setState(() => _calibrate = !_calibrate),
                child: Text(
                  _calibrate ? 'Калибровка: ВКЛ' : 'Калибровка: выкл',
                ),
              ),
              const SizedBox(width: 8),
            ],
            FilledButton.tonal(
              onPressed: _restart,
              child: Text(_restartLabel(context)),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMap() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxW = constraints.maxWidth;
        final maxH = constraints.maxHeight;
        double contentW = maxW, contentH = maxH, offsetX = 0, offsetY = 0;
        if (_mapSizeResolved && _mapImageSize != null) {
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
          child: GestureDetector(
            behavior: HitTestBehavior.translucent,
            onTapDown: _showCalibrate ? _onMapTapDown : null,
            child: Stack(
              children: [
                Positioned.fill(
                  child: Image.asset(
                    _mapAssetPath,
                    fit: BoxFit.contain,
                    errorBuilder: (context, _, __) =>
                        const Center(child: Text('Карта не найдена')),
                  ),
                ),
                if (_mapSizeResolved && _mapImageSize != null)
                  ..._buildReserveOverlays(
                    offsetX,
                    offsetY,
                    contentW,
                    contentH,
                  ),
                Positioned.fill(
                  child: IgnorePointer(
                    child: CustomPaint(painter: _PlusPainter(pluses: _pluses)),
                  ),
                ),
                // Конфетти — сработает, когда найдены все заповедники
                Positioned.fill(
                  child: IgnorePointer(
                    child: Align(
                      alignment: Alignment.center,
                      child: ConfettiWidget(
                        confettiController: _confetti,
                        blastDirectionality: BlastDirectionality.explosive,
                        shouldLoop: false,
                        numberOfParticles: 25,
                        emissionFrequency: 0,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  List<Widget> _buildReserveOverlays(
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

    _lastInnerLeft = innerLeft;
    _lastInnerTop = innerTop;
    _lastInnerW = innerW;
    _lastInnerH = innerH;

    final centers = _reserves.map((r) {
      final x = ((r.lng - _bboxMinLng) / (_bboxMaxLng - _bboxMinLng)) * innerW;
      final y = ((_bboxMaxLat - r.lat) / (_bboxMaxLat - _bboxMinLat)) * innerH;

      final totalNudge =
          (_dynamicNudges[r.id] ?? Offset.zero) + (nudges[r.id] ?? Offset.zero);
      final pos = Offset(x, y) + totalNudge;

      return (
        id: r.id,
        pos: Offset(
          pos.dx.clamp(_tapSize / 2, innerW - _tapSize / 2),
          pos.dy.clamp(_tapSize / 2, innerH - _tapSize / 2),
        ),
      );
    }).toList();

    _screenCenters
      ..clear()
      ..addEntries(
        centers.map(
          (e) =>
              MapEntry(e.id, Offset(innerLeft + e.pos.dx, innerTop + e.pos.dy)),
        ),
      );

    for (final e in centers) {
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
            onTap: () => _onReserveTap(id),
            child: Container(
              decoration: BoxDecoration(
                color: () {
                  if (isCorrect) return Colors.green;
                  if (isWrong) return Colors.redAccent;
                  return Colors.grey;
                }(),
                shape: BoxShape.circle,
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black26,
                    blurRadius: 3,
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

  // Клик по карте в режиме калибровки — считаем смещение для текущего элемента
  void _onMapTapDown(TapDownDetails d) {
    if (!_calibrate || !_mapSizeResolved || _mapImageSize == null) return;

    final tapX = (d.localPosition.dx - _lastInnerLeft).clamp(0.0, _lastInnerW);
    final tapY = (d.localPosition.dy - _lastInnerTop).clamp(0.0, _lastInnerH);

    final r = _currentReserve;

    final baseX =
        ((r.lng - _bboxMinLng) / (_bboxMaxLng - _bboxMinLng)) * _lastInnerW;
    final baseY =
        ((_bboxMaxLat - r.lat) / (_bboxMaxLat - _bboxMinLat)) * _lastInnerH;

    final delta = Offset(tapX - baseX, tapY - baseY);

    setState(() {
      _dynamicNudges[r.id] = delta;
    });

    final code = Localizations.localeOf(context).languageCode;
    final hint = switch (code) {
      'kk' => 'Подгонка (kk): ',
      'ru' => 'Подгонка: ',
      _ => 'Nudge: ',
    };
    final msg =
        "'${r.id}': const Offset(${delta.dx.toStringAsFixed(1)}, ${delta.dy.toStringAsFixed(1)}),";
    // ignore: avoid_print
    print('Nudge → $msg');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$hint${_reserveNameForLocale(context, r.id)}: $msg'),
      ),
    );
  }

  void _onReserveTap(String id) {
    final correctId = _currentReserve.id;
    if (id == correctId) {
      setState(() {
        _score++;
        _correct.add(id);
        _wrong.clear();
        _spawnPlusAt(id);
        if (_correct.length == _reserves.length) {
          _confetti.play();
        } else {
          _currentIndex++;
        }
      });
    } else {
      setState(() {
        _wrong.add(id);
      });
      Future.delayed(const Duration(milliseconds: 700), () {
        if (!mounted) return;
        setState(() => _wrong.remove(id));
      });
      try {
        HapticFeedback.heavyImpact();
      } catch (_) {}
    }
  }

  void _restart() {
    setState(() {
      _score = 0;
      _correct.clear();
      _wrong.clear();
      _currentIndex = 0;
      _dynamicNudges.clear();
    });
  }

  String _restartLabel(BuildContext context) {
    switch (Localizations.localeOf(context).languageCode) {
      case 'kk':
        return 'Қайтадан';
      case 'ru':
        return 'Заново';
      default:
        return 'Restart';
    }
  }

  String _findReservePrompt(BuildContext context) {
    switch (Localizations.localeOf(context).languageCode) {
      case 'kk':
        return 'Тауып басыңыз:';
      case 'ru':
        return 'Найдите:';
      default:
        return 'Find:';
    }
  }

  String _reserveNameForLocale(BuildContext context, String id) {
    final locale = Localizations.localeOf(context).languageCode;
    final entry = _reserves.firstWhere((e) => e.id == id);
    switch (locale) {
      case 'kk':
        return entry.nameKk;
      case 'ru':
        return entry.nameRu;
      default:
        return entry.nameEn;
    }
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
    final controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
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

  double _containScale(double srcW, double srcH, double dstW, double dstH) {
    final sx = dstW / srcW;
    final sy = dstH / srcH;
    return sx < sy ? sx : sy;
  }
}

class _Plus {
  _Plus({required this.origin, required this.ctrl});
  final Offset origin;
  final AnimationController ctrl;
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
            shadows: const [
              Shadow(
                blurRadius: 2,
                color: Colors.black26,
                offset: Offset(0, 1),
              ),
            ],
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
  bool shouldRepaint(covariant _PlusPainter oldDelegate) =>
      oldDelegate.pluses != pluses;
}
