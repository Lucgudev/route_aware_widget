import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

class AutoRouteRouteAwareWidget extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPageAppearing;
  final VoidCallback? onPageDisappearing;

  const AutoRouteRouteAwareWidget({
    super.key,
    required this.child,
    this.onPageAppearing,
    this.onPageDisappearing,
  });

  @override
  State<AutoRouteRouteAwareWidget> createState() =>
      _AutoRouteRouteAwareWidgetState();
}

class _AutoRouteRouteAwareWidgetState extends State<AutoRouteRouteAwareWidget> {
  StackRouter? _stackRouter;
  TabsRouter? _tabsRouter;
  String? _routeName;
  int? _tabIndex;
  bool _inTabContext = false;
  bool _isVisible = true; // track current state

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_stackRouter == null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _initializeRouter();
      });
    }
  }

  void _initializeRouter() {
    _stackRouter = AutoRouter.of(context);
    _routeName = _stackRouter?.current.name;
    _stackRouter?.addListener(_onStackChanged);

    try {
      _tabsRouter = AutoTabsRouter.of(context);
      if (_tabsRouter != null) {
        _inTabContext = true;
        _tabIndex = _tabsRouter?.activeIndex;
        _tabsRouter?.addListener(_onStackChanged);
      }
    } catch (_) {
      _inTabContext = false;
    }
  }

  void _onStackChanged() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final isCurrentRoute = _routeName == _stackRouter?.current.name;
      final isCurrentTab =
          !_inTabContext || (_tabIndex == _tabsRouter?.activeIndex);

      final shouldBeVisible = isCurrentRoute && isCurrentTab;

      if (shouldBeVisible && !_isVisible) {
        // Became visible
        _isVisible = true;
        widget.onPageAppearing?.call();
      } else if (!shouldBeVisible && _isVisible) {
        // Became hidden
        _isVisible = false;
        widget.onPageDisappearing?.call();
      }
    });
  }

  @override
  void dispose() {
    _stackRouter?.removeListener(_onStackChanged);
    _tabsRouter?.removeListener(_onStackChanged);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
