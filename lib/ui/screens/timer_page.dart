import 'dart:async';
import 'package:flutter/material.dart';
import '../../services/game_service.dart';
import '../../services/sound_service.dart';

class TimerPage extends StatefulWidget {
  const TimerPage({Key? key, required GameService gameService, required SoundService soundService}) : super(key: key);

  @override
  _TimerPageState createState() => _TimerPageState();
}

class _TimerPageState extends State<TimerPage> with SingleTickerProviderStateMixin {
  int _cookieCount = 0; // Compteur de clics
  bool _isGameOver = false; // Indique si le jeu est terminé
  Timer? _timer; // Timer pour le compte à rebours
  Duration _timeRemaining = const Duration(minutes: 1); // Durée initiale du timer

  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )..repeat(reverse: true);
    _animation = Tween<double>(begin: 1.0, end: 1.2).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer?.cancel();
    super.dispose();
  }

  void _incrementCookieCount() {
    if (_isGameOver) return;

    setState(() {
      _cookieCount++;
    });
  }

  void _startTimer() {
    setState(() {
      _isGameOver = false;
      _cookieCount = 0; // Réinitialiser le compteur de cookies
      _timeRemaining = const Duration(minutes: 1); // Réinitialiser le temps

      _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
        setState(() {
          if (_timeRemaining.inSeconds > 0) {
            _timeRemaining = _timeRemaining - const Duration(seconds: 1);
          } else {
            _isGameOver = true;
            _timer?.cancel();
          }
        });
      });
    });
  }

  void _restartGame() {
    _startTimer(); // Redémarrer le jeu
  }

  String formatTime(Duration duration) {
    String minutes = duration.inMinutes.toString().padLeft(2, '0');
    String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mode Chronomètre'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _restartGame,
            tooltip: 'Redémarrer le jeu',
          ),
        ],
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Cookies: $_cookieCount',
              style: const TextStyle(fontSize: 24),
            ),
            if (!_isGameOver)
              Text(
                'Temps restant: ${formatTime(_timeRemaining)}',
                style: const TextStyle(fontSize: 24, color: Colors.red),
              ),
            const SizedBox(height: 20),
            _isGameOver
                ? Column(
                    children: [
                      const Text(
                        'Terminé',
                        style: TextStyle(fontSize: 36, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _restartGame,
                        child: const Text('Recommencer'),
                      ),
                    ],
                  )
                : GestureDetector(
                    onTap: _incrementCookieCount,
                    child: AnimatedBuilder(
                      animation: _animation,
                      builder: (context, child) {
                        return Transform.scale(
                          scale: _animation.value,
                          child: child,
                        );
                      },
                      child: Image.asset(
                        'assets/images/cookie.png', // Assurez-vous que ce chemin est correct
                        width: 200,
                        height: 200,
                      ),
                    ),
                  ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _startTimer,
        tooltip: 'Démarrer le chronomètre',
        child: const Icon(Icons.play_arrow),
      ),
    );
  }
}
