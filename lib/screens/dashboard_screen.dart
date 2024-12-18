import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'orders_screen.dart';
import 'dish_details_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final List<Map<String, dynamic>> cart = []; // Shared cart state

  // All dishes data
  final List<Map<String, dynamic>> dishes = [
    {'name': 'La baguette raffinée XXL', 'price': 99.0, 'image': 'assets/images/baguette_xxl.jpeg'},
    {'name': 'Frite Raffinée', 'price': 35.0, 'image': 'assets/images/frite_raffinee.jpeg'},
    {'name': 'Croissant Classique', 'price': 15.0, 'image': 'assets/images/croissant.jpeg'},
    {'name': 'Mac and Cheese', 'price': 12.0, 'image': 'assets/images/mach.jpg'},
    {'name': 'Classic Burger', 'price': 8.0, 'image': 'assets/images/burg.jpg'},
    {'name': 'Spaghetti Carbonara', 'price': 15.0, 'image': 'assets/images/spag.jpg'},
    {'name': 'Sushi Rolls', 'price': 20.0, 'image': 'assets/images/sushi.jpg'},
    {'name': 'Margherita Pizza', 'price': 10.0, 'image': 'assets/images/pizza.jpg'},
    {'name': 'Ramen Noodles', 'price': 18.0, 'image': 'assets/images/ramen.jpg'},
    {'name': 'Soft Tacos', 'price': 7.0, 'image': 'assets/images/soft.jpg'},
    {'name': 'Grilled Steak', 'price': 25.0, 'image': 'assets/images/steak.jpg'},
    {'name': 'Couscous', 'price': 40.0, 'image': 'assets/images/couscous.webp'},
    {'name': 'Chicken Tagine', 'price': 50.0, 'image': 'assets/images/tajine.jpg'},
    {'name': 'Pastilla', 'price': 45.0, 'image': 'assets/images/pastille.jpg'},
    {'name': 'Harira Soup', 'price': 25.0, 'image': 'assets/images/harira.jpg'},
    {'name': 'Briouat', 'price': 30.0, 'image': 'assets/images/briouat.jpg'},
    {'name': 'Rfissa', 'price': 55.0, 'image': 'assets/images/rfissa.jpg'},
    {'name': 'Seffa', 'price': 40.0, 'image': 'assets/images/seffa.jpg'},
    {'name': 'Zaalouk', 'price': 15.0, 'image': 'assets/images/zaalouk.jpg'},
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
          .where((dish) =>
          dish['name'].toLowerCase().contains(query.toLowerCase()))
          .toList();
    });
  }

  // Add a dish to the cart
  void addToCart(Map<String, dynamic> dish) {
    setState(() {
      cart.add(dish);
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text("${dish['name']} added to orders!"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.menu, color: Colors.black),
          onPressed: () {},
        ),
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
                    builder: (context) => OrdersScreen(cart: cart),
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

          // Search Bar
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

          // Check if filtered dishes list is empty
          filteredDishes.isEmpty
              ? const Expanded(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search_off, size: 100, color: Colors.grey),
                  SizedBox(height: 10),
                  Text(
                    "Item not found",
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 5),
                  Text(
                    "Try searching the item with\na different keyword.",
                    textAlign: TextAlign.center,
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
          )
              : Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              gridDelegate:
              const SliverGridDelegateWithFixedCrossAxisCount(
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
                          description:
                          "A delicious and savory dish prepared to satisfy your taste buds.",
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
    );
  }
}

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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius:
              const BorderRadius.vertical(top: Radius.circular(16.0)),
              child: Image.asset(image,
                  fit: BoxFit.cover, width: double.infinity),
            ),
          ),
          Text(name,
              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold)),
          Text("${price.toStringAsFixed(2)} MAD",
              style: const TextStyle(color: Colors.redAccent)),
          TextButton(onPressed: onAddToCart, child: const Text("Add to Orders")),
        ],
      ),
    );
  }
}
