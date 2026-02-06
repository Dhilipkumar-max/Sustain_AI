import 'package:flutter/material.dart';
import 'package:sustainai_flutter/core/theme/app_theme.dart';
import 'package:sustainai_flutter/features/financial_integrity/models/financial_model.dart';
import 'package:sustainai_flutter/features/financial_integrity/services/financial_service.dart';

class EditFinancialProfileScreen extends StatefulWidget {
  final FinancialProfile initialProfile;

  const EditFinancialProfileScreen({super.key, required this.initialProfile});

  @override
  State<EditFinancialProfileScreen> createState() => _EditFinancialProfileScreenState();
}

class _EditFinancialProfileScreenState extends State<EditFinancialProfileScreen> {
  late TextEditingController _assetsController;
  late TextEditingController _greenInvestController;
  late TextEditingController _incomeController;
  late TextEditingController _spendingController;
  late TextEditingController _susSpendingController;

  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _assetsController = TextEditingController(text: widget.initialProfile.totalAssets.toStringAsFixed(0));
    _greenInvestController = TextEditingController(text: widget.initialProfile.greenInvestments.toStringAsFixed(0));
    _incomeController = TextEditingController(text: widget.initialProfile.monthlyIncome.toStringAsFixed(0));
    _spendingController = TextEditingController(text: widget.initialProfile.monthlySpending.toStringAsFixed(0));
    _susSpendingController = TextEditingController(text: widget.initialProfile.sustainableSpending.toStringAsFixed(0));
  }

  @override
  void dispose() {
    _assetsController.dispose();
    _greenInvestController.dispose();
    _incomeController.dispose();
    _spendingController.dispose();
    _susSpendingController.dispose();
    super.dispose();
  }

  Future<void> _saveProfile() async {
    setState(() => _isSaving = true);

    final newProfile = widget.initialProfile.copyWith(
      totalAssets: double.tryParse(_assetsController.text) ?? 0,
      greenInvestments: double.tryParse(_greenInvestController.text) ?? 0,
      monthlyIncome: double.tryParse(_incomeController.text) ?? 0,
      monthlySpending: double.tryParse(_spendingController.text) ?? 0,
      sustainableSpending: double.tryParse(_susSpendingController.text) ?? 0,
    );

    await FinancialService.updateProfile(newProfile);

    if (mounted) {
      setState(() => _isSaving = false);
      Navigator.pop(context, true); // Return true to signal refresh needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Update Financial Data', style: TextStyle(color: Color(0xFF111815), fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Color(0xFF111815)),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          TextButton(
            onPressed: _isSaving ? null : _saveProfile,
            child: _isSaving 
              ? const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2)) 
              : const Text('Save', style: TextStyle(color: AppTheme.primary500, fontWeight: FontWeight.bold, fontSize: 16)),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Portfolio Details',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF111815)),
            ),
            const SizedBox(height: 16),
            _buildCurrencyField('Total Assets', 'Estimated Value of all accounts', _assetsController),
            const SizedBox(height: 16),
            _buildCurrencyField('Green Investments', 'Amount in ESG/Sustainable funds', _greenInvestController),
            
            const SizedBox(height: 32),
            const Text(
              'Monthly Cashflow',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Color(0xFF111815)),
            ),
            const SizedBox(height: 16),
             _buildCurrencyField('Monthly Income', 'Net income after tax', _incomeController),
            const SizedBox(height: 16),
            _buildCurrencyField('Monthly Spending', 'Total expenses', _spendingController),
            const SizedBox(height: 16),
            _buildCurrencyField('Sustainable Spending', 'Spent on certified green products', _susSpendingController),
          ],
        ),
      ),
    );
  }

  Widget _buildCurrencyField(String label, String helper, TextEditingController controller) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14, color: Color(0xFF374151))),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            prefixText: '\$ ',
            helperText: helper,
            helperStyle: TextStyle(color: Colors.grey[500], fontSize: 12),
            filled: true,
            fillColor: const Color(0xFFF9FAFB),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: AppTheme.primary500, width: 2),
            ),
          ),
        ),
      ],
    );
  }
}
