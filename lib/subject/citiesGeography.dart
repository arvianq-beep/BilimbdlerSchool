import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../l10n/app_localizations.dart';

class CitiesGeographyPage extends StatefulWidget {
  const CitiesGeographyPage({super.key});

  @override
  State<CitiesGeographyPage> createState() => _CitiesGeographyPageState();
}

class _CitiesGeographyPageState extends State<CitiesGeographyPage> {
  // Major cities in Kazakhstan (approximate coordinates)
  final List<_City> _cities = const [
    _City(id: 'AST', nameEn: 'Astana', nameRu: 'Астана', nameKk: 'Астана', point: LatLng(51.1694, 71.4491)),
    _City(id: 'ALM', nameEn: 'Almaty', nameRu: 'Алматы', nameKk: 'Алматы', point: LatLng(43.2383, 76.9453)),
    _City(id: 'SHY', nameEn: 'Shymkent', nameRu: 'Шымкент', nameKk: 'Шымкент', point: LatLng(42.3155, 69.5869)),
    _City(id: 'KRG', nameEn: 'Karaganda', nameRu: 'Караганда', nameKk: 'Қарағанды', point: LatLng(49.8060, 73.0860)),
    _City(id: 'AKT', nameEn: 'Aktobe', nameRu: 'Актобе', nameKk: 'Ақтөбе', point: LatLng(50.2839, 57.1660)),
    _City(id: 'ATY', nameEn: 'Atyrau', nameRu: 'Атырау', nameKk: 'Атырау', point: LatLng(47.1160, 51.8830)),
    _City(id: 'KZO', nameEn: 'Kyzylorda', nameRu: 'Кызылорда', nameKk: 'Қызылорда', point: LatLng(44.8488, 65.4823)),
    _City(id: 'TRZ', nameEn: 'Taraz', nameRu: 'Тараз', nameKk: 'Тараз', point: LatLng(42.9000, 71.3667)),
    _City(id: 'PAV', nameEn: 'Pavlodar', nameRu: 'Павлодар', nameKk: 'Павлодар', point: LatLng(52.2870, 76.9674)),
    _City(id: 'OSK', nameEn: 'Oskemen', nameRu: 'Усть-Каменогорск', nameKk: 'Өскемен', point: LatLng(49.9480, 82.6280)),
    _City(id: 'SEM', nameEn: 'Semey', nameRu: 'Семей', nameKk: 'Семей', point: LatLng(50.4110, 80.2270)),
    _City(id: 'KOK', nameEn: 'Kokshetau', nameRu: 'Кокшетау', nameKk: 'Көкшетау', point: LatLng(53.2780, 69.3880)),
    _City(id: 'KST', nameEn: 'Kostanay', nameRu: 'Костанай', nameKk: 'Қостанай', point: LatLng(53.2140, 63.6240)),
    _City(id: 'PET', nameEn: 'Petropavl', nameRu: 'Петропавл', nameKk: 'Петропавл', point: LatLng(54.8750, 69.1640)),
    _City(id: 'ORL', nameEn: 'Oral', nameRu: 'Уральск', nameKk: 'Орал', point: LatLng(51.2200, 51.3810)),
    _City(id: 'AKU', nameEn: 'Aktau', nameRu: 'Актау', nameKk: 'Ақтау', point: LatLng(43.6480, 51.1720)),
    _City(id: 'TAL', nameEn: 'Taldykorgan', nameRu: 'Талдыкорган', nameKk: 'Талдықорған', point: LatLng(45.0150, 78.3730)),
    _City(id: 'TRK', nameEn: 'Turkestan', nameRu: 'Туркестан', nameKk: 'Түркістан', point: LatLng(43.2970, 68.2700)),
  ];

