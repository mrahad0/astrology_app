class SavedChartModel {
  final String systemType;
  final String name;
  final String date;
  final String city;
  final String country;
  final String chartCategory;

  SavedChartModel({
    required this.systemType,
    required this.name,
    required this.date,
    required this.city,
    required this.country,
    required this.chartCategory,
  });

  factory SavedChartModel.fromJson(Map<String, dynamic> json, String category) {
    return SavedChartModel(
      systemType: json['system'] ?? '',
      name: json['chart_data']?['name'] ?? '',
      date: json['chart_data']?['birth_date'] ?? '',
      city: json['chart_data']?['location']?['city'] ?? '',
      country: json['chart_data']?['location']?['country'] ?? '',
      chartCategory: category,
    );
  }
}
