import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import 'dart:async';
import 'dart:ui'; // For BackdropFilter
import 'dart:math' as math;

void main() {
  runApp(const SocioApp());
}

class SocioApp extends StatelessWidget {
  const SocioApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Premium Font Stack
    final textTheme = GoogleFonts.interTextTheme(
      Theme.of(context).textTheme,
    ).apply(
      fontFamilyFallback: [
        'SF Pro Display',
        'San Francisco',
        'Sequel Pro',
        'Helvetica',
        'Arial',
      ],
      bodyColor: const Color(0xFFE3EED4), // Cream text by default on dark bg
      displayColor: const Color(0xFFE3EED4),
    );

    return MaterialApp(
      title: 'Socio',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        textTheme: textTheme,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF375534), // Forest Green
          primary: const Color(0xFF375534),
          secondary: const Color(0xFF6B9071), // Sage
          tertiary: const Color(0xFFAEC3B0), // Light Sage
          surface: const Color(0xFF0F2A1D), // Deepest Green (Background)
          onSurface: const Color(0xFFE3EED4), // Cream (Text)
          background: const Color(0xFF0F2A1D),
        ),
        scaffoldBackgroundColor: const Color(0xFF0F2A1D), // Deepest Green
        iconTheme: const IconThemeData(color: Color(0xFFE3EED4)),
        appBarTheme: const AppBarTheme(
          backgroundColor: Colors.transparent,
          elevation: 0,
          centerTitle: true,
          scrolledUnderElevation: 0,
          iconTheme: IconThemeData(color: Color(0xFFE3EED4)),
          titleTextStyle: TextStyle(
              color: Color(0xFFE3EED4),
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
      ),
      home: const MainScreen(),
    );
  }
}

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const TigeScreen(),
    const ScriptsScreen(),
  ];

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
          _screens[_selectedIndex],
          // Gradient Fade at Bottom
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
            bottom: MediaQuery.of(context).viewInsets.bottom > 0
                ? -100
                : 0, // Slide down if keyboard open
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
                        height: 80,
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
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
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
        ],
      ),
    );
  }
}

// --- Task Model ---
class Task {
  final String id;
  final String title;
  final String subtitle;
  final String category; // 'Daily', 'Weekly', 'Zen'
  final String imagePath;
  final IconData icon;
  bool isCompleted;
  bool isBonus;

  Task({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.category,
    required this.imagePath,
    required this.icon,
    this.isCompleted = false,
    this.isBonus = false,
  });
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  String _selectedCategory = 'Daily';
  bool _isForward = true; // Track transition direction

  // Keys for Animation Targets
  final GlobalKey _dailyKey = GlobalKey();
  final GlobalKey _weeklyKey = GlobalKey();
  final GlobalKey _zenKey = GlobalKey();

