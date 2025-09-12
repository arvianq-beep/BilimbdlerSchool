import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart' show mapEquals;
import 'package:flutter/painting.dart' show MatrixUtils;
import 'package:vector_math/vector_math_64.dart' show Matrix4;
import 'package:flutter/services.dart' show rootBundle, HapticFeedback;
import 'package:confetti/confetti.dart';
import '../l10n/app_localizations.dart';

// This page shows an interactive SVG map of Kazakhstan.
// Users must click the requested region; correct guesses turn green,
// wrong clicks turn red. The target region name is localized by locale.

import 'package:xml/xml.dart' as xml;
import 'package:path_drawing/path_drawing.dart';

class PhysicalGeographyPage extends StatefulWidget {
  const PhysicalGeographyPage({super.key});

  @override
  State<PhysicalGeographyPage> createState() => _PhysicalGeographyPageState();
}

class _PhysicalGeographyPageState extends State<PhysicalGeographyPage> {
  static bool _rulesShownOnce = false;
  // Region IDs present in the SVG (<path id="...">)
  final List<String> _regionIds = const [
    'KZ10',
    'KZ11',
    'KZ15',
    'KZ19',
    'KZ23',
    'KZ27',
    'KZ31',
    'KZ33',
    'KZ35',
    'KZ39',
    'KZ43',
    'KZ47',
    'KZ55',
    'KZ59',
    'KZ61',
    'KZ62',
    'KZ63',
  ];

  late List<String> _remaining;
  String? _targetId;
  int _score = 0;
  final Set<String> _correct = {};
  final Set<String> _wrong = {};
  int _attempts = 0;
  bool _endShown = false;
  late final ConfettiController _confettiCtrl = ConfettiController(
    duration: const Duration(seconds: 3),
  );

