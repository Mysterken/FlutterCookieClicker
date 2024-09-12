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
  late Animation<double> _rotationAnimation;
  late Animation<double> _scaleAnimation;

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
      duration: const Duration(milliseconds: 50), // Shorter duration for a soft bounce
      vsync: this,
    );

    // Reduced scale range for softer bounce
    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _bounceController,
        curve: Curves.easeOut, // Smoother, less elastic curve
      ),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _bounceController.dispose();
    super.dispose();
  }

  void _handleTap() {
    widget.onTap();
    _bounceController.forward(from: 0.0); // Reset and play the bounce animation
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: _handleTap,
      child: AnimatedBuilder(
        animation: Listenable.merge([_rotationController, _bounceController]),
        builder: (context, child) {
          return Transform.rotate(
            angle: _rotationAnimation.value * 2.0 * 3.141592653589793, // Full rotation
            child: Transform.scale(
              scale: _scaleAnimation.value, // Softer bounce effect on tap
              child: child,
            ),
          );
        },
        child: widget.child,
      ),
    );
  }
}
