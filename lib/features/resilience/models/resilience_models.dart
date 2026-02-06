class CitySearchResult {
  final String name;
  final String displayName;
  final double lat;
  final double lon;

  CitySearchResult({
    required this.name,
    required this.displayName,
    required this.lat,
    required this.lon,
  });

  factory CitySearchResult.fromJson(Map<String, dynamic> json) {
    return CitySearchResult(
      name: json['name'] ?? '',
      displayName: '${json['name']}, ${json['country'] ?? ''} ${json['admin1'] ?? ''}',
      lat: json['latitude'] ?? 0.0,
      lon: json['longitude'] ?? 0.0,
    );
  }
}

class WeatherData {
  final double temperature;
  final String temperatureUnit;
  final double rainfall;
  final String rainfallUnit;
  final double windSpeed;
  final String windSpeedUnit;
  final int weatherCode;
  final bool isDay;
  final String floodRisk; // 'low', 'moderate', 'high'
  final String tempStatus; // 'normal', 'high', 'low'

  WeatherData({
    required this.temperature,
    required this.temperatureUnit,
    required this.rainfall,
    required this.rainfallUnit,
    required this.windSpeed,
    required this.windSpeedUnit,
    required this.weatherCode,
    required this.isDay,
    required this.floodRisk,
    required this.tempStatus,
  });

  factory WeatherData.fromJson(Map<String, dynamic> json) {
    final current = json['current'];
    final units = json['current_units'];

    double temp = (current['temperature_2m'] as num).toDouble();
    double rain = (current['rain'] as num).toDouble();
    
    // Risk Logic
    String tStatus = 'normal';
    if (temp > 35) tStatus = 'high';
    if (temp < 0) tStatus = 'low';

    String fRisk = 'low';
    if (rain > 10) fRisk = 'high';
    else if (rain > 2) fRisk = 'moderate';

    return WeatherData(
      temperature: temp,
      temperatureUnit: units['temperature_2m'] ?? '°C',
      rainfall: rain,
      rainfallUnit: units['rain'] ?? 'mm',
      windSpeed: (current['wind_speed_10m'] as num).toDouble(),
      windSpeedUnit: units['wind_speed_10m'] ?? 'km/h',
      weatherCode: current['weather_code'] as int,
      isDay: (current['is_day'] as int) == 1,
      floodRisk: fRisk,
      tempStatus: tStatus,
    );
  }
}

class AirQualityData {
  final int aqi;
  final String aqiLabel;
  final Map<String, double> components;

  AirQualityData({
    required this.aqi,
    required this.aqiLabel,
    required this.components,
  });

  factory AirQualityData.fromJson(Map<String, dynamic> json) {
    final list = json['list'][0];
    final main = list['main'];
    final comps = list['components'];
    final aqiVal = main['aqi'] as int;

    // Label mapping
    const labels = {
      1: 'Good',
      2: 'Fair',
      3: 'Moderate',
      4: 'Poor',
      5: 'Very Poor'
    };

    return AirQualityData(
      aqi: aqiVal,
      aqiLabel: labels[aqiVal] ?? 'Moderate',
      components: {
        'pm2_5': (comps['pm2_5'] as num).toDouble(),
        'pm10': (comps['pm10'] as num).toDouble(),
        'no2': (comps['no2'] as num).toDouble(),
      },
    );
  }
}