  // Sample ore deposits with custom icon paths (assets)
  final List<_Ore> _ores = const [
    _Ore(
      id: 'COP_ZHEZ',
      type: 'copper',
      titleEn: 'Zhezkazgan — Copper',
      titleRu: 'Жезказган — медь',
      titleKk: 'Жезқазған — мыс',
      point: LatLng(47.78, 67.71),
      assetPath: 'assets/icons/copper.png',
      descriptionEn: 'One of the largest copper deposits in Kazakhstan.',
      descriptionRu: 'Одно из крупнейших месторождений меди в Казахстане.',
      descriptionKk: 'Қазақстандағы ең ірі мыс кен орындарының бірі.',
    ),
    _Ore(
      id: 'COAL_EK',
      type: 'coal',
      titleEn: 'Ekibastuz — Coal',
      titleRu: 'Экибастуз — уголь',
      titleKk: 'Екібастұз — көмір',
      point: LatLng(51.73, 75.32),
      assetPath: 'assets/icons/coal.png',
      descriptionEn: 'Ekibastuz coal basin — major coal field.',
      descriptionRu: 'Экибастузский угольный бассейн — крупное месторождение угля.',
      descriptionKk: 'Екібастұз көмір бассейні — ірі көмір кен орны.',
    ),
    _Ore(
      id: 'COAL_KRG',
      type: 'coal',
      titleEn: 'Karaganda — Coal',
      titleRu: 'Караганда — уголь',
      titleKk: 'Қарағанды — көмір',
      point: LatLng(49.80, 73.10),
      assetPath: 'assets/icons/coal.png',
      descriptionEn: 'Karaganda coal basin — historically significant.',
      descriptionRu: 'Карагандинский угольный бассейн — исторически значим.',
      descriptionKk: 'Қарағанды көмір бассейні — тарихи маңызды.',
    ),
  ];

  late List<_City> _remaining;
  _City? _target;
  final Set<String> _correct = {};
  final Set<String> _wrong = {};
  int _score = 0;
  int _attempts = 0;

  @override
  void initState() {
    super.initState();
    _remaining = _cities.toList()..shuffle();
    _nextTarget();
  }

  void _nextTarget() {
    setState(() {
      _target = _remaining.isNotEmpty ? _remaining.first : null;
    });
    if (_target == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _showFinishDialog());
    }
  }

  void _restart() {
    setState(() {
      _correct.clear();
      _wrong.clear();
      _score = 0;
      _attempts = 0;
      _remaining = _cities.toList()..shuffle();
      _nextTarget();
    });
  }

  void _tapCity(_City c) {
    if (_target == null) return;
    _attempts += 1;
    if (c.id == _target!.id) {
      _correct.add(c.id);
      _wrong.clear();
      _score += 1;
      _remaining.removeAt(0);
      _nextTarget();
    } else {
      setState(() => _wrong
        ..clear()
        ..add(c.id));
    }
  }

  String _lang(BuildContext context) => Localizations.localeOf(context).languageCode;

  String _cityName(BuildContext context, _City c) {
    switch (_lang(context)) {
      case 'ru':
        return c.nameRu;
      case 'kk':
        return c.nameKk;
      default:
        return c.nameEn;
    }
  }

  String _selectCityLabel(BuildContext context, _City? c) {
    if (c == null) {
      switch (_lang(context)) {
        case 'ru':
          return 'Готово!';
        case 'kk':
          return 'Дайын!';
        default:
          return 'Done!';
      }
    }
    final city = _cityName(context, c);
    switch (_lang(context)) {
      case 'ru':
        return 'Выберите город: $city';
      case 'kk':
        return 'Қаланы таңдаңыз: $city';
      default:
        return 'Select city: $city';
    }
  }

  String _scoreLabel(BuildContext context) {
    switch (_lang(context)) {
      case 'ru':
        return 'Очки: $_score';
      case 'kk':
        return 'Ұпай: $_score';
      default:
        return 'Score: $_score';
    }
  }

  String _remainingLabel(BuildContext context) {
    final n = _remaining.length;
    switch (_lang(context)) {
      case 'ru':
        return 'Осталось: $n';
      case 'kk':
        return 'Қалды: $n';
      default:
        return 'Remaining: $n';
    }
  }

  String _restartLabel(BuildContext context) {
    switch (_lang(context)) {
      case 'ru':
        return 'Заново';
      case 'kk':
        return 'Қайта бастау';
      default:
        return 'Restart';
    }
  }

  String _backToMenuLabel(BuildContext context) {
    switch (_lang(context)) {
      case 'ru':
        return 'В меню';
      case 'kk':
        return 'Мәзірге оралу';
      default:
        return 'Back to menu';
    }
  }

  void _showFinishDialog() {
    if (!mounted) return;
    final t = AppLocalizations.of(context)!;
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.cities),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(_scoreLabel(context)),
            const SizedBox(height: 8),
            Text(_remainingLabel(context)),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              Navigator.of(context).pop();
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
      ),
    );
  }

  void _showOreDialog(_Ore ore) {
    showDialog<void>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(ore.title(context)),
        content: Text(ore.description(context)),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final t = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(t.cities)),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _restart,
        label: Text(_restartLabel(context)),
        icon: const Icon(Icons.refresh),
      ),
      body: Stack(
        children: [
          // Map
          FlutterMap(
            options: MapOptions(
              initialCenter: const LatLng(48.0, 67.0),
              initialZoom: 4.5,
              interactionOptions: const InteractionOptions(
                flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
              ),
            ),
            children: [
              TileLayer(
                urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                userAgentPackageName: 'com.example.flutter_bilimdler',
              ),
              // City markers
              MarkerLayer(
                markers: _cities.map<Marker>((c) {
                  final isCorrect = _correct.contains(c.id);
                  final isWrong = _wrong.contains(c.id);
                  final color = isCorrect
                      ? Colors.green
                      : isWrong
                          ? Colors.red
                          : cs.primary;
                  return Marker(
                    point: c.point,
                    width: 36,
                    height: 36,
                    alignment: Alignment.center,
                    child: _TapMarker(
                      onTap: () => _tapCity(c),
                      child: _Dot(color: color),
                    ),
                  );
                }).toList(),
              ),
              // Ore markers with custom icons
              MarkerLayer(
                markers: _ores.map<Marker>((o) {
                  return Marker(
                    point: o.point,
                    width: 40,
                    height: 40,
                    alignment: Alignment.center,
                    child: _TapMarker(
                      onTap: () => _showOreDialog(o),
                      child: _OreIcon(assetPath: o.assetPath, fallbackColor: cs.tertiary),
                    ),
                  );
                }).toList(),
              ),
            ],
          ),

          // Top-left score chip
          Positioned(
            top: 12,
            left: 12,
            child: _Chip(text: _scoreLabel(context)),
          ),
          // Top-left remaining under score
          Positioned(
            top: 56,
            left: 12,
            child: _Chip(text: _remainingLabel(context)),
          ),
          // Bottom target prompt
          Positioned(
            left: 12,
            right: 12,
            bottom: 16,
            child: _Prompt(text: _selectCityLabel(context, _target)),
          ),
        ],
      ),
    );
  }
}

