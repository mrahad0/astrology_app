// lib/models/chart_models/aspect_model.dart
class AspectModel {
  final String point1;
  final String point2;
  final String aspect;
  final double orb;
  final bool applying;
  final bool exact;
  final String influence;
  final double orbStrength;

  AspectModel({
    required this.point1,
    required this.point2,
    required this.aspect,
    required this.orb,
    required this.applying,
    required this.exact,
    required this.influence,
    required this.orbStrength,
  });

  factory AspectModel.fromJson(Map<String, dynamic> json) {
    return AspectModel(
      point1: json['point1'] ?? '',
      point2: json['point2'] ?? '',
      aspect: json['aspect'] ?? '',
      orb: (json['orb'] ?? 0).toDouble(),
      applying: json['applying'] ?? false,
      exact: json['exact'] ?? false,
      influence: json['influence'] ?? '',
      orbStrength: (json['orb_strength'] ?? 0).toDouble(),
    );
  }
}