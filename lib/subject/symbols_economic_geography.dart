import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;

/// Экономическая география — условные знаки (ресурсы).
/// Мини‑игра по типу озёр/рек: кликаем по точке, выбираем из 3 вариантов.
class SymbolsEconomicGeographyPage extends StatefulWidget {
  const SymbolsEconomicGeographyPage({super.key});

  @override
  State<SymbolsEconomicGeographyPage> createState() => _SymbolsEconomicGeographyPageState();
}

class _SymbolsEconomicGeographyPageState extends State<SymbolsEconomicGeographyPage>
    with TickerProviderStateMixin {
  // Карта (та же, что и в озёрах/реках)
  static const String _mapAssetPath = 'lib/Images/lakes_counrty.png';
  // Геобокс Казахстана для проекции lat/lng → XY
  static const double _bboxMinLat = 40.56;
  static const double _bboxMaxLat = 55.59;
  static const double _bboxMinLng = 46.50;
  static const double _bboxMaxLng = 87.30;
  // Внутренние отступы от краёв
  static const double _insetLeft = 0.02;
  static const double _insetRight = 0.02;
  static const double _insetTop = 0.03;
  static const double _insetBottom = 0.03;

  // Размер точки
  final double _tapSize = 28;

  Size? _mapImageSize;
  bool _mapSizeResolved = false;

  // Типы ресурсов
  static const List<({String id, String ru, String kk})> _types = [
    (id: 'coal', ru: 'Уголь', kk: 'Көмір'),
    (id: 'brown_coal', ru: 'Бурый уголь', kk: 'Қоңыр көмір'),
    (id: 'oil', ru: 'Нефть', kk: 'Мұнай'),
    (id: 'gas', ru: 'Газ', kk: 'Газ'),
    (id: 'iron', ru: 'Железо', kk: 'Темір кенд.'),
    (id: 'copper', ru: 'Медь', kk: 'Мыс кенд.'),
    (id: 'polymetal', ru: 'Полиметалл', kk: 'Полиметалл'),
    (id: 'asbestos', ru: 'Асбест', kk: 'Асбест'),
    (id: 'salt', ru: 'Соль', kk: 'Ас тұзы'),
    (id: 'gold', ru: 'Золото', kk: 'Алтын'),
    (id: 'nickel', ru: 'Никель', kk: 'Никель кенд.'),
    (id: 'chromite', ru: 'Хромит', kk: 'Хром кенд.'),
  ];

  // Города (с координатами) — кликаем по ним, чтобы ответить
  static const List<({String id, String nameId, double lat, double lng})> _cities = [
    (id: 'city_karaganda', nameId: 'city_karaganda', lat: 49.8028, lng: 73.0877),
    (id: 'city_atyrau', nameId: 'city_atyrau', lat: 47.116, lng: 51.883),
    (id: 'city_kostanay', nameId: 'city_kostanay', lat: 53.2144, lng: 63.6246),
    (id: 'city_zhezkazgan', nameId: 'city_zhezkazgan', lat: 47.7833, lng: 67.7667),
    (id: 'city_oskemen', nameId: 'city_ust_kamenogorsk', lat: 49.97, lng: 82.61),
    (id: 'city_kyzylorda', nameId: 'city_kyzylorda', lat: 44.852, lng: 65.509),
    (id: 'city_kokshetau', nameId: 'city_kokshetau', lat: 53.2833, lng: 69.3833),
    (id: 'city_aktobe', nameId: 'city_aktobe', lat: 50.2839, lng: 57.1660),
    (id: 'city_oskemen2', nameId: 'city_ust_kamenogorsk', lat: 49.97, lng: 82.61),
    (id: 'city_balkhash', nameId: 'city_taldykorgan', lat: 45.0, lng: 78.4),
  ];

  // Задания: ресурс → целевой город
  static const List<({String type, String cityId})> _tasks = [
    (type: 'coal', cityId: 'city_karaganda'),
    (type: 'oil', cityId: 'city_atyrau'),
    (type: 'iron', cityId: 'city_kostanay'),
    (type: 'copper', cityId: 'city_zhezkazgan'),
    (type: 'polymetal', cityId: 'city_oskemen'),
    (type: 'salt', cityId: 'city_kyzylorda'),
    (type: 'gold', cityId: 'city_kokshetau'),
    (type: 'nickel', cityId: 'city_aktobe'),
    (type: 'chromite', cityId: 'city_aktobe'),
  ];

  final Set<String> _correct = {};
  final Set<String> _wrong = {};
  int _score = 0;
  late List<int> _order; // порядок заданий
  int _current = 0;
  // +1 animation
  late final AnimationController _plusCtrl =
      AnimationController(vsync: this, duration: const Duration(milliseconds: 900));
  Offset? _plusPos;
  // экраны центров городов для +1
  final Map<String, Offset> _cityScreenCenters = {};

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
    _score = 0;
    _correct.clear();
    _wrong.clear();
    _order = List<int>.generate(_tasks.length, (i) => i)..shuffle();
    _current = 0;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Условные знаки'),
        actions: [
          IconButton(
            tooltip: 'Заново',
            icon: const Icon(Icons.refresh),
            onPressed: _startGame,
          )
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    decoration: BoxDecoration(color: cs.primaryContainer, borderRadius: BorderRadius.circular(999)),
                    child: Text('Счёт: $_score', style: TextStyle(color: cs.onPrimaryContainer, fontWeight: FontWeight.w700)),
                  ),
                  const Spacer(),
                  FilledButton.tonal(onPressed: _startGame, child: const Text('Заново')),
                ],
              ),
            ),
            Expanded(child: Padding(padding: const EdgeInsets.all(12), child: _buildMap())),
            _buildBottomPrompt(context),
          ],
        ),
      ),
    );
  }

  Widget _buildBottomPrompt(BuildContext context) {
    final currentTask = _tasks[_order[_current]];
    final cs = Theme.of(context).colorScheme;
    final type = _types.firstWhere((t) => t.id == currentTask.type);
    final label = Localizations.localeOf(context).languageCode == 'kk' ? type.kk : type.ru;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: cs.surface,
        border: Border(top: BorderSide(color: cs.outlineVariant)),
      ),
      child: Row(
        children: [
          CustomPaint(size: const Size(32, 32), painter: _SymbolPainter(type: type.id, isCorrect: false, isWrong: false)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              Localizations.localeOf(context).languageCode == 'kk'
                  ? 'Қай қалада орналасқан: $label?'
                  : 'Выберите город для: $label',
              style: TextStyle(color: cs.onSurface, fontWeight: FontWeight.w600),
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
        child: AnimatedBuilder(
          animation: _plusCtrl,
          builder: (context, _) => Stack(children: [
          Positioned.fill(
            child: Image.asset(
              _mapAssetPath,
              fit: BoxFit.contain,
              alignment: Alignment.center,
              errorBuilder: (context, _, __) => const Center(child: Text('Карта не найдена: lib/Images/lakes_counrty.png')),
            ),
          ),
          if (_mapSizeResolved && _mapImageSize != null)
            ..._buildCityOverlays(offsetX, offsetY, contentW, contentH),
          if (_plusPos != null)
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: _PlusPainter(
                    origin: _plusPos!,
                    progress: _plusCtrl.value,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
              ),
            ),
          ]),
        ),
      );
    });
  }

  List<Widget> _buildCityOverlays(double offsetX, double offsetY, double contentW, double contentH) {
    final innerLeft = offsetX + contentW * _insetLeft;
    final innerTop = offsetY + contentH * _insetTop;
    final innerW = contentW * (1 - _insetLeft - _insetRight);
    final innerH = contentH * (1 - _insetTop - _insetBottom);

    final centers = _cities
        .map((c) {
          final x = ((c.lng - _bboxMinLng) / (_bboxMaxLng - _bboxMinLng)).clamp(0.0, 1.0) * innerW;
          final y = ((_bboxMaxLat - c.lat) / (_bboxMaxLat - _bboxMinLat)).clamp(0.0, 1.0) * innerH;
          return (id: c.id, pos: Offset(x, y));
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

    final children = <Widget>[];
    for (final e in placed) {
      final id = e.id;
      final isWrong = _wrong.contains(id);
      final center = Offset(innerLeft + e.pos.dx, innerTop + e.pos.dy);
      _cityScreenCenters[id] = center;
      children.add(Positioned(
        left: center.dx - _tapSize / 2,
        top: center.dy - _tapSize / 2,
        width: _tapSize,
        height: _tapSize,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => _onTapCity(id),
          child: Container(
            decoration: BoxDecoration(
              color: () {
                if (isWrong) return Colors.redAccent;
                return Colors.grey;
              }(),
              borderRadius: BorderRadius.circular(6),
              boxShadow: const [BoxShadow(color: Colors.black26, blurRadius: 2, offset: Offset(0, 1))],
            ),
          ),
        ),
      ));
    }
    return children;
  }

  void _onTapCity(String cityId) {
    final currentTask = _tasks[_order[_current]];
    final targetCity = currentTask.cityId;
    final isCorrect = cityId == targetCity;
    if (isCorrect) {
      setState(() {
        _score += 1;
        _wrong.clear();
        final pos = _cityScreenCenters[cityId];
        if (pos != null) {
          _plusPos = pos;
          _plusCtrl.forward(from: 0);
        }
        if (_current < _order.length - 1) {
          _current += 1;
        } else {
          _current = 0;
          _order.shuffle();
          _score = 0; // авто‑рестарт без статистики, по желанию можно диалог
        }
      });
    } else {
      _wrong.add(cityId);
      try {
        HapticFeedback.heavyImpact();
      } catch (_) {}
      setState(() {});
    }
  }

  @override
  void dispose() {
    _plusCtrl.dispose();
    super.dispose();
  }

  double _containScale(double srcW, double srcH, double dstW, double dstH) {
    if (srcW <= 0 || srcH <= 0) return 1.0;
    final sx = dstW / srcW;
    final sy = dstH / srcH;
    return sx < sy ? sx : sy;
  }
}

