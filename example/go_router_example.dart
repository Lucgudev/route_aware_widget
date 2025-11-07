import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:route_aware_widget/route_aware_widget.dart';

/// Example demonstrating RouteAwareWidget with GoRouter
///
/// This example shows:
/// - GoRouter setup with multiple routes
/// - Automatic router detection (no manual configuration needed)
/// - Page appear/disappear callbacks with GoRouter navigation
/// - Path parameters and navigation patterns

void main() {
  runApp(GoRouterExampleApp());
}

class GoRouterExampleApp extends StatelessWidget {
  GoRouterExampleApp({super.key});

  final GoRouter _router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
        path: '/',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/products',
        builder: (context, state) => const ProductsPage(),
      ),
      GoRoute(
        path: '/products/:id',
        builder: (context, state) {
          final id = state.pathParameters['id'] ?? '0';
          return ProductDetailPage(productId: id);
        },
      ),
      GoRoute(
        path: '/cart',
        builder: (context, state) => const CartPage(),
      ),
      GoRoute(
        path: '/settings',
        builder: (context, state) => const SettingsPage(),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'GoRouter Example',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      routerConfig: _router,
    );
  }
}

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home - GoRouter'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: RouteAwareWidget(
        onPageAppear: () {
          debugPrint('🚀 [GoRouter] Home page appeared');
        },
        onPageDisappear: () {
          debugPrint('🚀 [GoRouter] Home page disappeared');
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.home, size: 64, color: Colors.deepPurple),
              const SizedBox(height: 24),
              const Text(
                'GoRouter Example',
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
                    onPressed: () => context.go('/products'),
                    icon: const Icon(Icons.shopping_bag),
                    label: const Text('Products'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => context.go('/cart'),
                    icon: const Icon(Icons.shopping_cart),
                    label: const Text('Cart'),
                  ),
                  ElevatedButton.icon(
                    onPressed: () => context.go('/settings'),
                    icon: const Icon(Icons.settings),
                    label: const Text('Settings'),
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

class ProductsPage extends StatelessWidget {
  const ProductsPage({super.key});

  static const products = [
    {'id': '1', 'name': 'Product A', 'icon': Icons.laptop},
    {'id': '2', 'name': 'Product B', 'icon': Icons.phone_android},
    {'id': '3', 'name': 'Product C', 'icon': Icons.watch},
    {'id': '4', 'name': 'Product D', 'icon': Icons.headphones},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Products'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: RouteAwareWidget(
        onPageAppear: () {
          debugPrint('🚀 [GoRouter] Products page appeared');
          // Example: Refresh product list
        },
        onPageDisappear: () {
          debugPrint('🚀 [GoRouter] Products page disappeared');
        },
        child: GridView.builder(
          padding: const EdgeInsets.all(16),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 16,
            mainAxisSpacing: 16,
            childAspectRatio: 1,
          ),
          itemCount: products.length,
          itemBuilder: (context, index) {
            final product = products[index];
            return Card(
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                onTap: () => context.go('/products/${product['id']}'),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      product['icon'] as IconData,
                      size: 48,
                      color: Colors.deepPurple,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      product['name'] as String,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => context.go('/cart'),
        child: const Icon(Icons.shopping_cart),
      ),
    );
  }
}

class ProductDetailPage extends StatelessWidget {
  final String productId;

  const ProductDetailPage({
    super.key,
    required this.productId,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Product $productId'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/products'),
        ),
      ),
      body: RouteAwareWidget(
        onPageAppear: () {
          debugPrint('🚀 [GoRouter] Product $productId detail appeared');
          // Example: Track product view
          // Analytics.logEvent('view_product', {'product_id': productId});
        },
        onPageDisappear: () {
          debugPrint('🚀 [GoRouter] Product $productId detail disappeared');
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shopping_bag, size: 80, color: Colors.deepPurple),
              const SizedBox(height: 24),
              Text(
                'Product $productId Details',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 32),
                child: Text(
                  'This is a detailed view of the product. The route contains a path parameter.',
                  textAlign: TextAlign.center,
                  style: TextStyle(color: Colors.grey),
                ),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => context.go('/cart'),
                icon: const Icon(Icons.add_shopping_cart),
                label: const Text('Add to Cart'),
              ),
              const SizedBox(height: 12),
              TextButton(
                onPressed: () => context.go('/products'),
                child: const Text('Back to Products'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  int _itemCount = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shopping Cart'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: RouteAwareWidget(
        onPageAppear: () {
          debugPrint('🚀 [GoRouter] Cart page appeared');
          // Example: Refresh cart items
          setState(() {
            _itemCount = 3; // Simulated cart items
          });
        },
        onPageDisappear: () {
          debugPrint('🚀 [GoRouter] Cart page disappeared');
          // Example: Save cart state
        },
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.shopping_cart, size: 64, color: Colors.green),
              const SizedBox(height: 24),
              const Text(
                'Shopping Cart',
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                '$_itemCount items in cart',
                style: const TextStyle(fontSize: 18, color: Colors.grey),
              ),
              const SizedBox(height: 32),
              ElevatedButton.icon(
                onPressed: () => context.go('/products'),
                icon: const Icon(Icons.shopping_bag),
                label: const Text('Continue Shopping'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool _notificationsEnabled = true;
  String _language = 'English';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.go('/'),
        ),
      ),
      body: RouteAwareWidget(
        onPageAppear: () {
          debugPrint('🚀 [GoRouter] Settings page appeared');
          // Example: Load settings from storage
        },
        onPageDisappear: () {
          debugPrint('🚀 [GoRouter] Settings page disappeared');
          // Example: Save settings to storage
        },
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            const Icon(Icons.settings, size: 64, color: Colors.orange),
            const SizedBox(height: 24),
            const Text(
              'App Settings',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            SwitchListTile(
              title: const Text('Push Notifications'),
              subtitle: const Text('Receive notifications'),
              value: _notificationsEnabled,
              onChanged: (value) {
                setState(() {
                  _notificationsEnabled = value;
                });
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Language'),
              subtitle: Text(_language),
              trailing: const Icon(Icons.arrow_forward_ios, size: 16),
              onTap: () {
                // Show language picker
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('About'),
              trailing: const Icon(Icons.info_outline),
              onTap: () {
                showAboutDialog(
                  context: context,
                  applicationName: 'GoRouter Example',
                  applicationVersion: '1.0.0',
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
