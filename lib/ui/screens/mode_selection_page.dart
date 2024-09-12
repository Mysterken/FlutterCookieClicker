import 'package:flutter/material.dart';
import '../../services/game_service.dart';
import '../../services/sound_service.dart';
import 'survivor_page.dart';
import 'main_page.dart';

class ModeSelectionPage extends StatelessWidget {
  final GameService gameService;
  final SoundService soundService;

  const ModeSelectionPage({
    Key? key,
    required this.gameService,
    required this.soundService,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Select Mode'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => MainPage(
                      gameService: gameService,
                      soundService: soundService,
                    ),
                  ),
                );
              },
              child: const Text('Classic Mode'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => SurvivorPage(
                      gameService: gameService,
                      soundService: soundService,
                    ),
                  ),
                );
              },
              child: const Text('Survivor Mode'),
            ),
          ],
        ),
      ),
    );
  }
}
