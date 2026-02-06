import 'package:flutter/material.dart';
import 'package:sustainai_flutter/core/theme/app_theme.dart';
import 'package:sustainai_flutter/features/predictive/models/esg_model.dart';
import 'package:sustainai_flutter/features/predictive/screens/predictive_recommendations_screen.dart';
import 'dart:math' as math;

class PredictiveResultsScreen extends StatefulWidget {
  final ESGFormData data;

  const PredictiveResultsScreen({super.key, required this.data});

  @override
  State<PredictiveResultsScreen> createState() => _PredictiveResultsScreenState();
}

class _PredictiveResultsScreenState extends State<PredictiveResultsScreen> with SingleTickerProviderStateMixin {
  late ESGScores _scores;
  late List<RiskFlag> _flags;
  late AnimationController _animController;
  late Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _scores = PredictiveLogic.calculateScores(widget.data);
    _flags = PredictiveLogic.generateRiskFlags(widget.data);

    _animController = AnimationController(vsync: this, duration: const Duration(milliseconds: 1500));
    _anim = CurvedAnimation(parent: _animController, curve: Curves.easeOutCubic);
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  Color _getScoreColor(int score) {
    if (score >= 70) return Colors.green;
    if (score >= 40) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      appBar: AppBar(
        title: const Text('ESG Analysis Results', style: TextStyle(color: Color(0xFF111815), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF111815), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            Text(
              widget.data.entityName,
              style: const TextStyle(fontSize: 18, color: Colors.grey, fontWeight: FontWeight.w500),
            ),
            const SizedBox(height: 20),
            _buildScoreCard(),
            const SizedBox(height: 24),
            _buildPillarBreakdown(),
            if (_flags.isNotEmpty) ...[
              const SizedBox(height: 24),
              _buildRiskFlags(),
            ],
            const SizedBox(height: 32),
            _buildActionButtons(),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildScoreCard() {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: _getScoreColor(_scores.overall).withOpacity(0.1),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 200,
            width: 200,
            child: AnimatedBuilder(
              animation: _anim,
              builder: (context, child) {
                return CustomPaint(
                  painter: GaugePainter(
                    score: _scores.overall,
                    progress: _anim.value,
                    color: _getScoreColor(_scores.overall),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${(_scores.overall * _anim.value).toInt()}',
                          style: const TextStyle(fontSize: 48, fontWeight: FontWeight.bold),
                        ),
                        const Text('/100', style: TextStyle(color: Colors.grey)),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),
          Text(
            _scores.overall >= 70 ? 'Strong ESG Alignment' : (_scores.overall >= 40 ? 'Moderate ESG Alignment' : 'Weak ESG Alignment'),
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: _getScoreColor(_scores.overall)),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.auto_awesome, size: 14, color: AppTheme.primary500),
                const SizedBox(width: 8),
                Text('${_scores.confidence} Confidence', style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPillarBreakdown() {
    return Column(
      children: [
        const Align(alignment: Alignment.centerLeft, child: Text('ESG Pillar Breakdown', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold))),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(child: _buildPillarCard('Environmental', 'E', _scores.environmental, Colors.green)),
            const SizedBox(width: 12),
            Expanded(child: _buildPillarCard('Social', 'S', _scores.social, Colors.blue)),
            const SizedBox(width: 12),
            Expanded(child: _buildPillarCard('Governance', 'G', _scores.governance, Colors.purple)),
          ],
        ),
      ],
    );
  }

  Widget _buildPillarCard(String label, String letter, int score, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8, offset: const Offset(0, 4)),
        ],
      ),
      child: Column(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle),
            alignment: Alignment.center,
            child: Text(letter, style: TextStyle(fontWeight: FontWeight.bold, color: color, fontSize: 18)),
          ),
          const SizedBox(height: 12),
          Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500)),
          const SizedBox(height: 12),
          Text('$score', style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: (score / 100) * _anim.value,
            backgroundColor: Colors.grey[100],
            color: color,
            borderRadius: BorderRadius.circular(4),
          ),
        ],
      ),
    );
  }

  Widget _buildRiskFlags() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('ESG Risk Indicators', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 16),
        ..._flags.map((flag) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: flag.severity == 'warning' ? Colors.red[50] : (flag.severity == 'info' ? Colors.blue[50] : Colors.orange[50]),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: flag.severity == 'warning' ? Colors.red[200]! : (flag.severity == 'info' ? Colors.blue[200]! : Colors.orange[200]!),
            ),
          ),
          child: Row(
            children: [
              Icon(Icons.warning_amber_rounded, size: 20, 
                color: flag.severity == 'warning' ? Colors.red : (flag.severity == 'info' ? Colors.blue : Colors.orange)
              ),
              const SizedBox(width: 12),
              Expanded(child: Text(flag.message, style: const TextStyle(fontWeight: FontWeight.w500))),
            ],
          ),
        )).toList(),
      ],
    );
  }

  Widget _buildActionButtons() {
    return Row(
      children: [
        Expanded(
          child: OutlinedButton.icon(
            onPressed: () {},
            icon: const Icon(Icons.save_alt, size: 18),
            label: const Text('Save Report'),
            style: OutlinedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              side: const BorderSide(color: Colors.grey),
              foregroundColor: Colors.black87,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton.icon(
            onPressed: () => Navigator.push(
              context, 
              MaterialPageRoute(builder: (_) => const PredictiveRecommendationsScreen())
            ),
            icon: const Icon(Icons.remove_red_eye, size: 18),
            label: const Text('View Recs'),
            style: ElevatedButton.styleFrom(
              padding: const EdgeInsets.symmetric(vertical: 16),
              backgroundColor: AppTheme.primary600,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
          ),
        ),
      ],
    );
  }
}

class GaugePainter extends CustomPainter {
  final double progress;
  final int score;
  final Color color;

  GaugePainter({required this.progress, required this.score, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;
    
    // Background Arc
    final bgPaint = Paint()
      ..color = Colors.grey[200]!
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15
      ..strokeCap = StrokeCap.round;
      
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi * 0.8,
      math.pi * 1.4,
      false,
      bgPaint,
    );

    // Progress Arc
    final fgPaint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 15
      ..strokeCap = StrokeCap.round;

    final sweepAngle = (math.pi * 1.4) * (score / 100) * progress;
    
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      math.pi * 0.8,
      sweepAngle,
      false,
      fgPaint,
    );
  }

  @override
  bool shouldRepaint(covariant GaugePainter oldDelegate) => true;
}
