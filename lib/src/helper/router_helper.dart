import 'package:flutter/material.dart';
import 'package:route_aware_widget/src/constants/router_type.dart';

class RouterHelper {
  static RouterType detectRouter(BuildContext context) {
    final delegate = Router.of(context).routerDelegate;
    final type = delegate.runtimeType.toString();

    if (type.contains('GoRouterDelegate')) return RouterType.goRouter;
    if (type.contains('RootRouterDelegate') ||
        type.contains('StackRouterDelegate')) {
      return RouterType.autoRoute;
    }
    return RouterType.navigator;
  }
}
