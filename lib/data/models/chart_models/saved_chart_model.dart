// lib/data/models/chart_models/saved_chart_model.dart

class SavedChartModel {
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
  final SavedChartProfile? profile;

  SavedChartModel({
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
    this.profile,
  });

  factory SavedChartModel.fromJson(Map<String, dynamic> json, String category) {
    return SavedChartModel(
      id: json['id'] ?? '',
      systemType: json['system'] ?? '',
      name: json['chart_data']?['name'] ?? json['profile']?['name'] ?? '',
      date: json['chart_data']?['birth_date'] ?? json['profile']?['birth_date'] ?? '',
      birthTime: json['chart_data']?['birth_time'] ?? json['profile']?['birth_time'] ?? '',
      city: json['chart_data']?['location']?['city'] ?? json['profile']?['birth_city'] ?? '',
      country: json['chart_data']?['location']?['country'] ?? json['profile']?['birth_country'] ?? '',
      chartCategory: category,
      chartImageUrl: json['chart_image_url'] ?? json['chart_image'] ?? '',
      interpretation: json['interpretation'] ?? '',
      calculationDate: json['calculation_date'] ?? '',
      isSaved: json['is_saved'] ?? false,
      chartData: json['chart_data'] ?? {},
      profile: json['profile'] != null 
          ? SavedChartProfile.fromJson(json['profile']) 
          : null,
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

class SavedChartProfile {
  final String id;
  final String name;
  final String birthDate;
  final String birthTime;
  final String birthCity;
  final String birthCountry;
  final double latitude;
  final double longitude;
  final String timezone;
  final int age;

  SavedChartProfile({
    required this.id,
    required this.name,
    required this.birthDate,
    required this.birthTime,
    required this.birthCity,
    required this.birthCountry,
    required this.latitude,
    required this.longitude,
    required this.timezone,
    required this.age,
  });

  factory SavedChartProfile.fromJson(Map<String, dynamic> json) {
    return SavedChartProfile(
      id: json['id'] ?? '',
      name: json['name'] ?? '',
      birthDate: json['birth_date'] ?? '',
      birthTime: json['birth_time'] ?? '',
      birthCity: json['birth_city'] ?? '',
      birthCountry: json['birth_country'] ?? '',
      latitude: (json['latitude'] ?? 0.0).toDouble(),
      longitude: (json['longitude'] ?? 0.0).toDouble(),
      timezone: json['timezone'] ?? 'UTC',
      age: json['age'] ?? 0,
    );
  }
}
