// lib/models/chart_models/house_model.dart
class HouseModel {
  final int houseNumber;
  final String sign;
  final double position;
  final int cusp;
  final String rulingPlanet;

  HouseModel({
    required this.houseNumber,
    required this.sign,
    required this.position,
    required this.cusp,
    required this.rulingPlanet,
  });

  factory HouseModel.fromJson(String houseKey, Map<String, dynamic> json) {
    // Extract house number from "house_1" -> 1
    int houseNum = int.tryParse(houseKey.replaceAll('house_', '')) ?? 0;

    return HouseModel(
      houseNumber: houseNum,
      sign: json['sign'] ?? '',
      position: (json['position'] ?? 0).toDouble(),
      cusp: json['cusp'] ?? 0,
      rulingPlanet: json['ruling_planet'] ?? '',
    );
  }
}