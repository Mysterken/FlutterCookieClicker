import 'dart:async';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../services/game_service.dart';
import '../../services/sound_service.dart';

class SurvivorPage extends StatefulWidget {
  final GameService gameService;
  final SoundService soundService;

  const SurvivorPage({
    Key? key,
    required this.gameService,
    required this.soundService,
  }) : super(key: key);

  @override
  _SurvivorPageState createState() => _SurvivorPageState();
}

class _SurvivorPageState extends State<SurvivorPage> with TickerProviderStateMixin {
  int _cookieCount = 0;
  final int _clickThreshold = 10;
  bool _isGameOver = false;
  int _difficulty = 1;
  int _clicksRemainingForChallenge = 10;
  Timer? _gameTimer;
  int _gameTimeRemaining = 20;
  Timer? _challengeTimer;
  int _challengeTimeRemaining = 10;
  bool _inChallenge = false;
  List<Offset> _challengeButtonPositions = [];
  List<bool> _buttonsClicked = [];
  bool _challengeButtonsVisible = false;
  late AnimationController _animationController;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _startGameTimer();
  }

  @override
  void dispose() {
    _gameTimer?.cancel();
    _challengeTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _startGameTimer() {
    _gameTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_gameTimeRemaining > 0) {
          _gameTimeRemaining--;
        } else {
          _gameOver();
        }
      });
    });
  }

  void _startChallengeTimer() {
    _challengeTimeRemaining = 10;
    _challengeTimer?.cancel();
    _challengeTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        if (_challengeTimeRemaining > 0) {
          _challengeTimeRemaining--;
        } else {
          _challengeFailed();
        }
      });
    });
  }

  void _incrementCookieCount() {
    if (_isGameOver || _inChallenge) return;

    setState(() {
      _cookieCount++;
      _clicksRemainingForChallenge--;

      if (_clicksRemainingForChallenge <= 0) {
        _startChallenge();
      }
    });
    widget.soundService.playClickSound();
  }

  void _restartGame() {
    setState(() {
      _cookieCount = 0;
      _clicksRemainingForChallenge = _clickThreshold;
      _gameTimeRemaining = 20;
      _difficulty = 1;
      _isGameOver = false;
      _inChallenge = false;
      _challengeButtonsVisible = false;
      _challengeButtonPositions.clear();
      _buttonsClicked.clear();
    });
    _startGameTimer();
  }

  void _startChallenge() {
    _inChallenge = true;
    _challengeButtonsVisible = true;
    _challengeButtonPositions.clear();
    _buttonsClicked.clear();
    Random random = Random();
    int challengeType = random.nextInt(2); // 0 pour calcul, 1 pour réaction

    if (challengeType == 0) {
      _mathChallenge();
    } else {
      _generateChallengeButtons();
      _startChallengeTimer();
    }
  }

  void _generateChallengeButtons() {
    Random random = Random();
    int numberOfButtons = _difficulty + 2;
    double maxWidth = MediaQuery.of(context).size.width - 100;
    double maxHeight = MediaQuery.of(context).size.height - 100;
    double buttonSize = 50.0; // Taille du bouton

    for (int i = 0; i < numberOfButtons; i++) {
      double dx = random.nextDouble() * (maxWidth - buttonSize);
      double dy = random.nextDouble() * (maxHeight - buttonSize);
      _challengeButtonPositions.add(Offset(dx, dy));
      _buttonsClicked.add(false);
    }
  }

  void _checkChallengeSuccess() {
    if (_buttonsClicked.every((clicked) => clicked)) {
      _challengeSuccess();
    }
  }

  void _mathChallenge() {
    Random random = Random();
    int num1 = random.nextInt(10 * _difficulty) + 1;
    int num2 = random.nextInt(10 * _difficulty) + 1;
    int correctAnswer = num1 + num2;

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Quel est $num1 + $num2 ?'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Temps restant: $_challengeTimeRemaining secondes'),
              TextField(
                keyboardType: TextInputType.number,
                onSubmitted: (value) {
                  _challengeTimer?.cancel();
                  int userInput = int.tryParse(value) ?? -1;

                  if (userInput == correctAnswer) {
                    _challengeSuccess();
                  } else {
                    _challengeFailed();
                  }

                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _speedChallenge() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Appuie rapidement !'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('Temps restant: $_challengeTimeRemaining secondes'),
              const Text('Cliquez sur tous les boutons le plus rapidement possible !'),
            ],
          ),
          actions: [
            TextButton(
              child: const Text('Commencer'),
              onPressed: () {
                Navigator.of(context).pop();
                _startChallengeTimer();
              },
            ),
          ],
        );
      },
    );
  }

  void _challengeSuccess() {
  final int additionalTime = Random().nextInt(16) + 5; 

  setState(() {
    _gameTimeRemaining += additionalTime;
    _clicksRemainingForChallenge = _clickThreshold;
    _difficulty++;
    _inChallenge = false;
    _challengeButtonsVisible = false;
  });

  _animationController.forward().then((_) {
    _animationController.reverse();
  });

  ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Text('Défi réussi ! Vous avez gagné $additionalTime secondes.'),
      duration: const Duration(seconds: 2),
    ),
  );
}


  void _challengeFailed() {
    setState(() {
      _inChallenge = false;
      _clicksRemainingForChallenge = _clickThreshold;
      _challengeButtonsVisible = false;
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Défi échoué... Pas de temps supplémentaire.'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  void _gameOver() {
    setState(() {
      _isGameOver = true;
    });

    _gameTimer?.cancel();
    _challengeTimer?.cancel();

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Temps écoulé ! Le jeu est terminé.'),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Survivor Clicker'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _restartGame,
          ),
        ],
      ),
      body: Stack(
        children: [
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Clics : $_cookieCount',
                  style: const TextStyle(fontSize: 24),
                ),
                Text(
                  'Temps restant : $_gameTimeRemaining s',
                  style: const TextStyle(fontSize: 24),
                ),
                GestureDetector(
                  onTap: _incrementCookieCount,
                  child: Image.asset(
                    'assets/images/cookie.png',
                    width: 200,
                    height: 200,
                  ),
                ),
                ScaleTransition(
                  scale: _animation,
                  child: const Text(
                    'Nice!',
                    style: TextStyle(
                      fontSize: 50,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                ),
                if (_isGameOver)
                  Column(
                    children: [
                      const Text(
                        'Le jeu est terminé.',
                        style: TextStyle(fontSize: 30, color: Colors.red),
                      ),
                      ElevatedButton(
                        onPressed: _restartGame,
                        child: const Text('Rejouer'),
                      ),
                    ],
                  ),
              ],
            ),
          ),
          if (_challengeButtonsVisible)
            ..._challengeButtonPositions.asMap().entries.map(
              (entry) {
                int index = entry.key;
                Offset position = entry.value;

                return Positioned(
                  left: position.dx,
                  top: position.dy,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _buttonsClicked[index] = true;
                        _checkChallengeSuccess();
                      });
                    },
                    child: Container(
                      width: 50,
                      height: 50,
                      child: Image.asset(
                        'assets/images/pepite_de_chocolat.png',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                );
              },
            ).toList(),
        ],
      ),
    );
  }
}
