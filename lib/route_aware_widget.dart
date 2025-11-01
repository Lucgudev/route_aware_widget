library route_aware_widget;

import 'package:flutter/material.dart';

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
  /// The widget to display
  final Widget child;

  /// Called when this route becomes visible
  final VoidCallback? onPageAppear;

  /// Called when this route becomes hidden (pushed over or popped)
  final VoidCallback? onPageDisappear;

  /// Optional RouteObserver for standard Navigator.
  /// If not provided, will try to find one in the widget tree via RouteObserverProvider.
  final RouteObserver<ModalRoute<dynamic>>? routeObserver;

  /// Optional custom observer for other navigation systems
  final RouteAwareWidgetObserver? customObserver;

  const RouteAwareWidget({
    super.key,
    required this.child,
    this.onPageAppear,
    this.onPageDisappear,
    this.routeObserver,
    this.customObserver,
  });

  @override
  State<RouteAwareWidget> createState() => _RouteAwareWidgetState();
}

class _RouteAwareWidgetState extends State<RouteAwareWidget>
    with RouteAware {
  RouteObserver<ModalRoute<dynamic>>? _routeObserver;
  RouteAwareWidgetObserver? _customObserver;
  ModalRoute<dynamic>? _currentRoute;
  bool _isVisible = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _setupObservers();
  }

  void _setupObservers() {
    // Unsubscribe from previous observers
    _routeObserver?.unsubscribe(this);
    _customObserver?.unsubscribe(this);

    // Setup standard RouteObserver
    _routeObserver = widget.routeObserver ??
        RouteObserverProvider.maybeOf(context);

    if (_routeObserver != null) {
      _currentRoute = ModalRoute.of(context);
      if (_currentRoute != null) {
        _routeObserver!.subscribe(this, _currentRoute!);
      }
    }

    // Setup custom observer (for AutoRoute, GoRouter, etc.)
    _customObserver = widget.customObserver;
    _customObserver?.subscribe(this, context);
  }

  @override
  void didPush() {
    // Route was pushed onto navigator and is now topmost route
    _setVisible(true);
  }

  @override
  void didPopNext() {
    // Covering route was popped off the navigator, this route is now topmost
    _setVisible(true);
  }

  @override
  void didPushNext() {
    // A new route was pushed onto navigator, this route is no longer topmost
    _setVisible(false);
  }

  @override
  void didPop() {
    // This route was popped off the navigator
    _setVisible(false);
  }

  void _setVisible(bool visible) {
    if (_isVisible == visible) return;
    _isVisible = visible;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      if (visible) {
        widget.onPageAppear?.call();
      } else {
        widget.onPageDisappear?.call();
      }
    });
  }

  @override
  void dispose() {
    _routeObserver?.unsubscribe(this);
    _customObserver?.unsubscribe(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}

/// Provider for RouteObserver to make it accessible in the widget tree.
///
/// Add this near the root of your app:
/// ```dart
/// RouteObserverProvider(
///   routeObserver: routeObserver,
///   child: MaterialApp(...),
/// )
/// ```
class RouteObserverProvider extends InheritedWidget {
  final RouteObserver<ModalRoute<dynamic>> routeObserver;

  const RouteObserverProvider({
    super.key,
    required this.routeObserver,
    required super.child,
  });

  static RouteObserver<ModalRoute<dynamic>>? maybeOf(BuildContext context) {
    return context
        .dependOnInheritedWidgetOfExactType<RouteObserverProvider>()
        ?.routeObserver;
  }

  static RouteObserver<ModalRoute<dynamic>> of(BuildContext context) {
    final observer = maybeOf(context);
    assert(observer != null, 'No RouteObserverProvider found in context');
    return observer!;
  }

  @override
  bool updateShouldNotify(RouteObserverProvider oldWidget) {
    return routeObserver != oldWidget.routeObserver;
  }
}

/// Abstract class for custom navigation system observers.
///
/// Implement this to support custom navigation systems like AutoRoute, GoRouter, etc.
abstract class RouteAwareWidgetObserver {
  /// Subscribe a RouteAware widget to route changes
  void subscribe(RouteAware routeAware, BuildContext context);

  /// Unsubscribe a RouteAware widget from route changes
  void unsubscribe(RouteAware routeAware);
}