  @override
  void initState() {
    super.initState();
    _remaining = _regionIds.toList()..shuffle();
    _nextTarget();
    // Show rules on first open
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && !_rulesShownOnce) {
        _rulesShownOnce = true;
        _showRulesDialog(context);
      }
    });
  }

  @override
  void dispose() {
    _confettiCtrl.dispose();
    super.dispose();
  }

  void _nextTarget() {
    setState(() {
      _targetId = _remaining.isNotEmpty ? _remaining.first : null;
    });
    if (_targetId == null && !_endShown) {
      _endShown = true;
      // Показать диалог по окончании кадра
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        // Конфетти + лёгкая вибрация при завершении
        try {
          HapticFeedback.vibrate();
        } catch (_) {}
        _confettiCtrl.play();
        _showFinishDialog(context);
      });
    }
  }

  bool _onTapRegion(String regionId) {
    _attempts += 1;
    if (_targetId == null) return false;
    if (regionId == _targetId) {
      _correct.add(regionId);
      _wrong.clear();
      _score += 1;
      _remaining.remove(regionId);
      _nextTarget();
      return true;
    } else {
      _wrong.add(regionId);
      // Haptic feedback on wrong pick
      unawaited(HapticFeedback.heavyImpact());
      setState(() {});
      return false;
    }
  }

  void _restart() {
    setState(() {
      _score = 0;
      _correct.clear();
      _wrong.clear();
      _attempts = 0;
      _endShown = false;
      _remaining = _regionIds.toList()..shuffle();
      _nextTarget();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context)!;
    final targetName = _localizedRegionName(context, _targetId);
    final finished = _targetId == null;

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.regions),
        actions: [
          IconButton(
            tooltip: _rulesButtonLabel(context),
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
                // Top bar with score + target in a card
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
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
                        const SizedBox(height: 10),
                        Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: finished
                                    ? ''
                                    : _selectRegionLabel(context, ''),
                                style: TextStyle(
                                  color: cs.onSurface,
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              if (!finished)
                                TextSpan(
                                  text: targetName,
                                  style: TextStyle(
                                    color: cs.primary,
                                    fontWeight: FontWeight.w800,
                                    fontSize: 18,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                // Map area
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: InteractiveViewer(
                      minScale: 1,
                      maxScale: 4,
                      boundaryMargin: const EdgeInsets.all(48),
                      child: KazakhstanSvgMap(
                        svgAssetPath: 'lib/Images/kazakhstan.svg',
                        onTapRegion: _onTapRegion,
                        colorForRegion: (id) {
                          if (_correct.contains(id))
                            return Colors.green; // всегда ярко-зелёный
                          if (_wrong.contains(id))
                            return Colors.redAccent; // всегда красный
                          return cs.primaryContainer.withOpacity(
                            0.55,
                          ); // остальные зависят от темы
                        },
                        strokeColor: cs.onSurface.withOpacity(0.35),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            // Confetti overlay (top center)
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

  String _locale(BuildContext context) =>
      Localizations.localeOf(context).languageCode;

  String _localizedRegionName(BuildContext context, String? id) {
    if (id == null) return '—';
    final lang = _locale(context);
    switch (lang) {
      case 'ru':
        const ru = {
          'KZ10': 'Абай',
          'KZ11': 'Акмолинская область',
          'KZ15': 'Актюбинская область',
          'KZ19': 'Алматинская область',
          'KZ23': 'Атырауская область',
          'KZ27': 'Западно-Казахстанская область',
          'KZ31': 'Жамбылская область',
          'KZ33': 'Жетысу',
          'KZ35': 'Карагандинская область',
          'KZ39': 'Костанайская область',
          'KZ43': 'Кызылординская область',
          'KZ47': 'Мангистауская область',
          'KZ55': 'Павлодарская область',
          'KZ59': 'Северо-Казахстанская область',
          'KZ61': 'Туркестанская область',
          'KZ62': 'Улытау',
          'KZ63': 'Восточно-Казахстанская область',
          'KZ71': 'Астана',
          'KZ75': 'Алматы',
          'KZ79': 'Шымкент',
        };
        return ru[id] ?? id;
      case 'kk':
        const kk = {
          'KZ10': 'Абай',
          'KZ11': 'Ақмола облысы',
          'KZ15': 'Ақтөбе облысы',
          'KZ19': 'Алматы облысы',
          'KZ23': 'Атырау облысы',
          'KZ27': 'Батыс Қазақстан облысы',
          'KZ31': 'Жамбыл облысы',
          'KZ33': 'Жетісу облысы',
          'KZ35': 'Қарағанды облысы',
          'KZ39': 'Қостанай облысы',
          'KZ43': 'Қызылорда облысы',
          'KZ47': 'Маңғыстау облысы',
          'KZ55': 'Павлодар облысы',
          'KZ59': 'Солтүстік Қазақстан облысы',
          'KZ61': 'Түркістан облысы',
          'KZ62': 'Ұлытау облысы',
          'KZ63': 'Шығыс Қазақстан облысы',
          'KZ71': 'Астана',
          'KZ75': 'Алматы',
          'KZ79': 'Шымкент',
        };
        return kk[id] ?? id;
      default:
        const en = {
          'KZ10': 'Abai',
          'KZ11': 'Akmola',
          'KZ15': 'Aktobe',
          'KZ19': 'Almaty',
          'KZ23': 'Atyrau',
          'KZ27': 'West Kazakhstan',
          'KZ31': 'Jambyl',
          'KZ33': 'Jetisu',
          'KZ35': 'Karaganda',
          'KZ39': 'Kostanay',
          'KZ43': 'Kyzylorda',
          'KZ47': 'Mangystau',
          'KZ55': 'Pavlodar',
          'KZ59': 'North Kazakhstan',
          'KZ61': 'Turkestan',
          'KZ62': 'Ulytau',
          'KZ63': 'East Kazakhstan',
          'KZ71': 'Astana',
          'KZ75': 'Almaty',
          'KZ79': 'Shymkent',
        };
        return en[id] ?? id;
    }
  }

  String _selectRegionLabel(BuildContext context, String regionName) {
    switch (_locale(context)) {
      case 'ru':
        return 'Выберите область: $regionName';
      case 'kk':
        return 'Облысты таңдаңыз: $regionName';
      default:
        return 'Select region: $regionName';
    }
  }

  String _gameFinishedLabel(BuildContext context, int score) {
    switch (_locale(context)) {
      case 'ru':
        return 'Готово! Ваш счёт: $score';
      case 'kk':
        return 'Дайын! Ұпайыңыз: $score';
      default:
        return 'Done! Your score: $score';
    }
  }

  String _scoreLabel(BuildContext context, int score) {
    switch (_locale(context)) {
      case 'ru':
        return 'Счёт: $score';
      case 'kk':
        return 'Ұпай: $score';
      default:
        return 'Score: $score';
    }
  }

  String _remainingLabel(BuildContext context, int n) {
    switch (_locale(context)) {
      case 'ru':
        return 'Осталось: $n';
      case 'kk':
        return 'Қалды: $n';
      default:
        return 'Remaining: $n';
    }
  }

  String _restartLabel(BuildContext context) {
    switch (_locale(context)) {
      case 'ru':
        return 'Заново';
      case 'kk':
        return 'Қайта бастау';
      default:
        return 'Restart';
    }
  }

  String _finishTitle(BuildContext context) {
    switch (_locale(context)) {
      case 'ru':
        return 'Игра завершена';
      case 'kk':
        return 'Ойын аяқталды';
      default:
        return 'Game Completed';
    }
  }

  String _totalScoreLabel(BuildContext context, int score, int total) {
    switch (_locale(context)) {
      case 'ru':
        return 'Всего баллов: $score из $total';
      case 'kk':
        return 'Жалпы ұпай: $score / $total';
      default:
        return 'Total score: $score / $total';
    }
  }

  String _attemptsUsedLabel(BuildContext context, int attempts) {
    switch (_locale(context)) {
      case 'ru':
        return 'Попыток использовано: $attempts';
      case 'kk':
        return 'Қолданылған талпыныстар: $attempts';
      default:
        return 'Attempts used: $attempts';
    }
  }

  String _avgAttemptsLabel(BuildContext context, double avg) {
    final avgStr = avg.toStringAsFixed(1);
    switch (_locale(context)) {
      case 'ru':
        return 'Среднее попыток на область: $avgStr';
      case 'kk':
        return 'Бір облысқа орташа талпыныс: $avgStr';
      default:
        return 'Average attempts per region: $avgStr';
    }
  }

  String _backToMenuLabel(BuildContext context) {
    switch (_locale(context)) {
      case 'ru':
        return 'В меню географии';
      case 'kk':
        return 'География мәзіріне';
      default:
        return 'Geography menu';
    }
  }

  void _showFinishDialog(BuildContext context) {
    final total = _regionIds.length;
    final score = _score;
    final attempts = _attempts;
    final avg = total == 0 ? 0.0 : attempts / total;

    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return AlertDialog(
          titlePadding: const EdgeInsets.fromLTRB(20, 16, 8, 0),
          title: Row(
            children: [
              Expanded(child: Text(_finishTitle(context))),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => Navigator.of(ctx).pop(),
                tooltip: MaterialLocalizations.of(context).closeButtonLabel,
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(_totalScoreLabel(context, score, total)),
              const SizedBox(height: 6),
              Text(_attemptsUsedLabel(context, attempts)),
              const SizedBox(height: 6),
              Text(_avgAttemptsLabel(context, avg)),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop(); // close dialog
                Navigator.of(context).pop(); // back to geography menu
              },
              child: Text(_backToMenuLabel(context)),
            ),
            FilledButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                _restart();
              },
              child: Text(_restartLabel(context)),
            ),
          ],
        );
      },
    );
  }

  String _rulesButtonLabel(BuildContext context) {
    switch (_locale(context)) {
      case 'ru':
        return 'Правила';
      case 'kk':
        return 'Ережелер';
      default:
        return 'Rules';
    }
  }

  String _rulesTitle(BuildContext context) {
    switch (_locale(context)) {
      case 'ru':
        return 'Правила игры';
      case 'kk':
        return 'Ойын ережелері';
      default:
        return 'Game Rules';
    }
  }

  String _rulesText(BuildContext context) {
    switch (_locale(context)) {
      case 'ru':
        return '— Выберите указанную область на карте.\n— Верный выбор даёт +1 балл.\n— Неверные клики подсвечиваются красным.\n— После верного ответа неверные подсветки сбрасываются.\n— Нажмите «Заново», чтобы начать сначала.';
      case 'kk':
        return '— Картадан көрсетілген облысты таңдаңыз.\n— Дұрыс таңдау +1 ұпай береді.\n— Қате басулар қызыл түспен белгіленеді.\n— Дұрыс жауаптан кейін қателердің белгісі жойылады.\n— «Қайта бастау» арқылы ойынды жаңадан бастаңыз.';
      default:
        return '— Pick the requested region on the map.\n— Correct pick gives +1 point.\n— Wrong picks are highlighted in red.\n— After a correct pick, wrong highlights are cleared.\n— Use “Restart” to start over.';
    }
  }

  void _showRulesDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(_rulesTitle(context)),
          content: Text(_rulesText(context)),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: Text(MaterialLocalizations.of(context).okButtonLabel),
            ),
          ],
        );
      },
    );
  }
}

