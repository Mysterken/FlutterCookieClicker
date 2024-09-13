import 'package:flutter/material.dart';

import 'models/achievement.dart';
import 'services/game_service.dart';
import 'services/sound_service.dart';
import 'services/storage_service.dart';
import 'ui/screens/login_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final storageService = StorageService();
  await storageService.init();

  final achievements = [
    Achievement(
      title: 'First Cookie',
      description: 'Bake your first cookie',
      type: AchievementType.cookieCount,
      threshold: 1,
      icon: 'assets/icons/first_cookie.png',
    ),
    Achievement(
      title: 'Hundred Cookies',
      description: 'Bake 100 cookies',
      type: AchievementType.cookieCount,
      threshold: 100,
      icon: 'assets/icons/hundred_cookies.png',
    ),
    Achievement(
      title: 'Five Hundred Cookies',
      description: 'Bake 500 cookies',
      type: AchievementType.cookieCount,
      threshold: 500,
      icon:
          'assets/icons/five_hundred_cookies.png', // Update with your icon path
    ),
    Achievement(
      title: 'One Thousand Cookies',
      description: 'Bake 1000 cookies',
      type: AchievementType.cookieCount,
      threshold: 1000,
      icon:
          'assets/icons/one_thousand_cookies.png', // Update with your icon path
    ),
    Achievement(
      title: 'Five Thousand Cookies',
      description: 'Bake 5000 cookies',
      type: AchievementType.cookieCount,
      threshold: 5000,
      icon:
          'assets/icons/five_thousand_cookies.png', // Update with your icon path
    ),
    Achievement(
      title: 'Ten Thousand Cookies',
      description: 'Bake 10,000 cookies',
      type: AchievementType.cookieCount,
      threshold: 10000,
      icon:
          'assets/icons/ten_thousand_cookies.png', // Update with your icon path
    ),
    Achievement(
      title: 'First Upgrade',
      description: 'Purchase your first upgrade',
      type: AchievementType.upgradeCount,
      threshold: 1,
      icon: 'assets/icons/first_upgrade.png',
    ),
    Achievement(
      title: 'Cookie Factory',
      description: 'Reach 10 cookies per second',
      type: AchievementType.cookiesPerSecond,
      threshold: 10,
      icon: 'assets/icons/cookie_factory.png',
    ),
  ];

  final gameService = GameService(
      upgrades: [], achievements: achievements, storageService: storageService);

  final soundService = SoundService();

  runApp(MyApp(gameService: gameService, soundService: soundService));
}

class MyApp extends StatelessWidget {
  final GameService gameService;
  final SoundService soundService;

  const MyApp(
      {super.key, required this.gameService, required this.soundService});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Cookie Clicker',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LoginPage(
        gameService: gameService,
        soundService: soundService,
      ),
    );
  }
}
