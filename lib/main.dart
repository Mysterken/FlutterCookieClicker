import 'package:flutter/material.dart';
import 'ui/screens/mode_selection_page.dart';
import 'services/game_service.dart';
import 'services/sound_service.dart';
import 'services/storage_service.dart';
import 'models/achievement.dart';
import 'ui/screens/login_page.dart';
import 'dart:async';

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
