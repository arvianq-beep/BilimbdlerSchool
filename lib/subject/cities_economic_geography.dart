import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;
import '../l10n/app_localizations.dart';
// Локализацию для этой мини-игры временно отключаем — используем статичные строки.

class CitiesEconomicGeographyPage extends StatefulWidget {
  const CitiesEconomicGeographyPage({super.key});

  @override
  State<CitiesEconomicGeographyPage> createState() => _CitiesEconomicGeographyPageState();
}

class _CitiesEconomicGeographyPageState extends State<CitiesEconomicGeographyPage>
    with TickerProviderStateMixin {
  // Путь к фоновой картинке Казахстана (PNG/JPG). Добавьте файл в lib/Images/.
  // Например, lib/Images/country.png
  static const String _mapAssetPath = 'lib/Images/country.png';

  // Список городов: id, имя, короткое имя, координаты (lat/lng).
  // id совпадает с вашим форматом city_* из mapdata.
  static const List<({String id, String name, String short, double lat, double lng})> _cities = [
    (id: 'city_astana', name: 'Астана', short: 'Астана', lat: 51.1694, lng: 71.4491),
    (id: 'city_almaty', name: 'Алматы', short: 'Алматы', lat: 43.2389, lng: 76.8897),
    (id: 'city_shymkent', name: 'Шымкент', short: 'Шымкент', lat: 42.3417, lng: 69.5901),
    (id: 'city_karaganda', name: 'Караганда', short: 'Караг.', lat: 49.8028, lng: 73.0877),
    (id: 'city_aktobe', name: 'Актобе', short: 'Актобе', lat: 50.2839, lng: 57.1660),
    (id: 'city_taraz', name: 'Тараз', short: 'Тараз', lat: 42.9, lng: 71.3667),
    (id: 'city_pavlodar', name: 'Павлодар', short: 'Павл.', lat: 52.3, lng: 76.95),
    (id: 'city_ust_kamenogorsk', name: 'Усть-Каменогорск', short: 'Усть-К.', lat: 49.97, lng: 82.61),
    (id: 'city_semey', name: 'Семей', short: 'Семей', lat: 50.4, lng: 80.25),
    (id: 'city_kostanay', name: 'Костанай', short: 'Костан.', lat: 53.2144, lng: 63.6246),
    (id: 'city_atyrau', name: 'Атырау', short: 'Атырау', lat: 47.116, lng: 51.883),
    (id: 'city_kyzylorda', name: 'Кызылорда', short: 'Кызыл.', lat: 44.852, lng: 65.509),
    (id: 'city_uralsk', name: 'Уральск', short: 'Уральск', lat: 51.2333, lng: 51.3667),
    (id: 'city_petropavlovsk', name: 'Петропавловск', short: 'Петр.', lat: 54.8833, lng: 69.1667),
    (id: 'city_ekibastuz', name: 'Экибастуз', short: 'Экибас.', lat: 51.6667, lng: 75.3667),
    (id: 'city_zhezkazgan', name: 'Жезказган', short: 'Жезк.', lat: 47.7833, lng: 67.7667),
    (id: 'city_temirtau', name: 'Темиртау', short: 'Темиртау', lat: 50.05, lng: 72.95),
    (id: 'city_kokshetau', name: 'Кокшетау', short: 'Кокшет.', lat: 53.2833, lng: 69.3833),
    (id: 'city_turkestan', name: 'Туркестан', short: 'Турк.', lat: 43.3, lng: 68.27),
    (id: 'city_taldykorgan', name: 'Талдыкорган', short: 'Талдык.', lat: 45.0, lng: 78.4),
  ];

  // Параметры карты/игры
  Size? _mapImageSize; // фактический размер изображения (px)
  bool _mapSizeResolved = false;
  final double _tapSize = 24; // размер кликабельной зоны в пикселях экрана

  // Калибровка: реальные границы Казахстана (можно подстроить под вашу картинку)
  // Источник (примерно): lat 40.56..55.59, lng 46.5..87.3
  static const double _bboxMinLat = 40.56;
  static const double _bboxMaxLat = 55.59;
  static const double _bboxMinLng = 46.50;
  static const double _bboxMaxLng = 87.30;

  // Если у изображения есть «пустые поля» вокруг карты — задайте внутренние проценты отступов
  // Например, слева/справа по 3%, сверху/снизу по 5%
  static const double _insetLeft = 0.03;
  static const double _insetRight = 0.03;
  static const double _insetTop = 0.05;
  static const double _insetBottom = 0.05;

  // Игровое состояние
  late List<int> _order; // индексы городов в случайном порядке
  int _currentIndex = 0;
  int _score = 0;
  final Set<String> _correct = {};
  final Set<String> _wrong = {};
  static bool _rulesShownOnce = false;

  // Для +1 анимаций
  final List<_Plus> _pluses = [];

  // Центры городов на экране на последней отрисовке (для анимации +1)
  final Map<String, Offset> _screenCenters = {};

  // Тонкая подстройка позиции отдельных городов в пикселях внутри карты
  // (если какая-то точка стабильно съезжает на вашем изображении)
  static const Map<String, Offset> _cityNudges = {
    // 'city_almaty': Offset(4, -2),
  };

  ({String id, String name, String short, double lat, double lng}) get _currentCity => _cities[_order[_currentIndex]];

  @override
  void initState() {
    super.initState();
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
      // Если не удалось прочитать размер (например, файла нет), всё равно отрисуем без точек
      _mapSizeResolved = false;
      try {
        stream.removeListener(listener!);
      } catch (_) {}
      if (mounted) setState(() {});
    });
    stream.addListener(listener);
  }

  void _startGame() {
    _order = List<int>.generate(_cities.length, (i) => i)..shuffle();
    _currentIndex = 0;
    _score = 0;
    _correct.clear();
    _wrong.clear();
    setState(() {});
  }

  @override
  void dispose() {
    for (final p in _pluses) {
      p.ctrl.dispose();
    }
    _pluses.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(t.citiesEgTitle),
        actions: [
          IconButton(
            tooltip: t.rules,
            icon: const Icon(Icons.help_outline),
            onPressed: _showRulesDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          _buildHeader(),
          const SizedBox(height: 8),
          Expanded(child: _buildMap()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final t = AppLocalizations.of(context)!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Flexible(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.findCityPrompt, style: const TextStyle(fontSize: 14)),
                Text(
                  _localizedCityName(context, _currentCity.id),
                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Text(t.scoreDisplay(_score), style: const TextStyle(fontSize: 18)),
        ],
      ),
    );
  }

  Widget _buildMap() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final maxW = constraints.maxWidth;
        final maxH = constraints.maxHeight;

        // Если знаем исходный размер карты — делаем точное BoxFit.contain.
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
          child: Stack(
          children: [
            // Фоновая картинка Казахстана
            Positioned.fill(
              child: Image.asset(
                _mapAssetPath,
                fit: BoxFit.contain,
                alignment: Alignment.center,
                errorBuilder: (context, _, __) => const Center(
                  child: Text('Не найдено изображение карты: lib/Images/country.png'),
                ),
              ),
            ),

            // Кликабельные точки городов
            if (_mapSizeResolved && _mapImageSize != null)
              ..._buildCityOverlays(offsetX, offsetY, contentW, contentH),

            // Рисуем анимации +1 поверх всего
            if (_pluses.isNotEmpty)
              Positioned.fill(
                child: IgnorePointer(
                  child: CustomPaint(
                    painter: _PlusPainter(pluses: _pluses),
                  ),
                ),
              ),
          ],
        ));
      },
    );
  }

  List<Widget> _buildCityOverlays(double offsetX, double offsetY, double contentW, double contentH) {
    final List<Widget> children = [];
    // Внутренний прямоугольник с учётом инсет‑процентов
    final innerLeft = offsetX + contentW * _insetLeft;
    final innerTop = offsetY + contentH * _insetTop;
    final innerW = contentW * (1 - _insetLeft - _insetRight);
    final innerH = contentH * (1 - _insetTop - _insetBottom);

    // Сперва спроецируем все центры
    final List<({String id, Offset pos})> centers = _cities
        .map((c) {
          final base = _projectLatLng(c.lat, c.lng, innerW, innerH);
          final nudge = _cityNudges[c.id] ?? Offset.zero;
          return (id: c.id, pos: base + nudge);
        })
        .toList();

    // Раздвинем точки, чтобы не перекрывались
    final placed = <({String id, Offset pos})>[];
    final minDist = _tapSize * 1.05;
    for (final item in centers) {
      Offset p = item.pos;
      bool ok() => placed.every((e) => (e.pos - p).distance >= minDist);
      if (!ok()) {
        // Поиск свободного места по спирали
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

    // Сохраним экраны центров для анимации +1
    _screenCenters
      ..clear()
      ..addEntries(placed.map((e) => MapEntry(e.id, Offset(innerLeft + e.pos.dx, innerTop + e.pos.dy))));

    for (final e in placed) {
      final id = e.id;
      final center = Offset(innerLeft + e.pos.dx, innerTop + e.pos.dy);

      final isTarget = id == _currentCity.id;
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
            onTap: () => _onCityTap(id),
            child: Container(
              decoration: BoxDecoration(
                color: () {
                  if (isCorrect) return Colors.green;
                  if (isWrong) return Colors.redAccent;
                  // цель не подсвечиваем отдельно
                  return Colors.grey; // neutral by default
                }(),
                borderRadius: BorderRadius.circular(6),
                boxShadow: const [
                  BoxShadow(color: Colors.black26, blurRadius: 3, offset: Offset(0, 1)),
                ],
              ),
            ),
          ),
        ),
      );
    }
    return children;
  }

  // Простейшая equirectangular-проекция под конкретную картинку.
  Offset _projectLatLng(double lat, double lng, double w, double h) {
    final x = ((lng - _bboxMinLng) / (_bboxMaxLng - _bboxMinLng)).clamp(0.0, 1.0) * w;
    // Инвертируем Y: сверху — maxLat
    final y = ((_bboxMaxLat - lat) / (_bboxMaxLat - _bboxMinLat)).clamp(0.0, 1.0) * h;
    return Offset(x, y);
  }

  void _onCityTap(String id) {
    final target = _currentCity.id;
    final isCorrect = id == target;
    if (isCorrect) {
      setState(() {
        _score += 1;
        _correct.add(id);
        _wrong.clear(); // все неверные вернуть в розовый после правильного ответа
        _spawnPlusAt(id);
        if (_currentIndex < _order.length - 1) {
          _currentIndex += 1;
        } else {
          _showFinishDialog();
        }
      });
    } else {
      _wrong.add(id);
      try {
        HapticFeedback.heavyImpact();
      } catch (_) {}
      setState(() {}); // без текста ошибок
    }
  }

  Future<void> _showFinishDialog() async {
    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(ctx)!.citiesEgFinishTitle),
        content: Text(AppLocalizations.of(ctx)!.resultDisplay(_score, _cities.length)),
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
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(AppLocalizations.of(ctx)!.rules),
        content: Text(AppLocalizations.of(ctx)!.citiesEgRulesText),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(AppLocalizations.of(ctx)!.btnOk),
          )
        ],
      ),
    );
  }

  void _spawnPlusAt(String cityId) {
    final center = _screenCenters[cityId];
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
}

