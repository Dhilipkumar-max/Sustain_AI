/// SUSTAINAI - Consumption Models
/// Data models for the Consumption module

class ConsumptionFormData {
  // Profile
  int householdSize;
  String livingArea;
  String residenceType;
  String lifestyleCategory;
  String activityLevel;
  int awarenessLevel;
  String ecoWillingness;
  
  // Consumption Data
  String diet;
  String eatingOutFrequency;
  int foodWaste;
  bool prioritizeLocal;
  
  // Energy
  int electricityUsage;
  int renewablePercentage;
  
  // Transport
  String transportMode;
  int commuteDistance;
  
  // Lifestyle
  String shoppingFrequency;
  int secondhandPercentage;

  ConsumptionFormData({
    this.householdSize = 2,
    this.livingArea = 'urban',
    this.residenceType = 'apartment',
    this.lifestyleCategory = 'moderate',
    this.activityLevel = 'moderate',
    this.awarenessLevel = 50,
    this.ecoWillingness = 'very_willing',
    this.diet = 'vegan',
    this.eatingOutFrequency = 'rarely',
    this.foodWaste = 30,
    this.prioritizeLocal = true,
    this.electricityUsage = 350,
    this.renewablePercentage = 20,
    this.transportMode = 'car',
    this.commuteDistance = 50,
    this.shoppingFrequency = 'sometimes',
    this.secondhandPercentage = 30,
  });

  Map<String, dynamic> toJson() => {
    'household_size': householdSize,
    'living_area': livingArea,
    'residence_type': residenceType,
    'lifestyle_category': lifestyleCategory,
    'activity_level': activityLevel,
    'awareness_level': awarenessLevel,
    'eco_willingness': ecoWillingness,
    'diet': diet,
    'eating_out_frequency': eatingOutFrequency,
    'food_waste': foodWaste,
    'prioritize_local': prioritizeLocal,
    'electricity_usage': electricityUsage,
    'renewable_percentage': renewablePercentage,
    'transport_mode': transportMode,
    'commute_distance': commuteDistance,
    'shopping_frequency': shoppingFrequency,
    'secondhand_percentage': secondhandPercentage,
  };

  factory ConsumptionFormData.fromJson(Map<String, dynamic> json) {
    return ConsumptionFormData(
      householdSize: json['household_size'] ?? 2,
      livingArea: json['living_area'] ?? 'urban',
      residenceType: json['residence_type'] ?? 'apartment',
      lifestyleCategory: json['lifestyle_category'] ?? 'moderate',
      activityLevel: json['activity_level'] ?? 'moderate',
      awarenessLevel: json['awareness_level'] ?? 50,
      ecoWillingness: json['eco_willingness'] ?? 'very_willing',
      diet: json['diet'] ?? 'vegan',
      eatingOutFrequency: json['eating_out_frequency'] ?? 'rarely',
      foodWaste: json['food_waste'] ?? 30,
      prioritizeLocal: json['prioritize_local'] ?? true,
      electricityUsage: json['electricity_usage'] ?? 350,
      renewablePercentage: json['renewable_percentage'] ?? 20,
      transportMode: json['transport_mode'] ?? 'car',
      commuteDistance: json['commute_distance'] ?? 50,
      shoppingFrequency: json['shopping_frequency'] ?? 'sometimes',
      secondhandPercentage: json['secondhand_percentage'] ?? 30,
    );
  }
}

class ImpactBreakdown {
  final String category;
  final String status;
  final double value;
  final String color;

  ImpactBreakdown({
    required this.category,
    required this.status,
    required this.value,
    required this.color,
  });

  Map<String, dynamic> toJson() => {
    'category': category,
    'status': status,
    'value': value,
    'color': color,
  };

  factory ImpactBreakdown.fromJson(Map<String, dynamic> json) {
    return ImpactBreakdown(
      category: json['category'] ?? '',
      status: json['status'] ?? '',
      value: (json['value'] ?? 0).toDouble(),
      color: json['color'] ?? 'green',
    );
  }
}

class Suggestion {
  final String id;
  final String category;
  final String title;
  final String impact;
  final String difficulty;
  final String icon;

  Suggestion({
    required this.id,
    required this.category,
    required this.title,
    required this.impact,
    required this.difficulty,
    required this.icon,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'category': category,
    'title': title,
    'impact': impact,
    'difficulty': difficulty,
    'icon': icon,
  };

  factory Suggestion.fromJson(Map<String, dynamic> json) {
    return Suggestion(
      id: json['id'] ?? '',
      category: json['category'] ?? '',
      title: json['title'] ?? '',
      impact: json['impact'] ?? '',
      difficulty: json['difficulty'] ?? 'Medium',
      icon: json['icon'] ?? '💡',
    );
  }
}

class EnvironmentalContext {
  final int airQualityIndex;
  final int carbonIntensity;
  final int regionalBenchmark;
  final String region;

  EnvironmentalContext({
    required this.airQualityIndex,
    required this.carbonIntensity,
    required this.regionalBenchmark,
    required this.region,
  });

  Map<String, dynamic> toJson() => {
    'airQualityIndex': airQualityIndex,
    'carbonIntensity': carbonIntensity,
    'regionalBenchmark': regionalBenchmark,
    'region': region,
  };

  factory EnvironmentalContext.fromJson(Map<String, dynamic> json) {
    return EnvironmentalContext(
      airQualityIndex: json['airQualityIndex'] ?? 50,
      carbonIntensity: json['carbonIntensity'] ?? 400,
      regionalBenchmark: json['regionalBenchmark'] ?? 65,
      region: json['region'] ?? 'Unknown',
    );
  }
}

class SustainabilityResult {
  final int score;
  final String impactLevel;
  final List<ImpactBreakdown> breakdown;
  final List<Suggestion> suggestions;
  final double carbonFootprint;
  final EnvironmentalContext apiContext;

  SustainabilityResult({
    required this.score,
    required this.impactLevel,
    required this.breakdown,
    required this.suggestions,
    required this.carbonFootprint,
    required this.apiContext,
  });

  Map<String, dynamic> toJson() => {
    'score': score,
    'impactLevel': impactLevel,
    'breakdown': breakdown.map((b) => b.toJson()).toList(),
    'suggestions': suggestions.map((s) => s.toJson()).toList(),
    'carbonFootprint': carbonFootprint,
    'apiContext': apiContext.toJson(),
  };

  factory SustainabilityResult.fromJson(Map<String, dynamic> json) {
    return SustainabilityResult(
      score: json['score'] ?? 68,
      impactLevel: json['impactLevel'] ?? 'Moderate',
      breakdown: (json['breakdown'] as List?)
          ?.map((b) => ImpactBreakdown.fromJson(b))
          .toList() ?? [],
      suggestions: (json['suggestions'] as List?)
          ?.map((s) => Suggestion.fromJson(s))
          .toList() ?? [],
      carbonFootprint: (json['carbonFootprint'] ?? 2.4).toDouble(),
      apiContext: EnvironmentalContext.fromJson(json['apiContext'] ?? {}),
    );
  }
}
