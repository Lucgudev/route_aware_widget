import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:route_aware_widget/route_aware_widget.dart';

/// Example demonstrating RouteAwareWidget with AutoRoute
///
/// This example shows:
/// - AutoRoute setup with @AutoRouterConfig and @RoutePage annotations
/// - Automatic router detection (no manual configuration needed)
/// - Page appear/disappear callbacks with AutoRoute navigation
/// - Nested navigation and route parameters
///
/// Note: To run this example, you need to:
/// 1. Add auto_route and auto_route_generator to pubspec.yaml
/// 2. Run: flutter pub run build_runner build
///    This generates the router configuration code

void main() {
  runApp(AutoRouteExampleApp());
}

class AutoRouteExampleApp extends StatelessWidget {
  AutoRouteExampleApp({super.key});

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'AutoRoute Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
        useMaterial3: true,
      ),
      routerConfig: _appRouter.config(),
    );
  }
}

// AutoRoute Configuration
@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(page: HomeRoute.page, initial: true),
        AutoRoute(page: DashboardRoute.page),
        AutoRoute(page: ProfileRoute.page),
        AutoRoute(page: ArticleRoute.page),
        AutoRoute(page: AboutRoute.page),
      ];
}

// Home Page
@RoutePage()
class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home - AutoRoute'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: RouteAwareWidget(
        onPageAppear: () {
          debugPrint('⚡ [AutoRoute] Home page appeared');
        },
        onPageDisappear: () {
          debugPrint('⚡ [AutoRoute] Home page disappeared');
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.home, size: 64, color: Colors.teal),
              const SizedBox(height: 24),
              const Text(
                'AutoRoute Example',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Auto-detection enabled',
                style: TextStyle(color: Colors.grey, fontSize: 12),
              ),
              const SizedBox(height: 32),
              Wrap(
                spacing: 12,
                runSpacing: 12,
                alignment: WrapAlignment.center,
                children: [
                  ElevatedButton.icon(
                    onPressed: () => context.router.push(const DashboardRoute()),
                    icon: const Icon(Icons.dashboard),
                    label: const Text('Dashboard'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => context.router.push(const ProfileRoute()),
                    icon: const Icon(Icons.person),
                    label: const Text('Profile'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => context.router.push(const AboutRoute()),
                    icon: const Icon(Icons.info),
                    label: const Text('About'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Dashboard Page
@RoutePage()
class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  static const articles = [
    {'id': 1, 'title': 'Getting Started with Flutter', 'icon': Icons.article},
    {'id': 2, 'title': 'State Management Guide', 'icon': Icons.store},
    {'id': 3, 'title': 'Navigation Best Practices', 'icon': Icons.navigation},
    {'id': 4, 'title': 'Performance Optimization', 'icon': Icons.speed},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Dashboard'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: RouteAwareWidget(
        onPageAppear: () {
          debugPrint('⚡ [AutoRoute] Dashboard page appeared');
          // Example: Refresh dashboard data
        },
        onPageDisappear: () {
          debugPrint('⚡ [AutoRoute] Dashboard page disappeared');
        },
        child: ListView.builder(
          padding: const EdgeInsets.all(16),
          itemCount: articles.length,
          itemBuilder: (context, index) {
            final article = articles[index];
            return Card(
              margin: const EdgeInsets.only(bottom: 12),
              child: ListTile(
                leading: Icon(
                  article['icon'] as IconData,
                  color: Colors.teal,
                  size: 32,
                ),
                title: Text(article['title'] as String),
                subtitle: Text('Article ${article['id']}'),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  context.router.push(
                    ArticleRoute(articleId: article['id'] as int),
                  );
                },
              ),
            );
          },
        ),
      ),
    );
  }
}

// Article Detail Page with route parameter
@RoutePage()
class ArticlePage extends StatelessWidget {
  final int articleId;

  const ArticlePage({
    super.key,
    @PathParam('id') required this.articleId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Article $articleId'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: RouteAwareWidget(
        onPageAppear: () {
          debugPrint('⚡ [AutoRoute] Article $articleId page appeared');
          // Example: Track article view
          // Analytics.logEvent('view_article', {'article_id': articleId});
        },
        onPageDisappear: () {
          debugPrint('⚡ [AutoRoute] Article $articleId page disappeared');
        },
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Icon(
                  Icons.article,
                  size: 80,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                'Article $articleId',
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Published on ${DateTime.now().toString().substring(0, 10)}',
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Lorem ipsum dolor sit amet, consectetur adipiscing elit. '
                'Sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. '
                'Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris '
                'nisi ut aliquip ex ea commodo consequat.\n\n'
                'Duis aute irure dolor in reprehenderit in voluptate velit esse '
                'cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat '
                'cupidatat non proident, sunt in culpa qui officia deserunt mollit '
                'anim id est laborum.',
                style: TextStyle(fontSize: 16, height: 1.6),
              ),
              const SizedBox(height: 32),
              Center(
                child: ElevatedButton.icon(
                  onPressed: () => context.router.maybePop(),
                  icon: const Icon(Icons.arrow_back),
                  label: const Text('Back to Dashboard'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Profile Page
@RoutePage()
class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  String _userName = 'John Doe';
  String _email = 'john.doe@example.com';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: RouteAwareWidget(
        onPageAppear: () {
          debugPrint('⚡ [AutoRoute] Profile page appeared');
          // Example: Load user profile data
        },
        onPageDisappear: () {
          debugPrint('⚡ [AutoRoute] Profile page disappeared');
          // Example: Save any pending changes
        },
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundColor: Colors.teal,
                child: Icon(Icons.person, size: 50, color: Colors.white),
              ),
            ),
            const SizedBox(height: 24),
            Text(
              _userName,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              _email,
              style: const TextStyle(color: Colors.grey, fontSize: 16),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            Card(
              child: Column(
                children: [
                  ListTile(
                    leading: const Icon(Icons.email),
                    title: const Text('Email'),
                    subtitle: Text(_email),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.phone),
                    title: const Text('Phone'),
                    subtitle: const Text('+1 234 567 8900'),
                  ),
                  const Divider(),
                  ListTile(
                    leading: const Icon(Icons.location_on),
                    title: const Text('Location'),
                    subtitle: const Text('San Francisco, CA'),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: () {
                // Edit profile
              },
              icon: const Icon(Icons.edit),
              label: const Text('Edit Profile'),
            ),
          ],
        ),
      ),
    );
  }
}

// About Page
@RoutePage()
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('About'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: RouteAwareWidget(
        onPageAppear: () {
          debugPrint('⚡ [AutoRoute] About page appeared');
        },
        onPageDisappear: () {
          debugPrint('⚡ [AutoRoute] About page disappeared');
        },
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const Icon(Icons.info, size: 80, color: Colors.teal),
            const SizedBox(height: 24),
            const Text(
              'AutoRoute Example App',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            const Text(
              'Version 1.0.0',
              style: TextStyle(color: Colors.grey),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'About this app',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text(
                      'This example demonstrates the RouteAwareWidget package '
                      'with AutoRoute. The widget automatically detects AutoRoute '
                      'and provides page lifecycle callbacks.',
                      style: TextStyle(height: 1.6),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            const Card(
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Features',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 12),
                    Text('• Automatic router detection'),
                    Text('• Page appear/disappear callbacks'),
                    Text('• Support for route parameters'),
                    Text('• No additional configuration needed'),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 32),
            ElevatedButton.icon(
              onPressed: () => context.router.maybePop(),
              icon: const Icon(Icons.arrow_back),
              label: const Text('Back'),
            ),
          ],
        ),
      ),
    );
  }
}
