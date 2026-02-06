/// SUSTAINAI - Consumption Service
/// Core functionality for sustainable consumption analysis

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:sustainai_flutter/core/services/supabase_service.dart';
import 'package:sustainai_flutter/features/consumption/models/consumption_model.dart';

class ConsumptionService {
  static const String _openWeatherApiKey = ''; // Add your key if available
  static const String _electricityMapsToken = ''; // Add your key if available
  static const int _apiTimeout = 5; // seconds

  /// Calculate sustainability score based on form data
  static int calculateSustainabilityScore(
    ConsumptionFormData formData,
    EnvironmentalContext context,
  ) {
    // Base score from lifestyle
    final lifestyleScores = {'minimal': 85, 'moderate': 65, 'high': 40};
    var baseScore = lifestyleScores[formData.lifestyleCategory] ?? 65;

    // Activity modifier
    final activityModifiers = {'sedentary': 5, 'moderate': 0, 'active': -5};
    baseScore += activityModifiers[formData.activityLevel] ?? 0;

    // Diet impact
    final dietModifiers = {
      'vegan': 15,
      'vegetarian': 10,
      'pescatarian': 5,
      'omnivore': 0
    };
    baseScore += dietModifiers[formData.diet] ?? 0;

    // Food waste penalty
    final wastePenalty = (formData.foodWaste / 25).floor() * -5;
    baseScore += wastePenalty;

    // Local food bonus
    if (formData.prioritizeLocal) {
      baseScore += 5;
    }

    // Regional modifier
    var regionalModifier = 0;
    if (context.airQualityIndex > 100) {
      regionalModifier = -10;
    } else if (context.airQualityIndex < 50) {
      regionalModifier = 5;
    }

    if (context.carbonIntensity > 400) {
      regionalModifier -= 5;
    } else if (context.carbonIntensity < 200) {
      regionalModifier += 5;
    }

    // Awareness bonus
    final awarenessBonus = (formData.awarenessLevel / 10).floor();

    // Willingness modifier
    final willingnessModifiers = {
      'very_willing': 5,
      'neutral': 0,
      'not_priority': -5
    };
    final willingnessBonus = willingnessModifiers[formData.ecoWillingness] ?? 0;

    // Calculate final score
    final finalScore = baseScore + regionalModifier + awarenessBonus + willingnessBonus;

    // Clamp to 0-100
    return finalScore.clamp(0, 100).round();
  }

  /// Determine impact level from score
  static String getImpactLevel(int score) {
    if (score >= 75) return 'Low';
    if (score >= 50) return 'Moderate';
    return 'High';
  }

  /// Generate impact breakdown by category
  static List<ImpactBreakdown> generateImpactBreakdown(
    ConsumptionFormData formData,
  ) {
    // Food impact
    final dietScores = {
      'vegan': 25.0,
      'vegetarian': 35.0,
      'pescatarian': 50.0,
      'omnivore': 65.0
    };
    final foodScore = dietScores[formData.diet] ?? 60.0;
    final double foodWasteImpact = (foodScore + formData.foodWaste / 2).clamp(0.0, 100.0);

    // Energy impact
    final lifestyleEnergy = {'minimal': 30.0, 'moderate': 55.0, 'high': 80.0};
    final energyScore = lifestyleEnergy[formData.lifestyleCategory] ?? 55.0;

    // Transport impact
    final activityTransport = {
      'sedentary': 35.0,
      'moderate': 55.0,
      'active': 70.0
    };
    final transportScore = activityTransport[formData.activityLevel] ?? 55.0;

    // Lifestyle impact
    final awarenessImpact = (100 - formData.awarenessLevel).toDouble();

    String getColor(double value) {
      if (value <= 40) return 'green';
      if (value <= 70) return 'orange';
      return 'red';
    }

    String getStatus(double value) {
      if (value <= 40) return 'Low impact';
      if (value <= 70) return 'Moderate impact';
      return 'High impact';
    }

    return [
      ImpactBreakdown(
        category: 'Food',
        status: getStatus(foodWasteImpact),
        value: foodWasteImpact,
        color: getColor(foodWasteImpact),
      ),
      ImpactBreakdown(
        category: 'Energy',
        status: getStatus(energyScore),
        value: energyScore,
        color: getColor(energyScore),
      ),
      ImpactBreakdown(
        category: 'Transport',
        status: getStatus(transportScore),
        value: transportScore,
        color: getColor(transportScore),
      ),
      ImpactBreakdown(
        category: 'Lifestyle',
        status: getStatus(awarenessImpact),
        value: awarenessImpact,
        color: getColor(awarenessImpact),
      ),
    ];
  }

