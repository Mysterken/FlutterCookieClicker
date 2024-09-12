import 'dart:async'; 
import 'package:flutter/material.dart';
import 'consp.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mon Application',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const LoginPage(),
    );
  }
}

class CookieClickerPage extends StatefulWidget {
  const CookieClickerPage({super.key});

  @override
  CookieClickerPageState createState() => CookieClickerPageState();
}

class CookieClickerPageState extends State<CookieClickerPage> with SingleTickerProviderStateMixin {
  int _cookieCount = 0;
  final int _maxClicks = 70; 
  bool _isGameOver = false;
  bool _isTimerMode = false; 
  Timer? _timer; 
  Duration _timeRemaining = const Duration(minutes: 1 ); 

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
      if (_cookieCount < _maxClicks) {
        _cookieCount++;
        _controller.forward().then((_) {
          _controller.reverse();
        });

        if (_cookieCount >= _maxClicks) {
          _isGameOver = true;
        }
      }
    });
  }

 
  void _startTimerMode() {
    setState(() {
      _isTimerMode = true; 
      _cookieCount = 0;
      _isGameOver = false;
      _timeRemaining = const Duration(minutes: 10); 

      
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
    setState(() {
      _cookieCount = 0;
      _isGameOver = false;
      _controller.reset();
      _controller.forward().then((_) {
        _controller.reverse();
      });

      if (_isTimerMode) {
        _timeRemaining = const Duration(minutes: 10);
        _timer?.cancel();
        _startTimerMode();
      }
    });
  }

  void _logout() {
    _timer?.cancel(); 
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const LoginPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final int clicksRemaining = _maxClicks - _cookieCount;

    String formatTime(Duration duration) {
      String minutes = duration.inMinutes.toString().padLeft(2, '0');
      String seconds = (duration.inSeconds % 60).toString().padLeft(2, '0');
      return '$minutes:$seconds';
    }

    return Scaffold(
      appBar: AppBar(
  title: const Text(
    'Cookie Clicker',
    style: TextStyle(
      fontWeight: FontWeight.bold,  
    ),
  ),
        actions: [
          IconButton(
            icon: const Icon(
              Icons.close,
              color: Colors.red,
            ),
            onPressed: _logout,
            tooltip: 'Déconnexion',
          ),
        ],
        leading: IconButton( 
          icon: const Icon(Icons.alarm), 
          onPressed: _startTimerMode,
          tooltip: 'Timer Mode',
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Cookies: $_cookieCount',
              style: const TextStyle(fontSize: 24),
            ),
            Text(
              'Clicks restants: $clicksRemaining',
              style: const TextStyle(fontSize: 24),
            ),
            if (_isTimerMode) 
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
                        child: const Text('Restart'),
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
                        'assets/cookie.png',
                        width: 200,
                        height: 200,
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}
