import 'package:flutter/widgets.dart';
import 'constants/router_type.dart';

class RouteAwareConfig extends InheritedWidget {
  final RouterType routerType;

  const RouteAwareConfig({
    super.key,
    required this.routerType,
    required super.child,
  });

  static RouterType? of(BuildContext context) {
    final config =
        context.dependOnInheritedWidgetOfExactType<RouteAwareConfig>();
    return config?.routerType;
  }

  @override
  bool updateShouldNotify(RouteAwareConfig oldWidget) {
    return oldWidget.routerType != routerType;
  }
}
