import 'package:flutter/material.dart';

class ScriptItem {
  final String title;
  final String description;
  final String content;

  const ScriptItem({
    required this.title,
    required this.description,
    required this.content,
  });
}

class ScriptsScreen extends StatelessWidget {
  const ScriptsScreen({super.key});

  final List<ScriptItem> scripts = const [
    ScriptItem(
      title: 'Grounding Technique (5-4-3-2-1)',
      description:
          'Use this when feeling overwhelmed to anchor yourself in the present.',
      content:
          'Acknowledge:\n5 things you can see around you.\n4 things you can physically feel.\n3 things you can hear.\n2 things you can smell.\n1 thing you can taste.',
    ),
    ScriptItem(
      title: 'Box Breathing',
      description:
          'A powerful relaxation technique to return breathing to normal.',
      content:
          '1. Inhale slowly for 4 seconds.\n2. Hold your breath for 4 seconds.\n3. Exhale slowly for 4 seconds.\n4. Hold for 4 seconds.\nRepeat until calm.',
    ),
    ScriptItem(
      title: 'Social Anxiety Script',
      description: 'What to tell yourself before entering a crowded room.',
      content:
          '"I am safe. People are focusing on themselves, not me. If I feel uncomfortable, I am allowed to step away. I am completely capable of handling this moment."',
    ),
    ScriptItem(
      title: 'Self-Compassion Break',
      description: 'For moments of intense self-criticism or failure.',
      content:
          '1. This is a moment of suffering.\n2. Suffering is a part of life.\n3. May I be kind to myself in this moment.\n4. May I give myself the compassion I need.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F2A1D),
      appBar: AppBar(
        title:
            const Text('Library', style: TextStyle(color: Color(0xFFE3EED4))),
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(24).copyWith(bottom: 120),
        itemCount: scripts.length,
        itemBuilder: (context, index) {
          final script = scripts[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              color: const Color(0xFF375534).withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                  color: const Color(0xFF6B9071).withValues(alpha: 0.2)),
            ),
            child: ExpansionTile(
              shape: const Border(), // Removes the default border when expanded
              collapsedIconColor: const Color(0xFFE3EED4),
              iconColor: const Color(0xFF6B9071),
              title: Text(
                script.title,
                style: const TextStyle(
                  color: Color(0xFFE3EED4),
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              subtitle: Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text(
                  script.description,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
              ),
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F2A1D).withValues(alpha: 0.5),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      script.content,
                      style: const TextStyle(
                        color: Color(0xFFE3EED4),
                        fontSize: 16,
                        height: 1.5,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
