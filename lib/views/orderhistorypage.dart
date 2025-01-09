import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class OrderHistoryPage extends StatefulWidget {
  @override
  _OrderHistoryPageState createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage> with SingleTickerProviderStateMixin {
  late String userId;
  List<Map<String, dynamic>> _orderHistory = [];
  bool _isComplete = false; // Track if the user marked the order as completed
  bool _isLoading = false; // Track if an order update is in progress
  late AnimationController _controller;
  late Animation<double> _underlineAnimation;

  @override
  void initState() {
    super.initState();
    _fetchUserSectionState(); // Fetch the section state (Received/Complete)
    _fetchOrderHistory();

    // Animation setup for underline transition
    _controller = AnimationController(vsync: this, duration: Duration(milliseconds: 300));
    _underlineAnimation = Tween(begin: 0.0, end: 1.0).animate(_controller);
  }

  // Fetch user's section state (Received or Complete)
  Future<void> _fetchUserSectionState() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid;
      });

      try {
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
        bool? isComplete = userDoc['orderSectionState']; // Fetch saved section state
        if (isComplete != null) {
          setState(() {
            _isComplete = isComplete;
          });
        }
      } catch (e) {
        print('Error fetching user section state: $e');
      }
    }
  }

  // Save the section state in Firestore
  Future<void> _saveUserSectionState(bool isComplete) async {
    try {
      final userRef = FirebaseFirestore.instance.collection('users').doc(userId);
      await userRef.update({'orderSectionState': isComplete}); // Save the state to Firestore
    } catch (e) {
      print('Error saving section state: $e');
    }
  }

  // Fetch order history for the current user
  Future<void> _fetchOrderHistory() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid;
      });

      try {
        final userDoc = await FirebaseFirestore.instance.collection('users').doc(userId).get();
        List<dynamic> fetchedOrderHistory = userDoc['orderHistory'] ?? [];

        setState(() {
          _orderHistory = List<Map<String, dynamic>>.from(fetchedOrderHistory);
        });
      } catch (e) {
        print('Error fetching order history: $e');
      }
    }
  }

  // Mark the order as "Complete" in Firestore
  Future<void> _markOrderComplete(String orderId, int index) async {
    setState(() {
      _isLoading = true; // Set loading state when updating order
    });

    try {
      final orderRef = FirebaseFirestore.instance.collection('orders').doc(orderId);
      await orderRef.update({'status': 'Completed'}); // Update status to 'Completed'

      // Update local order status without fetching all order history again
      setState(() {
        _orderHistory[index]['status'] = 'Completed'; // Update only the current order status
        _isLoading = false; // Reset loading state
      });
    } catch (e) {
      setState(() {
        _isLoading = false; // Reset loading state in case of error
      });
      print('Error marking order as complete: $e');
    }
  }

  @override
  void dispose() {
    _controller.dispose(); // Dispose animation controller
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 4,
          flexibleSpace: Container(
            height: 140,
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Image.asset(
                'images/logo.png',
                height: 160,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Text(
              "Order History",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 20),
            // Navigation Bar for "Received" and "Complete"
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isComplete = false; // Show "Received" orders
                      _controller.forward(from: 0); // Trigger underline animation
                    });
                    _saveUserSectionState(false); // Save state
                  },
                  child: Column(
                    children: [
                      Text(
                        'To Receive',
                        style: TextStyle(
                          color: _isComplete ? Colors.black : Colors.black,
                          fontSize: 16,
                          fontWeight: _isComplete ? FontWeight.normal : FontWeight.bold, // Bold when selected
                        ),
                      ),
                    ],
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    setState(() {
                      _isComplete = true; // Show "Complete" orders
                      _controller.forward(from: 0); // Trigger underline animation
                    });
                    _saveUserSectionState(true); // Save state
                  },
                  child: Column(
                    children: [
                      Text(
                        'Complete',
                        style: TextStyle(
                          color: _isComplete ? Colors.black : Colors.black,
                          fontSize: 16,
                          fontWeight: _isComplete ? FontWeight.bold : FontWeight.normal, // Bold when selected
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Order List
            Expanded(
              child: _orderHistory.isEmpty
                  ? Center(child: Text('No order history available.'))
                  : ListView.builder(
                      itemCount: _orderHistory.length,
                      itemBuilder: (context, index) {
                        var order = _orderHistory[index];

                        // Filter based on completion status
                        if (_isComplete && order['status'] != 'Completed') {
                          return SizedBox.shrink(); // Skip non-complete orders
                        }

                        if (!_isComplete && order['status'] == 'Completed') {
                          return SizedBox.shrink(); // Skip completed orders if in "Received" mode
                        }

                        return Card(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          elevation: 4,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text('Order ID: ${order['orderId']}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                                SizedBox(height: 10),
                                // Display product details
                                for (var item in order['cartItems']) ...[ 
                                  Row(
                                    children: [
                                      Image.asset(
                                        item['image'], // Now using local asset path (e.g., images/iphone16.png)
                                        width: 60,
                                        height: 60,
                                        fit: BoxFit.cover,
                                      ),
                                      SizedBox(width: 10),
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(item['name'], style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                                          Text('Price: \RM ${item['price'].toStringAsFixed(2)}'),
                                          Text('Quantity: ${item['quantity']}'),
                                        ],
                                      ),
                                    ],
                                  ),
                                  Divider(),
                                ],
                                SizedBox(height: 10),
                                // Show the total price for the order
                                Text('Total: \RM ${order['total'].toStringAsFixed(2)}', style: TextStyle(fontSize: 16)),
                                SizedBox(height: 10),
                                // Received Button with Full Width (Rounded Rectangle)
                                if (!_isComplete)
                                  GestureDetector(
                                    onTap: _isLoading
                                        ? null // Disable while loading
                                        : () {
                                            _markOrderComplete(order['orderId'], index);
                                          },
                                    child: Container(
                                      width: double.infinity,
                                      padding: EdgeInsets.symmetric(vertical: 15),
                                      decoration: BoxDecoration(
                                        color: Colors.black,
                                        borderRadius: BorderRadius.circular(30), // Rounded rectangle
                                      ),
                                      alignment: Alignment.center,
                                      child: _isLoading
                                          ? CircularProgressIndicator(color: Colors.black) // Show loading indicator
                                          : Text('Received', style: TextStyle(color: Colors.white)),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