  /// Estimate carbon footprint in tons CO2e/year
  static double estimateCarbonFootprint(
    ConsumptionFormData formData,
    EnvironmentalContext context,
  ) {
    // Base footprint
    final baseFootprint = {'minimal': 1.5, 'moderate': 2.5, 'high': 4.0};
    var footprint = baseFootprint[formData.lifestyleCategory] ?? 2.5;

    // Diet adjustment
    final dietAdjustment = {
      'vegan': -0.8,
      'vegetarian': -0.5,
      'pescatarian': -0.3,
      'omnivore': 0.0
    };
    footprint += dietAdjustment[formData.diet] ?? 0;

    // Regional carbon intensity
    if (context.carbonIntensity > 400) {
      footprint *= 1.2;
    } else if (context.carbonIntensity < 200) {
      footprint *= 0.8;
    }

    // Household size factor
    footprint *= (1 + (formData.householdSize - 1) * 0.3);

    return (footprint * 10).round() / 10;
  }

  /// Generate personalized suggestions
  static List<Suggestion> generateSuggestions(
    ConsumptionFormData formData,
    List<ImpactBreakdown> breakdown,
  ) {
    final suggestionBank = [
      // Food
      Suggestion(
        id: 'f1',
        category: 'FOOD',
        title: 'Reduce meat consumption',
        impact: '-15% Impact',
        difficulty: 'Medium',
        icon: '🥗',
      ),
      Suggestion(
        id: 'f2',
        category: 'FOOD',
        title: 'Buy local produce',
        impact: '-8% Impact',
        difficulty: 'Easy',
        icon: '🌽',
      ),
      Suggestion(
        id: 'f3',
        category: 'FOOD',
        title: 'Start composting',
        impact: '-10% Impact',
        difficulty: 'Medium',
        icon: '🌱',
      ),
      Suggestion(
        id: 'f4',
        category: 'FOOD',
        title: 'Meal planning to reduce waste',
        impact: '-12% Impact',
        difficulty: 'Easy',
        icon: '📋',
      ),
      // Energy
      Suggestion(
        id: 'e1',
        category: 'ENERGY',
        title: 'Switch to LED bulbs',
        impact: '-5% Impact',
        difficulty: 'Easy',
        icon: '💡',
      ),
      Suggestion(
        id: 'e2',
        category: 'ENERGY',
        title: 'Use smart power strips',
        impact: '-8% Impact',
        difficulty: 'Easy',
        icon: '🔌',
      ),
      Suggestion(
        id: 'e3',
        category: 'ENERGY',
        title: 'Optimize thermostat settings',
        impact: '-10% Impact',
        difficulty: 'Easy',
        icon: '🌡️',
      ),
      Suggestion(
        id: 'e4',
        category: 'ENERGY',
        title: 'Switch to renewable provider',
        impact: '-25% Impact',
        difficulty: 'Medium',
        icon: '☀️',
      ),
      // Transport
      Suggestion(
        id: 't1',
        category: 'TRANSPORT',
        title: 'Carpool 2x/week',
        impact: '-12% Impact',
        difficulty: 'Medium',
        icon: '🚗',
      ),
      Suggestion(
        id: 't2',
        category: 'TRANSPORT',
        title: 'Use public transit',
        impact: '-20% Impact',
        difficulty: 'Medium',
        icon: '🚌',
      ),
      Suggestion(
        id: 't3',
        category: 'TRANSPORT',
        title: 'Bike for short trips',
        impact: '-15% Impact',
        difficulty: 'Easy',
        icon: '🚴',
      ),
      Suggestion(
        id: 't4',
        category: 'TRANSPORT',
        title: 'Work from home 1 day/week',
        impact: '-8% Impact',
        difficulty: 'Easy',
        icon: '🏠',
      ),
      // Lifestyle
      Suggestion(
        id: 'l1',
        category: 'LIFESTYLE',
        title: 'Reduce single-use plastics',
        impact: '-5% Impact',
        difficulty: 'Easy',
        icon: '♻️',
      ),
      Suggestion(
        id: 'l2',
        category: 'LIFESTYLE',
        title: 'Buy second-hand items',
        impact: '-10% Impact',
        difficulty: 'Easy',
        icon: '👕',
      ),
      Suggestion(
        id: 'l3',
        category: 'LIFESTYLE',
        title: 'Repair instead of replace',
        impact: '-8% Impact',
        difficulty: 'Medium',
        icon: '🔧',
      ),
      Suggestion(
        id: 'l4',
        category: 'LIFESTYLE',
        title: 'Digital declutter',
        impact: '-3% Impact',
        difficulty: 'Easy',
        icon: '☁️',
      ),
    ];

    // Sort categories by impact
    final sortedCategories = [...breakdown]
      ..sort((a, b) => b.value.compareTo(a.value));

    final prioritizedSuggestions = <Suggestion>[];

    for (final breakdown in sortedCategories) {
      final category = breakdown.category.toUpperCase();
      final categorySuggestions =
          suggestionBank.where((s) => s.category == category);

      if (formData.ecoWillingness == 'not_priority') {
        prioritizedSuggestions
            .addAll(categorySuggestions.where((s) => s.difficulty == 'Easy'));
      } else {
        prioritizedSuggestions.addAll(categorySuggestions);
      }
    }

    return prioritizedSuggestions.take(4).toList();
  }

