import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sustainai_flutter/features/resilience/models/resilience_models.dart';

class ResilienceService {
  static const String _owmApiKey = '2d827146e63d6b638e5aa233588785d0';

  static Future<List<CitySearchResult>> searchCities(String query) async {
    if (query.length < 2) return [];

    try {
      final url = Uri.parse('https://geocoding-api.open-meteo.com/v1/search?name=${Uri.encodeComponent(query)}&count=5&language=en&format=json');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['results'] == null) return [];
        return (data['results'] as List).map((e) => CitySearchResult.fromJson(e)).toList();
      }
    } catch (e) {
      print('City Search Error: $e');
    }
    return [];
  }

  static Future<WeatherData?> fetchWeather(double lat, double lon) async {
    try {
      final url = Uri.parse('https://api.open-meteo.com/v1/forecast?latitude=$lat&longitude=$lon&current=temperature_2m,is_day,rain,weather_code,wind_speed_10m&current_units=temperature_2m,rain,wind_speed_10m&timezone=auto');
      final response = await http.get(url);
      
      if (response.statusCode == 200) {
        return WeatherData.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      print('Weather Fetch Error: $e');
    }
    return null;
  }

  static Future<AirQualityData?> fetchAirQuality(double lat, double lon) async {
    try {
      final url = Uri.parse('https://api.openweathermap.org/data/2.5/air_pollution?lat=$lat&lon=$lon&appid=$_owmApiKey');
      final response = await http.get(url);

      if (response.statusCode == 200) {
        return AirQualityData.fromJson(jsonDecode(response.body));
      }
    } catch (e) {
      print('AQI Fetch Error: $e');
    }
    // Fallback Mock if API fails
    return AirQualityData(
      aqi: 2,
      aqiLabel: 'Fair (Simulated)',
      components: {'pm2_5': 12.5, 'pm10': 22.0, 'no2': 5.0},
    );
  }

  static String getWeatherDescription(int code) {
    if (code == 0) return 'Clear sky';
    if (code <= 3) return 'Partly cloudy';
    if (code <= 48) return 'Foggy';
    if (code <= 57) return 'Drizzle';
    if (code <= 67) return 'Rain';
    if (code <= 77) return 'Snow';
    if (code <= 82) return 'Rain showers';
    if (code <= 99) return 'Thunderstorm';
    return 'Unknown';
  }
}
