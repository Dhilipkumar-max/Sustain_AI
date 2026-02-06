class ProfileModel {
  final String id;
  final String? fullName;
  final String? avatarUrl;
  final String? userType;
  final List<String>? primaryInterests;
  final Map<String, dynamic>? location;
  final Map<String, dynamic>? sustainabilityGoals;
  final bool onboardingCompleted;
  final DateTime createdAt;
  final DateTime updatedAt;
  
  ProfileModel({
    required this.id,
    this.fullName,
    this.avatarUrl,
    this.userType,
    this.primaryInterests,
    this.location,
    this.sustainabilityGoals,
    this.onboardingCompleted = false,
    required this.createdAt,
    required this.updatedAt,
  });
  
  factory ProfileModel.fromJson(Map<String, dynamic> json) {
    return ProfileModel(
      id: json['id'] as String,
      fullName: json['full_name'] as String?,
      avatarUrl: json['avatar_url'] as String?,
      userType: json['user_type'] as String?,
      primaryInterests: json['primary_interests'] != null
          ? List<String>.from(json['primary_interests'])
          : null,
      location: json['location'] as Map<String, dynamic>?,
      sustainabilityGoals: json['sustainability_goals'] as Map<String, dynamic>?,
      onboardingCompleted: json['onboarding_completed'] ?? false,
      createdAt: json['created_at'] != null 
          ? DateTime.parse(json['created_at']) 
          : DateTime.now(),
      updatedAt: json['updated_at'] != null 
          ? DateTime.parse(json['updated_at']) 
          : (json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now()),
    );
  }
  
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'full_name': fullName,
      'avatar_url': avatarUrl,
      'user_type': userType,
      'primary_interests': primaryInterests,
      'location': location,
      'sustainability_goals': sustainabilityGoals,
      'onboarding_completed': onboardingCompleted,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
  
  String get displayName => fullName ?? 'User';
  String get initials => fullName != null && fullName!.isNotEmpty
      ? fullName!.split(' ').map((e) => e[0]).take(2).join().toUpperCase()
      : 'U';
}
