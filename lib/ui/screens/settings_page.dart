import 'package:flutter/material.dart';

import '../../services/game_service.dart';
import '../../services/sound_service.dart';

class SettingsPage extends StatefulWidget {
  final GameService gameService;
  final SoundService soundService;

  const SettingsPage(
      {super.key, required this.gameService, required this.soundService});

  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  @override
  void initState() {
    super.initState();
    // Load initial settings (these could be stored and loaded via storageService if needed)
  }

  // Reset progress
  void _resetProgress() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Progress'),
        content: const Text('Are you sure you want to reset all progress?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context); // Close dialog
            },
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              widget.gameService.resetProgress(); // Reset the game
              Navigator.pop(context); // Close dialog
            },
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          // Reset Progress
          ListTile(
            title: const Text('Reset Progress'),
            subtitle:
                const Text('Clear all game progress and start from scratch'),
            trailing: IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: _resetProgress,
            ),
          ),

          // Future: Add more settings such as theme, stats, etc.
        ],
      ),
    );
  }
}
