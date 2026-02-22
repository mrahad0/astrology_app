// lib/models/chart_models/planet_model.dart
class PlanetModel {
  final String name;
  final String sign;
  final double degree;
  final String house;
  final bool retrograde;
  final String element;
  final String quality;
  final String positionStr;

  PlanetModel({
    required this.name,
    required this.sign,
    required this.degree,
    required this.house,
    required this.retrograde,
    required this.element,
    required this.quality,
    required this.positionStr,
  });

  factory PlanetModel.fromJson(
      String planetName,
      Map<String, dynamic> json,
      ) {
    return PlanetModel(
      name: planetName,
      sign: json['sign']?.toString() ?? '',
      degree: (json['degree'] as num?)?.toDouble() ?? 0.0,
      house: json['house']?.toString() ?? '',
      retrograde: json['retrograde'] == true,
      element: json['element']?.toString() ?? '',
      quality: json['quality']?.toString() ?? '',
      positionStr: json['position_str']?.toString() ?? '',
    );
  }
}
