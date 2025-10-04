import 'package:flutter/widgets.dart';

class DashboardTransitionScope extends InheritedWidget {
  const DashboardTransitionScope({
    super.key,
    required this.animation,
    required this.secondaryAnimation,
    required super.child,
  });

  final Animation<double> animation;
  final Animation<double> secondaryAnimation;

  static DashboardTransitionScope? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<DashboardTransitionScope>();
  }

  static DashboardTransitionScope of(BuildContext context) {
    final scope = maybeOf(context);
    assert(scope != null, 'DashboardTransitionScope not found in context');
    return scope!;
  }

  @override
  bool updateShouldNotify(DashboardTransitionScope oldWidget) {
    return animation != oldWidget.animation ||
        secondaryAnimation != oldWidget.secondaryAnimation;
  }
}
