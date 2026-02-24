import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:country_state_city/country_state_city.dart' as csc;

class LocationService {
  static List<csc.Country> _countries = [];

  static Future<void> loadLocationData() async {
    if (_countries.isEmpty) {
      _countries = await csc.getAllCountries();
    }
  }

  static Future<List<String>> searchCountries(String query) async {
    await loadLocationData();
    if (query.isEmpty) return _countries.map((e) => e.name).toList();
    final lowercaseQuery = query.toLowerCase();

    return _countries
        .where((country) => country.name.toLowerCase().contains(lowercaseQuery))
        .map((country) => country.name)
        .toList();
  }

  static Future<List<String>> searchCities(String countryName, String query) async {
    await loadLocationData();

    // 1. Find the selected country code
    final selectedCountry = _countries.firstWhere(
      (c) => c.name.toLowerCase() == countryName.toLowerCase(),
      orElse: () => csc.Country(name: '', isoCode: '', flag: '', phoneCode: '', currency: '', latitude: '', longitude: ''),
    );

    if (selectedCountry.isoCode.isEmpty) {
      return [];
    }

    // 2. Local search first
    final states = await csc.getStatesOfCountry(selectedCountry.isoCode);
    final cities = await csc.getCountryCities(selectedCountry.isoCode);

    final Set<String> localLocationNames = {};
    localLocationNames.addAll(states.map((s) => s.name));
    localLocationNames.addAll(cities.map((c) => c.name));

    final lowercaseQuery = query.toLowerCase();

    List<String> matchedLocalLocations = [];
    if (query.isEmpty) {
      matchedLocalLocations = localLocationNames.toList()..sort();
    } else {
      matchedLocalLocations = localLocationNames
          .where((loc) => loc.toLowerCase().contains(lowercaseQuery))
          .toList()
        ..sort();
    }

    // 3. Fallback/Supplement with API for precise cities (if user is actively typing)
    if (query.length >= 2) {
      try {
        final url = Uri.parse('https://geocoding-api.open-meteo.com/v1/search').replace(queryParameters: {
          'name': query,
          'count': '10',
          'language': 'en',
          'format': 'json',
        });
        
        final response = await http.get(url).timeout(const Duration(seconds: 3));
        
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          if (data['results'] != null) {
            for (var result in data['results']) {
              if (result['country_code'] == selectedCountry.isoCode && result['name'] != null) {
                // To avoid duplication, we just add it to the Set (transformed back to list)
                matchedLocalLocations.add(result['name'] as String);
              }
            }
          }
        }
      } catch (e) {
        // Silently fail if API is unreachable and just return local results
      }
    }

    // Convert to set to remove duplicates, then map back to list
    return matchedLocalLocations.toSet().take(100).toList();
  }
}
