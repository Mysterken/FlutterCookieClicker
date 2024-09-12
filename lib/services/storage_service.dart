import 'package:shared_preferences/shared_preferences.dart';
import '../models/achievement.dart';
import '../models/upgrade.dart';

class StorageService {
  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  int loadCookieCount() {
    return _prefs.getInt('cookieCount') ?? 0;
  }

  void saveCookieCount(int count) {
    _prefs.setInt('cookieCount', count);
  }

  List<Upgrade> loadUpgrades(List<Upgrade> upgrades) {
    for (int i = 0; i < upgrades.length; i++) {
      upgrades[i].isPurchased = _prefs.getBool('upgrade_$i') ?? false;
    }
    return upgrades;
  }

  void saveUpgrades(List<Upgrade> upgrades) {
    for (int i = 0; i < upgrades.length; i++) {
      _prefs.setBool('upgrade_$i', upgrades[i].isPurchased);
    }
  }

  List<Achievement> loadAchievements(List<Achievement> achievements) {
    for (int i = 0; i < achievements.length; i++) {
      achievements[i].isUnlocked = _prefs.getBool('achievement_$i') ?? false;
    }
    return achievements;
  }

  void saveAchievements(List<Achievement> achievements) {
    for (int i = 0; i < achievements.length; i++) {
      _prefs.setBool('achievement_$i', achievements[i].isUnlocked);
    }
  }
}