import 'package:flutter/material.dart';
import 'package:sustainai_flutter/core/theme/app_theme.dart';
import 'package:sustainai_flutter/features/dashboard/screens/dashboard_screen.dart';

class PredictiveRecommendationsScreen extends StatelessWidget {
  const PredictiveRecommendationsScreen({super.key});

  final List<Map<String, dynamic>> recommendations = const [
    {
      'id': '1',
      'category': 'environmental',
      'title': 'Implement Carbon Offset Program',
      'description': 'Partner with certified carbon offset providers to neutralize unavoidable emissions. Focus on verified forestry and renewable energy projects.',
      'impact': 'high',
      'effort': 'medium',
      'timeframe': '3-6 months',
    },
    {
      'id': '2',
      'category': 'environmental',
      'title': 'Transition to Renewable Energy',
      'description': 'Switch to 100% renewable energy sources for operations. Consider solar panels, wind power purchase agreements, or green energy tariffs.',
      'impact': 'high',
      'effort': 'high',
      'timeframe': '6-12 months',
    },
    {
      'id': '3',
      'category': 'social',
      'title': 'Enhance Employee Wellness Programs',
      'description': 'Introduce comprehensive wellness initiatives including mental health support, flexible working, and health insurance improvements.',
      'impact': 'medium',
      'effort': 'low',
      'timeframe': '1-3 months',
    },
    {
      'id': '4',
      'category': 'social',
      'title': 'Community Engagement Initiative',
      'description': 'Develop partnerships with local communities for skill development, education sponsorship, and volunteer programs.',
      'impact': 'medium',
      'effort': 'medium',
      'timeframe': '2-4 months',
    },
    {
      'id': '5',
      'category': 'governance',
      'title': 'Establish ESG Committee',
      'description': 'Create a dedicated board-level ESG committee to oversee sustainability strategy, set targets, and monitor progress.',
      'impact': 'high',
      'effort': 'low',
      'timeframe': '1-2 months',
    },
    {
      'id': '6',
      'category': 'governance',
      'title': 'Publish Annual Sustainability Report',
      'description': 'Develop comprehensive public sustainability reporting following GRI or SASB standards to increase transparency.',
      'impact': 'high',
      'effort': 'medium',
      'timeframe': '3-6 months',
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      appBar: AppBar(
        title: const Text('ESG Recommendations', style: TextStyle(color: Color(0xFF111815), fontWeight: FontWeight.bold)),
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
            _buildQuickActions(context),
            const SizedBox(height: 24),
            _buildSummary(),
            const SizedBox(height: 24),
            _buildCategorySection('Environmental', 'environmental', Colors.green),
            _buildCategorySection('Social', 'social', Colors.blue),
            _buildCategorySection('Governance', 'governance', Colors.purple),
            _buildBottomActions(context),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickActions(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _buildActionCard(
            context,
            icon: Icons.dashboard,
            label: 'Return to Dashboard',
            onTap: () => Navigator.pushAndRemoveUntil(
              context, 
              MaterialPageRoute(builder: (_) => const DashboardScreen()), 
              (route) => false
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: _buildActionCard(
            context,
            icon: Icons.add_circle,
            label: 'New Assessment',
            onTap: () => Navigator.pop(context), // Simplified 'new' by going back
          ),
        ),
      ],
    );
  }

  Widget _buildActionCard(BuildContext context, {required IconData icon, required String label, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 8)],
        ),
        child: Column(
          children: [
            Icon(icon, color: AppTheme.primary600, size: 28),
            const SizedBox(height: 8),
            Text(label, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  Widget _buildSummary() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildSummaryItem(Icons.lightbulb, '${recommendations.length}', 'Total Recs'),
          _buildSummaryItem(Icons.trending_up, '${recommendations.where((r) => r['impact'] == 'high').length}', 'High Impact'),
          _buildSummaryItem(Icons.check_circle, '${recommendations.where((r) => r['effort'] == 'low').length}', 'Quick Wins'),
        ],
      ),
    );
  }

  Widget _buildSummaryItem(IconData icon, String value, String label) {
    return Column(
      children: [
        Icon(icon, color: Colors.amber, size: 24),
        const SizedBox(height: 4),
        Text(value, style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
      ],
    );
  }

  Widget _buildCategorySection(String title, String categoryId, Color color) {
    final recs = recommendations.where((r) => r['category'] == categoryId).toList();
    if (recs.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Container(padding: const EdgeInsets.all(8), decoration: BoxDecoration(color: color.withOpacity(0.1), shape: BoxShape.circle), child: Icon(Icons.circle, color: color, size: 14)),
            const SizedBox(width: 8),
            Text('$title Recommendations', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
            const SizedBox(width: 8),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(color: Colors.grey[200], borderRadius: BorderRadius.circular(10)),
              child: Text('${recs.length}', style: const TextStyle(fontSize: 10, fontWeight: FontWeight.bold)),
            ),
          ],
        ),
        const SizedBox(height: 12),
        ...recs.map((rec) => Container(
          margin: const EdgeInsets.only(bottom: 16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(child: Text(rec['title'], style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14))),
                  Icon(Icons.warning_amber, size: 16, color: color),
                ],
              ),
              const SizedBox(height: 8),
              Text(rec['description'], style: const TextStyle(fontSize: 13, color: Colors.black87, height: 1.4)),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                children: [
                  _buildBadge('Impact: ${rec['impact']}', rec['impact'] == 'high' ? Colors.red : Colors.orange),
                  _buildBadge('Effort: ${rec['effort']}', rec['effort'] == 'high' ? Colors.red : Colors.green),
                  _buildBadge(rec['timeframe'], Colors.grey),
                ],
              ),
            ],
          ),
        )).toList(),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _buildBadge(String text, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Text(text.toUpperCase(), style: TextStyle(color: color, fontSize: 10, fontWeight: FontWeight.bold)),
    );
  }

  Widget _buildBottomActions(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        onPressed: () => Navigator.pushAndRemoveUntil(
          context, 
          MaterialPageRoute(builder: (_) => const DashboardScreen()), 
          (route) => false
        ),
        icon: const Icon(Icons.home),
        label: const Text('Return to Dashboard'),
        style: ElevatedButton.styleFrom(
          padding: const EdgeInsets.symmetric(vertical: 16),
          backgroundColor: AppTheme.primary600,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      ),
    );
  }
}
