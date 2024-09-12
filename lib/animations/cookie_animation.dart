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

  List<TapAnimation> _tapAnimations = [];

  @override
  void initState() {
    super.initState();

    // Rotation controller (infinite, slow)
    _rotationController = AnimationController(
      duration: const Duration(seconds: 10),
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

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _bounceController,
        curve: Curves.easeOut, // Softer bounce effect
      ),
    );
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _bounceController.dispose();
    _tapAnimations.forEach((tapAnim) => tapAnim.controller.dispose());
    super.dispose();
  }

  void _handleTap(TapDownDetails details) {
    widget.onTap();

    // Start bounce animation
    _bounceController.forward(from: 0.0);

    // Create a new tap animation for this tap
    _addTapAnimation(details.localPosition);
  }

  void _addTapAnimation(Offset position) {
    // Create a new animation controller for the tap
    final controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    // Create animations for fading and moving up
    final fadeAnimation = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeOut,
      ),
    );
    final moveUpAnimation = Tween<Offset>(begin: Offset.zero, end: const Offset(0, -1)).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeOut,
      ),
    );

    // Create a new TapAnimation object to track this animation
    final tapAnimation = TapAnimation(
      position: position,
      controller: controller,
      fadeAnimation: fadeAnimation,
      moveUpAnimation: moveUpAnimation,
    );

    // Add it to the list of tap animations
    setState(() {
      _tapAnimations.add(tapAnimation);
    });

    // Start the animation
    controller.forward();

    // Remove the animation when it's done
    controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() {
          _tapAnimations.remove(tapAnimation);
        });
        controller.dispose();
      }
    });
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

          // Render all active tap animations
          ..._tapAnimations.map((tapAnim) {
            return Positioned(
              left: tapAnim.position.dx - 20, // Adjust for text width
              top: tapAnim.position.dy - 40, // Adjust for initial text height
              child: AnimatedBuilder(
                animation: tapAnim.controller,
                builder: (context, child) {
                  return Opacity(
                    opacity: tapAnim.fadeAnimation.value, // Fade out
                    child: Transform.translate(
                      offset: tapAnim.moveUpAnimation.value * 30, // Move up by 30 pixels
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
            );
          }),
        ],
      ),
    );
  }
}

// Class to manage individual tap animations
class TapAnimation {
  final Offset position;
  final AnimationController controller;
  final Animation<double> fadeAnimation;
  final Animation<Offset> moveUpAnimation;

  TapAnimation({
    required this.position,
    required this.controller,
    required this.fadeAnimation,
    required this.moveUpAnimation,
  });
}
