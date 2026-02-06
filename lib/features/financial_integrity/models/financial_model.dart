class FinancialProfile {
  final double totalAssets;
  final double greenInvestments;
  final double monthlyIncome;
  final double monthlySpending;
  final double sustainableSpending;
  final double sustainabilityScore;
  final List<TransactionItem> recentTransactions;
  final List<InvestmentOpp> opportunities;

  FinancialProfile({
    required this.totalAssets,
    required this.greenInvestments,
    required this.monthlyIncome,
    required this.monthlySpending,
    required this.sustainableSpending,
    required this.sustainabilityScore,
    required this.recentTransactions,
    required this.opportunities,
  });

  double get greenRatio => totalAssets > 0 ? (greenInvestments / totalAssets) : 0;
  double get spendingRatio => monthlySpending > 0 ? (sustainableSpending / monthlySpending) : 0;

  FinancialProfile copyWith({
    double? totalAssets,
    double? greenInvestments,
    double? monthlyIncome,
    double? monthlySpending,
    double? sustainableSpending,
    double? sustainabilityScore,
    List<TransactionItem>? recentTransactions,
    List<InvestmentOpp>? opportunities,
  }) {
    return FinancialProfile(
      totalAssets: totalAssets ?? this.totalAssets,
      greenInvestments: greenInvestments ?? this.greenInvestments,
      monthlyIncome: monthlyIncome ?? this.monthlyIncome,
      monthlySpending: monthlySpending ?? this.monthlySpending,
      sustainableSpending: sustainableSpending ?? this.sustainableSpending,
      sustainabilityScore: sustainabilityScore ?? this.sustainabilityScore,
      recentTransactions: recentTransactions ?? this.recentTransactions,
      opportunities: opportunities ?? this.opportunities,
    );
  }
}

class TransactionItem {
  final String title;
  final double amount;
  final bool isSustainable;
  final String date;

  TransactionItem({required this.title, required this.amount, required this.isSustainable, required this.date});
}

class InvestmentOpp {
  final String title;
  final String returnRate;
  final String risk;
  final String impact;

  InvestmentOpp({required this.title, required this.returnRate, required this.risk, required this.impact});
}
