import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'dart:async';
import 'package:google_fonts/google_fonts.dart';

enum VoiceState { listening, userSpeaking, aiSpeaking }

class HaveATalkScreen extends StatefulWidget {
  const HaveATalkScreen({super.key});

  @override
  State<HaveATalkScreen> createState() => _HaveATalkScreenState();
}

class _HaveATalkScreenState extends State<HaveATalkScreen>
    with TickerProviderStateMixin {
  late AnimationController _blobController;
  late AnimationController _jitterController; // Controlled chaos for "speaking"
  Timer? _textTimer;
  int _textIndex = 0;
  VoiceState _currentState = VoiceState.listening;

  final List<String> _supportivePhrases = [
    "I'm listening...",
    "Take your time...",
    "Your voice matters.",
    "No rush, just breathe.",
    "I'm here for you.",
    "You are safe here.",
  ];

  @override
  void initState() {
    super.initState();
    _blobController =
        AnimationController(vsync: this, duration: const Duration(seconds: 4))
          ..repeat(reverse: true);

    _jitterController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300))
      ..repeat(reverse: true);

    _textTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      setState(() {
        _textIndex = (_textIndex + 1) % _supportivePhrases.length;
      });
    });
  }

  @override
  void dispose() {
    _blobController.dispose();
    _jitterController.dispose();
    _textTimer?.cancel();
    super.dispose();
  }

  void _toggleUserSpeaking() {
    setState(() {
      if (_currentState == VoiceState.userSpeaking) {
        _currentState = VoiceState.listening;
      } else {
        _currentState = VoiceState.userSpeaking;
      }
    });
  }

  void _toggleAISpeaking() {
    setState(() {
      if (_currentState == VoiceState.aiSpeaking) {
        _currentState = VoiceState.listening;
      } else {
        _currentState = VoiceState.aiSpeaking;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    // Dynamic Parameters based on State
    double scaleBase = 1.0;
    double glowIntensity = 10.0;
    double speedMultiplier = 1.0;

    switch (_currentState) {
      case VoiceState.userSpeaking:
        scaleBase = 1.6;
        glowIntensity = 60.0;
        speedMultiplier = 2.5;
        break;
      case VoiceState.aiSpeaking:
        scaleBase = 1.2;
        glowIntensity = 30.0;
        speedMultiplier = 1.5;
        break;
      case VoiceState.listening:
        scaleBase = 1.0;
        glowIntensity = 20.0;
        speedMultiplier = 1.0;
        break;
    }

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.keyboard_arrow_down_rounded,
              size: 32, color: Colors.white70),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: Container(
        // Awesome Background: Deep Atmospheric Vignette
        decoration: const BoxDecoration(
          gradient: RadialGradient(
            center: Alignment.center,
            radius: 1.5,
            colors: [
              Color(0xFF375534), // Forest Core
              Color(0xFF0F2A1D), // Deep Green
              Color(0xFF05110E), // Void Edge
            ],
            stops: [0.2, 0.6, 1.0],
          ),
        ),
        child: Stack(
          children: [
            // Fluid Harmonic Animation
            Center(
              child: AnimatedBuilder(
                animation:
                    Listenable.merge([_blobController, _jitterController]),
                builder: (context, child) {
                  // Add jitter for "Speaking" energy
                  final double jitter =
                      (_currentState == VoiceState.userSpeaking)
                          ? (_jitterController.value * 9.05)
                          : 0.0;

                  // Adjusted time for speed control
                  final double t = _blobController.value * speedMultiplier;

                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      // Blob 1 (Deep Green Base + Jitter)
                      Transform.scale(
                        scale: scaleBase + (t * 0.2) + jitter * 0.02,
                        child: Transform.rotate(
                          angle: t * math.pi / 4,
                          child: Container(
                            width: 280,
                            height: 260,
                            decoration: BoxDecoration(
                              // Water Bubble Effect: Radial Gradient + Glow
                              gradient: RadialGradient(
                                colors: [
                                  const Color(0xFF375534).withOpacity(0.8),
                                  const Color(0xFF0F2A1D).withOpacity(0.9),
                                ],
                                center: const Alignment(-0.2, -0.2),
                              ),
                              borderRadius: BorderRadius.all(Radius.elliptical(
                                  200 + (t * 50), 200 - (t * 20))),
                              boxShadow: [
                                BoxShadow(
                                    color: const Color(0xFF6B9071)
                                        .withOpacity(0.6),
                                    blurRadius: glowIntensity + 20,
                                    spreadRadius: 5), // Outer Glow
                              ],
                            ),
                          ),
                        ),
                      ),
                      // Blob 2 (Sage + Light)
                      Transform.translate(
                        offset: Offset(t * 30 + jitter, -t * 20 - jitter),
                        child: Container(
                          width: 220,
                          height: 240,
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              colors: [
                                const Color(0xFFE3EED4)
                                    .withOpacity(0.5), // Inner Light
                                const Color(0xFF6B9071)
                                    .withOpacity(0.7), // Body
                              ],
                              center: const Alignment(-0.3, -0.3),
                            ),
                            borderRadius: BorderRadius.all(Radius.elliptical(
                                180 - (t * 30), 200 + (t * 60))),
                            boxShadow: [
                              BoxShadow(
                                  color:
                                      const Color(0xFFE3EED4).withOpacity(0.4),
                                  blurRadius: glowIntensity,
                                  spreadRadius: 2)
                            ],
                          ),
                        ),
                      ),
                      // Blob 3 (Cream Core - High Highlight)
                      Transform.scale(
                        scale: (0.8 + (t * 0.1)) *
                            (scaleBase > 1.2
                                ? 1.2
                                : 1.0), // Expands when talking
                        child: Container(
                          width: 150,
                          height: 150,
                          decoration: BoxDecoration(
                            gradient: RadialGradient(
                              colors: [
                                Colors.white.withOpacity(0.9),
                                const Color(0xFFE3EED4).withOpacity(0.3),
                              ],
                              center: const Alignment(-0.2, -0.4),
                            ),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.white.withOpacity(0.6),
                                  blurRadius: glowIntensity + 10,
                                  spreadRadius: 10)
                            ],
                          ),
                        ),
                      ),

                      // Tige Avatar in Center
                      CircleAvatar(
                        radius: 40,
                        backgroundColor:
                            const Color(0xFFE3EED4).withOpacity(0.9),
                        child: Icon(Icons.pets,
                            size: 40,
                            color: (_currentState == VoiceState.aiSpeaking)
                                ? const Color(0xFF375534)
                                : const Color(0xFF0F2A1D)),
                      ),
                    ],
                  );
                },
              ),
            ),

            // Interaction UI
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // Supportive Text
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 800),
                    child: Text(
                      _currentState == VoiceState.userSpeaking
                          ? "I'm hearing you..."
                          : _supportivePhrases[_textIndex],
                      key: ValueKey<String>(
                          _currentState == VoiceState.userSpeaking
                              ? "hearing"
                              : _textIndex.toString()),
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        fontSize: 24,
                        fontWeight: FontWeight.w300,
                        color: const Color(0xFFE3EED4).withOpacity(0.9),
                        height: 1.3,
                        shadows: [
                          const Shadow(color: Colors.black54, blurRadius: 10)
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 60),

                // Controls
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    // Mic Button: User Talking Override
                    GestureDetector(
                      onLongPressStart: (_) => _toggleUserSpeaking(),
                      onLongPressEnd: (_) => _toggleUserSpeaking(),
                      onTap: _toggleUserSpeaking,
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 200),
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: _currentState == VoiceState.userSpeaking
                              ? const Color(0xFFE3EED4)
                              : Colors.white.withOpacity(0.1),
                          shape: BoxShape.circle,
                          boxShadow: _currentState == VoiceState.userSpeaking
                              ? [
                                  BoxShadow(
                                      color: const Color(0xFFE3EED4)
                                          .withOpacity(0.5),
                                      blurRadius: 20)
                                ]
                              : [],
                        ),
                        child: Icon(
                            _currentState == VoiceState.userSpeaking
                                ? Icons.mic_rounded
                                : Icons.mic_none_rounded,
                            color: _currentState == VoiceState.userSpeaking
                                ? const Color(0xFF0F2A1D)
                                : Colors.white,
                            size: 32),
                      ),
                    ),

                    // End Call
                    IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: Container(
                          padding: const EdgeInsets.all(24),
                          decoration: const BoxDecoration(
                            color: Color(0xFFCD5C5C), // Muted Red
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.black26,
                                  blurRadius: 10,
                                  offset: Offset(0, 4))
                            ],
                          ),
                          child: const Icon(Icons.call_end_rounded,
                              color: Colors.white, size: 32),
                        )),

                    // Speaker Button: AI Talking Override
                    IconButton(
                        onPressed: _toggleAISpeaking,
                        icon: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.all(20),
                          decoration: BoxDecoration(
                            color: _currentState == VoiceState.aiSpeaking
                                ? const Color(0xFF6B9071)
                                : Colors.white.withOpacity(0.1),
                            shape: BoxShape.circle,
                            boxShadow: _currentState == VoiceState.aiSpeaking
                                ? [
                                    BoxShadow(
                                        color: const Color(0xFF6B9071)
                                            .withOpacity(0.5),
                                        blurRadius: 20)
                                  ]
                                : [],
                          ),
                          child: const Icon(Icons.volume_up_rounded,
                              color: Colors.white, size: 32),
                        )),
                  ],
                ),
                const SizedBox(height: 60),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
