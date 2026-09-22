import 'dart:async';

import 'package:flutter/widgets.dart';

class MatchLifecycleGuard extends StatefulWidget {
  const MatchLifecycleGuard({
    super.key,
    required this.onPersist,
    required this.child,
  });

  final Future<void> Function() onPersist;
  final Widget child;

  @override
  State<MatchLifecycleGuard> createState() => _MatchLifecycleGuardState();
}

class _MatchLifecycleGuardState extends State<MatchLifecycleGuard> {
  late final AppLifecycleListener _listener;

  @override
  void initState() {
    super.initState();
    _listener = AppLifecycleListener(
      onInactive: _persist,
      onHide: _persist,
      onPause: _persist,
      onDetach: _persist,
    );
  }

  void _persist() => unawaited(widget.onPersist());

  @override
  void dispose() {
    _listener.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
