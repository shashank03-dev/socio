import 'package:flutter/material.dart';

class FlyParticle extends StatefulWidget {
  final Offset start;
  final Offset end;
  final VoidCallback onComplete;

  const FlyParticle({
    super.key,
    required this.start,
    required this.end,
    required this.onComplete,
  });

  @override
  State<FlyParticle> createState() => _FlyParticleState();
}

class _FlyParticleState extends State<FlyParticle>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));

    // Spring-like physics
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOutCubicEmphasized,
    );

    _controller.forward().then((_) => widget.onComplete());
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animation,
      builder: (context, child) {
        final t = _animation.value;
        // quadratic bezier
        final controlPoint = Offset(
          widget.start.dx +
              (widget.end.dx - widget.start.dx) / 2 +
              100, // Arc right
          widget.start.dy + (widget.end.dy - widget.start.dy) / 2, // Mid height
        );

        final l1 = Offset.lerp(widget.start, controlPoint, t)!;
        final l2 = Offset.lerp(controlPoint, widget.end, t)!;
        final pos = Offset.lerp(l1, l2, t)!;

        // Morphing: Start Large Rect -> End Small Circle
        // Actually, let's just do a glowing orb that shrinks slightly as it lands
        double size = 20 + (10 * (1 - t));

        return Positioned(
          left: pos.dx - size / 2,
          top: pos.dy - size / 2,
          child: Opacity(
            opacity: 1.0,
            child: Container(
              width: size,
              height: size,
              decoration: BoxDecoration(
                color: const Color(0xFFE3EED4), // Light Sage
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFFE3EED4).withOpacity(0.6),
                    blurRadius: 10,
                    spreadRadius: 2,
                  )
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
