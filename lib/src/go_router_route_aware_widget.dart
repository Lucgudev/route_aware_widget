import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class GoRouterRouteAwareWidget extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPageAppearing;
  final VoidCallback? onPageDisappearing;

  const GoRouterRouteAwareWidget({
    super.key,
    required this.child,
    this.onPageAppearing,
    this.onPageDisappearing,
  });

  @override
  State<GoRouterRouteAwareWidget> createState() =>
      _GoRouterRouteAwareWidgetState();
}

class _GoRouterRouteAwareWidgetState extends State<GoRouterRouteAwareWidget> {
  late GoRouter _router;
  late String _myLocation;
  bool _isVisible = true;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Initialize once after context is available
    if (mounted && _myLocation.isNotEmpty == false) {
      _router = GoRouter.of(context);
      _myLocation = _router.routeInformationProvider.value.location;

      _router.routerDelegate.addListener(_onRouteChange);
    }
  }

  void _onRouteChange() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      final currentLocation = _router.routeInformationProvider.value.location;
      final isCurrentlyVisible = currentLocation == _myLocation;

      if (isCurrentlyVisible && !_isVisible) {
        _isVisible = true;
        widget.onPageAppearing?.call();
      } else if (!isCurrentlyVisible && _isVisible) {
        _isVisible = false;
        widget.onPageDisappearing?.call();
      }
    });
  }

  @override
  void dispose() {
    _router.routerDelegate.removeListener(_onRouteChange);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
