import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:sustainai_flutter/core/theme/app_theme.dart';
import 'dart:math' as math;
import 'package:intl/intl.dart';
import 'dart:async';
import 'package:sustainai_flutter/features/monitor/services/monitor_service.dart';
import 'package:sustainai_flutter/core/config/app_config.dart';

class SustainabilityMonitorScreen extends StatefulWidget {
  const SustainabilityMonitorScreen({super.key});

  @override
  State<SustainabilityMonitorScreen> createState() => _SustainabilityMonitorScreenState();
}

class _SustainabilityMonitorScreenState extends State<SustainabilityMonitorScreen> {
  late Stream<List<Map<String, dynamic>>> _aqiStream;
  Timer? _simulationTimer;


  @override
  @override
  void initState() {
    super.initState();
    _aqiStream = Supabase.instance.client
        .from('air_quality_logs')
        .stream(primaryKey: ['id'])
        .order('created_at', ascending: false)
        .limit(1);
    
    // Auto-start data syncing when entering the module
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _startMonitoring();
    });
  }

  @override
  void dispose() {
    _simulationTimer?.cancel();
    super.dispose();
  }

  Future<void> _startMonitoring() async {
    final bool isRealApi = AppConfig.waqiToken.isNotEmpty && AppConfig.waqiToken != 'YOUR_ACCESS_KEY_HERE';
    
    // Initial fetch
    await MonitorService.syncSensorData();
    
    // Adjust frequency: Real API (1 min), Simulation (3 sec)
    final duration = isRealApi ? const Duration(minutes: 1) : const Duration(seconds: 3);
    
    _simulationTimer?.cancel();
    _simulationTimer = Timer.periodic(duration, (_) {
      MonitorService.syncSensorData();
    });
  }

  Color _getStatusColor(String status) {
    status = status.toUpperCase();
    if (status == 'GOOD') return Colors.green;
    if (status == 'MODERATE') return const Color(0xFFFACC15); // Yellow
    if (status == 'UNHEALTHY') return Colors.orange;
    if (status == 'HAZARDOUS') return Colors.red;
    return Colors.grey;
  }

  IconData _getStatusIcon(String status) {
    status = status.toUpperCase();
    if (status == 'GOOD') return Icons.sentiment_satisfied_alt;
    if (status == 'MODERATE') return Icons.sentiment_neutral;
    if (status == 'UNHEALTHY') return Icons.sentiment_dissatisfied;
    return Icons.sentiment_very_dissatisfied;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black87, size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh, color: Colors.black87),
            onPressed: () {
               MonitorService.syncSensorData();
               ScaffoldMessenger.of(context).showSnackBar(
                 const SnackBar(content: Text('Refreshing data...'), duration: Duration(seconds: 1)),
               );
            },
          ),
        ],
      ),
      // FAB Removed

      body: StreamBuilder<List<Map<String, dynamic>>>(
        stream: _aqiStream,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }
          
          if (!snapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final data = snapshot.data!.isNotEmpty ? snapshot.data!.first : null;
          
          // Default mocks if no data
          final aqiValue = data?['sensor_value'] ?? 0;
          final status = data?['air_quality'] ?? 'Syncing...';
          final timestamp = data?['created_at'] != null 
              ? DateTime.parse(data!['created_at']) 
              : DateTime.now();
          final timeAgo = DateTime.now().difference(timestamp).inMinutes;

          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              children: [
                _buildHeader(timeAgo),
                const SizedBox(height: 40),
                _buildGauge(aqiValue, status),
                const SizedBox(height: 40),
                _buildStatusBadge(status),
                const SizedBox(height: 40),
                _buildMetricsGrid(aqiValue, status),
                const SizedBox(height: 40),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildHeader(int minutesAgo) {
    return Column(
      children: [
        const Icon(Icons.location_on, color: Color(0xFF64748b), size: 24),
        const SizedBox(height: 16),
        const Text(
          'Sensor Location, Main Campus',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1e293b),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Last updated: $minutesAgo mins ago',
          style: const TextStyle(
            color: Color(0xFF94a3b8),
            fontSize: 14,
          ),
        ),
      ],
    );
  }

  Widget _buildGauge(int value, String status) {
    final color = _getStatusColor(status);
    
    return SizedBox(
      height: 280,
      width: 280,
      child: CustomPaint(
        painter: MonitorGaugePainter(
          value: value.toDouble(), 
          color: color,
          maxValue: 2000, // Assuming 2000 is max based on '1850' usage
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              '$value',
              style: const TextStyle(
                fontSize: 64,
                fontWeight: FontWeight.bold,
                color: Color(0xFF0f172a),
                height: 1,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'AQI INDEX',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: Color(0xFF94a3b8),
                letterSpacing: 1,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatusBadge(String status) {
    final color = _getStatusColor(status);
    final icon = _getStatusIcon(status);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.15),
        borderRadius: BorderRadius.circular(40),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: Colors.black87), // Assuming dark icon for contrast
          const SizedBox(width: 12),
          Text(
            status,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Color(0xFF451a03), // Dark Brown/Contrast
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricsGrid(int aqi, String status) {
    // Mocking other environmental data as they aren't in this specific table
    return GridView.count(
      shrinkWrap: true,
      crossAxisCount: 2,
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.5,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        _buildMetricCard(
          icon: Icons.thermostat,
          label: 'TEMP',
          value: '28.4',
          unit: '°C',
          color: const Color(0xFFecfdf5), // Green-50
          iconColor: const Color(0xFF10b981),
        ),
        _buildMetricCard(
          icon: Icons.water_drop,
          label: 'HUMIDITY',
          value: '62',
          unit: '%',
          color: const Color(0xFFeff6ff), // Blue-50
          iconColor: const Color(0xFF3b82f6),
        ),
        _buildMetricCard(
          icon: Icons.air,
          label: 'PM 2.5',
          value: '12.5',
          unit: 'µg/m³',
          color: const Color(0xFFfafafa), // Grey-50
          iconColor: const Color(0xFF64748b),
        ),
        _buildMetricCard(
          icon: Icons.sensors,
          label: 'STATUS',
          value: 'Live',
          unit: '',
          color: const Color(0xFFfafafa),
          iconColor: const Color(0xFF64748b),
          isStatus: true,
        ),
      ],
    );
  }

  Widget _buildMetricCard({
    required IconData icon,
    required String label,
    required String value,
    required String unit,
    required Color color,
    required Color iconColor,
    bool isStatus = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: iconColor),
              const SizedBox(width: 8),
              Text(
                label,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: iconColor,
                ),
              ),
            ],
          ),
          if (isStatus)
            Row(
              children: [
                Container(
                  width: 8, height: 8,
                  decoration: const BoxDecoration(color: Colors.green, shape: BoxShape.circle),
                ),
                const SizedBox(width: 8),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0f172a),
                  ),
                ),
              ],
            )
          else
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: value,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF0f172a),
                    ),
                  ),
                  TextSpan(
                    text: ' $unit',
                    style: const TextStyle(
                      fontSize: 14,
                      color: Color(0xFF64748b),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class MonitorGaugePainter extends CustomPainter {
  final double value;
  final double maxValue;
  final Color color;

  MonitorGaugePainter({required this.value, required this.maxValue, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;

    // Background Arc (Light Grey)
    final bgPaint = Paint()
      ..color = Colors.grey[100]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi * 0.75, // Start at roughly 135 degrees
      math.pi * 1.5,  // Sweep 270 degrees
      false,
      bgPaint,
    );

    // Progress Arc (Colored)
    final fgPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 25
      ..strokeCap = StrokeCap.round;

    final sweepAngle = (math.pi * 1.5) * (value / maxValue);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi * 0.75,
      sweepAngle,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(covariant MonitorGaugePainter oldDelegate) => true;
}