class _Plus {
  _Plus({required this.origin, required this.ctrl});
  final Offset origin; // экранные координаты центра города
  final AnimationController ctrl; // value: 0..1
}

class _PlusPainter extends CustomPainter {
  _PlusPainter({required this.pluses});
  final List<_Plus> pluses;

  @override
  void paint(Canvas canvas, Size size) {
    for (final p in pluses) {
      final t = p.ctrl.value;
      final dy = 40.0 * t; // поднимается вверх
      final opacity = (1.0 - t).clamp(0.0, 1.0);
      final text = '+1';
      final tp = TextPainter(
        text: TextSpan(
          text: text,
          style: TextStyle(
            color: Colors.green.withOpacity(opacity),
            fontSize: 24 + 4 * (1 - t),
            fontWeight: FontWeight.w800,
            shadows: const [
              Shadow(blurRadius: 2, color: Colors.black26, offset: Offset(0, 1)),
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
  bool shouldRepaint(covariant _PlusPainter oldDelegate) => oldDelegate.pluses != pluses;
}

String _localizedCityName(BuildContext context, String id) {
  final t = AppLocalizations.of(context)!;
  switch (id) {
    case 'city_astana':
      return t.cityAstana;
    case 'city_almaty':
      return t.cityAlmaty;
    case 'city_shymkent':
      return t.cityShymkent;
    case 'city_karaganda':
      return t.cityKaraganda;
    case 'city_aktobe':
      return t.cityAktobe;
    case 'city_taraz':
      return t.cityTaraz;
    case 'city_pavlodar':
      return t.cityPavlodar;
    case 'city_ust_kamenogorsk':
      return t.cityOskemen;
    case 'city_semey':
      return t.citySemey;
    case 'city_kostanay':
      return t.cityKostanay;
    case 'city_atyrau':
      return t.cityAtyrau;
    case 'city_kyzylorda':
      return t.cityKyzylorda;
    case 'city_uralsk':
      return t.cityOral;
    case 'city_petropavlovsk':
      return t.cityPetropavl;
    case 'city_ekibastuz':
      return t.cityEkibastuz;
    case 'city_zhezkazgan':
      return t.cityZhezkazgan;
    case 'city_temirtau':
      return t.cityTemirtau;
    case 'city_kokshetau':
      return t.cityKokshetau;
    case 'city_turkestan':
      return t.cityTurkistan;
    case 'city_taldykorgan':
      return t.cityTaldykorgan;
    default:
      return id;
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
