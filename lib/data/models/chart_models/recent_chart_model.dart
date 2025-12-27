class RecentChartModel {
  final String systemType;
  final String name;
  final String date;
  final String city;
  final String country;
  final String chartCategory;

  RecentChartModel({
    required this.systemType,
    required this.name,
    required this.date,
    required this.city,
    required this.country,
    required this.chartCategory,
  });

  factory RecentChartModel.fromJson(Map<String, dynamic> json, String category) {
    final chartData = json['chart_data'] ?? {};
    final location = chartData['location'] ?? {};

    return RecentChartModel(
      systemType: json['system'] ?? '',
      name: chartData['name'] ?? '',
      date: chartData['birth_date'] ?? '',
      city: location['city'] ?? '',
      country: location['country'] ?? '',
      chartCategory: category,
    );
  }
}
