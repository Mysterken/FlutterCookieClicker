class Upgrade {
  final String name;
  final int cost;
  final double cps; // Cookies per second
  bool isPurchased;

  Upgrade({
    required this.name,
    required this.cost,
    required this.cps,
    this.isPurchased = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'cost': cost,
      'cps': cps,
      'isPurchased': isPurchased,
    };
  }

  static Upgrade fromJson(Map<String, dynamic> json) {
    return Upgrade(
        name: json['name'],
        cost: json['cost'],
        cps: json['cps'],
        isPurchased: json['isPurchased']);
  }
}
