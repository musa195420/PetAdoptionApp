import 'package:flutter/material.dart';

class KeyboardVisibilityBuilder extends StatefulWidget {
  final Widget child;
  final Widget Function(
    BuildContext context,
    Widget child,
  ) builder;

  const KeyboardVisibilityBuilder({
    super.key,
    required this.child,
    required this.builder,
  });

  @override
  State<KeyboardVisibilityBuilder> createState() => _KeyboardVisibilityBuilderState();
}

class _KeyboardVisibilityBuilderState extends State<KeyboardVisibilityBuilder>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeMetrics() {
  //  final bottomInset = MediaQuery.of(context).viewInsets.bottom;
   // final isKeyboardVisible = bottomInset > 0.0;

    // if (!isKeyboardVisible) {
    //   // Only apply immersive mode when keyboard is dismissed
    //   Future.delayed(const Duration(milliseconds: 100), () {
    //     SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
    //   });
    // }
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder(context, widget.child);
  }
}