class _PlusPainter extends CustomPainter {
  _PlusPainter({required this.origin, required this.progress, required this.color});
  final Offset origin;
  final double progress; // 0..1
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final dy = 40.0 * progress;
    final opacity = (1.0 - progress).clamp(0.0, 1.0);
    final text = '+1';
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color.withOpacity(opacity),
          fontSize: 22 + 6 * (1 - progress),
          fontWeight: FontWeight.w800,
          shadows: const [Shadow(blurRadius: 2, color: Colors.black26, offset: Offset(0, 1))],
        ),
      ),
      textDirection: TextDirection.ltr,
    );
    tp.layout();
    final offset = origin - Offset(tp.width / 2, tp.height / 2 + dy);
    tp.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant _PlusPainter oldDelegate) {
    return oldDelegate.origin != origin || oldDelegate.progress != progress || oldDelegate.color != color;
  }
}

class _SymbolPainter extends CustomPainter {
  _SymbolPainter({required this.type, required this.isCorrect, required this.isWrong});
  final String type;
  final bool isCorrect;
  final bool isWrong;

  @override
  void paint(Canvas canvas, Size size) {
    final r = size.width / 2;
    final center = Offset(r, r);
    // background
    final bg = Paint()
      ..color = isCorrect
          ? Colors.green
          : isWrong
              ? Colors.redAccent
              : Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(center, r, bg);
    final border = Paint()
      ..color = Colors.black
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;
    canvas.drawCircle(center, r, border);

    // icon/drawing
    switch (type) {
      case 'coal':
        _drawSquare(canvas, center, r * 0.9, Colors.black, fill: true);
        break;
      case 'oil':
        _drawCircle(canvas, center, r * 0.75, Colors.black);
        break;
      case 'gas':
        _drawTriangleOutline(canvas, center, r * 0.95, Colors.black);
        break;
      case 'iron':
        _drawTriangle(canvas, center, r * 0.95, Colors.black);
        break;
      case 'copper':
        _drawSquare(canvas, center, r * 0.9, const Color(0xFF3E2723), fill: true);
        break;
      case 'polymetal':
        _drawHexagon(canvas, center, r * 0.95, const Color(0xFF455A64));
        break;
      case 'asbestos':
        _drawPlus(canvas, center, r * 0.9, Colors.black);
        break;
      case 'salt':
        _drawRing(canvas, center, r * 0.85, Colors.blueGrey);
        break;
      case 'gold':
        _drawRing(canvas, center, r * 0.9, Colors.amber);
        _drawDot(canvas, center, r * 0.18, Colors.amber.shade800);
        break;
      case 'nickel':
        _drawDiamond(canvas, center, r * 0.95, Colors.black);
        _drawLabel(canvas, center, 'Ni', color: Colors.white);
        break;
      case 'chromite':
        _drawDiamond(canvas, center, r * 0.95, Colors.black);
        _drawDiamondStripe(canvas, center, r * 0.95, Colors.white);
        break;
      default:
        _drawSquare(canvas, center, r * 0.9, Colors.black, fill: false);
    }
  }

