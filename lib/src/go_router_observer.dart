import 'package:flutter/material.dart';
import 'package:route_aware_widget/route_aware_widget.dart';

/// Observer for GoRouter navigation system.
///
/// This requires the go_router package to be added as a dependency.
///
/// Usage:
/// ```dart
/// RouteAwareWidget(
///   customObserver: GoRouterObserver(),
///   onPageAppear: () => print('Page appeared'),
///   onPageDisappear: () => print('Page disappeared'),
///   child: YourWidget(),
/// )
/// ```
class GoRouterObserver extends RouteAwareWidgetObserver {
  final Map<RouteAware, _GoRouterSubscription> _subscriptions = {};

  @override
  void subscribe(RouteAware routeAware, BuildContext context) {
    try {
      final currentLocation = _getCurrentLocation(context);
      final subscription = _GoRouterSubscription(
        routeAware: routeAware,
        context: context,
        initialLocation: currentLocation,
      );

      subscription.initialize();
      _subscriptions[routeAware] = subscription;
    } catch (e) {
      debugPrint('GoRouterObserver: Failed to subscribe - $e');
    }
  }

  @override
  void unsubscribe(RouteAware routeAware) {
    _subscriptions.remove(routeAware)?.dispose();
  }

  String? _getCurrentLocation(BuildContext context) {
    try {
      // Try to get GoRouter state
      // This uses dynamic to avoid hard dependency on go_router
      final goRouter = _getGoRouter(context);
      return goRouter?.toString();
    } catch (e) {
      return null;
    }
  }

  dynamic _getGoRouter(BuildContext context) {
    try {
      // This is a fallback implementation
      // In actual usage, users should use the go_router package's methods
      return null;
    } catch (e) {
      return null;
    }
  }
}

class _GoRouterSubscription {
  final RouteAware routeAware;
  final BuildContext context;
  final String? initialLocation;
  bool isVisible = true;

  _GoRouterSubscription({
    required this.routeAware,
    required this.context,
    this.initialLocation,
  });

  void initialize() {
    // GoRouter typically uses RouteObserver pattern as well
    // So this is more of a helper for specific GoRouter use cases
    // In most cases, standard RouteObserver should work with GoRouter
  }

  void dispose() {
    // Cleanup if needed
  }
}
