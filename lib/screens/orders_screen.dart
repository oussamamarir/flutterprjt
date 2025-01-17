import 'package:flutter/material.dart';

class OrdersScreen extends StatelessWidget {
  final List<Map<String, dynamic>> cart;

  const OrdersScreen({super.key, required this.cart}); // Accept cart as input

  @override
  Widget build(BuildContext context) {
    // Calculate the total price of all items in the cart
    double total = cart.fold(0, (sum, item) => sum + item['price']);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Orders"),
        centerTitle: true,
        backgroundColor: Colors.redAccent,
      ),
      body: cart.isEmpty
          ? const Center(
              child: Text(
                "No orders yet! Start ordering now.",
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            )
          : Column(
              children: [
                // Display the cart items in a list
                Expanded(
                  child: ListView.builder(
                    itemCount: cart.length,
                    itemBuilder: (context, index) {
                      final item = cart[index];
                      return Card(
                        elevation: 3,
                        margin: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 8.0),
                        child: ListTile(
                          leading: ClipRRect(
                            borderRadius: BorderRadius.circular(8.0),
                            child: Image.asset(
                              item['image'],
                              fit: BoxFit.cover,
                              width: 50,
                              height: 50,
                            ),
                          ),
                          title: Text(
                            item['name'],
                            style: const TextStyle(fontSize: 16),
                          ),
                          subtitle: Text(
                            "${item['price'].toStringAsFixed(2)} MAD",
                            style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Colors.redAccent),
                          ),
                          trailing: IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () {
                              // Remove the item from the cart
                              cart.removeAt(index);
                              // Rebuild the UI
                              (context as Element).markNeedsBuild();
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text("${item['name']} removed."),
                                ),
                              );
                            },
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // Display the total and checkout button
                Container(
                  color: Colors.white,
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      const Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "Total:",
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                          Text(
                            "${total.toStringAsFixed(2)} MAD",
                            style: const TextStyle(
                                fontSize: 18, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.redAccent,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        onPressed: () {
                          // Add checkout functionality here
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  "Checkout functionality not implemented yet!"),
                            ),
                          );
                        },
                        child: const Text(
                          "Checkout",
                          style:
                              TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}
