import 'package:flutter/material.dart';

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
