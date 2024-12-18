import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/orders_screen.dart';
import 'screens/dish_details_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
    );
  }
}

// GoRouter Configuration
final GoRouter _router = GoRouter(
  initialLocation: '/welcome',
  errorBuilder: (context, state) => const ErrorPage(), // Fallback for unknown routes
  routes: [
    GoRoute(
      path: '/welcome',
      builder: (context, state) => const WelcomeScreen(),
    ),
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginScreen(),
    ),
    GoRoute(
      path: '/dashboard',
      builder: (context, state) => const DashboardScreen(),
    ),
    GoRoute(
      path: '/orders',
      builder: (context, state) {
        final cart = state.extra as List<Map<String, dynamic>>?;
        return OrdersScreen(cart: cart ?? []);
      },
    ),
    GoRoute(
      path: '/dishDetails',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        if (extra != null) {
          return DishDetailsScreen(
            name: extra['name'],
            price: extra['price'],
            image: extra['image'],
            description: extra['description'],
            onAddToCart: extra['onAddToCart'],
          );
        } else {
          return const ErrorPage(); // Fallback if no data is passed
        }
      },
    ),
  ],
);

// Error Page for Invalid Routes
class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Page Not Found")),
      body: const Center(
        child: Text(
          "404 - Page Not Found",
          style: TextStyle(fontSize: 18, color: Colors.redAccent),
        ),
      ),
    );
  }
}
