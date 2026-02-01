import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../l10n/app_localizations.dart';

class SymbolsTestPage extends StatefulWidget {
  const SymbolsTestPage({super.key});

  @override
  State<SymbolsTestPage> createState() => _SymbolsTestPageState();
}

class _SymbolsTestPageState extends State<SymbolsTestPage> {
  final _rnd = math.Random();

  final List<ResourceSymbol> _symbols = const [
    // базовые
    ResourceSymbol(
      type: ResourceSymbolType.coalHard,
      kk: 'Тас көмір',
      ru: 'Каменный уголь',
      en: 'Hard coal',
    ),
    ResourceSymbol(
      type: ResourceSymbolType.oil,
      kk: 'Мұнай',
      ru: 'Нефть',
      en: 'Oil',
    ),
    ResourceSymbol(
      type: ResourceSymbolType.gas,
      kk: 'Табиғи газ',
      ru: 'Природный газ',
      en: 'Natural gas',
    ),
    ResourceSymbol(
      type: ResourceSymbolType.iron,
      kk: 'Темір',
      ru: 'Железо',
      en: 'Iron',
    ),
    ResourceSymbol(
      type: ResourceSymbolType.gold,
      kk: 'Алтын',
      ru: 'Золото',
      en: 'Gold',
    ),
    ResourceSymbol(
      type: ResourceSymbolType.copper,
      kk: 'Мыс',
      ru: 'Медь',
      en: 'Copper',
    ),
    ResourceSymbol(
      type: ResourceSymbolType.salt,
      kk: 'Тұз',
      ru: 'Соль',
      en: 'Salt',
    ),
    ResourceSymbol(
      type: ResourceSymbolType.limestone,
      kk: 'Әктас',
      ru: 'Известняк',
      en: 'Limestone',
    ),
    ResourceSymbol(
      type: ResourceSymbolType.clay,
      kk: 'Саз',
      ru: 'Глина',
      en: 'Clay',
    ),
    ResourceSymbol(
      type: ResourceSymbolType.aluminium,
      kk: 'Алюминий',
      ru: 'Алюминий',
      en: 'Aluminium',
    ),
    // добавленные
    ResourceSymbol(
      type: ResourceSymbolType.lignite,
      kk: 'Қоңыр көмір',
      ru: 'Бурый уголь',
      en: 'Lignite',
    ),
    ResourceSymbol(
      type: ResourceSymbolType.manganese,
      kk: 'Марганец',
      ru: 'Марганец',
      en: 'Manganese',
    ),
    ResourceSymbol(
      type: ResourceSymbolType.chromite,
      kk: 'Хромит',
      ru: 'Хромит',
      en: 'Chromite',
    ),
    ResourceSymbol(
      type: ResourceSymbolType.tungsten,
      kk: 'Вольфрам',
      ru: 'Вольфрам',
      en: 'Tungsten',
    ),
    ResourceSymbol(
      type: ResourceSymbolType.molybdenum,
      kk: 'Молибден',
      ru: 'Молибден',
      en: 'Molybdenum',
    ),
    ResourceSymbol(
      type: ResourceSymbolType.nickel,
      kk: 'Никель',
      ru: 'Никель',
      en: 'Nickel',
    ),
    ResourceSymbol(
      type: ResourceSymbolType.polymetal,
      kk: 'Полиметалдар',
      ru: 'Полиметаллы',
      en: 'Polymetals',
    ),
  ];

  late List<ResourceSymbol> _quizOrder;
  int _qIndex = 0;
  int _score = 0;
  List<ResourceSymbol> _options = const [];
  ResourceSymbol? _current;
  int? _chosen;

  bool get _answered => _chosen != null;

  @override
  void initState() {
    super.initState();
    _startNewQuiz();
  }

  void _startNewQuiz() {
    _quizOrder = [..._symbols]..shuffle(_rnd);
    _qIndex = 0;
    _score = 0;
    _loadQuestion();
  }

  String _label(ResourceSymbol s, BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    if (lang == 'kk') return s.kk;
    if (lang == 'ru') return s.ru;
    return s.en;
  }

  void _loadQuestion() {
    setState(() {
      _current = _quizOrder[_qIndex];
      _chosen = null;
      final wrong = [..._symbols]..remove(_current);
      wrong.shuffle(_rnd);
      _options = ([...wrong.take(3), _current!]..shuffle(_rnd)).toList();
      assert(_options.length == 4);
    });
  }

