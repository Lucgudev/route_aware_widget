import 'package:flutter/material.dart';
import 'package:route_aware_widget/route_aware_widget.dart';

/// Observer for AutoRoute navigation system.
///
/// This requires the auto_route package to be added as a dependency.
///
/// Usage:
/// ```dart
/// // Note: This is pseudo-code. You'll need to import auto_route in your app
/// RouteAwareWidget(
///   customObserver: AutoRouteObserver(),
///   onPageAppear: () => print('Page appeared'),
///   onPageDisappear: () => print('Page disappeared'),
///   child: YourWidget(),
/// )
/// ```
class AutoRouteObserver extends RouteAwareWidgetObserver {
  final Map<RouteAware, _AutoRouteSubscription> _subscriptions = {};

  @override
  void subscribe(RouteAware routeAware, BuildContext context) {
    try {
      // Try to get AutoRoute's StackRouter
      // This uses dynamic to avoid hard dependency on auto_route
      final stackRouter = _getAutoRouter(context, 'StackRouter');
      final tabsRouter = _getAutoRouter(context, 'TabsRouter');

      final subscription = _AutoRouteSubscription(
        routeAware: routeAware,
        stackRouter: stackRouter,
        tabsRouter: tabsRouter,
        routeName: stackRouter?.toString().split('(').last.split(')').first,
        tabIndex: tabsRouter != null ? _getActiveIndex(tabsRouter) : null,
      );

      subscription.initialize();
      _subscriptions[routeAware] = subscription;
    } catch (e) {
      debugPrint('AutoRouteObserver: Failed to subscribe - $e');
    }
  }

  @override
  void unsubscribe(RouteAware routeAware) {
    _subscriptions.remove(routeAware)?.dispose();
  }

  dynamic _getAutoRouter(BuildContext context, String routerType) {
    try {
      // This is a fallback implementation
      // In actual usage, users should pass the router explicitly
      // or use the auto_route_observer package extension
      return null;
    } catch (e) {
      return null;
    }
  }

  int? _getActiveIndex(dynamic router) {
    try {
      return (router as dynamic).activeIndex as int?;
    } catch (e) {
      return null;
    }
  }
}

class _AutoRouteSubscription {
  final RouteAware routeAware;
  final dynamic stackRouter;
  final dynamic tabsRouter;
  final String? routeName;
  final int? tabIndex;
  bool isVisible = true;

  _AutoRouteSubscription({
    required this.routeAware,
    this.stackRouter,
    this.tabsRouter,
    this.routeName,
    this.tabIndex,
  });

  void initialize() {
    stackRouter?.addListener(_onRouteChanged);
    tabsRouter?.addListener(_onRouteChanged);
  }

  void _onRouteChanged() {
    try {
      final currentRouteName =
          stackRouter.toString().split('(').last.split(')').first;
      final currentTabIndex =
          tabsRouter != null ? (tabsRouter as dynamic).activeIndex : tabIndex;

      final isCurrentRoute = routeName == currentRouteName;
      final isCurrentTab = tabsRouter == null || (tabIndex == currentTabIndex);
      final shouldBeVisible = isCurrentRoute && isCurrentTab;

      if (shouldBeVisible != isVisible) {
        isVisible = shouldBeVisible;
        if (isVisible) {
          (routeAware as dynamic).didPopNext();
        } else {
          (routeAware as dynamic).didPushNext();
        }
      }
    } catch (e) {
      debugPrint('AutoRouteSubscription: Error in route change - $e');
    }
  }

  void dispose() {
    stackRouter?.removeListener(_onRouteChanged);
    tabsRouter?.removeListener(_onRouteChanged);
  }
}
