import 'package:flutter/material.dart';
import 'package:sustainai_flutter/core/theme/app_theme.dart';
import 'package:sustainai_flutter/features/dashboard/screens/dashboard_screen.dart'; // For navigation mock
import 'dart:math' as math;

class WellBeingCheckInScreen extends StatefulWidget {
  const WellBeingCheckInScreen({super.key});

  @override
  State<WellBeingCheckInScreen> createState() => _WellBeingCheckInScreenState();
}

class _WellBeingCheckInScreenState extends State<WellBeingCheckInScreen> {
  // State variables
  double _energyLevel = 65;
  double _stressLevel = 30;
  String _selectedSleep = 'Good';
  String _activityLevel = '30-60 min (Active)';
  String _screenTime = '2-4 Hours (Balanced)';
  String _outdoorExposure = 'Direct Sunlight (30 min+)';
  
  bool _showResult = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          'Well-Being Check-in',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Colors.black, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildHeader(),
            const SizedBox(height: 32),
            if (!_showResult) ...[
              _buildDailyCheckIn(),
              const SizedBox(height: 32),
              _buildLifestyleAwareness(),
              const SizedBox(height: 40),
            ] else ...[
              _buildWellBeingResult(),
              const SizedBox(height: 32),
              _buildAiInsightCard(),
              const SizedBox(height: 32),
              _buildQuickActions(),
              const SizedBox(height: 40),
            ],
            if (!_showResult)
              _buildPrimaryButton()
            else
              _buildSecondaryButton(),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Well-Being Check-in',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Color(0xFF1B1B1B), // Dark text
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Reflect on your day to find your natural balance.',
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }

  Widget _buildDailyCheckIn() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Daily Check-in',
          style: TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1B1B1B),
          ),
        ),
        const SizedBox(height: 24),
        _buildSlider(
          label: 'Energy Level',
          value: _energyLevel,
          onChanged: (val) => setState(() => _energyLevel = val),
        ),
        const SizedBox(height: 24),
        _buildSlider(
          label: 'Stress Level',
          value: _stressLevel,
          onChanged: (val) => setState(() => _stressLevel = val),
        ),
        const SizedBox(height: 24),
        _buildSleepSelector(),
        const SizedBox(height: 24),
        _buildDropdown(
          label: 'Physical Activity',
          value: _activityLevel,
          items: ['None', '0-30 min (Light)', '30-60 min (Active)', '60+ min (Very Active)'],
          onChanged: (val) => setState(() => _activityLevel = val!),
        ),
      ],
    );
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
            Text('${value.toInt()}%', style: TextStyle(color: Colors.grey[600], fontSize: 13)),
          ],
        ),
        const SizedBox(height: 8),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: const Color(0xFF10b981), // Green
            inactiveTrackColor: Colors.grey[200],
            thumbColor: const Color(0xFF10b981),
            overlayColor: const Color(0xFF10b981).withOpacity(0.1),
            trackHeight: 4,
            thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
          ),
          child: Slider(
            value: value,
            min: 0,
            max: 100,
            onChanged: onChanged,
          ),
        ),
      ],
    );
  }

  Widget _buildSleepSelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Sleep Quality', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
        const SizedBox(height: 12),
        Row(
          children: [
            _buildSleepCard('Good', Icons.sentiment_satisfied_alt),
            const SizedBox(width: 12),
            _buildSleepCard('Fair', Icons.sentiment_neutral),
            const SizedBox(width: 12),
            _buildSleepCard('Poor', Icons.sentiment_dissatisfied),
          ],
        ),
      ],
    );
  }

  Widget _buildSleepCard(String label, IconData icon) {
    final isSelected = _selectedSleep == label;
    final color = isSelected ? const Color(0xFF10b981) : Colors.grey[400];
    final bg = isSelected ? const Color(0xFFecfdf5) : Colors.white; // Green-50 vs White
    final border = isSelected ? const Color(0xFF10b981) : Colors.grey[200];

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedSleep = label),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: border!),
          ),
          child: Column(
            children: [
              Icon(icon, color: color, size: 28),
              const SizedBox(height: 4),
              Text(
                label,
                style: TextStyle(
                  color: isSelected ? const Color(0xFF064e3b) : Colors.grey[600],
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC), // Slate-50
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.transparent),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              style: const TextStyle(color: Colors.black87, fontSize: 14),
              dropdownColor: Colors.white,
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLifestyleAwareness() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4), // Green-50ish
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Lifestyle Awareness',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF1B1B1B),
            ),
          ),
          const SizedBox(height: 16),
          _buildDropdownBase(
            label: 'Screen Time Awareness',
            value: _screenTime,
            items: ['< 2 Hours', '2-4 Hours (Balanced)', '4+ Hours'],
            onChanged: (val) => setState(() => _screenTime = val!),
            bgColor: Colors.white,
          ),
          const SizedBox(height: 16),
          _buildDropdownBase(
            label: 'Outdoor Exposure',
            value: _outdoorExposure,
            items: ['None', 'Indirect sunlight', 'Direct Sunlight (30 min+)'],
            onChanged: (val) => setState(() => _outdoorExposure = val!),
            bgColor: Colors.white,
          ),
        ],
      ),
    );
  }

  // Helper for Lifestyle card dropdowns to force white background
  Widget _buildDropdownBase({
    required String label,
    required String value,
    required List<String> items,
    required ValueChanged<String?> onChanged,
    required Color bgColor,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w500, color: Color(0xFF374151))),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(30), // Pill shape for inner inputs
            border: Border.all(color: Colors.transparent),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              isExpanded: true,
              icon: const Icon(Icons.keyboard_arrow_down, color: Colors.grey),
              style: const TextStyle(color: Colors.black87, fontSize: 14),
              dropdownColor: Colors.white,
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildWellBeingResult() {
    return Center(
      child: Column(
        children: [
          SizedBox(
            height: 200,
            width: 200,
            child: CustomPaint(
              painter: WellBeingCirclePainter(score: 78),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: const BoxDecoration(
                        color: Color(0xFFD1FAE5), // Green-100
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(Icons.eco, color: Color(0xFF059669), size: 24),
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Balanced',
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Daily Score: 78',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[500],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          RichText(
            text: const TextSpan(
              style: TextStyle(fontSize: 16, color: Colors.black54),
              children: [
                TextSpan(text: "You're feeling "),
                TextSpan(
                  text: 'Relaxed',
                  style: TextStyle(color: Color(0xFF10b981), fontWeight: FontWeight.bold),
                ),
                TextSpan(text: ' today'),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAiInsightCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB), // Very light grey/white
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: const BoxDecoration(
              color: Color(0xFFD1FAE5),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.smart_toy_outlined, size: 20, color: Color(0xFF059669)),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'AI INSIGHT',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF10b981),
                    letterSpacing: 1.0,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  "Great job maintaining your energy levels! Good balance between activity and rest today. Consider a short 5-minute stretch to keep the momentum.",
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'QUICK ACTIONS',
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: Colors.grey[400],
            letterSpacing: 1.0,
          ),
        ),
        const SizedBox(height: 16),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: [
              _buildActionButton(Icons.self_improvement, 'Stretch for 5 mins'),
              const SizedBox(width: 12),
              _buildActionButton(Icons.park, 'Fresh air break'),
              const SizedBox(width: 12),
              _buildActionButton(Icons.water_drop, 'Hydrate'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildActionButton(IconData icon, String label) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Icon(icon, size: 16, color: const Color(0xFF10b981)),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: Colors.black87,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPrimaryButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          setState(() {
            _showResult = true;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF10b981),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 0,
        ),
        child: const Text(
          'Check My Well-Being',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  Widget _buildSecondaryButton() {
    return Center(
      child: TextButton(
        onPressed: () {
          // Reset or Navigate away
           setState(() {
            _showResult = false;
          });
        },
        child: Text(
          'Check In Again',
          style: TextStyle(
            color: Colors.grey[600],
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }


}

class WellBeingCirclePainter extends CustomPainter {
  final double score; // 0-100

  WellBeingCirclePainter({required this.score});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;

    // Background Circle (Light Grey Faded)
    final bgPaint = Paint()
      ..color = Colors.grey[100]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 10),
      math.pi * 0.8, // Start angle (bottom-ish left)
      math.pi * 1.4, // Sweep
      false,
      bgPaint,
    );

    // Progress
    final progressPaint = Paint()
      ..color = const Color(0xFF10b981)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 12
      ..strokeCap = StrokeCap.round;

    final sweepAngle = (math.pi * 1.4) * (score / 100);

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - 10),
      math.pi * 0.8,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
