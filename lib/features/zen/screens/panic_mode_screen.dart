import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PanicModeScreen extends StatefulWidget {
  const PanicModeScreen({super.key});

  @override
  State<PanicModeScreen> createState() => _PanicModeScreenState();
}

class _PanicModeScreenState extends State<PanicModeScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;
  late Animation<double> _opacityAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    _animation = Tween<double>(begin: 1.0, end: 1.6).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOutQuad),
    );

    _opacityAnimation = Tween<double>(begin: 0.2, end: 0.6)
        .animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.close_rounded,
              color: Color(0xFFE3EED4), size: 30),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      backgroundColor: const Color(0xFF0F2A1D),
      body: Stack(
        children: [
          // Background Gradient using Palette
          AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color.lerp(const Color(0xFF0F2A1D),
                          const Color(0xFF375534), _controller.value)!,
                      Color.lerp(const Color(0xFF375534),
                          const Color(0xFF6B9071), _controller.value)!,
                    ],
                  ),
                ),
              );
            },
          ),
          Center(
            child: AnimatedBuilder(
              animation: _controller,
              builder: (context, child) {
                final isBreathingIn =
                    _controller.status == AnimationStatus.forward;
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    AnimatedSwitcher(
                      duration: const Duration(milliseconds: 600),
                      child: Text(
                        isBreathingIn ? 'Breathe In' : 'Breathe Out',
                        key: ValueKey(isBreathingIn),
                        style: GoogleFonts.inter(
                          fontSize: 36,
                          fontWeight: FontWeight.w200,
                          color: const Color(0xFFE3EED4), // Cream
                          letterSpacing: 2.0,
                        ),
                      ),
                    ),
                    const SizedBox(height: 80),
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        // Outer Halo (Sage)
                        Transform.scale(
                          scale: _animation.value * 1.2,
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF6B9071).withOpacity(0.1),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color(0xFF6B9071).withOpacity(0.1),
                                  blurRadius: 60,
                                  spreadRadius: 20,
                                ),
                              ],
                            ),
                          ),
                        ),
                        // Inner Circle (Cream)
                        Transform.scale(
                          scale: _animation.value,
                          child: Container(
                            width: 200,
                            height: 200,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFFE3EED4)
                                  .withOpacity(_opacityAnimation.value),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.black12,
                                  blurRadius: 30,
                                  offset: Offset(0, 10),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
