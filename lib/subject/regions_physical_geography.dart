import 'dart:math' as math;
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import 'package:confetti/confetti.dart';
import '../l10n/app_localizations.dart';

/// Физико-географическое районирование Казахстана (9 аймақ/районов)
/// Механика как на «заповедниках»: ищем нужный регион и тапаем по его точке.
class RegionsPhysicalGeographyPage extends StatefulWidget {
  const RegionsPhysicalGeographyPage({super.key});

  @override
  State<RegionsPhysicalGeographyPage> createState() =>
      _RegionsPhysicalGeographyPageState();
}

class _RegionsPhysicalGeographyPageState
    extends State<RegionsPhysicalGeographyPage>
    with TickerProviderStateMixin {
  // Путь к НОВОЙ карте
  static const String _mapAssetPath = 'lib/Images/regions_country.png';

  // Показать ли кнопку «Калибровка» (для подгонки точек поверх фона)
  static const bool _showCalibrate = false;

  // Геобокс Казахстана (как и раньше, под проекцию твоей карты)
  static const double _bboxMinLat = 40.56;
  static const double _bboxMaxLat = 55.59;
  static const double _bboxMinLng = 46.50;
  static const double _bboxMaxLng = 87.30;

  // 9 физ.-геогр. районов (примерные центры lat/lng)
  static const List<
    ({String id, String nameRu, String nameKk, double lat, double lng})
  >
  _regions = [
    (
      id: 'reg_east_europe_plain',
      nameRu: 'Шығыс Еуропа жазығы',
      nameKk: 'Шығыс Еуропа жазығы',
      lat: 50.6, // северо-запад
      lng: 52.5,
    ),
    (
      id: 'reg_north_kazakh_plain',
      nameRu: 'Солтүстік Қазақ жазығы',
      nameKk: 'Солтүстік Қазақ жазығы',
      lat: 53.3, // север
      lng: 69.0,
    ),
    (
      id: 'reg_turan_lowland',
      nameRu: 'Тұран жазығы',
      nameKk: 'Тұран жазығы',
      lat: 44.8, // юго-запад/юг
      lng: 60.0,
    ),
    (
      id: 'reg_ural_mugalzhar',
      nameRu: 'Орал (Мұғалжар)',
      nameKk: 'Орал (Мұғалжар)',
      lat: 48.6, // запад-центр
      lng: 58.0,
    ),
    (
      id: 'reg_saryarka',
      nameRu: 'Сарыарқа',
      nameKk: 'Сарыарқа',
      lat: 49.3, // центр
      lng: 68.5,
    ),
    (
      id: 'reg_altai',
      nameRu: 'Алтай',
      nameKk: 'Алтай',
      lat: 49.2, // северо-восток
      lng: 85.0,
    ),
    (
      id: 'reg_saur_tarbagatai',
      nameRu: 'Сауыр-Тарбағатай',
      nameKk: 'Сауыр-Тарбағатай',
      lat: 47.9, // восток, ниже Алтая
      lng: 84.3,
    ),
    (
      id: 'reg_zhetysu_alatau',
      nameRu: 'Жетісу Алатауы',
      nameKk: 'Жетісу Алатауы',
      lat: 45.3, // юго-восток (сев. от Алатау/Іле)
      lng: 80.7,
    ),
    (
      id: 'reg_tien_shan',
      nameRu: 'Тянь-Шань',
      nameKk: 'Тянь-Шань',
      lat: 42.9, // крайний юго-восток
      lng: 76.6,
    ),
  ];

  /// Статические подгонки (px в системе содержимого). Оставил нули — при
  /// необходимости включи _showCalibrate=true, потыкай — значения выведутся в лог.
  final Map<String, Offset> nudges = const {
    'reg_east_europe_plain': Offset(18.0, 9.0), // Шығыс Еуропа жазығы
    'reg_north_kazakh_plain': Offset(-12.0, 14.0), // Солт. Қазақ жазығы
    'reg_turan_lowland': Offset(6.0, -19.0), // Тұран жазығы
    'reg_ural_mugalzhar': Offset(8.0, -8.0), // Орал (Мұғалжар)
    'reg_saryarka': Offset(7.0, -8.0), // Сарыарқа
    'reg_altai': Offset(-10.0, 4.0), // Алтай
    'reg_saur_tarbagatai': Offset(12.0, -8.0), // Сауыр-Тарбағатай
    'reg_zhetysu_alatau': Offset(6.0, -12.0), // Жетісу Алатауы
    'reg_tien_shan': Offset(14.0, -20.0), // Тянь-Шань
  };

  // === Дополнительная калибровка во время работы ===
  bool _calibrate = false;
  final Map<String, Offset> _dynamicNudges = {};
  double _lastInnerLeft = 0,
      _lastInnerTop = 0,
      _lastInnerW = 1,
      _lastInnerH = 1;

  // Внутренние поля, чтобы точки не упирались в рамку
  static const double _insetLeft = 0.02;
  static const double _insetRight = 0.02;
  static const double _insetTop = 0.03;
  static const double _insetBottom = 0.03;

  Size? _mapImageSize;
  bool _mapSizeResolved = false;

  // Чуть меньше кружки, чем раньше
  final double _tapSize = 22;

  int _score = 0;
  int _currentIndex = 0;
  final Set<String> _correct = {};
  final Set<String> _wrong = {};
  final List<_Plus> _pluses = [];
  final Map<String, Offset> _screenCenters = {};
  late ConfettiController _confetti;

  ({String id, String nameRu, String nameKk, double lat, double lng})
  get _currentRegion => _regions[_currentIndex];

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
    return Scaffold(
      appBar: AppBar(title: Text(_title(context))),
      body: SafeArea(
        child: Column(
          children: [
            _buildHeader(context),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Text(
                '${_findPrompt(context)} ${_regionNameForLocale(context, _currentRegion.id)}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: _buildMap(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _title(BuildContext context) {
    final code = Localizations.localeOf(context).languageCode;
    if (code == 'kk') return 'Физ.-геогр. аймақтар';
    if (code == 'ru') return 'Физ.-геогр. районы';
    return 'Physical-geographic regions';
    // (если у тебя есть ключ в l10n — замени на t.***)
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
                  ..._buildRegionOverlays(offsetX, offsetY, contentW, contentH),
                Positioned.fill(
                  child: IgnorePointer(
                    child: CustomPaint(painter: _PlusPainter(pluses: _pluses)),
                  ),
                ),
                // Конфетти (сработает, когда пройдены все регионы)
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

  List<Widget> _buildRegionOverlays(
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

    final centers = _regions.map((r) {
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
            onTap: () => _onRegionTap(id),
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

  // Клик по карте в режиме калибровки — подгонка текущего региона
  void _onMapTapDown(TapDownDetails d) {
    if (!_calibrate || !_mapSizeResolved || _mapImageSize == null) return;

    final tapX = (d.localPosition.dx - _lastInnerLeft).clamp(0.0, _lastInnerW);
    final tapY = (d.localPosition.dy - _lastInnerTop).clamp(0.0, _lastInnerH);

    final r = _currentRegion;

    final baseX =
        ((r.lng - _bboxMinLng) / (_bboxMaxLng - _bboxMinLng)) * _lastInnerW;
    final baseY =
        ((_bboxMaxLat - r.lat) / (_bboxMaxLat - _bboxMinLat)) * _lastInnerH;

    final delta = Offset(tapX - baseX, tapY - baseY);

    setState(() {
      _dynamicNudges[r.id] = delta;
    });

    final msg =
        "'${r.id}': const Offset(${delta.dx.toStringAsFixed(1)}, ${delta.dy.toStringAsFixed(1)}),";
    // ignore: avoid_print
    print('Nudge → $msg');
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Подгонка для ${_regionNameForLocale(context, r.id)}: $msg',
        ),
      ),
    );
  }

  void _onRegionTap(String id) {
    final correctId = _currentRegion.id;
    if (id == correctId) {
      setState(() {
        _score++;
        _correct.add(id);
        _wrong.clear();
        _spawnPlusAt(id);
        if (_correct.length == _regions.length) {
          _confetti.play();
        } else {
          _currentIndex++;
        }
      });
    } else {
      setState(() => _wrong.add(id));
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

  String _restartLabel(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'kk'
      ? 'Қайтадан'
      : 'Заново';

  String _findPrompt(BuildContext context) =>
      Localizations.localeOf(context).languageCode == 'kk'
      ? 'Тауып басыңыз:'
      : 'Найдите:';

  String _regionNameForLocale(BuildContext context, String id) {
    final locale = Localizations.localeOf(context).languageCode;
    final entry = _regions.firstWhere((e) => e.id == id);
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
