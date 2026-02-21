import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lottie/lottie.dart';
import '../../../core/models/task.dart';
import '../../../core/models/user_profile.dart';
import '../../../shared/widgets/fly_particle.dart';
import '../../../shared/widgets/staggered_column.dart';
import '../../zen/screens/panic_mode_screen.dart';

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

  void _editName(BuildContext context) {
    final TextEditingController controller =
        TextEditingController(text: UserProfile.name.value);
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: const Color(0xFF0F2A1D),
          title: const Text('What should I call you?',
              style: TextStyle(color: Color(0xFFE3EED4))),
          content: TextField(
            controller: controller,
            style: const TextStyle(color: Color(0xFFE3EED4)),
            decoration: InputDecoration(
              hintText: 'Your name',
              hintStyle: TextStyle(
                  color: const Color(0xFF6B9071).withValues(alpha: 0.5)),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel',
                  style: TextStyle(color: Color(0xFF6B9071))),
            ),
            TextButton(
              onPressed: () {
                UserProfile.setName(controller.text);
                Navigator.pop(context);
              },
              child: const Text('Save',
                  style: TextStyle(color: Color(0xFFE3EED4))),
            ),
          ],
        );
      },
    );
  }

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
                              ValueListenableBuilder<String>(
                                valueListenable: UserProfile.name,
                                builder: (context, name, child) {
                                  return GestureDetector(
                                    onTap: () => _editName(context),
                                    child: Text(
                                      'Morning, $name',
                                      style: GoogleFonts.inter(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFFE3EED4)),
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                          const CircleAvatar(
                            radius: 20,
                            backgroundColor: Color(0xFF6B9071),
                            child: Icon(Icons.person, color: Color(0xFF0F2A1D)),
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
        constraints: const BoxConstraints(minHeight: 160),
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
        constraints: const BoxConstraints(minHeight: 160),
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
