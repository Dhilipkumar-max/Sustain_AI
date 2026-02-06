import 'package:flutter/material.dart';
import 'package:sustainai_flutter/core/theme/app_theme.dart';
import 'package:sustainai_flutter/features/predictive/models/esg_model.dart';
import 'package:sustainai_flutter/features/predictive/screens/predictive_results_screen.dart';

class PredictiveScreen extends StatefulWidget {
  const PredictiveScreen({super.key});

  @override
  State<PredictiveScreen> createState() => _PredictiveScreenState();
}

class _PredictiveScreenState extends State<PredictiveScreen> {
  final ESGFormData _formData = ESGFormData();

  // Options
  final entityTypes = [
    {'value': 'company', 'label': 'Company'},
    {'value': 'project', 'label': 'Project'},
    {'value': 'startup', 'label': 'Startup'},
    {'value': 'infrastructure', 'label': 'Infrastructure Initiative'},
  ];

  final industries = [
    {'value': 'energy', 'label': 'Energy'},
    {'value': 'agriculture', 'label': 'Agriculture'},
    {'value': 'manufacturing', 'label': 'Manufacturing'},
    {'value': 'technology', 'label': 'Technology'},
    {'value': 'transportation', 'label': 'Transportation'},
    {'value': 'construction', 'label': 'Construction'},
    {'value': 'other', 'label': 'Other'},
  ];

  final envImpacts = [
    {'value': 'carbon', 'label': 'Carbon Emissions'},
    {'value': 'water', 'label': 'Water Usage'},
    {'value': 'waste', 'label': 'Waste Mgmt'},
    {'value': 'biodiversity', 'label': 'Biodiversity'},
  ];

  final socImpacts = [
    {'value': 'labor', 'label': 'Labor Rights'},
    {'value': 'dei', 'label': 'DEI Programs'},
    {'value': 'health', 'label': 'Comm. Health'},
  ];

  void _analyze() {
    if (_formData.isValid) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (_) => PredictiveResultsScreen(data: _formData)),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please complete all required fields')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFB),
      appBar: AppBar(
        title: const Text('ESG Evaluation', style: TextStyle(color: Color(0xFF111815), fontWeight: FontWeight.bold)),
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
            _buildSection(
              title: 'Entity Information',
              child: Column(
                children: [
                  _buildDropdown('Entity Type', _formData.entityType, entityTypes, (v) => setState(() => _formData.entityType = v!)),
                  const SizedBox(height: 16),
                  _buildTextField('Name', _formData.entityName, (v) => _formData.entityName = v),
                  const SizedBox(height: 16),
                  _buildDropdown('Industry', _formData.industry, industries, (v) => setState(() => _formData.industry = v!)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildSection(
              title: 'Environmental',
              child: Column(
                children: [
                  _buildMultiSelect('Impact Areas', _formData.environmentalImpacts, envImpacts),
                  const SizedBox(height: 16),
                  _buildDropdown('Expected Outcome', _formData.environmentalOutcome, [
                    {'value': 'reduces', 'label': 'Reduces environmental impact'},
                    {'value': 'neutral', 'label': 'Neutral environmental impact'},
                    {'value': 'increases', 'label': 'Potentially increases impact'},
                  ], (v) => setState(() => _formData.environmentalOutcome = v!)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildSection(
              title: 'Social',
              child: Column(
                children: [
                  _buildMultiSelect('Social Impact Areas', _formData.socialImpacts, socImpacts),
                  const SizedBox(height: 16),
                  _buildDropdown('Stakeholder Reach', _formData.stakeholderReach, [
                    {'value': 'local', 'label': 'Local'},
                    {'value': 'regional', 'label': 'Regional'},
                    {'value': 'national', 'label': 'National'},
                    {'value': 'global', 'label': 'Global'},
                  ], (v) => setState(() => _formData.stakeholderReach = v!)),
                ],
              ),
            ),
            const SizedBox(height: 20),
            _buildSection(
              title: 'Governance',
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Commitment Level', style: TextStyle(fontWeight: FontWeight.w600, color: Colors.grey)),
                  const SizedBox(height: 10),
                  Row(
                    children: ['low', 'medium', 'high'].map((level) {
                      final isSelected = _formData.governanceCommitment == level;
                      return Expanded(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          child: InkWell(
                            onTap: () => setState(() => _formData.governanceCommitment = level),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 12),
                              decoration: BoxDecoration(
                                color: isSelected ? AppTheme.primary600 : Colors.white,
                                borderRadius: BorderRadius.circular(8),
                                border: Border.all(color: isSelected ? AppTheme.primary600 : Colors.grey[300]!),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                level.toUpperCase(),
                                style: TextStyle(
                                  color: isSelected ? Colors.white : Colors.black87,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 12,
                                ),
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 16),
                  SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    title: const Text('Public Disclosure Available', style: TextStyle(fontWeight: FontWeight.w600)),
                    value: _formData.publicDisclosure,
                    activeColor: AppTheme.primary500,
                    onChanged: (v) => setState(() => _formData.publicDisclosure = v),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 32),
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton(
                onPressed: _analyze,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.primary600,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                ),
                child: const Text('Analyze ESG Alignment', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildSection({required String title, required Widget child}) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
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
              Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
              const Icon(Icons.info_outline, size: 16, color: Colors.grey),
            ],
          ),
          const Divider(height: 24),
          child,
        ],
      ),
    );
  }

  Widget _buildDropdown(String label, String value, List<Map<String, String>> items, Function(String?) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.grey, fontSize: 13)),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.grey[300]!),
            borderRadius: BorderRadius.circular(12),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value.isEmpty ? null : value,
              isExpanded: true,
              hint: const Text('Select option'),
              items: items.map((item) {
                return DropdownMenuItem(
                  value: item['value'],
                  child: Text(item['label']!),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTextField(String label, String value, Function(String) onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.grey, fontSize: 13)),
        const SizedBox(height: 8),
        TextFormField(
          initialValue: value,
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: 'Enter entity name',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide(color: Colors.grey[300]!)),
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          ),
        ),
      ],
    );
  }

  Widget _buildMultiSelect(String label, List<String> selected, List<Map<String, String>> options) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.w600, color: Colors.grey, fontSize: 13)),
        const SizedBox(height: 12),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: options.map((opt) {
            final isSelected = selected.contains(opt['value']);
            return InkWell(
              onTap: () {
                setState(() {
                  if (isSelected) selected.remove(opt['value']);
                  else selected.add(opt['value']!);
                });
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppTheme.primary50 : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: isSelected ? AppTheme.primary500 : Colors.grey[300]!),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isSelected) ...[
                      const Icon(Icons.check, size: 14, color: AppTheme.primary600),
                      const SizedBox(width: 4),
                    ],
                    Text(
                      opt['label']!,
                      style: TextStyle(
                        color: isSelected ? AppTheme.primary700 : Colors.black87,
                        fontWeight: FontWeight.w500,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
              ),
            );
          }).toList(),
        ),
      ],
    );
  }
}
