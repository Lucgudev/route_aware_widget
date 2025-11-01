# RouteAwareWidget

A Flutter package that makes widgets aware of route navigation changes. Get callbacks when your widget's page appears or disappears, perfect for analytics tracking, video player controls, data refreshing, and more.

## Features

- 🎯 **Universal Compatibility**: Works with all major Flutter navigation systems
  - Standard Navigator (MaterialPageRoute, CupertinoPageRoute)
  - AutoRoute
  - GoRouter
  - Navigator 2.0
- 🪶 **Lightweight**: Minimal overhead, uses Flutter's built-in RouteObserver
- 🔌 **Easy Integration**: Drop-in widget wrapper with two simple callbacks
- 🎨 **Flexible**: Supports custom navigation systems via observer pattern
- 📱 **Production Ready**: Based on Flutter's standard RouteAware mixin

## Installation

Add this to your package's `pubspec.yaml` file:

```yaml
dependencies:
  route_aware_widget: ^0.0.1
```

Then run:

```bash
flutter pub get
```

## Usage

### Basic Setup (Standard Navigator)

1. Create a `RouteObserver` and add it to your app:

```dart
import 'package:flutter/material.dart';
import 'package:route_aware_widget/route_aware_widget.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final routeObserver = RouteObserver<ModalRoute<dynamic>>();

    return RouteObserverProvider(
      routeObserver: routeObserver,
      child: MaterialApp(
        navigatorObservers: [routeObserver],
        home: const HomePage(),
      ),
    );
  }
}
```

2. Wrap your widgets with `RouteAwareWidget`:

```dart
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Home')),
      body: RouteAwareWidget(
        onPageAppear: () {
          print('Page appeared!');
          // Trigger analytics, resume video, refresh data, etc.
        },
        onPageDisappear: () {
          print('Page disappeared!');
          // Pause video, save state, etc.
        },
        child: YourWidget(),
      ),
    );
  }
}
```

### Usage with AutoRoute

AutoRoute works seamlessly with Flutter's RouteObserver:

```dart
import 'package:auto_route/auto_route.dart';
import 'package:route_aware_widget/route_aware_widget.dart';

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
          navigatorObservers: () => [_routeObserver],
        ),
      ),
    );
  }
}

@RoutePage()
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RouteAwareWidget(
      onPageAppear: () => print('Home appeared'),
      onPageDisappear: () => print('Home disappeared'),
      child: YourWidget(),
    );
  }
}
```

### Usage with GoRouter

GoRouter also supports RouteObserver:

```dart
import 'package:go_router/go_router.dart';
import 'package:route_aware_widget/route_aware_widget.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final routeObserver = RouteObserver<ModalRoute<dynamic>>();

    final router = GoRouter(
      observers: [routeObserver],
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const HomePage(),
        ),
      ],
    );

    return RouteObserverProvider(
      routeObserver: routeObserver,
      child: MaterialApp.router(
        routerConfig: router,
      ),
    );
  }
}
```

## Real-World Examples

### 1. Video Player Auto-Pause

```dart
class VideoPlayerPage extends StatefulWidget {
  @override
  State<VideoPlayerPage> createState() => _VideoPlayerPageState();
}

class _VideoPlayerPageState extends State<VideoPlayerPage> {
  late VideoPlayerController _controller;

  @override
  Widget build(BuildContext context) {
    return RouteAwareWidget(
      onPageAppear: () {
        // Resume video when returning to this page
        _controller.play();
      },
      onPageDisappear: () {
        // Pause video when navigating away
        _controller.pause();
      },
      child: VideoPlayer(_controller),
    );
  }
}
```

### 2. Analytics Tracking

```dart
class ProductPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RouteAwareWidget(
      onPageAppear: () {
        // Track page view
        Analytics.logEvent('page_view', {'page': 'product'});
      },
      onPageDisappear: () {
        // Track page exit
        Analytics.logEvent('page_exit', {'page': 'product'});
      },
      child: ProductList(),
    );
  }
}
```

### 3. Data Refresh

```dart
class DashboardPage extends StatefulWidget {
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  Future<void> _refreshData() async {
    // Fetch latest data
  }

  @override
  Widget build(BuildContext context) {
    return RouteAwareWidget(
      onPageAppear: () {
        // Refresh data when page becomes visible
        _refreshData();
      },
      child: DashboardContent(),
    );
  }
}
```

## API Reference

### RouteAwareWidget

The main widget that provides route awareness.

#### Parameters

- `child` (required): The widget to display
- `onPageAppear`: Callback when the route becomes visible
  - Called when route is pushed
  - Called when a covering route is popped
- `onPageDisappear`: Callback when the route becomes hidden
  - Called when a new route is pushed on top
  - Called when this route is popped
- `routeObserver`: Optional RouteObserver (if not using RouteObserverProvider)
- `customObserver`: Optional custom observer for non-standard navigation

### RouteObserverProvider

InheritedWidget that provides RouteObserver to the widget tree.

#### Parameters

- `routeObserver` (required): The RouteObserver instance
- `child` (required): The child widget

## How It Works

`RouteAwareWidget` uses Flutter's built-in `RouteAware` mixin and `RouteObserver` class. This is the same mechanism Flutter uses internally for route awareness.

When wrapped in a `RouteAwareWidget`:
1. The widget subscribes to route changes via `RouteObserver`
2. When route visibility changes, RouteAware callbacks are triggered
3. Your `onPageAppear` and `onPageDisappear` callbacks are invoked
4. Cleanup happens automatically when the widget is disposed

## Differences from VisibilityDetector

| Feature | RouteAwareWidget | VisibilityDetector |
|---------|------------------|-------------------|
| Trigger | Route navigation | Widget visibility in viewport |
| Performance | Lightweight | Can be expensive for many widgets |
| Use Case | Page-level events | Scroll-based visibility |
| Accuracy | Route changes only | Pixel-perfect visibility |

Use `RouteAwareWidget` for page-level events (analytics, video control, etc.) and `VisibilityDetector` for scroll-based visibility (lazy loading, impression tracking).

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

If you find this package helpful, please give it a star on GitHub!

For issues and feature requests, please visit the issue tracker.
