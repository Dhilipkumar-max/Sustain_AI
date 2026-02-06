import 'package:supabase_flutter/supabase_flutter.dart';
import 'dart:math';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:sustainai_flutter/core/config/app_config.dart';

class MonitorService {
  static Future<Map<String, dynamic>?> getLatestAirQuality() async {
    try {
      final response = await Supabase.instance.client
          .from('air_quality_logs')
          .select()
          .order('created_at', ascending: false)
          .limit(1)
          .maybeSingle();
      return response;
    } catch (e) {
      print('Monitor Error: $e');
      return null;
    }
  }

  static Future<void> syncSensorData() async {
    // Check if we have a real API key
    if (AppConfig.waqiToken.isNotEmpty && AppConfig.waqiToken != 'YOUR_ACCESS_KEY_HERE') {
      try {
        await _fetchAndRecordRealData();
        return;
      } catch (e) {
        print('API Fetch Error: $e');
      }
    } else {
      print('No valid API token. Using existing database data.');
    }
  }

  static Future<void> _fetchAndRecordRealData() async {
    final response = await http.get(
      Uri.parse('https://api.waqi.info/feed/here/?token=${AppConfig.waqiToken}'),
    );

    if (response.statusCode == 200) {
      final json = jsonDecode(response.body);
      if (json['status'] == 'ok') {
        final data = json['data'];
        final aqi = data['aqi'];
        
        // Map AQI to our status
        String status = 'GOOD';
        if (aqi > 50) status = 'MODERATE';
        if (aqi > 100) status = 'UNHEALTHY';
        if (aqi > 200) status = 'HAZARDOUS'; // WAQI scale roughly

        // Use a multiplier to match the 0-2000 scale from the previous mock if needed, 
        // OR just use the real AQI. The previous mock used 50-1800 which is huge.
        // Real AQI is usually 0-500. Let's store the real value.
        // But the Gauge might expect large numbers? 
        // Build method uses: maxValue: 2000. 
        // If real AQI is 50, gauge will look empty.
        // Let's NOT scale it, but we might want to adjust the Gauge max value in the UI later. 
        // For now, let's store accurate data.
        
        await Supabase.instance.client.from('air_quality_logs').insert({
          'sensor_value': aqi,
          'air_quality': status,
        });
        return;
      }
    }
    throw Exception('Failed to fetch from API');
  }

  static Future<void> _simulateData() async {
    final random = Random();
    final value = 50 + random.nextInt(1800); 
    String status = 'GOOD';
    if (value > 300) status = 'MODERATE';
    if (value > 1000) status = 'UNHEALTHY';
    if (value > 1500) status = 'HAZARDOUS';

    try {
      await Supabase.instance.client.from('air_quality_logs').insert({
        'sensor_value': value,
        'air_quality': status,
      });
    } catch (e) {
      print('Simulation Error: $e');
    }
  }
}
