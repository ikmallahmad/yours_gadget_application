import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class CompletePage extends StatefulWidget {
  @override
  _CompletePageState createState() => _CompletePageState();
}

class _CompletePageState extends State<CompletePage> {
  late String userId;
  List<Map<String, dynamic>> _completedOrders = [];

  @override
  void initState() {
    super.initState();
    _fetchCompletedOrders();
  }

  Future<void> _fetchCompletedOrders() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid;
      });

      try {
        final snapshot = await FirebaseFirestore.instance
            .collection('orders')
            .where('userId', isEqualTo: userId)
            .where('status', isEqualTo: 'Completed') // Fetch only Completed orders
            .get();

        setState(() {
          _completedOrders = snapshot.docs
              .map((doc) => {'orderId': doc.id, ...doc.data() as Map<String, dynamic>})
              .toList();
        });
      } catch (e) {
        print('Error fetching Completed orders: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return _completedOrders.isEmpty
        ? Center(child: Text('No completed orders.'))
        : ListView.builder(
            itemCount: _completedOrders.length,
            itemBuilder: (context, index) {
              var order = _completedOrders[index];

              return Card(
                margin: EdgeInsets.symmetric(vertical: 10),
                elevation: 4,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Keep the order ID container UI as you had it
                      Text('Order ID: ${order['orderId']}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                      SizedBox(height: 10),
                      // Display product details
                      for (var item in order['cartItems']) ...[ 
                        Row(
                          children: [
                            Image.asset(
                              item['image'],
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
                      Text('Total: \RM ${order['total'].toStringAsFixed(2)}', style: TextStyle(fontSize: 16)),
                    ],
                  ),
                ),
              );
            },
          );
  }
}
