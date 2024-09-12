import 'package:flutter/material.dart';

class CookieAnimation extends StatefulWidget {
  final Widget child;
  final VoidCallback onTap;

  const CookieAnimation({super.key, required this.child, required this.onTap});

  @override
  _CookieAnimationState createState() => _CookieAnimationState();
}

class _CookieAnimationState extends State<CookieAnimation>
    with TickerProviderStateMixin {
  late AnimationController _rotationController;
  late AnimationController _bounceController;
  late AnimationController _tapAnimationController;
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _moveUpAnimation;

  Offset? _tapPosition; // Holds the tap position
  bool _showTapAnimation = false; // To control tap animation visibility

  @override
  void initState() {
    super.initState();

    // Rotation controller (infinite, slow)
    _rotationController = AnimationController(
      duration: const Duration(seconds: 10), // Slow rotation
      vsync: this,
    )..repeat(); // Infinite repeat

    _rotationAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _rotationController,
        curve: Curves.linear,
      ),
    );

    // Bounce controller (triggered on tap)
    _bounceController = AnimationController(
      duration: const Duration(milliseconds: 50), // Short duration for a soft bounce
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _bounceController,
        curve: Curves.easeOut, // Softer bounce effect
      ),
    );

    // Tap animation controller (for text movement and fade-out)
    _tapAnimationController = AnimationController(
      duration: const Duration(milliseconds: 600), // Animation duration for the tap text
      vsync: this,
    );

    // Fade-out animation for tap text
    _fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _tapAnimationController,
        curve: Curves.easeOut,
      ),
    );

    // Move-up animation for tap text
    _moveUpAnimation = Tween<Offset>(begin: Offset.zero, end: const Offset(0, -1)).animate(
      CurvedAnimation(
        parent: _tapAnimationController,
        curve: Curves.easeOut,
      ),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _bounceController.dispose();
    _tapAnimationController.dispose();
    super.dispose();
  }

  void _handleTap(TapDownDetails details) {
    widget.onTap();

    // Capture the tap position
    setState(() {
      _tapPosition = details.localPosition;
      _showTapAnimation = true;
    });

    // Start animations
    _bounceController.forward(from: 0.0); // Trigger the bounce
    _tapAnimationController.forward(from: 0.0); // Trigger the text animation
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: _handleTap,
      child: Stack(
        children: [
          // Main cookie animation
          AnimatedBuilder(
            animation: Listenable.merge([_rotationController, _bounceController]),
            builder: (context, child) {
              return Transform.rotate(
                angle: _rotationAnimation.value * 2.0 * 3.141592653589793, // Full rotation
                child: Transform.scale(
                  scale: _scaleAnimation.value, // Soft bounce on tap
                  child: child,
                ),
              );
            },
            child: widget.child,
          ),

          // Tap animation for cookies gained
          if (_showTapAnimation && _tapPosition != null)
            Positioned(
              left: _tapPosition!.dx - 20, // Adjust for text width
              top: _tapPosition!.dy - 40, // Adjust for initial text height
              child: AnimatedBuilder(
                animation: _tapAnimationController,
                builder: (context, child) {
                  return Opacity(
                    opacity: _fadeAnimation.value, // Fade out
                    child: Transform.translate(
                      offset: _moveUpAnimation.value * 30, // Move up by 30 pixels
                      child: child,
                    ),
                  );
                },
                child: const Text(
                  '+1',
                  style: TextStyle(
                    fontSize: 24,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
