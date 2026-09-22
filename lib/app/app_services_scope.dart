import 'package:flutter/widgets.dart';

import 'app_services.dart';

class AppServicesScope extends InheritedWidget {
  const AppServicesScope({
    super.key,
    required this.services,
    required super.child,
  });

  final AppServices services;

  static AppServices of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppServicesScope>();
    assert(scope != null, 'AppServicesScope not found in widget tree.');
    return scope!.services;
  }

  @override
  bool updateShouldNotify(AppServicesScope oldWidget) => services != oldWidget.services;
}
