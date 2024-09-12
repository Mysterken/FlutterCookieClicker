import 'package:flutter/material.dart';

import '../../animations/cookie_animation.dart';
import '../../services/game_service.dart';
import '../../services/sound_service.dart';
import '../widgets/upgrade_tile.dart';
import 'achievements_page.dart';

class MainPage extends StatefulWidget {
  final GameService gameService;
  final SoundService soundService;

  const MainPage(
      {super.key, required this.gameService, required this.soundService});

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  void initState() {
    super.initState();
    widget.gameService.loadGameData();
  }

  void _incrementCookies() {
    setState(() {
      widget.gameService.incrementCookies(1);
    });
    widget.soundService.playClickSound();
  }

  void _navigateToAchievements() {
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) =>
              AchievementsPage(gameService: widget.gameService)),
    );
  }

  void _showUpgradeDrawer() {
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Container(
          padding: const EdgeInsets.all(16.0),
          child: ListView.builder(
            itemCount: widget.gameService.upgrades.length,
            itemBuilder: (context, index) {
              return UpgradeTile(
                upgrade: widget.gameService.upgrades[index],
                onPurchase: () {
                  setState(() {
                    widget.gameService.purchaseUpgrade(
                      widget.gameService.upgrades[index],
                    );
                  });
                },
              );
            },
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cookie Clicker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.emoji_events),
            onPressed: _navigateToAchievements,
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Spacer(flex: 1),
                Text('Cookies: ${widget.gameService.cookieCount}'),
                Text('Cookies per second: ${widget.gameService.cookiesPerSecond}'),
                CookieAnimation(
                  onTap: _incrementCookies,
                  child: Image.asset(
                    'assets/images/cookie.png',
                    width: 300,
                    height: 300,
                  ),
                ),
                const Spacer(flex: 2),
              ],
            ),
          ),
          Positioned(
            bottom: 16.0,
            left: 0,
            right: 0,
            child: Center(
              child: ElevatedButton.icon(
                onPressed: _showUpgradeDrawer,
                icon: const Icon(Icons.arrow_circle_up),
                label: const Text('Upgrades'),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
