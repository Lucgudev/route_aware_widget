import 'package:flutter/material.dart';
import 'package:route_aware_widget/route_aware_widget.dart';

/// Example using RouteAwareWidget with standard Navigator
///
/// This is the most common use case and works with MaterialPageRoute,
/// CupertinoPageRoute, and any other ModalRoute-based navigation.
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Create a RouteObserver instance
    final routeObserver = RouteObserver<ModalRoute<dynamic>>();

    return RouteObserverProvider(
      routeObserver: routeObserver,
      child: MaterialApp(
        title: 'RouteAwareWidget Example',
        // Pass the observer to navigatorObservers
        navigatorObservers: [routeObserver],
        home: const HomePage(),
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home Page')),
      body: Center(
        child: RouteAwareWidget(
          onPageAppear: () {
            print('Home Page appeared');
            // You can trigger analytics, refresh data, resume video, etc.
          },
          onPageDisappear: () {
            print('Home Page disappeared');
            // You can pause video, save state, etc.
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Home Page with Route Awareness'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const DetailPage(),
                    ),
                  );
                },
                child: const Text('Go to Detail Page'),
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
      appBar: AppBar(title: const Text('Detail Page')),
      body: Center(
        child: RouteAwareWidget(
          onPageAppear: () {
            print('Detail Page appeared');
          },
          onPageDisappear: () {
            print('Detail Page disappeared');
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Detail Page with Route Awareness'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Go Back'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ThirdPage(),
                    ),
                  );
                },
                child: const Text('Go to Third Page'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ThirdPage extends StatelessWidget {
  const ThirdPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Third Page')),
      body: Center(
        child: RouteAwareWidget(
          onPageAppear: () {
            print('Third Page appeared');
          },
          onPageDisappear: () {
            print('Third Page disappeared');
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Third Page with Route Awareness'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Go Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