  /// Fetch environmental context (with fallback if APIs not available)
  static Future<EnvironmentalContext> fetchEnvironmentalContext(
    String livingArea,
  ) async {
    // Default fallback values
    var airQuality = 50;
    var carbonIntensity = 400;
    var regionalBenchmark = 65;
    String region;

    final regionNames = {
      'urban': 'Urban Area (Delhi)',
      'suburban': 'Suburban Area (Bangalore)',
      'rural': 'Rural Area (UP)',
    };
    region = regionNames[livingArea] ?? 'Unknown Region';

    // Try to fetch real data if API keys are available
    // For now, using fallback values based on region type
    if (livingArea == 'urban') {
      airQuality = 120; // Higher pollution in urban areas
      carbonIntensity = 450;
    } else if (livingArea == 'suburban') {
      airQuality = 60;
      carbonIntensity = 400;
    } else {
      airQuality = 30; // Better air in rural areas
      carbonIntensity = 350;
    }

    regionalBenchmark = ((100 - airQuality / 5) + (500 - carbonIntensity) / 10)
        .round()
        .clamp(0, 100);

    return EnvironmentalContext(
      airQualityIndex: airQuality,
      carbonIntensity: carbonIntensity,
      regionalBenchmark: regionalBenchmark,
      region: region,
    );
  }

  /// Perform complete sustainability analysis
  static Future<SustainabilityResult> analyzeConsumption(
    ConsumptionFormData formData,
  ) async {
    // 1. Fetch environmental context
    final context = await fetchEnvironmentalContext(formData.livingArea);

    // 2. Calculate sustainability score
    final score = calculateSustainabilityScore(formData, context);

    // 3. Determine impact level
    final impactLevel = getImpactLevel(score);

    // 4. Generate impact breakdown
    final breakdown = generateImpactBreakdown(formData);

    // 5. Estimate carbon footprint
    final carbonFootprint = estimateCarbonFootprint(formData, context);

    // 6. Generate suggestions
    final suggestions = generateSuggestions(formData, breakdown);

    return SustainabilityResult(
      score: score,
      impactLevel: impactLevel,
      breakdown: breakdown,
      suggestions: suggestions,
      carbonFootprint: carbonFootprint,
      apiContext: context,
    );
  }

  /// Save assessment to Supabase
  static Future<void> saveAssessment(
    String userId,
    ConsumptionFormData formData,
    SustainabilityResult result,
  ) async {
    final assessment = {
      'user_id': userId,
      ...formData.toJson(),
      'sustainability_score': result.score,
      'impact_level': result.impactLevel,
      'carbon_footprint': result.carbonFootprint,
      'suggestions': result.suggestions.map((s) => s.toJson()).toList(),
      'breakdown': result.breakdown.map((b) => b.toJson()).toList(),
      'api_context': result.apiContext.toJson(),
    };

    try {
      await SupabaseService.client
          .from('consumption_assessments')
          .insert(assessment);
    } catch (e) {
      print('Failed to save assessment: $e');
      // Non-blocking - don't throw error
    }
  }

  /// Get assessment history for a user
  static Future<List<Map<String, dynamic>>> getAssessmentHistory(
    String userId, {
    int limit = 10,
  }) async {
    try {
      final response = await SupabaseService.client
          .from('consumption_assessments')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(limit);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      print('Failed to fetch assessment history: $e');
      return [];
    }
  }

  /// Get the latest assessment for a user
  static Future<Map<String, dynamic>?> getLatestAssessment(
    String userId,
  ) async {
    try {
      final response = await SupabaseService.client
          .from('consumption_assessments')
          .select()
          .eq('user_id', userId)
          .order('created_at', ascending: false)
          .limit(1)
          .single();

      return response;
    } catch (e) {
      print('Failed to fetch latest assessment: $e');
      return null;
    }
  }
}
