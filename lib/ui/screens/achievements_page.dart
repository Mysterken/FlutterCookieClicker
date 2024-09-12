import 'package:flutter/material.dart';
import '../../models/achievement.dart';
import '../../services/game_service.dart';

class AchievementsPage extends StatelessWidget {
  final GameService gameService;

  const AchievementsPage({super.key, required this.gameService});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements'),
      ),
      body: ListView.builder(
        itemCount: gameService.achievements.length,
        itemBuilder: (context, index) {
          final achievement = gameService.achievements[index];
          return ListTile(
            leading: Icon(
              Icons.emoji_events,
              color: achievement.isUnlocked ? Colors.amber : Colors.grey,
            ),
            title: Text(achievement.title),
            subtitle: Text(achievement.description),
            trailing: achievement.isUnlocked
                ? const Icon(Icons.check, color: Colors.green)
                : null,
          );
        },
      ),
    );
  }
}