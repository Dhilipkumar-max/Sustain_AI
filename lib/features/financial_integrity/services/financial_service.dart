import 'package:sustainai_flutter/features/financial_integrity/models/financial_model.dart';

class FinancialService {
  static FinancialProfile? _currentProfile;

  static Future<FinancialProfile> getFinancialProfile() async {
    if (_currentProfile != null) return _currentProfile!;

    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 800));

    _currentProfile = FinancialProfile(
      totalAssets: 125000.0,
      greenInvestments: 45000.0,
      monthlyIncome: 8500.0,
      monthlySpending: 4200.0,
      sustainableSpending: 1200.0,
      sustainabilityScore: 72.0, // Initial calculation: (45/125)*50 + (1200/4200)*50 = 18 + 14 = 32... wait, logic below
      recentTransactions: [
        TransactionItem(title: 'Whole Foods Market', amount: 84.50, isSustainable: true, date: 'Today'),
        TransactionItem(title: 'Shell Station', amount: 45.00, isSustainable: false, date: 'Yesterday'),
        TransactionItem(title: 'Tesla Supercharger', amount: 12.00, isSustainable: true, date: 'Yesterday'),
        TransactionItem(title: 'Local Farmers Market', amount: 32.40, isSustainable: true, date: 'Feb 2'),
        TransactionItem(title: 'Amazon', amount: 120.00, isSustainable: false, date: 'Feb 1'),
      ],
      opportunities: [
        InvestmentOpp(title: 'Green Energy ETF', returnRate: '+12.4%', risk: 'Medium', impact: 'High'),
        InvestmentOpp(title: 'Sustainable Water Fund', returnRate: '+8.2%', risk: 'Low', impact: 'Medium'),
        InvestmentOpp(title: 'EV Tech Startups', returnRate: '+18.5%', risk: 'High', impact: 'Very High'),
      ],
    );
    
    _recalculateScore();
    return _currentProfile!;
  }

  static Future<void> updateProfile(FinancialProfile newProfile) async {
    _currentProfile = newProfile;
    _recalculateScore();
    // Simulate save delay
    await Future.delayed(const Duration(milliseconds: 500));
  }

  static void _recalculateScore() {
    if (_currentProfile == null) return;
    
    final p = _currentProfile!;
    
    // Logic:
    // Investment Ratio (0-100) * 0.6 weight
    // Spending Ratio (0-100) * 0.4 weight
    
    double investScore = p.totalAssets > 0 ? (p.greenInvestments / p.totalAssets) * 100 : 0;
    double spendScore = p.monthlySpending > 0 ? (p.sustainableSpending / p.monthlySpending) * 100 : 0;
    
    double total = (investScore * 0.6) + (spendScore * 0.4);
    
    // normalize to something reasonable (e.g. max 100)
    // Actually, let's boost it a bit so it's not too harsh
    total = (total * 1.2).clamp(0.0, 100.0);

    _currentProfile = p.copyWith(sustainabilityScore: total);
  }
}
