import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class ToReceivePage extends StatefulWidget {
  @override
  _ToReceivePageState createState() => _ToReceivePageState();
}

class _ToReceivePageState extends State<ToReceivePage> {
  late String userId;
  List<Map<String, dynamic>> _toReceiveOrders = [];
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _fetchToReceiveOrders();
  }

  Future<void> _fetchToReceiveOrders() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        userId = user.uid;
      });

      try {
        final snapshot = await FirebaseFirestore.instance
            .collection('orders')
            .where('userId', isEqualTo: userId)
            .where('status', isEqualTo: 'Pending') // Fetch only Pending orders
            .get();

        setState(() {
          _toReceiveOrders = snapshot.docs
              .map((doc) => {'orderId': doc.id, ...doc.data() as Map<String, dynamic>})
              .toList();
        });
      } catch (e) {
        print('Error fetching To Receive orders: $e');
      }
    }
  }

  Future<void> _markOrderComplete(String orderId) async {
    setState(() {
      _isLoading = true;
    });

    try {
      final orderRef = FirebaseFirestore.instance.collection('orders').doc(orderId);
      await orderRef.update({'status': 'Completed'}); // Update status to 'Completed'

      setState(() {
        _toReceiveOrders.removeWhere((order) => order['orderId'] == orderId);
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
      print('Error marking order as complete: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return _toReceiveOrders.isEmpty
        ? Center(child: Text('No orders to receive.'))
        : ListView.builder(
            itemCount: _toReceiveOrders.length,
            itemBuilder: (context, index) {
              var order = _toReceiveOrders[index];

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
                      SizedBox(height: 10),
                      GestureDetector(
                        onTap: _isLoading ? null : () => _markOrderComplete(order['orderId']),
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 15),
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          alignment: Alignment.center,
                          child: _isLoading
                              ? CircularProgressIndicator(color: Colors.white)
                              : Text('Received', style: TextStyle(color: Colors.white)),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
  }
}
