import 'package:flutter/material.dart';

class LifecycleObserver extends StatefulWidget {
  final Widget child;

  const LifecycleObserver({Key? key, required this.child}) : super(key: key);

  @override
  State<LifecycleObserver> createState() => _LifecycleObserverState();
}

class _LifecycleObserverState extends State<LifecycleObserver>
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
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);
    switch (state) {
      case AppLifecycleState.resumed:
        // App is in the foreground
        debugPrint("App is in the foreground");
        break;
      case AppLifecycleState.inactive:
        // App is inactive
        debugPrint("App is inactive");
        break;
      case AppLifecycleState.paused:
        // App is in the background
        debugPrint("App is in the background");
        break;
      case AppLifecycleState.detached:
        // App is detached
        debugPrint("App is detached");
        break;
      case AppLifecycleState.hidden:
        // App is hidden
        debugPrint("App is hidden");
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