  @override
  bool shouldRepaint(covariant _SymbolPainter oldDelegate) {
    return oldDelegate.type != type || oldDelegate.isCorrect != isCorrect || oldDelegate.isWrong != isWrong;
  }

  void _drawSquare(Canvas c, Offset center, double size, Color color, {bool fill = false}) {
    final rect = Rect.fromCenter(center: center, width: size, height: size);
    final p = Paint()
      ..color = color
      ..style = fill ? PaintingStyle.fill : PaintingStyle.stroke
      ..strokeWidth = 2;
    c.drawRect(rect, p);
  }

  void _drawStripedSquare(Canvas c, Offset center, double size, Color color) {
    final rect = Rect.fromCenter(center: center, width: size, height: size);
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    c.drawRect(rect, p);
    final stripe = Paint()
      ..color = color
      ..strokeWidth = 1.5;
    for (double x = rect.left; x <= rect.right; x += 4) {
      c.drawLine(Offset(x, rect.top), Offset(x + 6, rect.bottom), stripe);
    }
  }

  void _drawTriangle(Canvas c, Offset center, double size, Color color) {
    final h = size * math.sqrt(3) / 2;
    final path = Path()
      ..moveTo(center.dx, center.dy - h / 2)
      ..lineTo(center.dx - size / 2, center.dy + h / 2)
      ..lineTo(center.dx + size / 2, center.dy + h / 2)
      ..close();
    final p = Paint()..color = color;
    c.drawPath(path, p);
  }

