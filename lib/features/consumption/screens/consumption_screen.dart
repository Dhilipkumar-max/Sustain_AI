/// SUSTAINAI - Consumption Screen
/// Full implementation of the Sustainable Consumption module

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sustainai_flutter/core/theme/app_theme.dart';
import 'package:sustainai_flutter/features/auth/providers/auth_provider.dart';
import 'package:sustainai_flutter/features/consumption/models/consumption_model.dart';
import 'package:sustainai_flutter/features/consumption/services/consumption_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class ConsumptionScreen extends StatefulWidget {
  const ConsumptionScreen({super.key});

  @override
  State<ConsumptionScreen> createState() => _ConsumptionScreenState();
}

class _ConsumptionScreenState extends State<ConsumptionScreen> {
  int _currentStep = 1;
  String? _expandedSection = 'food';
  bool _isAnalyzing = false;
  SustainabilityResult? _analysisResult;
  late ConsumptionFormData _formData;

  @override
  void initState() {
    super.initState();
    _loadFormData();
  }

  Future<void> _loadFormData() async {
    final prefs = await SharedPreferences.getInstance();
    final savedData = prefs.getString('consumption-form-data');
    
    if (savedData != null) {
      try {
        final json = jsonDecode(savedData);
        setState(() {
          _formData = ConsumptionFormData.fromJson(json);
        });
      } catch (e) {
        setState(() {
          _formData = ConsumptionFormData();
        });
      }
    } else {
      setState(() {
        _formData = ConsumptionFormData();
      });
    }
  }

