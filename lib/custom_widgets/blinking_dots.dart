import 'package:flutter/material.dart';

class BlinkingDot extends StatelessWidget {
  final double size;
  final Color color;
  final bool isVisible;

  const BlinkingDot({
    super.key,
    this.size = 12,
    this.color = const Color.fromARGB(255, 146, 61, 5),
    required this.isVisible,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedOpacity(
      opacity: isVisible ? 1.0 : 0.2,
      duration: const Duration(milliseconds: 300),
      child: Container(
        width: size,
        height: size,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(1000), // Fully rounded
        ),
      ),
    );
  }
}
class BlinkingDotsLoader extends StatefulWidget {
  final int dotCount;

  const BlinkingDotsLoader({super.key, this.dotCount = 6});

  @override
  State<BlinkingDotsLoader> createState() => _BlinkingDotsLoaderState();
}

class _BlinkingDotsLoaderState extends State<BlinkingDotsLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  int _currentIndex = 0;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 300))
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          setState(() {
            _currentIndex = (_currentIndex + 1) % widget.dotCount;
          });
          _controller.forward(from: 0);
        }
      })
      ..forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.dotCount, (index) {
        return BlinkingDot(isVisible: _currentIndex == index);
      }),
    );
  }
}
