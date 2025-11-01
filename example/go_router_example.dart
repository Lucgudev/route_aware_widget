/// Example using RouteAwareWidget with GoRouter
///
/// NOTE: This example requires go_router package.
/// Add to your pubspec.yaml:
/// dependencies:
///   go_router: ^latest_version
///   route_aware_widget: ^latest_version
///
/// GoRouter also works with Flutter's standard RouteObserver pattern.

/*
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:route_aware_widget/route_aware_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final routeObserver = RouteObserver<ModalRoute<dynamic>>();

    final router = GoRouter(
      // Add RouteObserver to GoRouter
      observers: [routeObserver],
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomePage(),
        ),
        GoRoute(
          path: '/detail',
          builder: (context, state) => const DetailPage(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsPage(),
        ),
      ],
    );

    return RouteObserverProvider(
      routeObserver: routeObserver,
      child: MaterialApp.router(
        routerConfig: router,
        title: 'GoRouter Example',
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home - GoRouter')),
      body: RouteAwareWidget(
        onPageAppear: () => print('Home page appeared'),
        onPageDisappear: () => print('Home page disappeared'),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Home Page'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => context.go('/detail'),
                child: const Text('Go to Detail'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Detail Page'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => context.go('/settings'),
                child: const Text('Go to Settings'),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () => context.pop(),
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: RouteAwareWidget(
        onPageAppear: () => print('Settings page appeared'),
        onPageDisappear: () => print('Settings page disappeared'),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Settings Page'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => context.go('/'),
                child: const Text('Go Home'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
*/
