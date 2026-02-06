import 'package:flutter/material.dart';
import 'package:sustainai_flutter/core/theme/app_theme.dart';
import 'package:sustainai_flutter/features/financial_integrity/models/financial_model.dart';
import 'package:sustainai_flutter/features/financial_integrity/services/financial_service.dart';
import 'package:sustainai_flutter/features/financial_integrity/screens/edit_financial_profile_screen.dart';

class FinancialIntegrityScreen extends StatefulWidget {
  const FinancialIntegrityScreen({super.key});

  @override
  State<FinancialIntegrityScreen> createState() => _FinancialIntegrityScreenState();
}

class _FinancialIntegrityScreenState extends State<FinancialIntegrityScreen> {
  FinancialProfile? _profile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final profile = await FinancialService.getFinancialProfile();
    setState(() {
      _profile = profile;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB), // Light grey background
      appBar: AppBar(
        title: const Text('Financial Integrity', style: TextStyle(color: Color(0xFF111815), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new, color: Color(0xFF111815), size: 20),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit, color: Color(0xFF111815)),
            onPressed: _openEditScreen,
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator(color: AppTheme.primary500))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildBreadcrumb(),
                  const SizedBox(height: 20),
                  _buildOverviewCard(),
                  const SizedBox(height: 24),
                  _buildSpendingAnalysis(),
                  const SizedBox(height: 24),
                  _buildInvestmentOpportunities(),
                  const SizedBox(height: 40),
                ],
              ),
            ),
    );
  }

  Widget _buildBreadcrumb() {
    return Row(
      children: [
        Text(
          'DASHBOARD  ›  MODULES  ›  INTEGRITY',
          style: TextStyle(
            color: AppTheme.primary500,
            fontSize: 12,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.0,
          ),
        ),
      ],
    );
  }

  Widget _buildOverviewCard() {
    final ratio = _profile!.greenRatio;
    final score = _profile!.sustainabilityScore;
    
    String healthLabel = 'Poor';
    if (score >= 80) healthLabel = 'Excellent';
    else if (score >= 60) healthLabel = 'Good';
    else if (score >= 40) healthLabel = 'Fair';

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: const Color(0xFF1e3a8a), // Dark Blue
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF1e3a8a).withOpacity(0.3),
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            const Color(0xFF1e3a8a),
            const Color(0xFF3b82f6),
          ],
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Financial Health',
                    style: TextStyle(color: Colors.white70, fontSize: 14),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    healthLabel,
                    style: const TextStyle(color: Colors.white, fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.security, color: Colors.white),
              ),
            ],
          ),
          const SizedBox(height: 32),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Total Assets', style: TextStyle(color: Colors.white70)),
                    const SizedBox(height: 4),
                    Text(
                      '\$${_profile!.totalAssets.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]},')}',
                      style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              ),
              Container(
                width: 1, 
                height: 40,
                color: Colors.white24,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('Green Allocation', style: TextStyle(color: Colors.white70)),
                      const SizedBox(height: 4),
                      Text(
                        '${(ratio * 100).toStringAsFixed(1)}%',
                        style: const TextStyle(color: AppTheme.primary300, fontSize: 20, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: ratio,
              backgroundColor: Colors.white12,
              valueColor: const AlwaysStoppedAnimation(AppTheme.primary300), // Light green accent
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your portfolio is ${(ratio*100).toStringAsFixed(0)}% sustainable investments',
            style: const TextStyle(color: Colors.white54, fontSize: 12),
          ),
        ],
      ),
    );
  }

  Future<void> _openEditScreen() async {
    if (_profile == null) return;
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => EditFinancialProfileScreen(initialProfile: _profile!)),
    );
    
    if (result == true) {
      _loadData();
    }
  }

  Widget _buildSpendingAnalysis() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Recent Spending',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF111815)),
            ),
            TextButton(
              onPressed: () {},
              child: const Text('See All', style: TextStyle(color: AppTheme.primary500)),
            ),
          ],
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.grey[200]!),
          ),
          child: Column(
            children: _profile!.recentTransactions.map((tx) {
              return Column(
                children: [
                  ListTile(
                    leading: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: tx.isSustainable ? AppTheme.primary50: Colors.red[50],
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        tx.isSustainable ? Icons.eco : Icons.shopping_bag,
                        color: tx.isSustainable ? AppTheme.primary500 : Colors.red,
                        size: 20,
                      ),
                    ),
                    title: Text(tx.title, style: const TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: Text(tx.date, style: TextStyle(color: Colors.grey[500], fontSize: 12)),
                    trailing: Text(
                      '-\$${tx.amount.toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  if (tx != _profile!.recentTransactions.last)
                    Divider(height: 1, indent: 72, color: Colors.grey[100]),
                ],
              );
            }).toList(),
          ),
        ),
      ],
    );
  }

  Widget _buildInvestmentOpportunities() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Green Investment Opportunities',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF111815)),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 180,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: _profile!.opportunities.length,
            itemBuilder: (context, index) {
              final opp = _profile!.opportunities[index];
              return Container(
                width: 280,
                margin: const EdgeInsets.only(right: 16),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey[200]!),
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
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppTheme.primary50,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            opp.impact,
                            style: const TextStyle(
                              color: AppTheme.primary600,
                              fontWeight: FontWeight.bold,
                              fontSize: 10,
                            ),
                          ),
                        ),
                        const Icon(Icons.arrow_outward, color: Colors.grey, size: 18),
                      ],
                    ),
                    const Spacer(),
                    Text(
                      opp.title,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        Text(
                          opp.returnRate,
                          style: const TextStyle(
                            color: AppTheme.primary500,
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                        const SizedBox(width: 8),
                         Text(
                          'Return',
                          style: TextStyle(color: Colors.grey[500], fontSize: 12),
                        ),
                      ],
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