  void _drawTriangleOutline(Canvas c, Offset center, double size, Color color) {
    final h = size * math.sqrt(3) / 2;
    final path = Path()
      ..moveTo(center.dx, center.dy - h / 2)
      ..lineTo(center.dx - size / 2, center.dy + h / 2)
      ..lineTo(center.dx + size / 2, center.dy + h / 2)
      ..close();
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    c.drawPath(path, p);
  }

  void _drawHexagon(Canvas c, Offset center, double size, Color color) {
    final path = Path();
    for (int i = 0; i < 6; i++) {
      final a = (math.pi / 3) * i - math.pi / 6;
      final pt = center + Offset(size * math.cos(a), size * math.sin(a));
      if (i == 0) {
        path.moveTo(pt.dx, pt.dy);
      } else {
        path.lineTo(pt.dx, pt.dy);
      }
    }
    path.close();
    final p = Paint()..color = color;
    c.drawPath(path, p);
  }

  void _drawDiamond(Canvas c, Offset center, double size, Color color) {
    final path = Path()
      ..moveTo(center.dx, center.dy - size)
      ..lineTo(center.dx - size, center.dy)
      ..lineTo(center.dx, center.dy + size)
      ..lineTo(center.dx + size, center.dy)
      ..close();
    final p = Paint()..color = color;
    c.drawPath(path, p);
  }

