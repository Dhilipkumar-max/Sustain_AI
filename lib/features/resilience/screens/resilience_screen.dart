import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:sustainai_flutter/core/theme/app_theme.dart';
import 'package:sustainai_flutter/features/resilience/models/resilience_models.dart';
import 'package:sustainai_flutter/features/resilience/services/resilience_service.dart';

class ResilienceScreen extends StatefulWidget {
  const ResilienceScreen({super.key});

  @override
  State<ResilienceScreen> createState() => _ResilienceScreenState();
}

class _ResilienceScreenState extends State<ResilienceScreen> {
  // Search State
  final TextEditingController _searchController = TextEditingController();
  final MapController _mapController = MapController();
  List<CitySearchResult> _cityResults = [];
  CitySearchResult? _selectedCity;
  bool _isSearching = false;
  Timer? _debounce;

  // Data State
  bool _isLoading = false;
  bool _isMonitoring = false;
  WeatherData? _weather;
  AirQualityData? _aqi;

  // Filter State
  final List<String> _selectedRisks = ['heatwave'];
  String _sensitivity = 'standard';
  bool _historyExpanded = false;

  @override
  void dispose() {
    _searchController.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    
    _debounce = Timer(const Duration(milliseconds: 500), () async {
      if (query.length > 2) {
        setState(() => _isSearching = true);
        final results = await ResilienceService.searchCities(query);
        if (mounted) {
          setState(() {
            _cityResults = results;
            _isSearching = false;
          });
        }
      } else {
        setState(() => _cityResults = []);
      }
    });
  }

  void _selectCity(CitySearchResult city) {
    setState(() {
      _selectedCity = city;
      _searchController.text = city.displayName.split(',')[0];
      _cityResults = [];
      _isMonitoring = false; // Reset monitoring
    });
    _mapController.move(LatLng(city.lat, city.lon), 10.0);
  }

