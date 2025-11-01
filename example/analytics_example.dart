import 'package:flutter/material.dart';
import 'package:route_aware_widget/route_aware_widget.dart';

/// Example: Track page views for analytics
///
/// This demonstrates using RouteAwareWidget to automatically
/// track when users view different screens.
void main() {
  runApp(const AnalyticsApp());
}

class AnalyticsService {
  static final AnalyticsService instance = AnalyticsService._();
  AnalyticsService._();

  void logPageView(String pageName) {
    final timestamp = DateTime.now().toIso8601String();
    print('📊 Analytics: Page view - $pageName at $timestamp');
    // In real app, send to Firebase Analytics, Mixpanel, etc.
  }

  void logPageExit(String pageName) {
    final timestamp = DateTime.now().toIso8601String();
    print('📊 Analytics: Page exit - $pageName at $timestamp');
    // Track time spent on page, etc.
  }
}

class AnalyticsApp extends StatelessWidget {
  const AnalyticsApp({super.key});

  @override
  Widget build(BuildContext context) {
    final routeObserver = RouteObserver<ModalRoute<dynamic>>();

    return RouteObserverProvider(
      routeObserver: routeObserver,
      child: MaterialApp(
        title: 'Analytics Example',
        navigatorObservers: [routeObserver],
        home: const AnalyticsHomePage(),
      ),
    );
  }
}

class AnalyticsHomePage extends StatelessWidget {
  const AnalyticsHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home - Analytics Example')),
      body: RouteAwareWidget(
        onPageAppear: () {
          AnalyticsService.instance.logPageView('home_page');
        },
        onPageDisappear: () {
          AnalyticsService.instance.logPageExit('home_page');
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Home Page'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const ProductPage(),
                    ),
                  );
                },
                child: const Text('View Products'),
              ),
              const SizedBox(height: 20),
              const Text(
                'Check console for analytics events',
                style: TextStyle(fontSize: 12, fontStyle: FontStyle.italic),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProductPage extends StatelessWidget {
  const ProductPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Products')),
      body: RouteAwareWidget(
        onPageAppear: () {
          AnalyticsService.instance.logPageView('product_page');
        },
        onPageDisappear: () {
          AnalyticsService.instance.logPageExit('product_page');
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Product Page'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const CheckoutPage(),
                    ),
                  );
                },
                child: const Text('Go to Checkout'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CheckoutPage extends StatelessWidget {
  const CheckoutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: RouteAwareWidget(
        onPageAppear: () {
          AnalyticsService.instance.logPageView('checkout_page');
        },
        onPageDisappear: () {
          AnalyticsService.instance.logPageExit('checkout_page');
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Checkout Page'),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Back'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
