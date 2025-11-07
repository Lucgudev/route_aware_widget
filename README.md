# Route Aware Widget

A Flutter package that makes widgets aware of route navigation changes. Get callbacks when your widget's page appears or disappears - perfect for analytics, video playback control, and lifecycle management.

## Features

- **Multiple Router Support**: Works with Navigator, GoRouter, and AutoRoute
- **Simple API**: Just wrap your widget and provide callbacks
- **Easy Configuration**: Specify your router type once at the app level
- **Lifecycle Callbacks**: `onPageAppear` and `onPageDisappear` events

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

### Step 1: Configure Router Type

Wrap your app with `RouteAwareConfig` and specify which router you're using:

### Navigator Example

```dart
import 'package:flutter/material.dart';
import 'package:route_aware_widget/route_aware_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RouteAwareConfig(
      routerType: RouterType.navigator,
      child: MaterialApp(
        // Important: Add the routeObserver to your MaterialApp
        navigatorObservers: [routeObserver],
        home: FirstPage(),
      ),
    );
  }
}

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('First Page')),
      body: RouteAwareWidget(
        onPageAppear: () => print('First page appeared'),
        onPageDisappear: () => print('First page disappeared'),
        child: Center(
          child: ElevatedButton(
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => SecondPage()),
            ),
            child: Text('Go to Second Page'),
          ),
        ),
      ),
    );
  }
}
```

### GoRouter Example

```dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:route_aware_widget/route_aware_widget.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _router = GoRouter(
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => HomePage(),
      ),
      GoRoute(
        path: '/details',
        builder: (context, state) => DetailsPage(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return RouteAwareConfig(
      routerType: RouterType.goRouter,
      child: MaterialApp.router(
        routerConfig: _router,
      ),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: RouteAwareWidget(
        onPageAppear: () => print('Home page appeared'),
        onPageDisappear: () => print('Home page disappeared'),
        child: Center(
          child: ElevatedButton(
            onPressed: () => context.go('/details'),
            child: Text('Go to Details'),
          ),
        ),
      ),
    );
  }
}
```

### AutoRoute Example

```dart
import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:route_aware_widget/route_aware_widget.dart';

void main() {
  runApp(MyApp());
}

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
    AutoRoute(page: HomeRoute.page, initial: true),
    AutoRoute(page: DetailsRoute.page),
  ];
}

class MyApp extends StatelessWidget {
  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return RouteAwareConfig(
      routerType: RouterType.autoRoute,
      child: MaterialApp.router(
        routerConfig: _appRouter.config(),
      ),
    );
  }
}

@RoutePage()
class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Home')),
      body: RouteAwareWidget(
        onPageAppear: () => print('Home page appeared'),
        onPageDisappear: () => print('Home page disappeared'),
        child: Center(
          child: ElevatedButton(
            onPressed: () => context.router.push(DetailsRoute()),
            child: Text('Go to Details'),
          ),
        ),
      ),
    );
  }
}
```

## Common Use Cases

### Video Player Control

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
      onPageAppear: () => _controller.play(),
      onPageDisappear: () => _controller.pause(),
      child: VideoPlayer(_controller),
    );
  }
}
```

### Analytics Tracking

```dart
class ProductPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return RouteAwareWidget(
      onPageAppear: () {
        analytics.logScreenView(screenName: 'ProductDetails');
      },
      onPageDisappear: () {
        analytics.logEvent(name: 'left_product_details');
      },
      child: ProductDetailsWidget(),
    );
  }
}
```

### Resource Management

```dart
class DashboardPage extends StatefulWidget {
  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  StreamSubscription? subscription;

  @override
  Widget build(BuildContext context) {
    return RouteAwareWidget(
      onPageAppear: () {
        // Start expensive operations
        subscription = streamController.stream.listen(...);
      },
      onPageDisappear: () {
        // Clean up resources
        subscription?.cancel();
      },
      child: DashboardContent(),
    );
  }
}
```

## API Reference

### RouteAwareWidget

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `child` | `Widget` | Yes | The widget to wrap |
| `onPageAppear` | `VoidCallback?` | No | Called when the page becomes visible |
| `onPageDisappear` | `VoidCallback?` | No | Called when the page becomes hidden |

### RouteAwareConfig

| Parameter | Type | Required | Description |
|-----------|------|----------|-------------|
| `routerType` | `RouterType` | Yes | The type of router being used |
| `child` | `Widget` | Yes | The app widget tree |

### RouterType Enum

- `RouterType.navigator` - Standard Flutter Navigator
- `RouterType.goRouter` - GoRouter package
- `RouterType.autoRoute` - AutoRoute package

## Setup Requirements

### For Navigator

You **MUST** add the `routeObserver` to your `MaterialApp`:

```dart
RouteAwareConfig(
  routerType: RouterType.navigator,
  child: MaterialApp(
    navigatorObservers: [routeObserver],  // Required!
    home: HomePage(),
  ),
)
```

### For GoRouter

Wrap your app with `RouteAwareConfig`:

```dart
RouteAwareConfig(
  routerType: RouterType.goRouter,
  child: MaterialApp.router(
    routerConfig: router,
  ),
)
```

### For AutoRoute

Wrap your app with `RouteAwareConfig`:

```dart
RouteAwareConfig(
  routerType: RouterType.autoRoute,
  child: MaterialApp.router(
    routerConfig: appRouter.config(),
  ),
)
```

## How It Works

1. **Router Type Configuration**: You specify which router you're using via `RouteAwareConfig`
2. **Router-Specific Implementation**: The widget uses the appropriate implementation for your router
3. **Lifecycle Callbacks**: Each implementation uses the router's native mechanisms to detect route changes and trigger callbacks

## Troubleshooting

### Callbacks not firing with Navigator

Make sure you've:
1. Wrapped your app with `RouteAwareConfig(routerType: RouterType.navigator, ...)`
2. Added `routeObserver` to `navigatorObservers`:

```dart
MaterialApp(
  navigatorObservers: [routeObserver],
  // ...
)
```

### Callbacks not firing with GoRouter

Make sure you've wrapped your app with `RouteAwareConfig(routerType: RouterType.goRouter, ...)`. The widget uses location-based detection, so ensure your routes have unique paths.

### Callbacks not firing with AutoRoute

Make sure you've wrapped your app with `RouteAwareConfig(routerType: RouterType.autoRoute, ...)`.

## Contributing

Contributions are welcome! Please feel free to submit a Pull Request.

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Support

For issues and feature requests, please file an issue on the [GitHub repository](https://github.com/yourusername/route_aware_widget/issues).
