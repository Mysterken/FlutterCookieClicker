enum AchievementType {
  cookieCount,
  upgradeCount,
  cookiesPerSecond,
}

class Achievement {
  final String title;
  final String description;
  final AchievementType type;
  final int threshold;
  bool isUnlocked;
  final String icon;

  Achievement({
    required this.title,
    required this.description,
    required this.type,
    required this.threshold,
    required this.icon,
    this.isUnlocked = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'type': type.toString(),
      'threshold': threshold,
      'icon': icon,
      'isUnlocked': isUnlocked,
    };
  }

  static Achievement fromJson(Map<String, dynamic> json) {
    return Achievement(
      title: json['title'],
      description: json['description'],
      type: AchievementType.values.firstWhere((e) => e.toString() == json['type']),
      threshold: json['threshold'],
      icon: json['icon'],
      isUnlocked: json['isUnlocked'],
    );
  }
}