class _City {
  final String id;
  final String nameEn;
  final String nameRu;
  final String nameKk;
  final LatLng point;
  const _City({
    required this.id,
    required this.nameEn,
    required this.nameRu,
    required this.nameKk,
    required this.point,
  });
}

class _Ore {
  final String id;
  final String type; // 'copper' | 'coal' | ...
  final String titleEn;
  final String titleRu;
  final String titleKk;
  final String descriptionEn;
  final String descriptionRu;
  final String descriptionKk;
  final LatLng point;
  final String assetPath; // assets/icons/copper.png, etc.
  const _Ore({
    required this.id,
    required this.type,
    required this.titleEn,
    required this.titleRu,
    required this.titleKk,
    required this.descriptionEn,
    required this.descriptionRu,
    required this.descriptionKk,
    required this.point,
    required this.assetPath,
  });

  String title(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    switch (lang) {
      case 'ru':
        return titleRu;
      case 'kk':
        return titleKk;
      default:
        return titleEn;
    }
  }

  String description(BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    switch (lang) {
      case 'ru':
        return descriptionRu;
      case 'kk':
        return descriptionKk;
      default:
        return descriptionEn;
    }
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.color});
  final Color color;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: color,
        shape: BoxShape.circle,
        boxShadow: const [
          BoxShadow(blurRadius: 4, color: Colors.black26, offset: Offset(0, 1)),
        ],
      ),
      width: 14,
      height: 14,
    );
  }
}

class _OreIcon extends StatelessWidget {
  const _OreIcon({required this.assetPath, required this.fallbackColor});
  final String assetPath;
  final Color fallbackColor;
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(2),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        boxShadow: const [
          BoxShadow(blurRadius: 4, color: Colors.black26, offset: Offset(0, 1)),
        ],
      ),
      child: Image.asset(
        assetPath,
        width: 28,
        height: 28,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => Icon(Icons.circle, color: fallbackColor, size: 24),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: cs.surface.withOpacity(0.9),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: cs.outline.withOpacity(0.35)),
      ),
      child: Text(text, style: TextStyle(color: cs.onSurface, fontWeight: FontWeight.w600)),
    );
  }
}

class _Prompt extends StatelessWidget {
  const _Prompt({required this.text});
  final String text;
  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: cs.surface.withOpacity(0.95),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: cs.outline.withOpacity(0.35)),
      ),
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(color: cs.onSurface, fontSize: 16, fontWeight: FontWeight.w600),
      ),
    );
  }
}

class _TapMarker extends StatelessWidget {
  const _TapMarker({required this.onTap, required this.child});
  final VoidCallback onTap;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: onTap, child: child);
  }
}
