import 'dart:math' as math;
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show HapticFeedback;

import '../l10n/app_localizations.dart';

class MountainsPhysicalGeographyPage extends StatefulWidget {
  const MountainsPhysicalGeographyPage({super.key});

  @override
  State<MountainsPhysicalGeographyPage> createState() =>
      _MountainsPhysicalGeographyPageState();
}

class _MountainsPhysicalGeographyPageState
    extends State<MountainsPhysicalGeographyPage>
    with TickerProviderStateMixin {
  // Путь к карте (проверь имя файла: у вас было "lakes_counrty.png")
  static const String _mapAssetPath = 'lib/Images/lakes_counrty.png';

  // Геобокс Казахстана (как в других экранах)
  static const double _bboxMinLat = 40.56;
  static const double _bboxMaxLat = 55.59;
  static const double _bboxMinLng = 46.50;
  static const double _bboxMaxLng = 87.30;

  // Внутренние отступы от краёв карты (проекция lat/lng → XY)
  static const double _insetLeft = 0.02;
  static const double _insetRight = 0.02;
  static const double _insetTop = 0.03;
  static const double _insetBottom = 0.03;

  final double _tapSize = 20;

  Size? _mapImageSize;
  bool _mapSizeResolved = false;

  // Только id + координаты; названия берём из локализаций
  static const List<({String id, double lat, double lng})> _mountains = [
    (id: 'ile_alatau', lat: 43.2, lng: 77.2),
    (id: 'tien_shan', lat: 42.9, lng: 78.3),
    (id: 'zhetysu_alatau', lat: 45.0, lng: 79.5),
    (id: 'altai', lat: 49.2, lng: 85.5),
    (id: 'sauyr_tarbagatai', lat: 47.8, lng: 84.2),
    (id: 'bayanaul', lat: 50.8, lng: 75.7),
    (id: 'karkaraly', lat: 49.4, lng: 75.5),
    (id: 'ulytau', lat: 48.6, lng: 66.0),
    (id: 'kokshetau', lat: 53.2, lng: 69.4),
    (id: 'karatau', lat: 43.3, lng: 69.2),
    (id: 'mugodzhary', lat: 48.5, lng: 58.5),
    (id: 'mangystau', lat: 44.2, lng: 52.0),
    (id: 'kalba', lat: 49.4, lng: 83.0),
  ];

  late List<int> _order;
  int _currentIndex = 0;
  int _score = 0;
  final Set<String> _correct = {};
  final Set<String> _wrong = {};

  // Экранные центры (если пригодится для подсказок/анимаций)
  final Map<String, Offset> _screenCenters = {};

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

  void _startGame() {
    _score = 0;
    _correct.clear();
    _wrong.clear();
    _order = List<int>.generate(_mountains.length, (i) => i)..shuffle();
    _currentIndex = 0;
    setState(() {});
  }

  ({String id, double lat, double lng}) get _currentMountain =>
      _mountains[_order[_currentIndex]];

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(t.mountainsTitle),
        actions: [
          IconButton(
            tooltip: t.restart,
            icon: const Icon(Icons.refresh),
            onPressed: _startGame,
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
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
                    t.score(_score),
                    style: TextStyle(
                      color: cs.onPrimaryContainer,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const Spacer(),
                Text(t.findRange, style: const TextStyle(fontSize: 14)),
                const SizedBox(width: 8),
                Text(
                  _mountainName(t, _currentMountain.id),
                  style: TextStyle(
                    color: cs.primary,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: _buildMap(t),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMap(AppLocalizations t) {
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
                  errorBuilder: (context, _, __) =>
                      Center(child: Text(t.mapNotFound)),
                ),
              ),
              if (_mapSizeResolved && _mapImageSize != null)
                ..._buildOverlays(t, offsetX, offsetY, contentW, contentH),
            ],
          ),
        );
      },
    );
  }

  List<Widget> _buildOverlays(
    AppLocalizations t,
    double offsetX,
    double offsetY,
    double contentW,
    double contentH,
  ) {
    final innerLeft = offsetX + contentW * _insetLeft;
    final innerTop = offsetY + contentH * _insetTop;
    final innerW = contentW * (1 - _insetLeft - _insetRight);
    final innerH = contentH * (1 - _insetTop - _insetBottom);

    final centers = _mountains.map((m) {
      final x =
          ((m.lng - _bboxMinLng) / (_bboxMaxLng - _bboxMinLng)).clamp(
            0.0,
            1.0,
          ) *
          innerW;
      final y =
          ((_bboxMaxLat - m.lat) / (_bboxMaxLat - _bboxMinLat)).clamp(
            0.0,
            1.0,
          ) *
          innerH;
      return (id: m.id, pos: Offset(x, y));
    }).toList();

    // Разводим точки, чтобы не перекрывались
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

    final children = <Widget>[];
    final targetId = _currentMountain.id;
    for (final e in placed) {
      final id = e.id;
      final isCorrect = _correct.contains(id);
      final isWrong = _wrong.contains(id);
      final center = Offset(innerLeft + e.pos.dx, innerTop + e.pos.dy);
      _screenCenters[id] = center;

      children.add(
        Positioned(
          left: center.dx - _tapSize / 2,
          top: center.dy - _tapSize / 2,
          width: _tapSize,
          height: _tapSize,
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => _onTap(id, targetId),
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

  void _onTap(String tappedId, String targetId) {
    final ok = tappedId == targetId;
    if (ok) {
      setState(() {
        _score += 1;
        _correct.add(tappedId);
        _wrong.clear();
        if (_currentIndex < _order.length - 1) {
          _currentIndex += 1;
        } else {
          _showFinishDialog();
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

  Future<void> _showFinishDialog() async {
    final t = AppLocalizations.of(context)!;
    final total = _mountains.length;

    await showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.gameFinished),
        content: Text(t.score(_score)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(t.ok),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              _startGame();
            },
            child: Text(t.playAgain),
          ),
        ],
      ),
    );
  }

  // Локализованное имя по id
  String _mountainName(AppLocalizations t, String id) {
    switch (id) {
      case 'ile_alatau':
        return t.mountainIleAlatau;
      case 'tien_shan':
        return t.mountainTienShan;
      case 'zhetysu_alatau':
        return t.mountainZhetysuAlatau;
      case 'altai':
        return t.mountainAltai;
      case 'sauyr_tarbagatai':
        return t.mountainSauyrTarbagatai;
      case 'bayanaul':
        return t.mountainBayanaul;
      case 'karkaraly':
        return t.mountainKarkaraly;
      case 'ulytau':
        return t.mountainUlytau;
      case 'kokshetau':
        return t.mountainKokshetau;
      case 'karatau':
        return t.mountainKaratau;
      case 'mugodzhary':
        return t.mountainMugodzhary;
      case 'mangystau':
        return t.mountainMangystau;
      case 'kalba':
        return t.mountainKalba;
      default:
        return id;
    }
  }

  double _containScale(double srcW, double srcH, double dstW, double dstH) {
    if (srcW <= 0 || srcH <= 0) return 1.0;
    final sx = dstW / srcW;
    final sy = dstH / srcH;
    return sx < sy ? sx : sy;
  }
}
