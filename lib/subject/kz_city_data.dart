/// Строковые ID из твоего JS-кода: "0"…"29"
class CityId {
  static const astana = "0";
  static const almaty = "1";
  static const shymkent = "2";
  static const karaganda = "3";
  static const aktobe = "4";
  static const atyrau = "5";
  static const aktau = "6";
  static const oral = "7";
  static const kostanay = "8";
  static const petropavl = "9";
  static const kokshetau = "10";
  static const pavlodar = "11";
  static const oskemen = "12";
  static const semey = "13";
  static const ekibastuz = "14";
  static const temirtau = "15";
  static const zhezkazgan = "16";
  static const balkhash = "17";
  static const taldykorgan = "18";
  static const kyzylorda = "19";
  static const turkistan = "20";
  static const taraz = "21";
  static const saryagash = "22";
  static const baikonur = "23";
  static const rudny = "24";
  static const stepnogorsk = "25";
  static const talgar = "26";
  static const kaskelen = "27";
  static const kulsary = "28";
  static const zhanaozen = "29";
}

class City {
  final String id;
  final String name;
  final double lat;
  final double lng;
  final double? size; // если в исходнике указан size

  const City({
    required this.id,
    required this.name,
    required this.lat,
    required this.lng,
    this.size,
  });
}

/// Данные 1-в-1 из simplemaps (ID → объект города)
const Map<String, City> kzCitiesById = {
  CityId.astana: City(id: CityId.astana, name: "Astana", lat: 51.169, lng: 71.449),
  CityId.almaty: City(id: CityId.almaty, name: "Almaty", lat: 43.238, lng: 76.889, size: 10),
  CityId.shymkent: City(id: CityId.shymkent, name: "Shymkent", lat: 42.314, lng: 69.59),
  CityId.karaganda: City(id: CityId.karaganda, name: "Karaganda", lat: 49.806, lng: 73.085),
  CityId.aktobe: City(id: CityId.aktobe, name: "Aktobe", lat: 50.283, lng: 57.167),
  CityId.atyrau: City(id: CityId.atyrau, name: "Atyrau", lat: 47.116, lng: 51.883),
  CityId.aktau: City(id: CityId.aktau, name: "Aktau", lat: 43.653, lng: 51.152),
  CityId.oral: City(id: CityId.oral, name: "Oral", lat: 51.222, lng: 51.386),
  CityId.kostanay: City(id: CityId.kostanay, name: "Kostanay", lat: 53.219, lng: 63.635),
  CityId.petropavl: City(id: CityId.petropavl, name: "Petropavl", lat: 54.88, lng: 69.16),
  CityId.kokshetau: City(id: CityId.kokshetau, name: "Kokshetau", lat: 53.3, lng: 69.404),
  CityId.pavlodar: City(id: CityId.pavlodar, name: "Pavlodar", lat: 52.287, lng: 76.973),
  CityId.oskemen: City(id: CityId.oskemen, name: "Oskemen", lat: 49.948, lng: 82.627),
  CityId.semey: City(id: CityId.semey, name: "Semey", lat: 50.431, lng: 80.251),
  CityId.ekibastuz: City(id: CityId.ekibastuz, name: "Ekibastuz", lat: 51.729, lng: 75.322),
  CityId.temirtau: City(id: CityId.temirtau, name: "Temirtau", lat: 50.054, lng: 72.964),
  CityId.zhezkazgan: City(id: CityId.zhezkazgan, name: "Zhezkazgan", lat: 47.802, lng: 67.711),
  CityId.balkhash: City(id: CityId.balkhash, name: "Balkhash", lat: 46.848, lng: 74.995),
  CityId.taldykorgan: City(id: CityId.taldykorgan, name: "Taldykorgan", lat: 45.017, lng: 78.367, size: 10),
  CityId.kyzylorda: City(id: CityId.kyzylorda, name: "Kyzylorda", lat: 44.848, lng: 65.482),
  CityId.turkistan: City(id: CityId.turkistan, name: "Turkistan", lat: 43.297, lng: 68.269),
  CityId.taraz: City(id: CityId.taraz, name: "Taraz", lat: 42.898, lng: 71.378),
  CityId.saryagash: City(id: CityId.saryagash, name: "Saryagash", lat: 41.454, lng: 69.175),
  CityId.baikonur: City(id: CityId.baikonur, name: "Baikonur", lat: 45.621, lng: 63.313),
  CityId.rudny: City(id: CityId.rudny, name: "Rudny", lat: 52.972, lng: 63.116),
  CityId.stepnogorsk: City(id: CityId.stepnogorsk, name: "Stepnogorsk", lat: 52.35, lng: 71.88),
  CityId.talgar: City(id: CityId.talgar, name: "Talgar", lat: 43.304, lng: 77.233, size: 10),
  CityId.kaskelen: City(id: CityId.kaskelen, name: "Kaskelen", lat: 43.204, lng: 76.625, size: 10),
  CityId.kulsary: City(id: CityId.kulsary, name: "Kulsary", lat: 46.954, lng: 54.019),
  CityId.zhanaozen: City(id: CityId.zhanaozen, name: "Zhanaozen", lat: 43.341, lng: 52.861),
};