  Future<void> _startMonitoring() async {
    if (_selectedCity == null) return;

    setState(() => _isLoading = true);
    
    try {
      final weather = await ResilienceService.fetchWeather(_selectedCity!.lat, _selectedCity!.lon);
      final aqi = await ResilienceService.fetchAirQuality(_selectedCity!.lat, _selectedCity!.lon);

      if (mounted) {
        setState(() {
          _weather = weather;
          _aqi = aqi;
          _isMonitoring = true;
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      appBar: AppBar(
        title: const Text('Disaster Resilience', style: TextStyle(color: Color(0xFF111815), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF111815), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildSearchSection(),
            const SizedBox(height: 16),
            _buildMap(), // Real Map
            const SizedBox(height: 16),
            _buildControlPanel(),
            if (_isMonitoring && _weather != null) ...[
              const SizedBox(height: 24),
              _buildStatusGrid(),
              const SizedBox(height: 16),
              _buildAlertCard(),
              const SizedBox(height: 16),
              _buildAIInsight(),
              const SizedBox(height: 16),
              _buildHistory(),
            ],
            if (!_isMonitoring) 
              _buildEmptyState(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchSection() {
    return Column(
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              TextField(
                controller: _searchController,
                onChanged: _onSearchChanged,
                decoration: InputDecoration(
                  hintText: 'Search City (e.g. Chennai)',
                  prefixIcon: const Icon(Icons.search, color: Colors.grey),
                  suffixIcon: _isSearching 
                    ? const SizedBox(width: 20, height: 20, child: Padding(padding: EdgeInsets.all(12), child: CircularProgressIndicator(strokeWidth: 2)))
                    : IconButton(icon: const Icon(Icons.my_location), onPressed: () {}),
                  border: InputBorder.none,
                  contentPadding: const EdgeInsets.symmetric(vertical: 16),
                ),
              ),
              if (_cityResults.isNotEmpty && _selectedCity == null)
                Container(
                  constraints: const BoxConstraints(maxHeight: 200),
                  child: ListView.separated(
                    shrinkWrap: true,
                    itemCount: _cityResults.length,
                    separatorBuilder: (_, __) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final city = _cityResults[index];
                      return ListTile(
                        leading: const Icon(Icons.location_on, size: 16, color: Colors.grey),
                        title: Text(city.displayName, style: const TextStyle(fontSize: 14)),
                        onTap: () => _selectCity(city),
                      );
                    },
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMap() {
    return Container(
      height: 300,
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[300]!),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: const LatLng(20.5937, 78.9629), // Default to India
            initialZoom: 4.0,
            interactionOptions: const InteractionOptions(flags: InteractiveFlag.all),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'com.sustainai.app',
            ),
            if (_selectedCity != null)
              MarkerLayer(
                markers: [
                  Marker(
                    point: LatLng(_selectedCity!.lat, _selectedCity!.lon),
                    width: 80,
                    height: 80,
                    child: Column(
                      children: [
                        const Icon(Icons.location_on, color: Colors.red, size: 40),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: [BoxShadow(color: Colors.black26, blurRadius: 4)],
                          ),
                          child: Text(
                            _selectedCity!.displayName.split(',')[0],
                            style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlPanel() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFe2e8f0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('RISK SELECTION', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _buildFilterChip('Heatwave', 'heatwave'),
              _buildFilterChip('Flood', 'flood'),
              _buildFilterChip('Wildfire', 'wildfire'),
              _buildFilterChip('Storm', 'storm'),
            ],
          ),
          const SizedBox(height: 16),
          const Text('ALERT SENSITIVITY', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey)),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            children: [
              _buildSensitivityChip('Standard', 'standard'),
              _buildSensitivityChip('Moderate', 'moderate'),
              _buildSensitivityChip('High Risk', 'high'),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: (_selectedCity == null || _isLoading) ? null : _startMonitoring,
              icon: _isLoading 
                ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2))
                : const Icon(Icons.radar),
              label: Text(_isLoading ? 'Loading Data...' : 'Start Monitoring'),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppTheme.primary600,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String label, String id) {
    final isSelected = _selectedRisks.contains(id);
    return InkWell(
      onTap: () {
        setState(() {
          if (isSelected) _selectedRisks.remove(id);
          else _selectedRisks.add(id);
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black : Colors.grey[100],
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? Colors.black : Colors.transparent),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? Colors.white : Colors.black87,
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildSensitivityChip(String label, String id) {
    final isSelected = _sensitivity == id;
    return InkWell(
      onTap: () => setState(() => _sensitivity = id),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? AppTheme.primary100 : Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: isSelected ? AppTheme.primary500 : Colors.grey[300]!),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppTheme.primary700 : Colors.grey[700],
            fontWeight: FontWeight.w500,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusGrid() {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.4,
      children: [
        _buildStatusCard(
          icon: Icons.thermostat,
          color: Colors.orange,
          label: 'Temperature',
          value: '${_weather?.temperature}${_weather?.temperatureUnit}',
          status: _weather?.tempStatus == 'normal' ? 'STABLE' : 'HIGH',
          statusColor: _weather?.tempStatus == 'normal' ? Colors.green : Colors.red,
        ),
        _buildStatusCard(
          icon: Icons.water_drop,
          color: Colors.blue,
          label: 'Rainfall',
          value: '${_weather?.rainfall} ${_weather?.rainfallUnit}',
          status: _weather?.floodRisk == 'low' ? 'STABLE' : (_weather?.floodRisk.toUpperCase() ?? ''),
          statusColor: _weather?.floodRisk == 'low' ? Colors.green : Colors.red,
        ),
        _buildStatusCard(
          icon: Icons.air,
          color: Colors.purple,
          label: 'AQI Index',
          value: '${_aqi?.aqi}',
          status: _aqi?.aqiLabel.toUpperCase() ?? '',
          statusColor: (_aqi?.aqi ?? 0) <= 2 ? Colors.green : Colors.orange,
        ),
        _buildStatusCard(
          icon: Icons.visibility,
          color: Colors.teal,
          label: 'Condition',
          value: ResilienceService.getWeatherDescription(_weather?.weatherCode ?? 0),
          status: 'REALTIME',
          statusColor: Colors.grey,
        ),
      ],
    );
  }

  Widget _buildStatusCard({required IconData icon, required Color color, required String label, required String value, required String status, required Color statusColor}) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(padding: const EdgeInsets.all(6), decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(8)), child: Icon(icon, color: color, size: 18)),
              Text(status, style: TextStyle(color: statusColor, fontSize: 10, fontWeight: FontWeight.bold)),
            ],
          ),
          const Spacer(),
          Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Color(0xFF111815))),
          Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
        ],
      ),
    );
  }

  Widget _buildAlertCard() {
    bool isRisky = (_weather!.temperature > 35) || (_weather!.rainfall > 5);
    // Mock logic matching React
    
    if (isRisky) {
      return Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.red[50],
          borderRadius: BorderRadius.circular(16),
          border: Border(left: BorderSide(color: Colors.red[400]!, width: 4)),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.warning_amber, color: Colors.red[400]),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('CRITICAL ALERT DETECTED', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.red)),
                  const SizedBox(height: 4),
                  Text(
                    _weather!.temperature > 35 
                      ? 'Heatwave conditions detected. Stay hydrated.' 
                      : 'Heavy rainfall warning. Monitor local alerts.',
                    style: TextStyle(color: Colors.red[900], fontSize: 13),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
    
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.green[50],
        borderRadius: BorderRadius.circular(16),
        border: Border(left: BorderSide(color: Colors.green[400]!, width: 4)),
      ),
      child: Row(
        children: [
          Icon(Icons.check_circle_outline, color: Colors.green[600]),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Conditions Stable', style: TextStyle(fontWeight: FontWeight.bold, color: Colors.green[800])),
              Text('No critical risks currently detected.', style: TextStyle(color: Colors.green[700], fontSize: 12)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAIInsight() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFF3b82f6), // Blue
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(colors: [Color(0xFF3b82f6), Color(0xFF2563eb)]),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.auto_awesome, color: Colors.white, size: 16),
              SizedBox(width: 8),
              Text('AI INSIGHT: WHAT THIS MEANS', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            '${_weather!.temperature > 30 ? "High thermal stress potential. " : "Temperature is within normal range. "}'
            '${_weather!.rainfall > 0 ? "Surfaces may be slippery due to rain. " : ""}'
            '${(_aqi?.aqi ?? 0) > 2 ? "Air quality is less than ideal, sensitive groups should take care." : "Air pollution levels are low."}',
            style: const TextStyle(color: Colors.white, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildHistory() {
    return Column(
      children: [
        InkWell(
          onTap: () => setState(() => _historyExpanded = !_historyExpanded),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.history, size: 18, color: Colors.grey),
                  SizedBox(width: 8),
                  Text('Alert History (24h)', style: TextStyle(fontWeight: FontWeight.w600, color: Color(0xFF374151))),
                ],
              ),
              Icon(_historyExpanded ? Icons.keyboard_arrow_up : Icons.keyboard_arrow_down, color: Colors.grey),
            ],
          ),
        ),
        if (_historyExpanded) ...[
          const SizedBox(height: 16),
          Row(
            children: [
              Container(width: 8, height: 8, decoration: const BoxDecoration(color: Colors.blue, shape: BoxShape.circle)),
              const SizedBox(width: 12),
              const Expanded(child: Text('System monitoring started', style: TextStyle(fontSize: 13))),
              const Text('Just now', style: TextStyle(fontSize: 12, color: Colors.grey)),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 40),
        child: Column(
          children: [
            Icon(Icons.radar, size: 60, color: Colors.grey[300]),
            const SizedBox(height: 16),
            Text(
              'Enter a city above and click\n"Start Monitoring" to see real-time data',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[500]),
            ),
          ],
        ),
      ),
    );
  }
}
