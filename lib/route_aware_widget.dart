library route_aware_widget;

import 'package:flutter/material.dart';
import 'package:route_aware_widget/route_aware_widget.dart';
import 'package:route_aware_widget/src/auto_route_route_aware_widget.dart';
import 'package:route_aware_widget/src/constants/router_type.dart';
import 'package:route_aware_widget/src/go_router_route_aware_widget.dart';
import 'package:route_aware_widget/src/helper/router_helper.dart';
import 'package:route_aware_widget/src/navigator_route_aware_widget.dart';
export 'src/route_observer.dart';
export 'src/constants/router_type.dart';
export 'src/route_aware_config.dart';

/// A widget that provides callbacks when the route it's on becomes visible or hidden.
///
/// This widget works with multiple navigation systems:
/// - Standard Navigator with RouteObserver
/// - AutoRoute
/// - GoRouter
/// - Any custom navigation system via RouteAwareWidgetObserver
///
/// Example usage with Navigator:
/// ```dart
/// RouteAwareWidget(
///   onPageAppear: () => print('Page appeared'),
///   onPageDisappear: () => print('Page disappeared'),
///   child: YourWidget(),
/// )
/// ```
class RouteAwareWidget extends StatefulWidget {
  final Widget child;

  /// Called when this route becomes visible
  final VoidCallback? onPageAppear;

  /// Called when this route becomes hidden (pushed over or popped)
  final VoidCallback? onPageDisappear;

  const RouteAwareWidget({
    super.key,
    required this.child,
    this.onPageAppear,
    this.onPageDisappear,
  });

  @override
  State<RouteAwareWidget> createState() => _RouteAwareWidgetState();
}

class _RouteAwareWidgetState extends State<RouteAwareWidget> with RouteAware {
  RouterType routerType = RouterType.unknown;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // 1. Check configured global router type (safe here)
    final globalRouterType = RouteAwareConfig.of(context);
    if (globalRouterType != null) {
      routerType = globalRouterType;
      return;
    }

    // 2. Auto-detect based on widget position in nav tree
    routerType = RouterHelper.detectRouter(context);
  }

  @override
  Widget build(BuildContext context) {
    switch (routerType) {
      case RouterType.goRouter:
        return GoRouterRouteAwareWidget(
          onPageAppearing: widget.onPageAppear,
          onPageDisappearing: widget.onPageDisappear,
          child: widget.child,
        );
      case RouterType.autoRoute:
        return AutoRouteRouteAwareWidget(
          onPageAppearing: widget.onPageAppear,
          onPageDisappearing: widget.onPageDisappear,
          child: widget.child,
        );
      case RouterType.navigator:
        return NavigatorRouteAwareWidget(
          onPageAppearing: widget.onPageAppear,
          onPageDisappearing: widget.onPageDisappear,
          child: widget.child,
        );
      case RouterType.unknown:
        return widget.child;
    }
  }
}