typedef RegionColorResolver = Color Function(String regionId);

class KazakhstanSvgMap extends StatefulWidget {
  const KazakhstanSvgMap({
    super.key,
    required this.svgAssetPath,
    required this.onTapRegion,
    required this.colorForRegion,
    this.labels = const {},
    this.strokeColor = Colors.black54,
  });

  final String svgAssetPath;
  final bool Function(String regionId) onTapRegion; // returns true if correct
  final RegionColorResolver colorForRegion;
  final Map<String, String> labels; // id -> label text
  final Color strokeColor;

  @override
  State<KazakhstanSvgMap> createState() => _KazakhstanSvgMapState();
}

class _KazakhstanSvgMapState extends State<KazakhstanSvgMap>
    with TickerProviderStateMixin {
  Map<String, Path> _paths = {};
  Rect? _viewBox;
  bool _loading = true;
  String? _error;

  // Tap ripple animation
  late final AnimationController _pulseCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 350),
  );
  Offset? _pulseScreenPos;
  // +1 animation on correct pick
  late final AnimationController _plusCtrl = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 700),
  );
  Offset? _plusPos;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
    _pulseCtrl.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _pulseScreenPos = null;
        _pulseCtrl.reset();
        if (mounted) setState(() {});
      }
    });
    _plusCtrl.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _plusPos = null;
        _plusCtrl.reset();
        if (mounted) setState(() {});
      }
    });
  }

  Future<void> _load() async {
    try {
      final svgString = await rootBundle.loadString(widget.svgAssetPath);
      final doc = xml.XmlDocument.parse(svgString);
      final svgEl = doc.rootElement;

      // Parse viewBox (support both viewBox/viewbox)
      final vbAttr =
          svgEl.getAttribute('viewBox') ?? svgEl.getAttribute('viewbox');
      if (vbAttr != null) {
        final nums = vbAttr
            .split(RegExp(r'[\s,]+'))
            .where((e) => e.isNotEmpty)
            .toList();
        if (nums.length == 4) {
          final x = double.tryParse(nums[0]) ?? 0;
          final y = double.tryParse(nums[1]) ?? 0;
          final w = double.tryParse(nums[2]) ?? 1000;
          final h = double.tryParse(nums[3]) ?? 1000;
          _viewBox = Rect.fromLTWH(x, y, w, h);
        }
      }

      final Map<String, Path> paths = {};
      for (final node in svgEl.findAllElements('path')) {
        final id = node.getAttribute('id');
        final d = node.getAttribute('d');
        if (id == null || d == null) continue;
        try {
          final p = parseSvgPathData(d);
          paths[id] = p;
        } catch (_) {
          // skip malformed paths
        }
      }

      if (paths.isEmpty) {
        throw Exception('В SVG не найдены <path id="..." d="..."> элементы');
      }

      setState(() {
        _paths = paths;
        _loading = false;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_error != null) {
      return Center(
        child: Text(
          'Ошибка загрузки карты:\n$_error',
          textAlign: TextAlign.center,
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        final childSize = Size(constraints.maxWidth, constraints.maxHeight);
        return Stack(
          fit: StackFit.expand,
          children: [
            CustomPaint(
              painter: _MapPainter(
                paths: _paths,
                viewBox: _viewBox,
                colorForRegion: widget.colorForRegion,
                labels: widget.labels,
                strokeColor: widget.strokeColor,
              ),
              size: childSize,
            ),
            // Tap hit layer + pulse overlay
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTapDown: (details) {
                  final box = context.findRenderObject() as RenderBox?;
                  if (box == null) return;
                  final local = box.globalToLocal(details.globalPosition);
                  _pulseScreenPos = local;
                  // No external transform: use local directly
                  final id = _hitTest(local, childSize);
                  if (id != null) {
                    final ok = widget.onTapRegion(id);
                    if (ok) {
                      _plusPos = local;
                      _plusCtrl.forward(from: 0);
                    }
                  }
                  _pulseCtrl.forward(from: 0);
                  setState(() {});
                },
                child: AnimatedBuilder(
                  animation: Listenable.merge([_pulseCtrl, _plusCtrl]),
                  builder: (context, _) {
                    final cs = Theme.of(context).colorScheme;
                    return Stack(
                      children: [
                        if (_pulseScreenPos != null)
                          CustomPaint(
                            painter: _PulsePainter(
                              center: _pulseScreenPos!,
                              progress: _pulseCtrl.value,
                              color: Colors.white.withOpacity(0.7),
                            ),
                          ),
                        if (_plusPos != null)
                          CustomPaint(
                            painter: _PlusPainter(
                              origin: _plusPos!,
                              progress: _plusCtrl.value,
                              color: cs.primary,
                            ),
                          ),
                      ],
                    );
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _plusCtrl.dispose();
    super.dispose();
  }

  String? _hitTest(Offset localPos, Size size) {
    final vb = _viewBox ?? _computeBounds();
    final scale = _computeUniformScale(vb.size, size);
    final dx = (size.width - vb.width * scale) / 2 - vb.left * scale;
    final dy = (size.height - vb.height * scale) / 2 - vb.top * scale;

    final inverse = Matrix4.identity()
      ..translate(dx, dy)
      ..scale(scale, scale);
    final inv = Matrix4.inverted(inverse);
    final svgPoint = MatrixUtils.transformPoint(inv, localPos);

    for (final entry in _paths.entries) {
      if (entry.value.contains(svgPoint)) return entry.key;
    }
    return null;
  }

  Rect _computeBounds() {
    Rect? b;
    for (final p in _paths.values) {
      final pb = p.getBounds();
      b = b == null ? pb : b!.expandToInclude(pb);
    }
    return b ?? const Rect.fromLTWH(0, 0, 1000, 1000);
  }

  double _computeUniformScale(Size content, Size box) {
    if (content.width == 0 || content.height == 0) return 1.0;
    final sx = box.width / content.width;
    final sy = box.height / content.height;
    return math.min(sx, sy);
  }
}

class _MapPainter extends CustomPainter {
  _MapPainter({
    required this.paths,
    required this.viewBox,
    required this.colorForRegion,
    required this.labels,
    required this.strokeColor,
  });

  final Map<String, Path> paths;
  final Rect? viewBox;
  final RegionColorResolver colorForRegion;
  final Map<String, String> labels; // id -> localized text
  final Color strokeColor;

  @override
  void paint(Canvas canvas, Size size) {
    final vb = viewBox ?? _computeBounds();
    final scale = _computeUniformScale(vb.size, size);
    final dx = (size.width - vb.width * scale) / 2 - vb.left * scale;
    final dy = (size.height - vb.height * scale) / 2 - vb.top * scale;

    canvas.save();
    canvas.translate(dx, dy);
    canvas.scale(scale, scale);

    final fillPaint = Paint()..style = PaintingStyle.fill;
    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = math.min(vb.width, vb.height) / 300
      ..color = strokeColor;

    for (final entry in paths.entries) {
      fillPaint.color = colorForRegion(entry.key);
      canvas.drawPath(entry.value, fillPaint);
      canvas.drawPath(entry.value, strokePaint);

      final text = labels[entry.key];
      if (text != null && text.isNotEmpty) {
        final pos = _findPointInside(entry.value);
        if (pos != null) {
          // Clip to region so text doesn't bleed into neighbours
          canvas.save();
          canvas.clipPath(entry.value);
          final bounds = entry.value.getBounds();
          final fs = _fontSizeFor(bounds);
          final tp = TextPainter(
            text: TextSpan(
              text: text,
              style: TextStyle(
                color: Colors.black.withOpacity(0.85),
                fontSize: fs,
                fontWeight: FontWeight.w700,
                shadows: const [
                  Shadow(
                    blurRadius: 2,
                    color: Colors.white,
                    offset: Offset(0, 0),
                  ),
                ],
              ),
            ),
            textAlign: TextAlign.center,
            textDirection: TextDirection.ltr,
            maxLines: 1,
            ellipsis: '…',
          );
          tp.layout(minWidth: 0);
          final offset = pos - Offset(tp.width / 2, tp.height / 2);
          tp.paint(canvas, offset);
          canvas.restore();
        }
      }
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _MapPainter oldDelegate) {
    return oldDelegate.paths != paths ||
        oldDelegate.strokeColor != strokeColor ||
        oldDelegate.viewBox != viewBox ||
        oldDelegate.colorForRegion != colorForRegion ||
        !mapEquals(oldDelegate.labels, labels);
  }

  Rect _computeBounds() {
    Rect? b;
    for (final p in paths.values) {
      final pb = p.getBounds();
      b = b == null ? pb : b!.expandToInclude(pb);
    }
    return b ?? const Rect.fromLTWH(0, 0, 1000, 1000);
  }

  double _computeUniformScale(Size content, Size box) {
    if (content.width == 0 || content.height == 0) return 1.0;
    final sx = box.width / content.width;
    final sy = box.height / content.height;
    return math.min(sx, sy);
  }

  double _fontSizeFor(Rect b) {
    final shortest = math.min(b.width, b.height);
    final fs = shortest * 0.18; // 18% of the smaller dimension
    return fs.clamp(8.0, 28.0);
  }

  Offset? _findPointInside(Path p) {
    final b = p.getBounds();
    Offset c = b.center;
    if (p.contains(c)) return c;
    final rBase = math.min(b.width, b.height) * 0.1;
    for (int ring = 1; ring <= 6; ring++) {
      final r = rBase * ring;
      for (int i = 0; i < 24; i++) {
        final ang = (i / 24.0) * 2 * math.pi;
        final cand = c + Offset(math.cos(ang), math.sin(ang)) * r;
        if (p.contains(cand)) return cand;
      }
    }
    return c; // fallback
  }
}

class _PulsePainter extends CustomPainter {
  _PulsePainter({
    required this.center,
    required this.progress,
    required this.color,
  });
  final Offset center;
  final double progress; // 0..1
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final maxRadius = size.shortestSide * 0.08; // ~8% of min dimension
    final radius = (0.4 + 0.6 * progress) * maxRadius;
    final alpha = (1.0 - progress).clamp(0.0, 1.0);
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 3.0 * (1.0 - 0.5 * progress)
      ..color = color.withOpacity(alpha);
    canvas.drawCircle(center, radius, paint);
  }

  @override
  bool shouldRepaint(covariant _PulsePainter oldDelegate) {
    return oldDelegate.center != center ||
        oldDelegate.progress != progress ||
        oldDelegate.color != color;
  }
}

class _PlusPainter extends CustomPainter {
  _PlusPainter({
    required this.origin,
    required this.progress,
    required this.color,
  });
  final Offset origin;
  final double progress; // 0..1
  final Color color;

  @override
  void paint(Canvas canvas, Size size) {
    final dy = 40.0 * progress; // move up
    final opacity = (1.0 - progress).clamp(0.0, 1.0);
    final text = '+1';
    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color.withOpacity(opacity),
          fontSize: 22 + 6 * (1 - progress),
          fontWeight: FontWeight.w800,
          shadows: const [
            Shadow(blurRadius: 2, color: Colors.black26, offset: Offset(0, 1)),
          ],
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
    return oldDelegate.origin != origin ||
        oldDelegate.progress != progress ||
        oldDelegate.color != color;
  }
}
