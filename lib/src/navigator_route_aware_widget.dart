import 'package:flutter/material.dart';
import 'route_observer.dart';

class NavigatorRouteAwareWidget extends StatefulWidget {
  final Widget child;
  final VoidCallback? onPageAppearing;
  final VoidCallback? onPageDisappearing;

  const NavigatorRouteAwareWidget({
    super.key,
    required this.child,
    this.onPageAppearing,
    this.onPageDisappearing,
  });

  @override
  State<NavigatorRouteAwareWidget> createState() =>
      _NavigatorRouteAwareWidgetState();
}

class _NavigatorRouteAwareWidgetState extends State<NavigatorRouteAwareWidget>
    with RouteAware {
  ModalRoute<dynamic>? _modalRoute;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _modalRoute = ModalRoute.of(context);
    if (_modalRoute is PageRoute) {
      routeObserver.subscribe(this, _modalRoute as PageRoute);
    }
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  // Called when page appears (on push or after returning from another page)
  @override
  void didPushNext() {
    widget.onPageDisappearing?.call();
  }

  @override
  void didPopNext() {
    widget.onPageAppearing?.call();
  }

  @override
  void didPush() {
    widget.onPageAppearing?.call();
  }

  @override
  void didPop() {
    widget.onPageDisappearing?.call();
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
