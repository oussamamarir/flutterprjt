import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'cart_screen.dart';
import 'dish_details_screen.dart';
import 'profile_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<Map<String, dynamic>> cart = []; // Shared cart state

  // All dishes data
  final List<Map<String, dynamic>> dishes = [
    {'id': 1, 'name': 'La baguette raffinée XXL', 'price': 99.0, 'image': 'assets/images/baguette_xxl.jpeg'},
    {'id': 2, 'name': 'Frite Raffinée', 'price': 35.0, 'image': 'assets/images/frite_raffinee.jpeg'},
    {'id': 3, 'name': 'Croissant Classique', 'price': 15.0, 'image': 'assets/images/croissant.jpeg'},
    {'id': 4, 'name': 'Mac and Cheese', 'price': 12.0, 'image': 'assets/images/mach.jpg'},
    {'id': 5, 'name': 'Classic Burger', 'price': 8.0, 'image': 'assets/images/burg.jpg'},
    {'id': 6, 'name': 'Spaghetti Carbonara', 'price': 15.0, 'image': 'assets/images/spag.jpg'},
    {'id': 7, 'name': 'Sushi Rolls', 'price': 20.0, 'image': 'assets/images/sushi.jpg'},
    {'id': 8, 'name': 'Margherita Pizza', 'price': 10.0, 'image': 'assets/images/pizza.jpg'},
    {'id': 9, 'name': 'Ramen Noodles', 'price': 18.0, 'image': 'assets/images/ramen.jpg'},
    {'id': 10, 'name': 'Soft Tacos', 'price': 7.0, 'image': 'assets/images/soft.jpg'},
  ];

  List<Map<String, dynamic>> filteredDishes = []; // Filtered list for search
  final TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    filteredDishes = dishes; // Initialize filtered list with all dishes
  }

  // Search function
  void searchDishes(String query) {
    setState(() {
      filteredDishes = dishes
          .where((dish) => dish['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  // Add a dish to the cart
  void addToCart(Map<String, dynamic> dish) {
    setState(() {
      cart.add(dish); // Add to cart and refresh state
    });

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("${dish['name']} added to cart!")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        actions: [
          badges.Badge(
            position: badges.BadgePosition.topEnd(top: 0, end: 3),
            showBadge: cart.isNotEmpty,
            badgeContent: Text(
              cart.length.toString(),
              style: const TextStyle(color: Colors.white, fontSize: 12),
            ),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart_outlined, color: Colors.black),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => CartScreen(cart: cart),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              "Delicious\nfood for you",
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: TextField(
              controller: searchController,
              onChanged: searchDishes,
              decoration: InputDecoration(
                hintText: "Search for dishes...",
                prefixIcon: const Icon(Icons.search, color: Colors.grey),
                filled: true,
                fillColor: Colors.grey[200],
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          filteredDishes.isEmpty
              ? const Expanded(
            child: Center(
              child: Text("No dishes found"),
            ),
          )
              : Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.75,
              ),
              itemCount: filteredDishes.length,
              itemBuilder: (context, index) {
                final dish = filteredDishes[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => DishDetailsScreen(
                          name: dish['name'],
                          price: dish['price'],
                          image: dish['image'],
                          description: "Savory and delicious!",
                          onAddToCart: () => addToCart(dish),
                        ),
                      ),
                    );
                  },
                  child: _DishCard(
                    name: dish['name'],
                    price: dish['price'],
                    image: dish['image'],
                    onAddToCart: () => addToCart(dish),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile',
          ),
        ],
        currentIndex: 0, // Default to Home tab
        onTap: (index) {
          if (index == 1) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>  ProfileScreen()),
            );
          }
        },
      ),
    );
  }
}

// Dish Card Widget
class _DishCard extends StatelessWidget {
  final String name;
  final double price;
  final String image;
  final VoidCallback onAddToCart;

  const _DishCard({
    required this.name,
    required this.price,
    required this.image,
    required this.onAddToCart,
  });

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
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
              child: Image.asset(image, fit: BoxFit.cover, width: double.infinity),
            ),
          ),
          Text(name, style: const TextStyle(fontWeight: FontWeight.bold)),
          Text("${price.toStringAsFixed(2)} MAD", style: const TextStyle(color: Colors.redAccent)),
          TextButton(onPressed: onAddToCart, child: const Text("Add to Cart")),
        ],
      ),
    );
  }
}