  // Initial Tasks Data
  final List<Task> _tasks = [
    // Daily Tasks
    Task(
      id: 'd1',
      title: 'Smile at a stranger',
      subtitle: 'Coffee shop or park interaction',
      category: 'Daily',
      imagePath: 'assets/images/smile.png',
      icon: Icons.sentiment_satisfied_alt,
    ),
    Task(
      id: 'd2',
      title: 'Ask for time',
      subtitle: 'Simple question to anyone',
      category: 'Daily',
      imagePath: 'assets/images/time.png',
      icon: Icons.access_time_filled,
    ),
    Task(
      id: 'd4',
      title: 'Check in with yourself',
      subtitle: 'How are you feeling right now?',
      category: 'Daily',
      imagePath: 'assets/images/check_in.png',
      icon: Icons.self_improvement,
    ),
    Task(
      id: 'd3',
      title: 'Compliment a cashier',
      subtitle: 'Bonus: Make someone\'s day',
      category: 'Daily',
      imagePath: 'assets/images/compliment.png',
      icon: Icons.favorite_rounded,
      isBonus: true,
    ),

    // Weekly Tasks
    Task(
      id: 'w1',
      title: 'Visit a new park',
      subtitle: 'Spend 20 mins outside',
      category: 'Weekly',
      imagePath: 'assets/images/park.png',
      icon: Icons.nature_people,
    ),
    Task(
      id: 'w2',
      title: 'Read in public',
      subtitle: 'Library or bench',
      category: 'Weekly',
      imagePath: 'assets/images/read_public.png',
      icon: Icons.menu_book_rounded,
    ),
    Task(
      id: 'w3',
      title: 'Buy a small plant',
      subtitle: 'Bonus: Nurture something',
      category: 'Weekly',
      imagePath: 'assets/images/plant.png',
      icon: Icons.local_florist,
      isBonus: true,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    // Filter tasks based on selection
    final displayedTasks =
        _tasks.where((t) => t.category == _selectedCategory).toList();

    // Sort: Non-bonus first, then bonus
    displayedTasks.sort((a, b) {
      if (a.isBonus && !b.isBonus) return 1;
      if (!a.isBonus && b.isBonus) return -1;
      return 0;
    });

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF0F2A1D),
        ),
        child: SafeArea(
          child: SingleChildScrollView(
            child: Stack(
              children: [
                // 1. The Connector Line (Visual Thread)
                Positioned(
                  top: 130, // Starts below header
                  right: 50, // Aligned with where the doodle will be
                  bottom: 0,
                  child: Container(
                    width: 2,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          const Color(0xFF6B9071).withOpacity(0.0), // Fade in
                          const Color(0xFF6B9071).withOpacity(0.3),
                          const Color(0xFF6B9071).withOpacity(0.3),
                          const Color(0xFF6B9071)
                              .withOpacity(0.0), // Fade out at bottom
                        ],
                      ),
                    ),
                  ),
                ),

                // 2. The Hero Doodle (Top Right)
                Positioned(
                  top: 60,
                  right: -30,
                  child: ShaderMask(
                    shaderCallback: (Rect bounds) {
                      return const RadialGradient(
                        center: Alignment.center,
                        radius: 0.7,
                        colors: [
                          Colors.black, // Opaque center
                          Colors.transparent, // Fade to transparent
                        ],
                        stops: [0.3, 1.0],
                      ).createShader(bounds);
                    },
                    blendMode: BlendMode.dstIn,
                    child: Opacity(
                      opacity: 0.8,
                      child: Image.asset(
                        'assets/images/home_person_doodle.png',
                        width: 220,
                        fit: BoxFit.contain,
                      ),
                    ),
                  ),
                ),

                // 3. The Main Content
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 20, 24, 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                height: 50,
                                width: 50,
                                child: Lottie.network(
                                  'https://raw.githubusercontent.com/xvrh/lottie-flutter/master/example/assets/Mobilo/A.json',
                                  errorBuilder: (context, error, stackTrace) {
                                    return const Icon(Icons.spa,
                                        color: Color(0xFFE3EED4), size: 30);
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Morning, Alex',
                                style: GoogleFonts.inter(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFFE3EED4)),
                              ),
                            ],
                          ),
                          const CircleAvatar(
                            radius: 20,
                            backgroundColor: Color(0xFF6B9071),
                            child: Icon(Icons.person,
                                color: Color(0xFF0F2A1D)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),

                      // Title
                      Text(
                        'Social\nSteps',
                        style: GoogleFonts.inter(
                          fontSize: 48,
                          fontWeight: FontWeight.bold,
                          height: 1.1,
                          color: const Color(0xFFE3EED4),
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Category Chips
                      SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          children: [
                            _buildCategoryChip('Daily'),
                            _buildCategoryChip('Weekly'),
                            _buildCategoryChip('Zen'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 30),

                      // Task List
                      AnimatedSwitcher(
                        duration: const Duration(
                            milliseconds: 500), // Slower for smooth curve
                        layoutBuilder: (currentChild, previousChildren) {
                          return Stack(
                            alignment: Alignment.topLeft,
                            children: [
                              ...previousChildren,
                              if (currentChild != null) currentChild,
                            ],
                          );
                        },
                        transitionBuilder: (child, animation) {
                          final bool isCurrent =
                              (child.key as ValueKey<String>).value ==
                                  _selectedCategory;

                          // Custom Bezier Curve for Slide
                          final CurvedAnimation slideCurve = CurvedAnimation(
                            parent: animation,
                            curve: Curves.easeInOutCubicEmphasized,
                            reverseCurve: Curves.easeInOutCubicEmphasized,
                          );

                          // Accelerated Fade Curve (Fade out earlier)
                          // During Exit (1.0 -> 0.0), we want it to vanish by 0.5.
                          // So opacity should map 0.5->1.0 to 0.0->1.0.
                          final Animation<double> fastFade = CurvedAnimation(
                            parent: animation,
                            curve:
                                const Interval(0.5, 1.0, curve: Curves.easeOut),
                          );

                          if (isCurrent) {
                            // Entering: Just Fade (StaggeredColumn handles Slide)
                            return FadeTransition(
                                opacity: slideCurve, child: child);
                          } else {
                            // Exiting: Slide Away + Fast Fade Out
                            final double exitOffset = _isForward ? -1.0 : 1.0;

                            return FadeTransition(
                              opacity: fastFade, // Use accelerated fade
                              child: SlideTransition(
                                position: Tween<Offset>(
                                        begin: Offset(exitOffset, 0.0),
                                        end: Offset.zero)
                                    .animate(slideCurve), // Keep smooth slide
                                child: child,
                              ),
                            );
                          }
                        },
                        child: _selectedCategory == 'Zen'
                            ? Padding(
                                key: const ValueKey('Zen'),
                                padding: const EdgeInsets.only(bottom: 16),
                                child: _buildMissionCard(
                                  context,
                                  title: 'SOS Mode',
                                  subtitle: 'Immediate panic relief',
                                  imagePath: 'assets/images/sos.png',
                                  icon: Icons.emergency,
                                  isAction: true,
                                  onTap: () {
                                    Navigator.of(context).push(
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const PanicModeScreen()),
                                    );
                                  },
                                ),
                              )
                            : StaggeredColumn(
                                key: ValueKey(_selectedCategory),
                                startOffset: _isForward
                                    ? 0.5
                                    : -0.5, // Enter Right if Forward, Left if Back
                                children: displayedTasks
                                    .map((task) => Padding(
                                          padding:
                                              const EdgeInsets.only(bottom: 16),
                                          child: _buildTaskCard(task),
                                        ))
                                    .toList(),
                              ),
                      ),

                      // Always show SOS if not in Zen (optional, or keeping it separate)
                      if (_selectedCategory != 'Zen')
                        Padding(
                          padding: const EdgeInsets.only(top: 16),
                          child: _buildMissionCard(
                            context,
                            title: 'SOS Mode',
                            subtitle: 'Immediate panic relief',
                            imagePath: 'assets/images/sos.png',
                            icon: Icons.emergency,
                            isAction: true,
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const PanicModeScreen()),
                              );
                            },
                          ),
                        ),

                      const SizedBox(height: 80),
                    ],
                  ),
                ),
                // Closing Stack, SingleChildScrollView, SafeArea, and Container
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCategoryChip(String label) {
    bool isSelected = _selectedCategory == label;

    // Assign Key
    GlobalKey? key;
    if (label == 'Daily') key = _dailyKey;
    if (label == 'Weekly') key = _weeklyKey;
    if (label == 'Zen') key = _zenKey;

    // Calculate Stats
    int total = _tasks.where((t) => t.category == label).length;
    int completed =
        _tasks.where((t) => t.category == label && t.isCompleted).length;
    String statusText = (label == 'Zen') ? '∞' : '$completed/$total';

    // Calculate Progress value
    double? progressValue;
    if (label != 'Zen' && total > 0) {
      progressValue = completed / total;
    }

    // Categories list for index calculation
    final List<String> categories = ['Daily', 'Weekly', 'Zen'];

    return GestureDetector(
      onTap: () {
        int oldIndex = categories.indexOf(_selectedCategory);
        int newIndex = categories.indexOf(label);
        setState(() {
          _isForward = newIndex > oldIndex;
          _selectedCategory = label;
        });
      },
      child: Container(
        margin: const EdgeInsets.only(right: 24),
        child: Column(
          children: [
            Container(
              key: key, // Target for Animation
              width: 50,
              height: 50,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color:
                    isSelected ? const Color(0xFF0F2A1D) : Colors.transparent,
              ),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Progress Indicator
                  if (label != 'Zen')
                    SizedBox(
                      width: 50,
                      height: 50,
                      child: TweenAnimationBuilder<double>(
                        tween: Tween<double>(begin: 0, end: progressValue ?? 0),
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOutQuad,
                        builder: (context, value, _) {
                          return CircularProgressIndicator(
                            value: value,
                            strokeWidth: 3,
                            backgroundColor:
                                const Color(0xFF6B9071).withOpacity(0.2),
                            valueColor: const AlwaysStoppedAnimation<Color>(
                                Color(0xFFE3EED4)),
                          );
                        },
                      ),
                    )
                  else
                    // Zen Border (Infinite)
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: isSelected
                            ? Border.all(
                                color: const Color(0xFFE3EED4), width: 1)
                            : Border.all(
                                color: const Color(0xFF6B9071).withOpacity(0.5),
                                width: 1),
                      ),
                    ),

                  // Text Count
                  Text(
                    statusText,
                    style: TextStyle(
                      color: isSelected
                          ? const Color(0xFFE3EED4)
                          : const Color(0xFF6B9071),
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: isSelected
                    ? const Color(0xFFE3EED4)
                    : const Color(0xFF6B9071).withOpacity(0.7),
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _runCompletionAnimation(TapUpDetails details, Task task) {
    // 1. Identify Target
    late GlobalKey targetKey;
    if (task.category == 'Daily')
      // ignore: curly_braces_in_flow_control_structures
      targetKey = _dailyKey;
    else if (task.category == 'Weekly')
      targetKey = _weeklyKey;
    else
      targetKey = _zenKey;

    final RenderBox? targetBox =
        targetKey.currentContext?.findRenderObject() as RenderBox?;
    if (targetBox == null) {
      // Fallback if not visible
      setState(() => task.isCompleted = !task.isCompleted);
      return;
    }

    final Offset targetPos = targetBox.localToGlobal(Offset.zero) +
        Offset(targetBox.size.width / 2, targetBox.size.height / 2);

    // 2. Spawn Overlay
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => FlyParticle(
        start: details.globalPosition,
        end: targetPos,
        onComplete: () {
          entry.remove();
          // Update State on LANDING
          setState(() {
            task.isCompleted = true;
          });
        },
      ),
    );

    Overlay.of(context).insert(entry);
  }

  Widget _buildTaskCard(Task task) {
    return GestureDetector(
      onTapUp: (details) {
        if (!task.isCompleted) {
          _runCompletionAnimation(details, task);
        } else {
          setState(() => task.isCompleted = !task.isCompleted);
        }
      },
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          border: task.isBonus
              ? Border.all(color: const Color(0xFFE3EED4), width: 1)
              : null, // Highlight bonus
          image: DecorationImage(
            image: AssetImage(task.imagePath),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              const Color(0xFF0F2A1D)
                  .withOpacity(task.isCompleted ? 0.8 : 0.6), // Darker if done
              BlendMode.srcOver,
            ),
          ),
        ),
        child: Stack(
          children: [
            // Checkmark Overlay if Done
            if (task.isCompleted)
              Center(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: const BoxDecoration(
                      color: Color(0xFFE3EED4), shape: BoxShape.circle),
                  child: const Icon(Icons.check,
                      color: Color(0xFF0F2A1D), size: 32),
                ),
              ),

            Padding(
              padding: const EdgeInsets.all(24),
              child: Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        if (task.isBonus)
                          Container(
                            margin: const EdgeInsets.only(bottom: 8),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 4),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE3EED4),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: const Text('BONUS',
                                style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.bold,
                                    color: Color(0xFF0F2A1D))),
                          ),
                        Text(
                          task.title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.inter(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: Colors.white
                                .withOpacity(task.isCompleted ? 0.5 : 1.0),
                            decoration: task.isCompleted
                                ? TextDecoration.lineThrough
                                : null,
                            decorationColor: const Color(0xFFE3EED4),
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.5),
                                offset: const Offset(0, 2),
                                blurRadius: 4,
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          task.subtitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.white70
                                .withOpacity(task.isCompleted ? 0.4 : 0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (!task.isCompleted)
                    Container(
                      height: 50,
                      width: 50,
                      decoration: BoxDecoration(
                        color: const Color(0xFFE3EED4),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        task.icon,
                        color: const Color(0xFF0F2A1D),
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Keeping the original generic builder for SOS/Zen
  Widget _buildMissionCard(
    BuildContext context, {
    required String title,
    required String subtitle,
    required String imagePath,
    required IconData icon,
    bool isAction = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 160,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(32),
          image: DecorationImage(
            image: AssetImage(imagePath),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              const Color(0xFF0F2A1D)
                  .withOpacity(0.6), // Dark overlay for readability
              BlendMode.srcOver,
            ),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.inter(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                        shadows: [
                          const Shadow(
                              color: Colors.black45,
                              blurRadius: 4,
                              offset: Offset(0, 2))
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        fontSize: 14,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 50,
                width: 50,
                decoration: BoxDecoration(
                  color: isAction
                      ? const Color(0xFFCD5C5C)
                      : const Color(0xFFE3EED4),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(
                  isAction ? Icons.arrow_forward : Icons.add,
                  color: isAction ? Colors.white : const Color(0xFF0F2A1D),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class TigeScreen extends StatelessWidget {
  const TigeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F2A1D),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0F2A1D),
        title: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircleAvatar(
              radius: 16,
              backgroundColor: Color(0xFFE3EED4),
              child: Icon(Icons.pets, size: 18, color: Color(0xFF0F2A1D)),
            ),
            SizedBox(width: 12),
            Text('Tige',
                style: TextStyle(
                    fontWeight: FontWeight.bold, color: Color(0xFFE3EED4))),
          ],
        ),
        actions: [
          // Voice Mode Button
          IconButton(
            icon: const Icon(Icons.graphic_eq_rounded,
                color: Color(0xFFE3EED4), size: 28),
            tooltip: 'Have a Talk',
            onPressed: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                    builder: (context) => const HaveATalkScreen()),
              );
            },
          ),
          const SizedBox(width: 8),
          IconButton(
              icon:
                  const Icon(Icons.more_vert_rounded, color: Color(0xFFE3EED4)),
              onPressed: () {}),
        ],
      ),
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFF0F2A1D),
          image: DecorationImage(
            image: AssetImage('assets/images/chat_bg.png'),
            fit: BoxFit.cover,
            opacity: 0.15, // Subtle doodle effect
          ),
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                itemCount: 6,
                itemBuilder: (context, index) {
                  final isMe = index % 2 == 0;
                  return Align(
                    alignment:
                        isMe ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 8),
                      constraints: BoxConstraints(
                          maxWidth: MediaQuery.of(context).size.width * 0.75),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 16),
                      decoration: BoxDecoration(
                        // Using Palette for Bubbles
                        color: isMe
                            ? const Color(0xFF375534) // My Bubble: Forest Green
                            : const Color(0xFFE3EED4), // Tige Bubble: Cream
                        borderRadius: BorderRadius.only(
                          topLeft: const Radius.circular(24),
                          topRight: const Radius.circular(24),
                          bottomLeft: isMe
                              ? const Radius.circular(24)
                              : const Radius.circular(4),
                          bottomRight: isMe
                              ? const Radius.circular(4)
                              : const Radius.circular(24),
                        ),
                      ),
                      child: Text(
                        isMe
                            ? 'Did the challenge!'
                            : 'That\'s amazing! How do you feel?',
                        style: TextStyle(
                          color: isMe
                              ? const Color(0xFFE3EED4)
                              : const Color(0xFF0F2A1D), // Contrast text
                          fontSize: 16,
                          height: 1.4,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            // Input Bar
            Container(
              padding: const EdgeInsets.fromLTRB(20, 12, 20,
                  120), // Keep padding to clear nav (nav slides away but padding is safe)
              decoration: const BoxDecoration(
                color: Color(0xFF0F2A1D),
              ),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: const BoxDecoration(
                      color: Color(0xFF375534),
                      shape: BoxShape.circle, // Circular Plus
                    ),
                    child:
                        const Icon(Icons.add_rounded, color: Color(0xFFE3EED4)),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      height: 44, // Slimmer height
                      decoration: BoxDecoration(
                        color: const Color(0xFF375534),
                        borderRadius: BorderRadius.circular(24), // Pill shape
                        border: Border.all(
                            color: const Color(0xFF6B9071).withOpacity(0.3)),
                      ),
                      child: Row(
                        children: [
                          // Emoji Button (Left)
                          GestureDetector(
                            onTap: () {
                              // Placeholder for Emoji Picker
                            },
                            child: const Icon(Icons.emoji_emotions_outlined,
                                color: Color(0xFF6B9071), size: 24),
                          ),
                          const SizedBox(width: 8),

                          const Expanded(
                            child: TextField(
                              style: TextStyle(
                                  color: Color(0xFFE3EED4), fontSize: 16),
                              decoration: InputDecoration(
                                hintText: 'Message', // Updated Hint
                                border: InputBorder.none,
                                isDense: true,
                                contentPadding: EdgeInsets.zero,
                                hintStyle: TextStyle(color: Color(0xFF6B9071)),
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Mic Button (Right) - Triggers Voice Mode
                          GestureDetector(
                            onTap: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const HaveATalkScreen()),
                              );
                            },
                            child: const Icon(Icons.mic_none_rounded,
                                color: Color(0xFF6B9071), size: 24),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Removed separate big mic button to match Apple style (or keep if desired)
                  // Assuming user wants "refer apple's designs", usually mic is inside or minimal.
                  // But user said "even the mic ... rounded". Let's keep the existing button but make it circular.
                  const SizedBox(width: 8),
                  Container(
                    height: 44,
                    width: 44,
                    decoration: const BoxDecoration(
                      color: Color(0xFFE3EED4),
                      shape: BoxShape.circle, // Fully Circular
                    ),
                    child: const Icon(Icons.arrow_upward_rounded,
                        color: Color(0xFF0F2A1D)), // Send Arrow
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ScriptsScreen extends StatelessWidget {
  const ScriptsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scripts')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.library_books_rounded,
                size: 64, color: Color(0xFF375534)),
            const SizedBox(height: 16),
            Text('Library Coming Soon',
                style: TextStyle(
                    color: const Color(0xFFE3EED4).withOpacity(0.5),
                    fontSize: 18)),
          ],
        ),
      ),
    );
  }
}

// Fluid Harmonic Voice Visualizer
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

// Staggered Animation Widget
class StaggeredColumn extends StatefulWidget {
  final List<Widget> children;
  final Duration itemDuration;
  final Duration staggerDuration;
  final double startOffset;

  const StaggeredColumn({
    super.key,
    required this.children,
    this.itemDuration = const Duration(milliseconds: 400),
    this.staggerDuration = const Duration(milliseconds: 100),
    this.startOffset = 0.5,
  });

  @override
  State<StaggeredColumn> createState() => _StaggeredColumnState();
}

class _StaggeredColumnState extends State<StaggeredColumn>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this,
        duration: widget.itemDuration +
            (widget.staggerDuration * widget.children.length));
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(widget.children.length, (index) {
        final start = (widget.staggerDuration.inMilliseconds * index) /
            _controller.duration!.inMilliseconds;
        final end = start +
            (widget.itemDuration.inMilliseconds /
                _controller.duration!.inMilliseconds);

        // Clamp end to 1.0
        final curvedEnd = end > 1.0 ? 1.0 : end;

        final animation = Tween<Offset>(
                begin: Offset(widget.startOffset, 0), end: Offset.zero)
            .animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(start, curvedEnd, curve: Curves.easeOutCubic),
          ),
        );

        final opacity = Tween<double>(begin: 0, end: 1).animate(
          CurvedAnimation(
            parent: _controller,
            curve: Interval(start, curvedEnd, curve: Curves.linear),
          ),
        );

        return FadeTransition(
          opacity: opacity,
          child: SlideTransition(
            position: animation,
            child: widget.children[index],
          ),
        );
      }),
    );
  }
}
