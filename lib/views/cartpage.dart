import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yours_gadget_latest/providers/cart_state.dart';
import 'checkoutpage.dart'; // Importing the CheckoutPage

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  @override
  Widget build(BuildContext context) {
    final cartState = Provider.of<CartState>(context); // Access the CartState
    final cartItems = cartState.cartItems; // Get the list of cart items

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120), // Adjust header height
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          flexibleSpace: Container(
            height: 140, // Adjust header height
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Image.asset(
                'images/logo.png', // Your app logo image
                height: 110, // Adjust logo size here
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          // "YOUR CART" Title
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16.0),
            child: Text(
              'YOUR CART',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),

          // Cart Content
          Expanded(
            child: cartItems.isEmpty
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Image.asset(
                          'images/cartempty.png', // Empty cart image
                          height: 200,
                          width: 200,
                          fit: BoxFit.contain,
                        ),
                        SizedBox(height: 16),
                        Text(
                          'Your cart is empty.',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  )
                : ListView.builder(
                    itemCount: cartItems.length,
                    itemBuilder: (context, index) {
                      final item = cartItems[index];
                      return Card(
                        margin: EdgeInsets.all(8),
                        elevation: 4,
                        child: Column(
                          children: [
                            ListTile(
                              leading: Image.asset(
                                item['image'],
                                width: 50,
                                height: 50,
                                fit: BoxFit.cover,
                              ),
                              title: Text(item['name']),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Price: \RM ${item['price'].toStringAsFixed(2)}'),
                                  if (item['variant'] != null)
                                    Text('Variant: ${item['variant']}'),
                                  if (item['storage'] != null)
                                    Text('Storage: ${item['storage']}'),
                                ],
                              ),
                              trailing: IconButton(
                                icon: Icon(Icons.delete, color: Colors.black),
                                onPressed: () {
                                  // Remove item from cart
                                  cartState.removeFromCart(item);

                                  // Show snackbar confirmation
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: Text('${item['name']} removed from cart.'),
                                    ),
                                  );
                                },
                              ),
                            ),
                            // Quantity Row
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'Quantity: ',
                                    style: TextStyle(fontWeight: FontWeight.bold),
                                  ),
                                  Row(
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.remove, color: Colors.black),
                                        onPressed: () {
                                          if (item['quantity'] > 1) {
                                            cartState.updateQuantity(item, item['quantity'] - 1);
                                          }
                                        },
                                      ),
                                      Text(
                                        '${item['quantity']}',
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.add, color: Colors.black),
                                        onPressed: () {
                                          cartState.updateQuantity(item, item['quantity'] + 1);
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
          ),

          // Subtotal and Checkout Section
          if (cartItems.isNotEmpty)
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                children: [
                  // Subtotal Text
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Subtotal  ',
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        '\RM ${cartState.totalPrice.toStringAsFixed(2)}',
                        style: TextStyle(fontSize: 18),
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  // Checkout Button
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // Navigate to CheckoutPage (no need to pass cartItems anymore)
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CheckoutPage(),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black, // Black background
                        foregroundColor: Colors.white, // White text
                        padding: EdgeInsets.symmetric(vertical: 16.0),
                      ),
                      child: Text(
                        'Checkout',
                        style: TextStyle(fontSize: 18),
                      ),
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
