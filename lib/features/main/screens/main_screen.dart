import 'package:flutter/material.dart';
import 'dart:ui';
import '../../home/screens/home_screen.dart';
import '../../chat/screens/tige_screen.dart';
import '../../scripts/screens/scripts_screen.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true, // Content scrolls behing nav
      body: Stack(
        children: [
          IndexedStack(
            index: _selectedIndex,
            children: [
              const HomeScreen(),
              TigeScreen(onBack: () => setState(() => _selectedIndex = 0)),
              const ScriptsScreen(),
            ],
          ),
          // Gradient Fade at Bottom
          if (_selectedIndex != 1)
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              height: 140,
              child: IgnorePointer(
                child: Container(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        const Color(0xFF0F2A1D).withOpacity(0.0),
                        const Color(0xFF0F2A1D).withOpacity(1.0),
                      ],
                    ),
                  ),
                ),
              ),
            ),

          // Glassmorphic Navigation Bar (Auto-Hide on Keyboard)
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            curve: Curves.easeInOut,
            bottom: (MediaQuery.of(context).viewInsets.bottom > 0 ||
                    _selectedIndex == 1)
                ? -120
                : 0, // Slide down if keyboard open or in chat
            left: 0,
            right: 0,
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(24, 0, 24, 30),
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.3),
                        blurRadius: 20,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(40),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        height: 90,
                        decoration: BoxDecoration(
                          color: const Color(0xFF0F2A1D).withOpacity(0.8),
                          borderRadius: BorderRadius.circular(40),
                          border: Border.all(
                            color: Colors.white.withOpacity(0.1),
                            width: 1,
                          ),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildNavItem(0, Icons.grid_view_outlined,
                                Icons.grid_view_rounded, 'Home'),
                            _buildNavItem(1, Icons.chat_bubble_outline_rounded,
                                Icons.chat_bubble_rounded, 'Tige'),
                            _buildNavItem(2, Icons.book_outlined,
                                Icons.book_rounded, 'Scripts'),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
      int index, IconData icon, IconData selectedIcon, String label) {
    final isSelected = _selectedIndex == index;
    return GestureDetector(
      onTap: () => _onItemTapped(index),
      behavior: HitTestBehavior.opaque,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 6),
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFF375534).withOpacity(0.5)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              isSelected ? selectedIcon : icon,
              color: isSelected
                  ? const Color(0xFFE3EED4)
                  : const Color(0xFF6B9071),
              size: 26,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 10,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
              color: isSelected
                  ? const Color(0xFFE3EED4)
                  : const Color(0xFF6B9071),
            ),
          ),
        ],
      ),
    );
  }
}
