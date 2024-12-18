import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // All dishes
    final List<Map<String, String>> dishes = [
      {'name': 'Mac and Cheese', 'price': '12,00 MAD', 'image': 'assets/images/mach.jpg'},
      {'name': 'Classic Burger', 'price': '8,00 MAD', 'image': 'assets/images/burg.jpg'},
      {'name': 'Spaghetti Carbonara', 'price': '15,00 MAD', 'image': 'assets/images/spag.jpg'},
      {'name': 'Sushi Rolls', 'price': '20,00 MAD', 'image': 'assets/images/sushi.jpg'},
      {'name': 'Margherita Pizza', 'price': '10,00 MAD', 'image': 'assets/images/pizza.jpg'},
      {'name': 'Ramen Noodles', 'price': '18,00 MAD', 'image': 'assets/images/ramen.jpg'},
      {'name': 'Soft Tacos', 'price': '7,00 MAD', 'image': 'assets/images/soft.jpg'},
      {'name': 'Grilled Steak', 'price': '25,00 MAD', 'image': 'assets/images/steak.jpg'},
      {'name': 'Couscous', 'price': '40,00 MAD', 'image': 'assets/images/couscous.webp'},
      {'name': 'Chicken Tagine', 'price': '50,00 MAD', 'image': 'assets/images/tajine.jpg'},
      {'name': 'Pastilla', 'price': '45,00 MAD', 'image': 'assets/images/pastille.jpg'},
      {'name': 'Harira Soup', 'price': '25,00 MAD', 'image': 'assets/images/harira.jpg'},
      {'name': 'Briouat', 'price': '30,00 MAD', 'image': 'assets/images/briouat.jpg'},
      {'name': 'Rfissa', 'price': '55,00 MAD', 'image': 'assets/images/rfissa.jpg'},
      {'name': 'Seffa', 'price': '40,00 MAD', 'image': 'assets/images/seffa.jpg'},
      {'name': 'Zaalouk', 'price': '15,00 MAD', 'image': 'assets/images/zaalouk.jpg'},
    ];

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {
            // Add menu functionality here
          },
        ),
        actions: [
          // Navigate to Orders Screen when clicking the cart icon
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
            onPressed: () {
              context.go('/orders'); // Navigate to Orders Screen
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Text
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Delicious\nfood for you",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Search",
                filled: true,
                fillColor: Colors.grey.shade200,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 20),

          // Dishes List
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.8,
              ),
              itemCount: dishes.length,
              itemBuilder: (context, index) {
                return _DishCard(
                  name: dishes[index]['name']!,
                  price: dishes[index]['price']!,
                  image: dishes[index]['image']!,
                );
              },
            ),
          ),
        ],
      ),

      // Bottom Navigation Bar
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Colors.redAccent,
        unselectedItemColor: Colors.grey,
        onTap: (index) {
          if (index == 1) {
            context.go('/orders'); // Navigate to Orders Screen
          }
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: ""),
          BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: ""),
        ],
      ),
    );
  }
}

// Dish Card Widget
class _DishCard extends StatelessWidget {
  final String name;
  final String price;
  final String image;

  const _DishCard({required this.name, required this.price, required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            spreadRadius: 2,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Dish Image
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
              child: Image.asset(
                image,
                fit: BoxFit.cover,
                width: double.infinity,
              ),
            ),
          ),
          const SizedBox(height: 10),

          // Dish Name
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              name,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 5),

          // Dish Price
          Text(
            price,
            style: const TextStyle(
              color: Colors.redAccent,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}