  // АВТО-ПЕРЕХОД ПОСЛЕ ТАПА
  void _choose(int i) {
    if (_answered) return;
    setState(() => _chosen = i);
    if (_options[i] == _current) _score++;

    Future.delayed(const Duration(milliseconds: 450), () {
      if (!mounted) return;
      if (_qIndex < _quizOrder.length - 1) {
        _qIndex++;
        _loadQuestion();
      } else {
        _showResult();
      }
    });
  }

  void _showResult() {
    final t = AppLocalizations.of(context)!;
    final total = _quizOrder.length;
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(t.symbolsResultTitle),
        content: Text('${t.correctAnswers}: $_score / $total'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _startNewQuiz();
            },
            child: Text(t.restart),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(t.close),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final cs = Theme.of(context).colorScheme;
    final total = _quizOrder.length, idx = _qIndex + 1;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.symbolsQuizTitle),
        actions: [
          Center(
            child: Padding(
              padding: const EdgeInsets.only(right: 8),
              child: Text(
                '$idx / $total',
                style: TextStyle(color: cs.onSurfaceVariant),
              ),
            ),
          ),
          IconButton(
            onPressed: _startNewQuiz,
            icon: const Icon(Icons.refresh),
            tooltip: t.reset,
          ),
        ],
      ),
      // SafeArea — убираем конфликт с «домиком» iOS и переполнения
      body: SafeArea(
        top: false,
        bottom: true,
        child: _current == null
            ? const SizedBox.shrink()
            : _Body(
                score: _score,
                labelBuilder: (s) => _label(s, context),
                current: _current!,
                options: _options,
                answered: _answered,
                chosenIndex: _chosen,
                onChoose: _choose,
              ),
      ),
    );
  }
}

/* ---------- верх: символ + счёт; низ: список из 4 кликабельных вариантов ---------- */

class _Body extends StatelessWidget {
  const _Body({
    required this.score,
    required this.labelBuilder,
    required this.current,
    required this.options,
    required this.answered,
    required this.chosenIndex,
    required this.onChoose,
  });

