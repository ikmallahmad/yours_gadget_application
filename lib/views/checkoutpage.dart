import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:yours_gadget_latest/providers/cart_state.dart'; // Import the CartState
import 'orderconfirmationpage.dart'; // Import OrderConfirmationPage
import 'add_address_page.dart';

class CheckoutPage extends StatefulWidget {
  @override
  _CheckoutPageState createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  List<Map<String, dynamic>> _addresses = [];
  Map<String, dynamic>? _selectedAddress;
  String? _selectedPaymentMethod;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _fetchAddresses();
  }

  // Fetch addresses from Firestore for the logged-in user
  Future<void> _fetchAddresses() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;
      try {
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();
        List<dynamic> fetchedAddresses = userDoc['addresses'] ?? [];

        setState(() {
          _addresses = List<Map<String, dynamic>>.from(fetchedAddresses);
          if (_addresses.isNotEmpty) {
            _selectedAddress = _addresses.first;
          }
        });
      } catch (e) {
        print('Error fetching addresses: $e');
      }
    }
  }

  // Place the order and save cartItems to Firestore
  Future<void> _placeOrder() async {
    setState(() {
      _errorMessage = null; // Reset any previous error message
    });

    if (_selectedAddress == null || _selectedPaymentMethod == null) {
      setState(() {
        _errorMessage = 'Please select both a shipping address and a payment method.';
      });
      return;
    }

    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;
      final cartState = Provider.of<CartState>(context, listen: false);
      final cartItems = cartState.cartItems; // Get the latest cart items from CartState

      final orderRef = FirebaseFirestore.instance.collection('orders').doc();
      final orderId = orderRef.id;

      final orderData = {
        'userId': uid,
        'address': _selectedAddress,
        'paymentMethod': _selectedPaymentMethod,
        'cartItems': cartItems,
        'total': cartItems.fold(0.0, (sum, item) => sum + ((item['price'] as double) * (item['quantity'] ?? 1))),
        'orderDate': Timestamp.now(),
        'orderId': orderId,
        'status': 'Pending',  // Set the initial order status to "Pending"
      };

      try {
        // Save the order along with cartItems to Firestore
        await orderRef.set(orderData);

        // Update the order history for the user
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'orderHistory': FieldValue.arrayUnion([orderData]),
        });

        // Clear the cart after the order is placed
        cartState.clearCart();  // Clear cart after order placement

        // Navigate to the Order Confirmation page
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => OrderConfirmationPage(orderId: orderId),
          ),
        );
      } catch (e) {
        print('Error placing order: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartState = Provider.of<CartState>(context);
    final cartItems = cartState.cartItems;  // Get the cart items directly from CartState

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 4,
          flexibleSpace: Container(
            height: 120,
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Image.asset(
                'images/logo.png',
                height: 60,
              ),
            ),
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Checkout", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
              SizedBox(height: 20),
              Text("Order Summary", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              // Loop through cartItems to display them
              for (var item in cartItems) ...[
                ListTile(
                  leading: Image.asset(item['image'], width: 50, height: 50, fit: BoxFit.cover),
                  title: Text(item['name']),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Price: \RM ${item['price'].toStringAsFixed(2)}'),
                      Text('Quantity: ${item['quantity']}'),
                    ],
                  ),
                ),
                Divider(),
              ],
              SizedBox(height: 10),
              // Display the total price
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text("Total: ", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  Text(
                    "\RM ${cartItems.fold(0.0, (sum, item) => sum + ((item['price'] as double) * (item['quantity'] ?? 1))).toStringAsFixed(2)}",
                    style: TextStyle(fontSize: 18),
                  ),
                ],
              ),
              SizedBox(height: 30),
              // Shipping Address Section
              Text("Shipping Address", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              _addresses.isEmpty
                  ? Center(child: Text("No saved addresses available."))
                  : DropdownButton<Map<String, dynamic>>(
                      isExpanded: true,
                      value: _selectedAddress,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedAddress = newValue;
                        });
                      },
                      items: _addresses.map((address) {
                        return DropdownMenuItem<Map<String, dynamic>>(
                          value: address,
                          child: Text('${address['address']}'),
                        );
                      }).toList(),
                    ),
              SizedBox(height: 10),
              // Button to add new address
              ElevatedButton(
                onPressed: _addNewAddress,
                child: Text("Add New Address"),
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.black,
                ),
              ),
              SizedBox(height: 30),
              // Payment Method Section
              Text("Payment Method", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              SizedBox(height: 10),
              DropdownButton<String>(
                isExpanded: true,
                hint: Text("Select Payment Method"),
                value: _selectedPaymentMethod,
                onChanged: (newValue) {
                  setState(() {
                    _selectedPaymentMethod = newValue;
                  });
                },
                items: <String>['DuitNow', 'Bank Transfer']
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Row(
                      children: [
                        Image.asset(
                          value == 'DuitNow' ? 'images/duitnow.png' : 'images/bankicon.png',
                          width: 24,
                          height: 24,
                        ),
                        SizedBox(width: 10),
                        Text(value),
                      ],
                    ),
                  );
                }).toList(),
              ),
              SizedBox(height: 30),
              // Error message for missing address or payment method
              if (_errorMessage != null)
                Padding(
                  padding: const EdgeInsets.only(bottom: 20),
                  child: Text(
                    _errorMessage!,
                    style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
                  ),
                ),
              // Place Order Button
              ElevatedButton(
                onPressed: _placeOrder,
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(40),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.lock, color: Colors.white),
                    SizedBox(width: 8),
                    Text("Place Order Now", style: TextStyle(fontSize: 16)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Method to add a new address
  void _addNewAddress() async {
    final newAddress = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => AddAddressPage()),
    );

    if (newAddress != null) {
      setState(() {
        _addresses.add(newAddress);
        _selectedAddress = newAddress;
      });
    }
  }
}
