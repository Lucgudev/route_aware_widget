/// Example using RouteAwareWidget with AutoRoute
///
/// NOTE: This example requires auto_route package.
/// Add to your pubspec.yaml:
/// dependencies:
///   auto_route: ^latest_version
///   route_aware_widget: ^latest_version
///
/// AutoRoute works with Flutter's standard RouteObserver,
/// so you can use RouteAwareWidget directly without custom observers.
///
/// Here's how to set it up:

/*
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:route_aware_widget/route_aware_widget.dart';

// 1. Define your routes
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: HomeRoute.page, initial: true),
        AutoRoute(page: DetailRoute.page),
      ];
}

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _appRouter = AppRouter();
  final _routeObserver = RouteObserver<ModalRoute<dynamic>>();

  MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return RouteObserverProvider(
      routeObserver: _routeObserver,
      child: MaterialApp.router(
        routerConfig: _appRouter.config(
          // 2. Add RouteObserver to AutoRoute
          navigatorObservers: () => [_routeObserver],
        ),
      ),
    );
  }
}

// 3. Use RouteAwareWidget in your pages
@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: RouteAwareWidget(
        onPageAppear: () => print('Home page appeared'),
        onPageDisappear: () => print('Home page disappeared'),
        child: Center(
          child: ElevatedButton(
            onPressed: () => context.router.push(const DetailRoute()),
            child: const Text('Go to Detail'),
          ),
        ),
      ),
    );
  }
}

@RoutePage()
class DetailPage extends StatelessWidget {
  const DetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail')),
      body: RouteAwareWidget(
        onPageAppear: () => print('Detail page appeared'),
        onPageDisappear: () => print('Detail page disappeared'),
        child: Center(
          child: ElevatedButton(
            onPressed: () => context.router.pop(),
            child: const Text('Go Back'),
          ),
        ),
      ),
    );
  }
}

// 4. For TabsRouter (bottom navigation)
@RoutePage()
class MainPage extends StatelessWidget {
  const MainPage({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: const [
        Tab1Route(),
        Tab2Route(),
        Tab3Route(),
      ],
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);
        return Scaffold(
          body: child,
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: tabsRouter.activeIndex,
            onTap: tabsRouter.setActiveIndex,
            items: const [
              BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Tab 1'),
              BottomNavigationBarItem(icon: Icon(Icons.search), label: 'Tab 2'),
              BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Tab 3'),
            ],
          ),
        );
      },
    );
  }
}

@RoutePage()
class Tab1Page extends StatelessWidget {
  const Tab1Page({super.key});

  @override
  Widget build(BuildContext context) {
    return RouteAwareWidget(
      onPageAppear: () => print('Tab 1 appeared'),
      onPageDisappear: () => print('Tab 1 disappeared'),
      child: const Center(child: Text('Tab 1 Content')),
    );
  }
}

@RoutePage()
class Tab2Page extends StatelessWidget {
  const Tab2Page({super.key});

  @override
  Widget build(BuildContext context) {
    return RouteAwareWidget(
      onPageAppear: () => print('Tab 2 appeared'),
      onPageDisappear: () => print('Tab 2 disappeared'),
      child: const Center(child: Text('Tab 2 Content')),
    );
  }
}

@RoutePage()
class Tab3Page extends StatelessWidget {
  const Tab3Page({super.key});

  @override
  Widget build(BuildContext context) {
    return RouteAwareWidget(
      onPageAppear: () => print('Tab 3 appeared'),
      onPageDisappear: () => print('Tab 3 disappeared'),
      child: const Center(child: Text('Tab 3 Content')),
    );
  }
}
*/