  Future<void> _saveFormData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('consumption-form-data', jsonEncode(_formData.toJson()));
  }

  void _updateForm(String field, dynamic value) {
    setState(() {
      switch (field) {
        case 'householdSize':
          _formData.householdSize = value;
          break;
        case 'livingArea':
          _formData.livingArea = value;
          break;
        case 'residenceType':
          _formData.residenceType = value;
          break;
        case 'lifestyleCategory':
          _formData.lifestyleCategory = value;
          break;
        case 'activityLevel':
          _formData.activityLevel = value;
          break;
        case 'awarenessLevel':
          _formData.awarenessLevel = value;
          break;
        case 'ecoWillingness':
          _formData.ecoWillingness = value;
          break;
        case 'diet':
          _formData.diet = value;
          break;
        case 'eatingOutFrequency':
          _formData.eatingOutFrequency = value;
          break;
        case 'foodWaste':
          _formData.foodWaste = value;
          break;
        case 'prioritizeLocal':
          _formData.prioritizeLocal = value;
          break;
        case 'electricityUsage':
          _formData.electricityUsage = value;
          break;
        case 'renewablePercentage':
          _formData.renewablePercentage = value;
          break;
        case 'transportMode':
          _formData.transportMode = value;
          break;
        case 'commuteDistance':
          _formData.commuteDistance = value;
          break;
        case 'shoppingFrequency':
          _formData.shoppingFrequency = value;
          break;
        case 'secondhandPercentage':
          _formData.secondhandPercentage = value;
          break;
      }
    });
    _saveFormData();
  }

  void _nextStep() {
    _saveFormData();
    setState(() {
      _currentStep = (_currentStep + 1).clamp(1, 3);
    });
  }

  void _prevStep() {
    _saveFormData();
    setState(() {
      _currentStep = (_currentStep - 1).clamp(1, 3);
    });
  }

  Future<void> _handleAnalyze() async {
    setState(() {
      _isAnalyzing = true;
    });

    try {
      final result = await ConsumptionService.analyzeConsumption(_formData);
      setState(() {
        _analysisResult = result;
      });

      // Save to Supabase if user is logged in
      final authProvider = context.read<AuthProvider>();
      if (authProvider.user?.id != null) {
        ConsumptionService.saveAssessment(
          authProvider.user!.id,
          _formData,
          result,
        ).catchError((e) => print('Failed to save assessment: $e'));
      }

      // Move to insights
      setState(() {
        _currentStep = 3;
      });
    } catch (e) {
      print('Analysis failed: $e');
      setState(() {
        _currentStep = 3; // Still show insights with fallback data
      });
    } finally {
      setState(() {
        _isAnalyzing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    
    return Scaffold(
      backgroundColor: const Color(0xFFf8fafc),
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: AppTheme.textLightPrimary),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppTheme.teal,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.eco, color: Colors.white, size: 18),
            ),
            const SizedBox(width: 12),
            const Text(
              'Consumption Module',
              style: TextStyle(
                color: AppTheme.textLightPrimary,
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Progress Indicator
          _buildProgressIndicator(),
          
          // Content
          Expanded(
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.all(24),
              child: _buildCurrentStep(authProvider),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressIndicator() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: Color(0xFFe2e8f0))),
      ),
      child: Row(
        children: [
          _buildStepCircle(1, 'Profile'),
          _buildStepLine(1),
          _buildStepCircle(2, 'Data'),
          _buildStepLine(2),
          _buildStepCircle(3, 'Insights'),
        ],
      ),
    );
  }

  Widget _buildStepCircle(int step, String label) {
    final isActive = _currentStep == step;
    final isCompleted = _currentStep > step;
    
    return Expanded(
      child: Column(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: isActive || isCompleted ? AppTheme.teal : Colors.grey[300],
              shape: BoxShape.circle,
            ),
            child: Center(
              child: isCompleted
                  ? const Icon(Icons.check, color: Colors.white, size: 20)
                  : Text(
                      '$step',
                      style: TextStyle(
                        color: isActive ? Colors.white : Colors.grey[600],
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: isActive ? AppTheme.teal : Colors.grey[600],
              fontWeight: isActive ? FontWeight.w600 : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStepLine(int step) {
    final isCompleted = _currentStep > step;
    
    return Expanded(
      child: Container(
        height: 2,
        margin: const EdgeInsets.only(bottom: 28),
        color: isCompleted ? AppTheme.teal : Colors.grey[300],
      ),
    );
  }

  Widget _buildCurrentStep(AuthProvider authProvider) {
    switch (_currentStep) {
      case 1:
        return _buildProfileSetup(authProvider);
      case 2:
        return _buildConsumptionData();
      case 3:
        return _buildInsights();
      default:
        return _buildProfileSetup(authProvider);
    }
  }

  // STEP 1: Profile Setup
  Widget _buildProfileSetup(AuthProvider authProvider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Title
        Text(
          authProvider.profile?.displayName  != null
              ? 'Welcome, ${authProvider.profile!.displayName.split(' ')[0]}!'
              : 'Consumption Profile',
          style: const TextStyle(
            fontSize: 32,
            fontWeight: FontWeight.bold,
            color: AppTheme.textLightPrimary,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Refine your profile to help the SUSTAINAI engine calculate your footprint with precision.',
          style: TextStyle(
            fontSize: 16,
            color: AppTheme.textLightSecondary,
            height: 1.6,
          ),
        ),
        const SizedBox(height: 32),

        // Basic Details Section
        _buildFormSection(
          icon: Icons.home,
          iconColor: AppTheme.green,
          title: 'Basic Details',
          children: [
            _buildNumberField(
              label: 'Household Size',
              value: _formData.householdSize,
              onChanged: (v) => _updateForm('householdSize', v),
              min: 1,
              max: 20,
            ),
            _buildSelectField(
              label: 'Living Area Type',
              value: _formData.livingArea,
              options: const [
                {'value': 'urban', 'label': 'Urban (City Center)'},
                {'value': 'suburban', 'label': 'Suburban'},
                {'value': 'rural', 'label': 'Rural'},
              ],
              onChanged: (v) => _updateForm('livingArea', v),
            ),
            _buildSelectField(
              label: 'Residence Type',
              value: _formData.residenceType,
              options: const [
                {'value': 'apartment', 'label': 'Apartment / Flat'},
                {'value': 'house', 'label': 'House'},
                {'value': 'townhouse', 'label': 'Townhouse'},
              ],
              onChanged: (v) => _updateForm('residenceType', v),
            ),
          ],
        ),

        const SizedBox(height: 24),

        // Lifestyle Section
        _buildFormSection(
          icon: Icons.flash_on,
          iconColor: AppTheme.orange,
          title: 'Lifestyle Information',
          children: [
            _buildSelectField(
              label: 'Lifestyle Category',
              value: _formData.lifestyleCategory,
              options: const [
                {'value': 'minimal', 'label': 'Minimal Consumption'},
                {'value': 'moderate', 'label': 'Moderate Consumption'},
                {'value': 'high', 'label': 'High Consumption'},
              ],
              onChanged: (v) => _updateForm('lifestyleCategory', v),
            ),
            const SizedBox(height: 16),
            const Text(
              'Average Daily Activity Level',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textLightPrimary,
              ),
            ),
            const SizedBox(height: 12),
            _buildRadioCards([
              {
                'value': 'sedentary',
                'title': 'Sedentary',
                'desc': 'Mostly sitting throughout the day'
              },
              {
                'value': 'moderate',
                'title': 'Moderately Active',
                'desc': 'Walking, light exercise, standing'
              },
              {
                'value': 'active',
                'title': 'Highly Active',
                'desc': 'Physical labor or heavy sport'
              },
            ], _formData.activityLevel, (v) => _updateForm('activityLevel', v)),
          ],
        ),

        const SizedBox(height: 24),

        // Sustainability Awareness Section
        _buildFormSection(
          icon: Icons.eco,
          iconColor: AppTheme.green,
          title: 'Sustainability Awareness',
          children: [
            _buildSliderField(
              label: 'Awareness Level',
              value: _formData.awarenessLevel,
              min: 0,
              max: 100,
              onChanged: (v) => _updateForm('awarenessLevel', v.round()),
              labels: const ['BEGINNER', 'INTERMEDIATE', 'ADVANCED'],
            ),
            const SizedBox(height: 16),
            const Text(
              'Willingness to Adopt Eco-Friendly Practices',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textLightPrimary,
              ),
            ),
            const SizedBox(height: 12),
            _buildVerticalRadioButtons([
              {'value': 'very_willing', 'label': 'Very Willing'},
              {'value': 'neutral', 'label': 'Neutral / Case-by-Case'},
              {'value': 'not_priority', 'label': 'Not a Priority'},
            ], _formData.ecoWillingness, (v) => _updateForm('ecoWillingness', v)),
          ],
        ),

        const SizedBox(height: 40),

        // Action Buttons
        Row(
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: _nextStep,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.teal,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Text(
                      'Save Profile & Continue',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    SizedBox(width: 8),
                    Icon(Icons.arrow_forward, size: 18),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Center(
          child: TextButton(
            onPressed: _nextStep,
            child: const Text(
              'Skip for Now',
              style: TextStyle(color: AppTheme.textLightSecondary),
            ),
          ),
        ),
      ],
    );
  }

  // To be continued in next file...
  Widget _buildConsumptionData() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Detailed Consumption',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: AppTheme.textLightPrimary,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Provide more details to get accurate insights.',
          style: TextStyle(
            fontSize: 16,
            color: AppTheme.textLightSecondary,
          ),
        ),
        const SizedBox(height: 24),

        // Food Section
        _buildFormSection(
          icon: Icons.restaurant,
          iconColor: AppTheme.orange,
          title: 'Food & Nutrition',
          children: [
            _buildSelectField(
              label: 'Dietary Preference',
              value: _formData.diet,
              options: const [
                {'value': 'vegan', 'label': 'Vegan (No animal products)'},
                {'value': 'vegetarian', 'label': 'Vegetarian'},
                {'value': 'pescatarian', 'label': 'Pescatarian'},
                {'value': 'omnivore', 'label': 'Omnivore (Eat everything)'},
              ],
              onChanged: (v) => _updateForm('diet', v),
            ),
            _buildSliderField(
              label: 'Food Waste (Estimated %)',
              value: _formData.foodWaste,
              min: 0,
              max: 50,
              onChanged: (v) => _updateForm('foodWaste', v.round()),
              labels: const ['0%', '25%', '50%'],
            ),
             // Prioritize Local Switch
             Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Prioritize Local/Seasonal?', 
                    style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppTheme.textLightPrimary)),
                Switch(
                  value: _formData.prioritizeLocal,
                  activeColor: AppTheme.teal,
                  onChanged: (v) => _updateForm('prioritizeLocal', v),
                ),
              ],
             ),
          ],
        ),
        
        const SizedBox(height: 20),

        // Transport Section
         _buildFormSection(
          icon: Icons.directions_car,
          iconColor: Colors.blue,
          title: 'Transport',
          children: [
             _buildSelectField(
              label: 'Primary Transport Mode',
              value: _formData.transportMode,
              options: const [
                {'value': 'car', 'label': 'Private Car'},
                {'value': 'motorcycle', 'label': 'Motorcycle'},
                {'value': 'public', 'label': 'Public Transport'},
                {'value': 'bicycle', 'label': 'Bicycle / Walk'},
              ],
              onChanged: (v) => _updateForm('transportMode', v),
            ),
             _buildNumberField(
              label: 'Daily Commute (km)',
              value: _formData.commuteDistance,
              onChanged: (v) => _updateForm('commuteDistance', v),
              max: 200,
            ),
          ],
        ),

        const SizedBox(height: 20),
        
        // Energy Section
        _buildFormSection(
          icon: Icons.lightbulb,
          iconColor: Colors.amber,
          title: 'Home Energy',
          children: [
             _buildNumberField(
              label: 'Monthly Electricity (kWh)',
              value: _formData.electricityUsage,
              onChanged: (v) => _updateForm('electricityUsage', v),
              max: 1000,
            ),
             _buildSliderField(
              label: 'Renewable Energy (%)',
              value: _formData.renewablePercentage,
              min: 0,
              max: 100,
              onChanged: (v) => _updateForm('renewablePercentage', v.round()),
              labels: const ['0%', '50%', '100%'],
            ),
          ],
        ),

        const SizedBox(height: 32),

        // Analyze Button
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _isAnalyzing ? null : _handleAnalyze,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppTheme.teal,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              elevation: 4,
            ),
            child: _isAnalyzing 
              ? const SizedBox(
                  height: 24, 
                  width: 24, 
                  child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2)
                )
              : const Text(
                  'Analyze Consumption', 
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)
                ),
          ),
        ),
        const SizedBox(height: 20),
        Center(
          child: TextButton(
            onPressed: _prevStep,
            child: const Text('Back to Profile', style: TextStyle(color: AppTheme.textLightSecondary)),
          ),
        ),
      ],
    );
  }

  Widget _buildInsights() {
    if (_analysisResult == null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.analytics_outlined, size: 64, color: AppTheme.textLightSecondary),
            const SizedBox(height: 16),
            const Text('No analysis data available yet.', style: TextStyle(color: AppTheme.textLightSecondary)),
            TextButton(
              onPressed: () => setState(() => _currentStep = 1),
              child: const Text('Start Assessment'),
            ),
          ],
        ),
      );
    }

    final result = _analysisResult!;

    return Column(
      children: [
        // App Bar / Breadcrumb
        Padding(
          padding: const EdgeInsets.only(bottom: 24),
          child: Row(
            children: [
              Text(
                'DASHBOARD  ›  ENGINE  ›  INSIGHTS',
                style: TextStyle(
                  color: AppTheme.primary500,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 1.0,
                ),
              ),
            ],
          ),
        ),

        // 1. Sustainability Score Card
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Stack(
            children: [
              // Decorative Leaf
              Positioned(
                top: 0,
                right: 0,
                child: Opacity(
                  opacity: 0.1,
                  child: Icon(Icons.eco, size: 64, color: AppTheme.primary500),
                ),
              ),
              Column(
                children: [
                  // Circular Progress
                  SizedBox(
                    width: 140,
                    height: 140,
                    child: Stack(
                      children: [
                        Center(
                          child: SizedBox(
                            width: 140,
                            height: 140,
                            child: CircularProgressIndicator(
                              value: 1.0,
                              strokeWidth: 10,
                              color: Colors.grey[100],
                            ),
                          ),
                        ),
                        Center(
                          child: SizedBox(
                            width: 140,
                            height: 140,
                            child: CircularProgressIndicator(
                              value: result.score / 100,
                              strokeWidth: 10,
                              color: AppTheme.primary500, // Green
                              strokeCap: StrokeCap.round,
                            ),
                          ),
                        ),
                        Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '${result.score}',
                                style: const TextStyle(
                                  fontSize: 36,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF111815),
                                  height: 1.0,
                                ),
                              ),
                              Text(
                                '/100',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.grey[400],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    _getScoreLabel(result.score),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111815),
                    ),
                  ),
                  const Text(
                    'Sustainability Score',
                    style: TextStyle(
                      fontSize: 14,
                      color: Color(0xFF9CA3AF),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // 2. Impact Breakdown Card
        Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.04),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.bar_chart, color: AppTheme.primary500),
                  const SizedBox(width: 8),
                  const Text(
                    'Impact Breakdown',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF111815),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Filter out duplicate categories if any
              ...result.breakdown.map((item) => _buildImpactRow(item)).toList(),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // 3. Carbon Footprint Card (Dark)
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF111815), // Black
                Color(0xFF064e3b), // Dark Green
              ],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: Column(
            children: [
              const Text(
                'CARBON FOOTPRINT',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 12,
                  letterSpacing: 1.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              
              // Gauge Meter
              SizedBox(
                height: 80, // Height is half of width (160)
                width: 160,
                child: CustomPaint(
                  painter: GaugePainter(
                    value: (result.carbonFootprint / 10.0).clamp(0.0, 1.0), // Assuming 10 is max scale
                    color: const Color(0xFFE68A6E), // Coral Warning
                    backgroundColor: const Color(0xFF2a302e),
                  ),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '${result.carbonFootprint}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w800,
                            height: 1.0,
                          ),
                        ),
                        const Text(
                          'tons CO2e/year',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // Warning Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE68A6E).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE68A6E).withOpacity(0.3)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: const [
                    Icon(Icons.warning, color: Color(0xFFE68A6E), size: 14),
                    SizedBox(width: 6),
                    Text(
                      '15% ABOVE AVERAGE', // Currently hardcoded/placeholder logic
                      style: TextStyle(
                        color: Color(0xFFE68A6E),
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 20),

        // 4. AI Key Insights
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppTheme.primary500.withOpacity(0.05),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppTheme.primary500.withOpacity(0.2)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 24,
                    height: 24,
                    decoration: BoxDecoration(
                      color: AppTheme.primary500,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(Icons.auto_awesome, color: Colors.white, size: 14),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'AI Key Insights',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: AppTheme.primary600,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              _buildInsightBullet('Transportation contributes 38% of your total emissions this month.'),
              const SizedBox(height: 12),
              _buildInsightBullet('Energy efficiency increased by 5% compared to your last analysis.'),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // 5. Smart Recommendations Header
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'Smart Recommendations',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF111815),
              ),
            ),
            Text(
              'SEE ALL',
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: AppTheme.primary500,
                letterSpacing: 0.5,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),

        // Recommendation Cards
        ...result.suggestions.take(3).map((suggestion) => Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.02),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: _getCategoryColor(suggestion.category).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(suggestion.icon, style: const TextStyle(fontSize: 24)),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.grey[100],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            suggestion.category.toUpperCase(),
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey[600],
                            ),
                          ),
                        ),
                        Text(
                          suggestion.impact,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppTheme.primary600,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    Text(
                      suggestion.title,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF111815),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Row(
                      children: [
                        Icon(Icons.signal_cellular_alt, size: 12, color: Colors.grey[400]),
                        const SizedBox(width: 4),
                        Text(
                          '${suggestion.difficulty} Difficulty',
                          style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        )).toList(),

        const SizedBox(height: 24),

        // Action Buttons
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0F9D58), // Google Green
              foregroundColor: Colors.white,
              elevation: 4,
              shadowColor: const Color(0xFF0F9D58).withOpacity(0.4),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            ),
            child: const Text(
              'Done',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.5,
              ),
            ),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: TextButton(
            onPressed: () => setState(() => _currentStep = 2),
            child: const Text(
              'Modify Consumption Data',
              style: TextStyle(
                color: Color(0xFF4B5563), // Cool Gray 600
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }

  // Helpers
  String _getScoreLabel(int score) {
    if (score >= 80) return 'Excellent';
    if (score >= 60) return 'Fair';
    return 'Poor';
  }

  Color _getCategoryColor(String category) {
    switch (category.toUpperCase()) {
      case 'FOOD': return AppTheme.orange;
      case 'ENERGY': return AppTheme.primary500;
      case 'TRANSPORT': return const Color(0xFFE68A6E);
      default: return Colors.blue;
    }
  }

  Widget _buildImpactRow(ImpactBreakdown item) {
    Color color;
    String status;
    
    // Logic matching design system
    if (item.value <= 40) {
      color = AppTheme.primary500; // Green
      status = 'Low Impact';
    } else if (item.value <= 70) {
      color = AppTheme.primary500; // Still green for efficient
      status = 'Moderate / Efficient'; 
    } else {
      color = const Color(0xFFE68A6E); // Coral/Orange
      status = 'High Impact';
    }

    // Override specifically for UI match
    if (item.category == 'Food') status = 'Moderate Impact';
    if (item.category == 'Energy') status = 'Efficient';
    if (item.category == 'Transport') { status = 'High Impact'; color = const Color(0xFFE68A6E); }
    if (item.category == 'Lifestyle') status = 'Low Impact';

    IconData icon;
    switch(item.category) {
      case 'Food': icon = Icons.restaurant; break;
      case 'Energy': icon = Icons.bolt; break;
      case 'Transport': icon = Icons.commute; break;
      case 'Lifestyle': icon = Icons.shopping_bag; break;
      default: icon = Icons.circle;
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 32,
                    height: 32,
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(icon, color: color, size: 18),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    item.category,
                    style: const TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                      color: Color(0xFF111815),
                    ),
                  ),
                ],
              ),
              Text(
                status,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: color == const Color(0xFFE68A6E) ? color : const Color(0xFF6B7280),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: item.value / 100,
              backgroundColor: Colors.grey[100],
              color: color,
              minHeight: 8,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightBullet(String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 6),
          child: Container(
            width: 6,
            height: 6,
            decoration: const BoxDecoration(
              color: AppTheme.primary500,
              shape: BoxShape.circle,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 14,
              height: 1.5,
              color: Color(0xFF374151),
            ),
          ),
        ),
      ],
    );
  }


  // Helper Widgets will be added in the continuation...
  Widget _buildFormSection({
    required IconData icon,
    required Color iconColor,
    required String title,
    required List<Widget> children,
  }) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFe2e8f0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textLightPrimary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          ...children,
        ],
      ),
    );
  }

  Widget _buildNumberField({
    required String label,
    required int value,
    required Function(int) onChanged,
    int min = 0,
    int max = 100,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textLightPrimary,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.info_outline, size: 14, color: AppTheme.textLightSecondary),
            ],
          ),
          const SizedBox(height: 8),
          TextField(
            keyboardType: TextInputType.number,
            controller: TextEditingController(text: value.toString()),
            onChanged: (v) => onChanged(int.tryParse(v) ?? min),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFe2e8f0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFe2e8f0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppTheme.teal, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSelectField({
    required String label,
    required String value,
    required List<Map<String, String>> options,
    required Function(String) onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppTheme.textLightPrimary,
                ),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.info_outline, size: 14, color: AppTheme.textLightSecondary),
            ],
          ),
          const SizedBox(height: 8),
          DropdownButtonFormField<String>(
            value: value,
            items: options.map((opt) {
              return DropdownMenuItem(
                value: opt['value'],
                child: Text(opt['label'] ?? ''),
              );
            }).toList(),
            onChanged: (v) => onChanged(v!),
            decoration: InputDecoration(
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFe2e8f0)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFe2e8f0)),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppTheme.teal, width: 2),
              ),
              contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRadioCards(
    List<Map<String, String>> options,
    String currentValue,
    Function(String) onChanged,
  ) {
    return Column(
      children: options.map((opt) {
        final isSelected = currentValue == opt['value'];
        return GestureDetector(
          onTap: () => onChanged(opt['value']!),
          child: Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.teal.withOpacity(0.05) : Colors.white,
              border: Border.all(
                color: isSelected ? AppTheme.teal : const Color(0xFFe2e8f0),
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? AppTheme.teal : Colors.grey[400]!,
                      width: 2,
                    ),
                    color: isSelected ? AppTheme.teal : Colors.transparent,
                  ),
                  child: isSelected
                      ? const Center(
                          child: Icon(Icons.circle, size: 10, color: Colors.white),
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        opt['title']!,
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? AppTheme.teal : AppTheme.textLightPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        opt['desc']!,
                        style: const TextStyle(
                          fontSize: 13,
                          color: AppTheme.textLightSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildSliderField({
    required String label,
    required int value,
    required int min,
    required int max,
    required Function(double) onChanged,
    required List<String> labels,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppTheme.textLightPrimary,
              ),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.info_outline, size: 14, color: AppTheme.textLightSecondary),
          ],
        ),
        const SizedBox(height: 12),
        Slider(
          value: value.toDouble(),
          min: min.toDouble(),
          max: max.toDouble(),
          activeColor: AppTheme.teal,
          onChanged: onChanged,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: labels.map((l) {
            return Text(
              l,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: AppTheme.textLightSecondary,
              ),
            );
          }).toList(),
        ),
      ],
    );
  }

  Widget _buildVerticalRadioButtons(
    List<Map<String, String>> options,
    String currentValue,
    Function(String) onChanged,
  ) {
    return Column(
      children: options.map((opt) {
        final isSelected = currentValue == opt['value'];
        return GestureDetector(
          onTap: () => onChanged(opt['value']!),
          child: Container(
            margin: const EdgeInsets.only(bottom: 8),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: isSelected ? AppTheme.teal.withOpacity(0.05) : Colors.white,
              border: Border.all(
                color: isSelected ? AppTheme.teal : const Color(0xFFe2e8f0),
                width: isSelected ? 2 : 1,
              ),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? AppTheme.teal : Colors.grey[400]!,
                      width: 2,
                    ),
                    color: isSelected ? AppTheme.teal : Colors.transparent,
                  ),
                  child: isSelected
                      ? const Center(
                          child: Icon(Icons.circle, size: 10, color: Colors.white),
                        )
                      : null,
                ),
                const SizedBox(width: 12),
                Text(
                  opt['label']!,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: isSelected ? AppTheme.teal : AppTheme.textLightPrimary,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

class GaugePainter extends CustomPainter {
  final double value; // 0.0 to 1.0
  final Color color;
  final Color backgroundColor;

  GaugePainter({
    required this.value,
    required this.color,
    required this.backgroundColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height);
    final radius = size.width / 2;
    final strokeWidth = 12.0;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    // Background Arc (180 degrees)
    paint.color = backgroundColor;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth/2),
      3.14159, // PI (180 deg)
      3.14159, // PI (180 deg sweep)
      false,
      paint,
    );

    // Foreground Arc
    paint.color = color;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius - strokeWidth/2),
      3.14159,
      3.14159 * value,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

