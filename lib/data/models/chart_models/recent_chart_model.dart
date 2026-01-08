// lib/data/models/chart_models/recent_chart_model.dart

class RecentChartModel {
  final String id;
  final String systemType;
  final String name;
  final String date;
  final String birthTime;
  final String city;
  final String country;
  final String chartCategory;
  final String chartImageUrl;
  final String interpretation;
  final String calculationDate;
  final bool isSaved;
  final Map<String, dynamic> chartData;

  RecentChartModel({
    required this.id,
    required this.systemType,
    required this.name,
    required this.date,
    required this.birthTime,
    required this.city,
    required this.country,
    required this.chartCategory,
    required this.chartImageUrl,
    required this.interpretation,
    required this.calculationDate,
    required this.isSaved,
    required this.chartData,
  });

  factory RecentChartModel.fromJson(Map<String, dynamic> json, String category) {
    final chartData = json['chart_data'] ?? {};
    final location = chartData['location'] ?? {};

    return RecentChartModel(
      id: json['id'] ?? '',
      systemType: json['system'] ?? '',
      name: chartData['name'] ?? json['profile']?['name'] ?? '',
      date: chartData['birth_date'] ?? json['profile']?['birth_date'] ?? '',
      birthTime: chartData['birth_time'] ?? json['profile']?['birth_time'] ?? '',
      city: location['city'] ?? json['profile']?['birth_city'] ?? '',
      country: location['country'] ?? json['profile']?['birth_country'] ?? '',
      chartCategory: category,
      chartImageUrl: json['chart_image_url'] ?? json['chart_image'] ?? '',
      interpretation: json['interpretation'] ?? '',
      calculationDate: json['calculation_date'] ?? '',
      isSaved: json['is_saved'] ?? false,
      chartData: chartData,
    );
  }

  /// Get formatted calculation date
  String get formattedDate {
    if (calculationDate.isEmpty) return 'Unknown';
    try {
      final dateTime = DateTime.parse(calculationDate);
      final now = DateTime.now();
      final difference = now.difference(dateTime);
      
      if (difference.inDays == 0) {
        if (difference.inHours == 0) {
          return '${difference.inMinutes} mins ago';
        }
        return '${difference.inHours} hours ago';
      } else if (difference.inDays == 1) {
        return 'Yesterday';
      } else if (difference.inDays < 7) {
        return '${difference.inDays} days ago';
      } else {
        return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
      }
    } catch (e) {
      return 'Unknown';
    }
  }

  /// Get word count from interpretation
  int get wordCount {
    if (interpretation.isEmpty) return 0;
    return interpretation.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).length;
  }

  /// Get system display name
  String get systemDisplayName {
    switch (systemType.toLowerCase()) {
      case 'western':
        return 'Western';
      case 'vedic':
        return 'Vedic';
      case '13_sign':
        return '13-Sign';
      case 'evolutionary':
        return 'Evolutionary';
      case 'galactic':
        return 'Galactic';
      case 'human_design':
        return 'Human Design';
      default:
        return systemType;
    }
  }
}
