import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/dashboard_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/dish_details_screen.dart';
import 'screens/profile_screen.dart'; // Import ProfileScreen

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
      path: '/cart', // Route for CartScreen
      builder: (context, state) {
        final cart = state.extra as List<Map<String, dynamic>>?;
        return CartScreen(cart: cart ?? []);
      },
    ),
    GoRoute(
      path: '/dishDetails', // Route for DishDetailsScreen
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
        }
        return const ErrorPage(); // Show error page if data is missing
      },
    ),
    GoRoute(
      path: '/profile', // Route for ProfileScreen
      builder: (context, state) =>  ProfileScreen(),
    ),
  ],
);

// Error Page for Invalid Routes
class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Page Not Found"),
        backgroundColor: Colors.redAccent,
      ),
      body: const Center(
        child: Text(
          "404 - Page Not Found",
          style: TextStyle(fontSize: 20, color: Colors.redAccent),
        ),
      ),
    );
  }
}
