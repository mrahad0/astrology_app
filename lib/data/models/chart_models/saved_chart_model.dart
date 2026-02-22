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
  
  // Person 2 data for Synastry charts
  final String? name2;
  final String? date2;
  final String? birthTime2;
  final String? city2;
  final String? country2;

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
    this.name2,
    this.date2,
    this.birthTime2,
    this.city2,
    this.country2,
  });

  factory SavedChartModel.fromJson(Map<String, dynamic> json, String category) {
    // Safely cast chart_data to Map<String, dynamic>
    final rawChartData = json['chart_data'];
    final Map<String, dynamic> chartData = rawChartData != null 
        ? Map<String, dynamic>.from(rawChartData as Map) 
        : {};
    
    // Safely extract location data
    final rawLocation = chartData['location'];
    final Map<String, dynamic> location = rawLocation != null 
        ? Map<String, dynamic>.from(rawLocation as Map) 
        : {};
    
    // Safely extract profile data
    final rawProfile = json['profile'];
    final Map<String, dynamic>? profile = rawProfile != null 
        ? Map<String, dynamic>.from(rawProfile as Map) 
        : null;
    
    // Handle Synastry charts with profile1/profile2 data
    String name = '';
    String date = '';
    String birthTime = '';
    String city = '';
    String country = '';
    String chartImageUrl = '';
    
    // Person 2 data for Synastry
    String? name2;
    String? date2;
    String? birthTime2;
    String? city2;
    String? country2;
    
    if (category == 'Synastry') {
      // Synastry has profile1 and profile2 at the root level
      final rawProfile1 = json['profile1'];
      final rawProfile2 = json['profile2'];
      final Map<String, dynamic> profile1 = rawProfile1 != null 
          ? Map<String, dynamic>.from(rawProfile1 as Map) 
          : {};
      final Map<String, dynamic> profile2Data = rawProfile2 != null 
          ? Map<String, dynamic>.from(rawProfile2 as Map) 
          : {};
      
      // Use profile1's data, or combine both names
      final profile1Name = profile1['name']?.toString() ?? '';
      final profile2Name = profile2Data['name']?.toString() ?? '';
      
      if (profile1Name.isNotEmpty && profile2Name.isNotEmpty) {
        name = '$profile1Name & $profile2Name';
      } else if (profile1Name.isNotEmpty) {
        name = profile1Name;
      } else if (profile2Name.isNotEmpty) {
        name = profile2Name;
      }
      
      // Person 1 data
      date = profile1['birth_date']?.toString() ?? '';
      birthTime = profile1['birth_time']?.toString() ?? '';
      city = profile1['birth_city']?.toString() ?? '';
      country = profile1['birth_country']?.toString() ?? '';
      
      // Person 2 data
      name2 = profile2Name;
      date2 = profile2Data['birth_date']?.toString();
      birthTime2 = profile2Data['birth_time']?.toString();
      city2 = profile2Data['birth_city']?.toString();
      country2 = profile2Data['birth_country']?.toString();
      
      // Synastry uses comparison_image_url
      chartImageUrl = json['comparison_image_url']?.toString() ?? '';
    } else if (category == 'Transit') {
      // Transit charts - check for profile or natal_data
      final rawTransitProfile = json['profile'];
      final Map<String, dynamic> transitProfile = rawTransitProfile != null 
          ? Map<String, dynamic>.from(rawTransitProfile as Map) 
          : {};
      
      // Try transit profile first, then chart_data, then natal_data
      final rawNatalData = chartData['natal_data'];
      final Map<String, dynamic> natalData = rawNatalData != null 
          ? Map<String, dynamic>.from(rawNatalData as Map) 
          : {};
      
      // Extract natal location
      final rawNatalLocation = natalData['location'];
      final Map<String, dynamic> natalLocation = rawNatalLocation != null 
          ? Map<String, dynamic>.from(rawNatalLocation as Map) 
          : {};
      
      name = transitProfile['name']?.toString() ?? natalData['name']?.toString() ?? chartData['name']?.toString() ?? profile?['name']?.toString() ?? '';
      date = transitProfile['birth_date']?.toString() ?? natalData['birth_date']?.toString() ?? chartData['birth_date']?.toString() ?? profile?['birth_date']?.toString() ?? '';
      birthTime = transitProfile['birth_time']?.toString() ?? natalData['birth_time']?.toString() ?? chartData['birth_time']?.toString() ?? profile?['birth_time']?.toString() ?? '';
      city = transitProfile['birth_city']?.toString() ?? natalLocation['city']?.toString() ?? location['city']?.toString() ?? profile?['birth_city']?.toString() ?? '';
      country = transitProfile['birth_country']?.toString() ?? natalLocation['country']?.toString() ?? location['country']?.toString() ?? profile?['birth_country']?.toString() ?? '';
      
      chartImageUrl = json['chart_image_url']?.toString() ?? json['transit_image_url']?.toString() ?? '';
    } else {
      // Natal charts - standard structure
      name = chartData['name']?.toString() ?? profile?['name']?.toString() ?? '';
      date = chartData['birth_date']?.toString() ?? profile?['birth_date']?.toString() ?? '';
      birthTime = chartData['birth_time']?.toString() ?? profile?['birth_time']?.toString() ?? '';
      city = location['city']?.toString() ?? profile?['birth_city']?.toString() ?? '';
      country = location['country']?.toString() ?? profile?['birth_country']?.toString() ?? '';
      chartImageUrl = json['chart_image_url']?.toString() ?? json['chart_image']?.toString() ?? '';
    }
    
    return SavedChartModel(
      id: json['id']?.toString() ?? '',
      systemType: json['system']?.toString() ?? '',
      name: name,
      date: date,
      birthTime: birthTime,
      city: city,
      country: country,
      chartCategory: category,
      chartImageUrl: chartImageUrl,
      interpretation: json['interpretation']?.toString() ?? '',
      calculationDate: json['calculation_date']?.toString() ?? json['created_at']?.toString() ?? '',
      isSaved: json['is_saved'] == true,
      chartData: chartData,
      profile: profile != null 
          ? SavedChartProfile.fromJson(profile) 
          : null,
      name2: name2,
      date2: date2,
      birthTime2: birthTime2,
      city2: city2,
      country2: country2,
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
