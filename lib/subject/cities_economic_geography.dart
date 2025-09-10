import 'dart:async';
import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart' show MatrixUtils;
import 'package:flutter/services.dart' show rootBundle, HapticFeedback;
import 'package:vector_math/vector_math_64.dart' show Matrix4;
import 'package:confetti/confetti.dart';
import 'package:xml/xml.dart' as xml;
import 'package:path_drawing/path_drawing.dart';

import '../l10n/app_localizations.dart';
import 'kz_city_data.dart';

class CitiesEconomicGeographyPage extends StatefulWidget {
  const CitiesEconomicGeographyPage({super.key});

  @override
  State<CitiesEconomicGeographyPage> createState() => _CitiesEconomicGeographyPageState();
}

class _CitiesEconomicGeographyPageState extends State<CitiesEconomicGeographyPage> {
  static bool _rulesShownOnce = false;

  final List<String> _ids = kzCityIds.toList();
  late List<String> _remaining;
  String? _targetId;
  int _score = 0;
  final Set<String> _correct = {};
  final Set<String> _wrong = {};
  int _attempts = 0;
  bool _endShown = false;
  late final ConfettiController _confettiCtrl = ConfettiController(duration: const Duration(seconds: 3));

  @override
  void initState() {
    super.initState();
    _remaining = _ids.toList()..shuffle();
    _nextTarget();
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
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        try { HapticFeedback.vibrate(); } catch (_) {}
        _confettiCtrl.play();
        _showFinishDialog(context);
      });
    }
  }

  bool _onTap(String id) {
    _attempts += 1;
    if (_targetId == null) return false;
    if (id == _targetId) {
      _correct.add(id);
      _wrong.clear();
      _score += 1;
      _remaining.remove(id);
      _nextTarget();
      return true;
    } else {
      _wrong.add(id);
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
      _remaining = _ids.toList()..shuffle();
      _nextTarget();
    });
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context)!;
    final targetName = _cityName(context, _targetId);
    final finished = _targetId == null;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.cities),
        actions: [
          IconButton(
            tooltip: _rulesButtonLabel(context),
            icon: const Icon(Icons.help_outline),
            onPressed: () => _showRulesDialog(context),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
              child: Container(
                decoration: BoxDecoration(
                  color: cs.surface,
                  border: Border.all(color: cs.outlineVariant),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: cs.primaryContainer,
                            borderRadius: BorderRadius.circular(999),
                          ),
                          child: Text(
                            _scoreLabel(context, _score),
                            style: TextStyle(color: cs.onPrimaryContainer, fontWeight: FontWeight.w700),
                          ),
                        ),
                        const Spacer(),
                        FilledButton.tonal(onPressed: _restart, child: Text(_restartLabel(context))),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Text.rich(
                      TextSpan(children: [
                        TextSpan(
                          text: finished ? '' : _selectLabel(context, ''),
                          style: TextStyle(color: cs.onSurface, fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        if (!finished)
                          TextSpan(
                            text: targetName,
                            style: TextStyle(color: cs.primary, fontWeight: FontWeight.w800, fontSize: 18),
                          ),
                      ]),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: _SvgHitMap(
                  svgAssetPath: 'lib/Images/cities.svg',
                  filterIds: _ids.toSet(),
                  colorForId: (id) {
                    if (_correct.contains(id)) return cs.primary.withOpacity(0.85);
                    if (_wrong.contains(id)) return Theme.of(context).colorScheme.error.withOpacity(0.6);
                    return cs.primaryContainer.withOpacity(0.55);
                  },
                  onTapId: _onTap,
                  strokeColor: cs.onSurface.withOpacity(0.35),
                  labels: { for (final id in _ids) id: _cityName(context, id) },
                  geoLatLng: {
                    for (final id in _ids)
                      id: Offset(kzCitiesById[id]!.lng, kzCitiesById[id]!.lat),
                  },
                  backgroundFill: cs.secondaryContainer.withOpacity(0.25),
                ),
              ),
            ),
            SizedBox(
              height: 0,
              child: ConfettiWidget(
                confettiController: _confettiCtrl,
                blastDirectionality: BlastDirectionality.explosive,
                emissionFrequency: 0.02,
                numberOfParticles: 12,
                maxBlastForce: 20,
                minBlastForce: 6,
                gravity: 0.3,
                colors: [cs.primary, cs.secondary, cs.tertiary, Colors.white],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _locale(BuildContext context) => Localizations.localeOf(context).languageCode;

  String _cityName(BuildContext context, String? id) {
    if (id == null) return '';
    final lang = _locale(context);
    return cityNameForLocale(id, lang);
  }

  String _selectLabel(BuildContext context, String _) {
    switch (_locale(context)) {
      case 'ru':
        return 'Выберите город: ';
      case 'kk':
        return 'Қаланы таңдаңыз: ';
      default:
        return 'Select city: ';
    }
  }

  String _scoreLabel(BuildContext context, int score) {
    switch (_locale(context)) {
      case 'ru':
        return 'Очки: $score';
      case 'kk':
        return 'Ұпай: $score';
      default:
        return 'Score: $score';
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

  String _rulesButtonLabel(BuildContext context) {
    switch (_locale(context)) {
      case 'ru':
        return 'Правила';
      case 'kk':
        return 'Ереже';
      default:
        return 'Rules';
    }
  }

  String _rulesTitle(BuildContext context) {
    switch (_locale(context)) {
      case 'ru':
        return 'Правила игры';
      case 'kk':
        return 'Ойын ережесі';
      default:
        return 'Game Rules';
    }
  }

  String _rulesText(BuildContext context) {
    switch (_locale(context)) {
      case 'ru':
        return '• Нажмите на запрошенный город на карте.\n• Верный выбор даёт +1 очко.\n• Неверные выделяются красным.\n• После верного выбора неверные подсветки сбрасываются.\n• Кнопка «Заново» начинает игру сначала.';
      case 'kk':
        return '• Картамен көрсетілген қаланы таңданыз.\n• Дұрыс таңдау +1 ұпай береді.\n• Қате таңдау қызылмен белгіленеді.\n• Дұрыс таңдаудан кейін қате белгілер тазартылады.\n• «Қайта бастау» ойынды жаңадан бастайды.';
      default:
        return '• Pick the requested city on the map.\n• Correct pick gives +1 point.\n• Wrong picks are highlighted in red.\n• After a correct pick, wrong highlights are cleared.\n• Use Restart to start over.';
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
        return 'Общий счёт: $score / $total';
      case 'kk':
        return 'Жалпы ұпай: $score / $total';
      default:
        return 'Total score: $score / $total';
    }
  }

  void _showFinishDialog(BuildContext context) {
    final total = _ids.length;
    final score = _score;
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (ctx) {
        return AlertDialog(
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
          content: Text(_totalScoreLabel(context, score, total)),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(ctx).pop();
                Navigator.of(context).pop();
              },
              child: Text(MaterialLocalizations.of(context).backButtonTooltip ?? 'Back'),
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
}

typedef IdColorResolver = Color Function(String id);

class _SvgHitMap extends StatefulWidget {
  const _SvgHitMap({
    required this.svgAssetPath,
    required this.onTapId,
    required this.colorForId,
    required this.labels,
    required this.strokeColor,
    required this.filterIds,
    this.geoLatLng,
    this.backgroundFill,
  });

  final String svgAssetPath;
  final bool Function(String id) onTapId;
  final IdColorResolver colorForId;
  final Map<String, String> labels;
  final Color strokeColor;
  final Set<String> filterIds;
  // Optional: fallback geographic coordinates per id (lon,lat)
  final Map<String, Offset>? geoLatLng;
  final Color? backgroundFill;

  @override
  State<_SvgHitMap> createState() => _SvgHitMapState();
}

class _SvgHitMapState extends State<_SvgHitMap> {
  Map<String, Path> _paths = {};
  final List<Path> _background = [];
  Rect? _viewBox;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    unawaited(_load());
  }

  Future<void> _load() async {
    try {
      final svgString = await rootBundle.loadString(widget.svgAssetPath);
      final doc = xml.XmlDocument.parse(svgString);
      final svgEl = doc.rootElement;

      final vbAttr = svgEl.getAttribute('viewBox') ?? svgEl.getAttribute('viewbox');
      if (vbAttr != null) {
        final nums = vbAttr.split(RegExp(r'[\s,]+')).where((e) => e.isNotEmpty).toList();
        if (nums.length == 4) {
          final x = double.tryParse(nums[0]) ?? 0;
          final y = double.tryParse(nums[1]) ?? 0;
          final w = double.tryParse(nums[2]) ?? 1000;
          final h = double.tryParse(nums[3]) ?? 1000;
          _viewBox = Rect.fromLTWH(x, y, w, h);
        }
      }

      final Map<String, Path> paths = {};

      // Новая стратегия: рекурсивно обходим дерево, применяя transform из <g> и элементов
      String? _normalizeCityId(String? raw) {
        if (raw == null) return null;
        final m = RegExp(r'(\d+)$').firstMatch(raw);
        return m != null ? m.group(1) : null;
      }

      void walk(xml.XmlElement el, Matrix4 parentTf) {
        Matrix4 tf = parentTf.clone();
        final tr = el.getAttribute('transform');
        if (tr != null) {
          tf = tf.multiplied(_parseTransform(tr));
        }

        switch (el.name.local) {
          case 'path':
            final d = el.getAttribute('d');
            if (d != null) {
              try {
                final id = _normalizeCityId(el.getAttribute('id'));
                Path p = parseSvgPathData(d);
                p = p.transform(tf.storage);
                if (id != null && widget.filterIds.contains(id)) {
                  paths[id] = p;
                } else {
                  _background.add(p);
                }
              } catch (_) {}
            }
            break;
          case 'circle':
            final id = _normalizeCityId(el.getAttribute('id'));
            final cx = double.tryParse(el.getAttribute('cx') ?? '');
            final cy = double.tryParse(el.getAttribute('cy') ?? '');
            final r = double.tryParse(el.getAttribute('r') ?? '');
            if (cx != null && cy != null && r != null) {
              Path p = Path()..addOval(Rect.fromCircle(center: Offset(cx, cy), radius: r));
              p = p.transform(tf.storage);
              if (id != null && widget.filterIds.contains(id)) {
                paths[id] = p;
              }
            }
            break;
          case 'ellipse':
            final id = _normalizeCityId(el.getAttribute('id'));
            final cx = double.tryParse(el.getAttribute('cx') ?? '');
            final cy = double.tryParse(el.getAttribute('cy') ?? '');
            final rx = double.tryParse(el.getAttribute('rx') ?? '');
            final ry = double.tryParse(el.getAttribute('ry') ?? '');
            if (cx != null && cy != null && rx != null && ry != null) {
              Path p = Path()..addOval(Rect.fromCenter(center: Offset(cx, cy), width: rx * 2, height: ry * 2));
              p = p.transform(tf.storage);
              if (id != null && widget.filterIds.contains(id)) {
                paths[id] = p;
              }
            }
            break;
          case 'rect':
            final id = _normalizeCityId(el.getAttribute('id'));
            final isClickable = id != null && widget.filterIds.contains(id);
            final x = double.tryParse(el.getAttribute('x') ?? '');
            final y = double.tryParse(el.getAttribute('y') ?? '');
            final w = double.tryParse(el.getAttribute('width') ?? '');
            final h = double.tryParse(el.getAttribute('height') ?? '');
            if (x != null && y != null && w != null && h != null) {
              if (isClickable) {
                Path p = Path()..addRect(Rect.fromLTWH(x, y, w, h));
                p = p.transform(tf.storage);
                paths[id] = p;
              }
            }
            break;
          default:
            break;
        }

        for (final child in el.children.whereType<xml.XmlElement>()) {
          walk(child, tf);
        }
      }

      walk(svgEl, Matrix4.identity());

      if (paths.isEmpty) {
        // Fallback: generate small circles at provided geo coordinates
        final coords = widget.geoLatLng;
        if (coords != null && coords.isNotEmpty) {
          // Determine bounds from coordinates
          double minLon = double.infinity, maxLon = -double.infinity;
          double minLat = double.infinity, maxLat = -double.infinity;
          coords.values.forEach((o) {
            final lon = o.dx, lat = o.dy;
            if (lon < minLon) minLon = lon;
            if (lon > maxLon) maxLon = lon;
            if (lat < minLat) minLat = lat;
            if (lat > maxLat) maxLat = lat;
          });
          // Используем границы фона (карты), чтобы сопоставить долготу/широту
          Rect vb = _viewBox ?? const Rect.fromLTWH(0, 0, 1000, 600);
          if (_background.isNotEmpty) {
            Rect? bb;
            for (final p in _background) {
              bb = bb == null ? p.getBounds() : bb!.expandToInclude(p.getBounds());
            }
            if (bb != null && bb.width > 0 && bb.height > 0) {
              vb = bb;
            }
          }
          final r = math.min(vb.width, vb.height) * 0.024; // ~2.4% — баланс удобства/точности
          final Map<String, Offset> centers = {};
          int i = 0;
          for (final entry in coords.entries) {
            final id = entry.key;
            final lon = entry.value.dx;
            final lat = entry.value.dy;
            // Simple equirectangular mapping
            final x = vb.left + (lon - minLon) / (maxLon - minLon) * vb.width;
            final y = vb.top + (maxLat - lat) / (maxLat - minLat) * vb.height;
            // Индивидуальная коррекция в долях размеров
            final offPct = cityOffsetPct[id];
            Offset c = Offset(x, y);
            if (offPct != null && offPct.length == 2) {
              c = c + Offset(vb.width * offPct[0], vb.height * offPct[1]);
            }
            // лёгкий детерминированный сдвиг, чтобы точки меньше накладывались
            final ang = (i * 37 % 360) * math.pi / 180.0;
            final jitter = r * 0.15;
            c = c + Offset(math.cos(ang) * jitter, math.sin(ang) * jitter);
            // Раздвижка: если близко к уже добавленным точкам — увеличим сдвиг
            for (final prev in centers.values) {
              final d = (c - prev).distance;
              if (d < r * 1.8) {
                c = c + Offset(math.cos(ang), math.sin(ang)) * (r * 0.6);
              }
            }
            // Clamp внутри рамки
            final cx = c.dx.clamp(vb.left + r, vb.right - r);
            final cy = c.dy.clamp(vb.top + r, vb.bottom - r);
            c = Offset(cx.toDouble(), cy.toDouble());
            centers[id] = c;
            final p = Path()..addOval(Rect.fromCircle(center: c, radius: r));
            if (widget.filterIds.contains(id)) {
              paths[id] = p;
            }
            i++;
          }
        }
        if (paths.isEmpty) {
          throw Exception('No clickable shapes with id found in SVG.');
        }
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
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_error != null) return Center(child: Text(_error!));

    return LayoutBuilder(builder: (context, constraints) {
      final childSize = Size(constraints.maxWidth, constraints.maxHeight);
      return Stack(
        fit: StackFit.expand,
        children: [
          CustomPaint(
            painter: _CitiesPainter(
              paths: _paths,
              viewBox: _viewBox,
              colorForId: widget.colorForId,
              strokeColor: widget.strokeColor,
              background: _background,
              backgroundFill: widget.backgroundFill ?? const Color(0xFFEAF3FF),
            ),
            size: childSize,
          ),
          Positioned.fill(
            child: GestureDetector(
              behavior: HitTestBehavior.opaque,
              onTapDown: (details) {
                final box = context.findRenderObject() as RenderBox?;
                if (box == null) return;
                final local = box.globalToLocal(details.globalPosition);
                final id = _hitTest(local, childSize);
                if (id != null) {
                  widget.onTapId(id);
                }
              },
            ),
          ),
        ],
      );
    });
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
    const marginFactor = 0.92; // немного уменьшаем, чтобы карта полностью влезала
    return math.min(sx, sy) * marginFactor;
  }
}

class _CitiesPainter extends CustomPainter {
  _CitiesPainter({
    required this.paths,
    required this.viewBox,
    required this.colorForId,
    required this.strokeColor,
    required this.background,
    required this.backgroundFill,
  });

  final Map<String, Path> paths;
  final Rect? viewBox;
  final IdColorResolver colorForId;
  final Color strokeColor;
  final List<Path> background;
  final Color backgroundFill;

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
      ..strokeWidth = math.min(vb.width, vb.height) / 400
      ..color = strokeColor;

    // Draw background map first
    if (background.isNotEmpty) {
      final bgStroke = Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = math.min(vb.width, vb.height) / 500
        ..color = strokeColor.withOpacity(0.35);
      for (final p in background) {
        fillPaint.color = backgroundFill;
        canvas.drawPath(p, fillPaint);
        canvas.drawPath(p, bgStroke);
      }
    }

    for (final entry in paths.entries) {
      fillPaint.color = colorForId(entry.key);
      canvas.drawPath(entry.value, fillPaint);
      canvas.drawPath(entry.value, strokePaint);
    }

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _CitiesPainter oldDelegate) {
    return oldDelegate.paths != paths ||
        oldDelegate.viewBox != viewBox ||
        oldDelegate.strokeColor != strokeColor ||
        oldDelegate.colorForId != colorForId;
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
    const marginFactor = 0.92; // небольшие поля по краям
    return math.min(sx, sy) * marginFactor;
  }
}

// --- Transform helpers -------------------------------------------------------

Matrix4 _parseTransform(String tr) {
  final re = RegExp(r'(matrix|translate|scale|rotate)\s*\(([^\)]*)\)');
  Matrix4 out = Matrix4.identity();
  for (final m in re.allMatches(tr)) {
    final type = m.group(1) ?? '';
    final params = (m.group(2) ?? '')
        .split(RegExp(r'[\s,]+'))
        .where((e) => e.isNotEmpty)
        .map((e) => double.tryParse(e) ?? 0)
        .toList();
    switch (type) {
      case 'matrix':
        if (params.length >= 6) {
          final a = params[0], b = params[1], c = params[2], d = params[3], e = params[4], f = params[5];
          final m4 = Matrix4(a, b, 0, 0, c, d, 0, 0, 0, 0, 1, 0, e, f, 0, 1);
          out = out.multiplied(m4);
        }
        break;
      case 'translate':
        final tx = params.isNotEmpty ? params[0] : 0.0;
        final ty = params.length > 1 ? params[1] : 0.0;
        out = out.multiplied(Matrix4.translationValues(tx, ty, 0));
        break;
      case 'scale':
        final sx = params.isNotEmpty ? params[0] : 1.0;
        final sy = params.length > 1 ? params[1] : sx;
        out = out.multiplied(Matrix4.diagonal3Values(sx, sy, 1));
        break;
      case 'rotate':
        final ang = (params.isNotEmpty ? params[0] : 0.0) * math.pi / 180.0;
        final cosA = math.cos(ang), sinA = math.sin(ang);
        final m4 = Matrix4(cosA, sinA, 0, 0, -sinA, cosA, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1);
        out = out.multiplied(m4);
        break;
    }
  }
  return out;
}