  final int score;
  final String Function(ResourceSymbol) labelBuilder;
  final ResourceSymbol current;
  final List<ResourceSymbol> options;
  final bool answered;
  final int? chosenIndex;
  final void Function(int) onChoose;

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context)!;

    return LayoutBuilder(
      builder: (context, c) {
        final compact = c.maxHeight < 700;
        final symbolMaxH = c.maxHeight * (compact ? 0.24 : 0.28);
        final symbolSide = math.min(
          symbolMaxH,
          c.maxWidth * (compact ? 0.55 : 0.6),
        );
        final optionVPad = compact ? 10.0 : 14.0;
        final optionFont = compact ? 15.0 : 16.0;

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
              child: Center(
                child: SizedBox(
                  width: symbolSide,
                  height: symbolSide,
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(14),
                      child: FittedBox(
                        fit: BoxFit.contain,
                        child: SizedBox(
                          width: 220,
                          height: 220,
                          child: CustomPaint(
                            painter: ResourceSymbolPainter(
                              current.type,
                              color: cs.onSurface,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 6),
              child: // правильно — вызываем функцию и ничего не конкатенируем
              Text(
                t.score(score),
                style: TextStyle(color: cs.onSurfaceVariant),
              ),
            ),
            Expanded(
              child: ListView.separated(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                itemCount: options.length, // = 4
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (context, i) {
                  final opt = options[i];
                  final isCorrect = opt == current;
                  Color? bg, fg;
                  if (answered) {
                    if (i == chosenIndex && !isCorrect) {
                      bg = Colors.red.withOpacity(0.12);
                      fg = Colors.red;
                    }
                    if (isCorrect) {
                      bg = Colors.green.withOpacity(0.14);
                      fg = Colors.green.shade800;
                    }
                  }
                  return Material(
                    color: Colors.transparent,
                    clipBehavior: Clip.antiAlias,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Ink(
                      decoration: BoxDecoration(
                        color: bg ?? cs.surface,
                        border: Border.all(
                          color: (answered && isCorrect)
                              ? Colors.green
                              : cs.outlineVariant,
                        ),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        onTap: () => onChoose(i), // Кликабельно для всех 4
                        borderRadius: BorderRadius.circular(12),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            vertical: optionVPad,
                            horizontal: 14,
                          ),
                          child: Row(
                            children: [
                              Icon(
                                answered
                                    ? (isCorrect
                                          ? Icons.check_circle
                                          : (i == chosenIndex
                                                ? Icons.cancel
                                                : Icons.circle_outlined))
                                    : Icons.circle_outlined,
                                size: 18,
                                color: fg ?? cs.onSurfaceVariant,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Text(
                                  labelBuilder(opt),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: optionFont,
                                    fontWeight: FontWeight.w500,
                                    color: fg ?? cs.onSurface,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }
}

/* ===== модели и рисовалка (оставил в этом файле, чтобы всё было самодостаточно) ===== */

enum ResourceSymbolType {
  coalHard,
  oil,
  gas,
  iron,
  gold,
  copper,
  salt,
  limestone,
  clay,
  aluminium,
  lignite,
  manganese,
  chromite,
  tungsten,
  molybdenum,
  nickel,
  polymetal,
}

class ResourceSymbol {
  final ResourceSymbolType type;
  final String kk, ru, en;
  const ResourceSymbol({
    required this.type,
    required this.kk,
    required this.ru,
    required this.en,
  });
}

class ResourceSymbolPainter extends CustomPainter {
  final ResourceSymbolType type;
  final Color color;
  ResourceSymbolPainter(this.type, {required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width, h = size.height;
    final stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(w, h) * 0.06
      ..strokeJoin = StrokeJoin.round
      ..strokeCap = StrokeCap.round;
    final thin = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.max(w, h) * 0.035;
    final fill = Paint()
      ..color = color
      ..style = PaintingStyle.fill;

    final pad = w * 0.12;
    final rect = Rect.fromLTWH(pad, pad, w - 2 * pad, h - 2 * pad);

    switch (type) {
      case ResourceSymbolType.coalHard:
        canvas.drawRect(rect, fill);
        break;
      case ResourceSymbolType.oil:
        final top = rect.top + rect.height * 0.10;
        final bottom = rect.bottom - rect.height * 0.05;
        final path = Path()
          ..moveTo(rect.left + rect.width * 0.25, top)
          ..lineTo(rect.right - rect.width * 0.25, top)
          ..lineTo(rect.right - rect.width * 0.10, bottom)
          ..lineTo(rect.left + rect.width * 0.10, bottom)
          ..close();
        canvas.drawPath(path, fill);
        break;
      case ResourceSymbolType.gas:
        final path = Path()
          ..moveTo(rect.center.dx, rect.top)
          ..lineTo(rect.right, rect.bottom)
          ..lineTo(rect.left, rect.bottom)
          ..close();
        canvas.drawPath(path, stroke);
        break;
      case ResourceSymbolType.iron:
        final p = Path()
          ..moveTo(rect.center.dx, rect.top)
          ..lineTo(rect.right, rect.bottom)
          ..lineTo(rect.left, rect.bottom)
          ..close();
        canvas.drawPath(p, fill);
        break;
      case ResourceSymbolType.gold:
        canvas.drawCircle(rect.center, rect.shortestSide * 0.38, fill);
        break;
      case ResourceSymbolType.copper:
        final r = Rect.fromCenter(
          center: rect.center,
          width: rect.width * 0.9,
          height: rect.height * 0.45,
        );
        canvas.drawRect(r, fill);
        break;
      case ResourceSymbolType.salt:
        canvas.drawRect(rect, stroke);
        final dx = rect.width * 0.18, dy = rect.height * 0.18;
        canvas.drawLine(rect.topLeft, rect.topLeft + Offset(dx, -dy), stroke);
        canvas.drawLine(rect.topRight, rect.topRight + Offset(dx, -dy), stroke);
        canvas.drawLine(
          rect.topLeft + Offset(dx, -dy),
          rect.topRight + Offset(dx, -dy),
          stroke,
        );
        canvas.drawLine(
          rect.bottomRight,
          rect.bottomRight + Offset(dx, -dy),
          stroke,
        );
        canvas.drawLine(rect.topRight, rect.topRight + Offset(dx, -dy), stroke);
        break;
      case ResourceSymbolType.limestone:
        canvas.drawRect(rect, stroke);
        canvas.drawLine(rect.topLeft, rect.bottomRight, stroke);
        canvas.drawLine(rect.bottomLeft, rect.topRight, stroke);
        break;
      case ResourceSymbolType.clay:
        canvas.drawRect(rect, stroke);
        final tri = Path()
          ..moveTo(rect.left, rect.bottom)
          ..lineTo(rect.right, rect.bottom)
          ..lineTo(rect.left, rect.top)
          ..close();
        canvas.drawPath(tri, fill);
        break;
      case ResourceSymbolType.aluminium:
        canvas.drawRect(rect, stroke);
        final tpA = TextPainter(
          text: TextSpan(
            text: 'A',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: rect.height * 0.75,
              height: 1.0,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: rect.width);
        tpA.paint(
          canvas,
          Offset(
            rect.left + (rect.width - tpA.width) / 2,
            rect.top + (rect.height - tpA.height) / 2,
          ),
        );
        break;
      case ResourceSymbolType.lignite:
        canvas.drawRect(rect, stroke);
        final step = rect.width * 0.14;
        for (double x = rect.left - rect.height; x < rect.right; x += step) {
          canvas.drawLine(
            Offset(x, rect.bottom),
            Offset(x + rect.height, rect.top),
            thin,
          );
        }
        break;
      case ResourceSymbolType.manganese:
        canvas.drawRect(rect, stroke);
        final tpM = TextPainter(
          text: TextSpan(
            text: 'M',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: rect.height * 0.75,
              height: 1.0,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: rect.width);
        tpM.paint(
          canvas,
          Offset(
            rect.left + (rect.width - tpM.width) / 2,
            rect.top + (rect.height - tpM.height) / 2,
          ),
        );
        break;
      case ResourceSymbolType.chromite:
        final left = Path()
          ..moveTo(rect.left, rect.top)
          ..lineTo(rect.center.dx, rect.center.dy)
          ..lineTo(rect.left, rect.bottom)
          ..close();
        final right = Path()
          ..moveTo(rect.right, rect.top)
          ..lineTo(rect.center.dx, rect.center.dy)
          ..lineTo(rect.right, rect.bottom)
          ..close();
        canvas.drawPath(left, fill);
        canvas.drawPath(right, fill);
        break;
      case ResourceSymbolType.tungsten:
        canvas.drawRect(rect, stroke);
        break;
      case ResourceSymbolType.molybdenum:
        final rh = Path()
          ..moveTo(rect.center.dx, rect.top)
          ..lineTo(rect.right, rect.center.dy)
          ..lineTo(rect.center.dx, rect.bottom)
          ..lineTo(rect.left, rect.center.dy)
          ..close();
        canvas.drawPath(rh, fill);
        break;
      case ResourceSymbolType.nickel:
        canvas.drawRect(rect, stroke);
        final tpH = TextPainter(
          text: TextSpan(
            text: 'H',
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w800,
              fontSize: rect.height * 0.75,
              height: 1.0,
            ),
          ),
          textDirection: TextDirection.ltr,
        )..layout(maxWidth: rect.width);
        tpH.paint(
          canvas,
          Offset(
            rect.left + (rect.width - tpH.width) / 2,
            rect.top + (rect.height - tpH.height) / 2,
          ),
        );
        break;
      case ResourceSymbolType.polymetal:
        final rad = rect.shortestSide * 0.48;
        canvas.drawCircle(rect.center, rad, stroke);
        for (int i = 0; i < 3; i++) {
          final a = -math.pi / 2 + i * 2 * math.pi / 3;
          final tip =
              rect.center +
              Offset(rad * 0.85 * math.cos(a), rad * 0.85 * math.sin(a));
          final leftPt =
              rect.center +
              Offset(
                rad * 0.35 * math.cos(a - math.pi / 8),
                rad * 0.35 * math.sin(a - math.pi / 8),
              );
          final rightPt =
              rect.center +
              Offset(
                rad * 0.35 * math.cos(a + math.pi / 8),
                rad * 0.35 * math.sin(a + math.pi / 8),
              );
          final tri = Path()..addPolygon([tip, leftPt, rightPt], true);
          canvas.drawPath(tri, fill);
        }
        break;
    }
  }

  @override
  bool shouldRepaint(covariant ResourceSymbolPainter old) =>
      old.type != type || old.color != color;
}
