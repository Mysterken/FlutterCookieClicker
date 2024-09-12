import 'package:flutter/cupertino.dart';

import '../models/achievement.dart';
import '../models/upgrade.dart';
import 'storage_service.dart';

class GameService {
  int cookieCount = 0;
  double cookiesPerSecond = 0;
  final List<Upgrade> upgrades;
  final List<Achievement> achievements;
  final StorageService storageService;

  final ValueNotifier<Achievement?> achievementNotifier =
      ValueNotifier<Achievement?>(null);

  GameService({
    required this.upgrades,
    required this.achievements,
    required this.storageService,
  });

  void loadGameData() {
    cookieCount = storageService.loadCookieCount();
    storageService.loadUpgrades(upgrades);
    storageService.loadAchievements(achievements);
    _updateCPS();
  }

  void _updateCPS() {
    cookiesPerSecond = upgrades
        .where((upgrade) => upgrade.isPurchased)
        .fold(0.0, (total, upgrade) => total + upgrade.cps);
  }

  void purchaseUpgrade(Upgrade upgrade) {
    if (cookieCount >= upgrade.cost && !upgrade.isPurchased) {
      cookieCount -= upgrade.cost;
      upgrade.isPurchased = true;
      cookiesPerSecond += upgrade.cps;
      storageService.saveUpgrades(upgrades);
      storageService.saveCookieCount(cookieCount);
      checkAchievements();
    }
  }

  void incrementCookies(int amount) {
    cookieCount += amount;
    storageService.saveCookieCount(cookieCount);
    checkAchievements();
  }

  void checkAchievements() {
    for (var achievement in achievements) {
      if (!achievement.isUnlocked) {
        switch (achievement.type) {
          case AchievementType.cookieCount:
            if (cookieCount >= achievement.threshold) {
              achievement.isUnlocked = true;
            }
            break;
          case AchievementType.upgradeCount:
            if (upgrades.where((u) => u.isPurchased).length >=
                achievement.threshold) {
              achievement.isUnlocked = true;
            }
            break;
          case AchievementType.cookiesPerSecond:
            if (cookiesPerSecond >= achievement.threshold) {
              achievement.isUnlocked = true;
            }
            break;
        }
        if (achievement.isUnlocked) {
          storageService.saveAchievements(achievements);
          achievementNotifier.value = achievement;
        }
      }
    }
  }

  void resetProgress() {
    cookieCount = 0;
    cookiesPerSecond = 0;

    for (var upgrade in upgrades) {
      upgrade.isPurchased = false;
    }

    for (var achievement in achievements) {
      achievement.isUnlocked = false;
    }

    storageService.saveCookieCount(cookieCount);
    storageService.saveUpgrades(upgrades);
    storageService.saveAchievements(achievements);
  }
}
