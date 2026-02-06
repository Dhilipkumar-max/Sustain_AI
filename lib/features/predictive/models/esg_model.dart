class ESGFormData {
  String entityType;
  String entityName;
  String industry;
  List<String> environmentalImpacts;
  String environmentalOutcome;
  List<String> socialImpacts;
  String stakeholderReach;
  String governanceCommitment;
  bool publicDisclosure;
  String investmentHorizon;

  ESGFormData({
    this.entityType = '',
    this.entityName = '',
    this.industry = '',
    List<String>? environmentalImpacts,
    this.environmentalOutcome = '',
    List<String>? socialImpacts,
    this.stakeholderReach = '',
    this.governanceCommitment = 'low',
    this.publicDisclosure = false,
    this.investmentHorizon = '',
  }) : environmentalImpacts = environmentalImpacts ?? ['carbon', 'biodiversity'],
       socialImpacts = socialImpacts ?? ['dei'];

  bool get isValid => 
      entityType.isNotEmpty && 
      entityName.trim().isNotEmpty && 
      industry.isNotEmpty &&
      environmentalImpacts.isNotEmpty &&
      socialImpacts.isNotEmpty &&
      governanceCommitment.isNotEmpty;
}

class ESGScores {
  final int overall;
  final int environmental;
  final int social;
  final int governance;
  final String confidence; // 'High', 'Medium', 'Low'

  ESGScores({
    required this.overall,
    required this.environmental,
    required this.social,
    required this.governance,
    required this.confidence,
  });
}

class RiskFlag {
  final String id;
  final String message;
  final String severity; // 'warning', 'caution', 'info'

  RiskFlag({required this.id, required this.message, required this.severity});
}

class PredictiveLogic {
  static const Map<String, int> industryRiskFactors = {
    'energy': -15,
    'manufacturing': -10,
    'transportation': -8,
    'construction': -5,
    'agriculture': 0,
    'technology': 5,
    'other': 0,
  };

  static ESGScores calculateScores(ESGFormData data) {
    // Environmental (40 max)
    double envScore = 0;
    envScore += data.environmentalImpacts.length * 6; 
    if (data.environmentalOutcome == 'reduces') envScore += 10;
    else if (data.environmentalOutcome == 'neutral') envScore += 5;
    envScore = envScore.clamp(0, 40);

    // Social (30 max)
    double socScore = 0;
    socScore += data.socialImpacts.length * 5;
    if (data.stakeholderReach == 'global') socScore += 10;
    else if (data.stakeholderReach == 'national') socScore += 7;
    else if (data.stakeholderReach == 'regional') socScore += 4;
    else socScore += 2;
    socScore = socScore.clamp(0, 30);

    // Governance (30 max)
    double govScore = 0;
    if (data.governanceCommitment == 'high') govScore += 20;
    else if (data.governanceCommitment == 'medium') govScore += 12;
    else govScore += 5;
    if (data.publicDisclosure) govScore += 10;
    govScore = govScore.clamp(0, 30);

    // Industry 
    final adjustment = industryRiskFactors[data.industry] ?? 0;

    double overall = envScore + socScore + govScore + adjustment;
    overall = overall.clamp(0, 100);

    // Confidence
    int completeness = 0;
    if (data.entityName.isNotEmpty) completeness++;
    if (data.entityType.isNotEmpty) completeness++;
    if (data.industry.isNotEmpty) completeness++;
    if (data.environmentalImpacts.isNotEmpty) completeness++;
    if (data.socialImpacts.isNotEmpty) completeness++;
    if (data.governanceCommitment.isNotEmpty) completeness++;

    String confidence = 'High';
    if (completeness < 4) confidence = 'Low';
    else if (completeness < 6) confidence = 'Medium';

    return ESGScores(
      overall: overall.round(),
      environmental: ((envScore / 40) * 100).round(),
      social: ((socScore / 30) * 100).round(),
      governance: ((govScore / 30) * 100).round(),
      confidence: confidence,
    );
  }

  static List<RiskFlag> generateRiskFlags(ESGFormData data) {
    List<RiskFlag> flags = [];

    if (['energy', 'manufacturing'].contains(data.industry)) {
      flags.add(RiskFlag(id: 'carbon', message: 'High carbon-intensive sector', severity: 'warning'));
    }
    if (!data.publicDisclosure) {
      flags.add(RiskFlag(id: 'no-disclosure', message: 'Limited public disclosure', severity: 'caution'));
    }
    if (data.governanceCommitment == 'low') {
      flags.add(RiskFlag(id: 'gov-low', message: 'Governance transparency unclear', severity: 'warning'));
    }
    if (data.environmentalOutcome == 'increases') {
      flags.add(RiskFlag(id: 'env-inc', message: 'Potential environmental impact increase', severity: 'warning'));
    }
    if (data.stakeholderReach == 'local') {
      flags.add(RiskFlag(id: 'reach-local', message: 'Limited stakeholder reach scope', severity: 'info'));
    }

    return flags;
  }
}
