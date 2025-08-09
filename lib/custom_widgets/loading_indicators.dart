// ignore_for_file: must_be_immutable

import 'dart:math';
import 'package:flutter/material.dart';

class FadingCircularDots extends StatefulWidget {
  final int count;
  final double radius;
  final double dotRadius;
  final Duration duration;
  final Color color;

  const FadingCircularDots({
    super.key,
    this.count = 12,
    this.radius = 30,
    this.dotRadius = 5,
    this.duration = const Duration(milliseconds: 1200),
    this.color = const Color.fromARGB(255, 61, 33, 24),
  });

  @override
  State<FadingCircularDots> createState() => _FadingCircularDotsState();
}

class _FadingCircularDotsState extends State<FadingCircularDots>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _calculateOpacity(int index, double animationValue) {
    double position = (animationValue * widget.count);
    double distance = (index - position) % widget.count;
    if (distance < 0) distance += widget.count;
    return 1.0 - (distance / widget.count);
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.radius * 2 + widget.dotRadius * 2,
      height: widget.radius * 2 + widget.dotRadius * 2,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          return Stack(
            alignment: Alignment.center,
            children: List.generate(widget.count, (index) {
              final angle = 2 * pi * index / widget.count;
              final x = widget.radius * cos(angle);
              final y = widget.radius * sin(angle);
              final opacity = _calculateOpacity(index, _controller.value);

              return Positioned(
                left: widget.radius + x,
                top: widget.radius + y,
                child: Opacity(
                  opacity: opacity,
                  child: Container(
                    width: widget.dotRadius * 2,
                    height: widget.dotRadius * 2,
                    decoration: BoxDecoration(
                      color: widget.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              );
            }),
          );
        },
      ),
    );
  }
}

class FadingHorizontalDots extends StatefulWidget {
  final int count;
  final double spacing;
  final double dotRadius;
  final Duration duration;
  final Color color;

  const FadingHorizontalDots({
    super.key,
    this.count = 5,
    this.spacing = 12,
    this.dotRadius = 5,
    this.duration = const Duration(milliseconds: 1000),
    this.color = Colors.white,
  });

  @override
  State<FadingHorizontalDots> createState() => _FadingHorizontalDotsState();
}

class _FadingHorizontalDotsState extends State<FadingHorizontalDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  double _calculateOpacity(int index, double value) {
    final position = (value * widget.count);
    double distance = (index - position) % widget.count;
    if (distance < 0) distance += widget.count;
    return 1.0 - (distance / widget.count);
  }

  @override
  Widget build(BuildContext context) {
    final width = (widget.count * widget.dotRadius * 2) +
        ((widget.count - 1) * widget.spacing);

    return SizedBox(
      width: width,
      height: widget.dotRadius * 2,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (_, __) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(widget.count, (index) {
              final opacity = _calculateOpacity(index, _controller.value);
              return Container(
                margin: EdgeInsets.only(
                  left: index == 0 ? 0 : widget.spacing / 2,
                  right: index == widget.count - 1 ? 0 : widget.spacing / 2,
                ),
                width: widget.dotRadius * 2,
                height: widget.dotRadius * 2,
                decoration: BoxDecoration(
                  color: widget.color.withOpacity(opacity),
                  shape: BoxShape.circle,
                ),
              );
            }),
          );
        },
      ),
    );
  }
}

class FadingDotsIndicator extends StatelessWidget {
  final int count;
  final int selectedIndex;
  final double radius;
  final double spacing;
  final Color activeColor;
  final Color inactiveColor;

  const FadingDotsIndicator({
    Key? key,
    this.count = 5,
    this.selectedIndex = 0,
    this.radius = 6.0,
    this.spacing = 12.0,
    this.activeColor = Colors.blue,
    this.inactiveColor = Colors.grey,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List.generate(count, (index) {
        final isSelected = index == selectedIndex;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: spacing / 2),
          width: radius * 2,
          height: radius * 2,
          decoration: BoxDecoration(
            color: isSelected ? activeColor : inactiveColor.withOpacity(0.5),
            shape: BoxShape.circle,
          ),
        );
      }),
    );
  }
}

class GradientIndeterminateProgressBar extends StatefulWidget {
  double height;

  GradientIndeterminateProgressBar({super.key, this.height = 10});

  @override
  State<GradientIndeterminateProgressBar> createState() =>
      _GradientIndeterminateProgressBarState();
}

class _GradientIndeterminateProgressBarState
    extends State<GradientIndeterminateProgressBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(); // Infinite loop
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10), // Rounded edges
      child: Container(
        height: widget.height,
        color: Colors.grey[200], // Background color
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: 0.3, // width of the moving gradient bar
              child: Transform.translate(
                offset: Offset(
                    _controller.value * MediaQuery.of(context).size.width, 0),
                child: Container(
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFFF1A5C9),
                        Color(0xFFEFD2BE),
                        Color(0xFFACECDC),
                        Color(0xFF8AE5FE),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
