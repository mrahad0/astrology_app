class PrivacyModel {
  final String title;
  final String privacyPolicy;
  DateTime updatedAt;

  PrivacyModel({
    required this.title,
    required this.privacyPolicy,
    required this.updatedAt,
  });

  factory PrivacyModel.fromJson(Map<String, dynamic> json) {
    return PrivacyModel(
      title: json['title'],
      privacyPolicy: json['privacy_policy'],
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }
}