/// Удобный список всех ID (если надо итерироваться)
const List<String> kzCityIds = [
  CityId.astana,
  CityId.almaty,
  CityId.shymkent,
  CityId.karaganda,
  CityId.aktobe,
  CityId.atyrau,
  CityId.aktau,
  CityId.oral,
  CityId.kostanay,
  CityId.petropavl,
  CityId.kokshetau,
  CityId.pavlodar,
  CityId.oskemen,
  CityId.semey,
  CityId.ekibastuz,
  CityId.temirtau,
  CityId.zhezkazgan,
  CityId.balkhash,
  CityId.taldykorgan,
  CityId.kyzylorda,
  CityId.turkistan,
  CityId.taraz,
  CityId.saryagash,
  CityId.baikonur,
  CityId.rudny,
  CityId.stepnogorsk,
  CityId.talgar,
  CityId.kaskelen,
  CityId.kulsary,
  CityId.zhanaozen,
];

// Локализованные названия городов
const Map<String, String> cityNameRuById = {
  '0': 'Астана',
  '1': 'Алматы',
  '2': 'Шымкент',
  '3': 'Караганда',
  '4': 'Актобе',
  '5': 'Атырау',
  '6': 'Актау',
  '7': 'Орал',
  '8': 'Костанай',
  '9': 'Петропавл',
  '10': 'Кокшетау',
  '11': 'Павлодар',
  '12': 'Усть-Каменогорск',
  '13': 'Семей',
  '14': 'Экибастуз',
  '15': 'Темиртау',
  '16': 'Жезказган',
  '17': 'Балхаш',
  '18': 'Талдыкорган',
  '19': 'Кызылорда',
  '20': 'Туркестан',
  '21': 'Тараз',
  '22': 'Сарыагаш',
  '23': 'Байконур',
  '24': 'Рудный',
  '25': 'Степногорск',
  '26': 'Талгар',
  '27': 'Каскелен',
  '28': 'Кульсары',
  '29': 'Жанаозен',
};

const Map<String, String> cityNameKkById = {
  '0': 'Астана',
  '1': 'Алматы',
  '2': 'Шымкент',
  '3': 'Қарағанды',
  '4': 'Ақтөбе',
  '5': 'Атырау',
  '6': 'Ақтау',
  '7': 'Орал',
  '8': 'Қостанай',
  '9': 'Петропавл',
  '10': 'Көкшетау',
  '11': 'Павлодар',
  '12': 'Өскемен',
  '13': 'Семей',
  '14': 'Екібастұз',
  '15': 'Теміртау',
  '16': 'Жезқазған',
  '17': 'Балқаш',
  '18': 'Талдықорған',
  '19': 'Қызылорда',
  '20': 'Түркістан',
  '21': 'Тараз',
  '22': 'Сарыағаш',
  '23': 'Байқоныр',
  '24': 'Рудный',
  '25': 'Степногорск',
  '26': 'Талғар',
  '27': 'Қаскелең',
  '28': 'Құлсары',
  '29': 'Жаңаөзен',
};

String cityNameForLocale(String id, String locale) {
  switch (locale) {
    case 'ru':
      return cityNameRuById[id] ?? kzCitiesById[id]?.name ?? id;
    case 'kk':
      return cityNameKkById[id] ?? kzCitiesById[id]?.name ?? id;
    default:
      return kzCitiesById[id]?.name ?? id;
  }
}

/// Индивидуальные поправки позиций (в долях от размеров карты)
/// dx, dy умножаются на ширину/высоту фоновой рамки SVG
const Map<String, List<double>> cityOffsetPct = {
  // Западные города — немного сдвигаем вправо, чтобы лечь на контур
  CityId.oral: [0.028, 0.000],
  CityId.atyrau: [0.018, 0.006],
  CityId.aktau: [0.020, -0.004],
  CityId.kulsary: [0.018, 0.004],

  // Алматинская агломерация — лёгкое разнесение
  CityId.almaty: [-0.006, 0.004],
  CityId.kaskelen: [-0.010, 0.002],
  CityId.talgar: [0.004, 0.004],

  // Восток — незначительная коррекция
  CityId.oskemen: [-0.004, -0.002],
  CityId.semey: [-0.003, -0.002],
};