  void _drawDiamondStripe(Canvas c, Offset center, double size, Color color) {
    final p = Paint()
      ..color = color
      ..strokeWidth = 2;
    c.drawLine(center + Offset(-size * 0.6, 0), center + Offset(size * 0.6, 0), p);
  }

  void _drawStar(Canvas c, Offset center, double radius, Color color) {
    final path = Path();
    for (int i = 0; i < 10; i++) {
      final r = (i % 2 == 0) ? radius : radius * 0.45;
      final a = -math.pi / 2 + (math.pi / 5) * i;
      final pt = center + Offset(r * math.cos(a), r * math.sin(a));
      if (i == 0) path.moveTo(pt.dx, pt.dy); else path.lineTo(pt.dx, pt.dy);
    }
    path.close();
    final p = Paint()..color = color;
    c.drawPath(path, p);
  }

  void _drawDrop(Canvas c, Offset center, double size, Color color) {
    final path = Path();
    final top = center + Offset(0, -size * 0.6);
    final bottom = center + Offset(0, size * 0.6);
    path.moveTo(top.dx, top.dy);
    path.cubicTo(center.dx + size * 0.6, center.dy - size * 0.2, center.dx + size * 0.5, center.dy + size * 0.2, bottom.dx, bottom.dy);
    path.cubicTo(center.dx - size * 0.5, center.dy + size * 0.2, center.dx - size * 0.6, center.dy - size * 0.2, top.dx, top.dy);
    final p = Paint()..color = color;
    c.drawPath(path, p);
  }

  void _drawCircle(Canvas c, Offset center, double radius, Color color) {
    final p = Paint()..color = color;
    c.drawCircle(center, radius, p);
  }

  void _drawRing(Canvas c, Offset center, double radius, Color color) {
    final p = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    c.drawCircle(center, radius, p);
  }

  void _drawFlame(Canvas c, Offset center, double size, Color color) {
    final path = Path();
    path.moveTo(center.dx, center.dy - size * 0.6);
    path.cubicTo(center.dx + size * 0.6, center.dy - size * 0.2, center.dx + size * 0.3, center.dy + size * 0.4, center.dx, center.dy + size * 0.6);
    path.cubicTo(center.dx - size * 0.3, center.dy + size * 0.4, center.dx - size * 0.6, center.dy - size * 0.2, center.dx, center.dy - size * 0.6);
    final p = Paint()..color = color;
    c.drawPath(path, p);
  }

  void _drawDot(Canvas c, Offset center, double radius, Color color) {
    final p = Paint()..color = color;
    c.drawCircle(center, radius, p);
  }

  void _drawLabel(Canvas c, Offset center, String text, {Color color = Colors.black}) {
    final tp = TextPainter(
      text: TextSpan(text: text, style: TextStyle(color: color, fontWeight: FontWeight.w800, fontSize: 11)),
      textDirection: TextDirection.ltr,
    )..layout();
    tp.paint(c, center - Offset(tp.width / 2, tp.height / 2));
  }

  void _drawPlus(Canvas c, Offset center, double size, Color color) {
    final p = Paint()
      ..color = color
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round;
    final len = size * 0.6;
    c.drawLine(center + Offset(-len / 2, 0), center + Offset(len / 2, 0), p);
    c.drawLine(center + Offset(0, -len / 2), center + Offset(0, len / 2), p);
  }
}
