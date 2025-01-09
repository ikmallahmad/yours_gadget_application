import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class OrderDetailPage extends StatefulWidget {
  final String orderId;

  OrderDetailPage({required this.orderId});

  @override
  _OrderDetailPageState createState() => _OrderDetailPageState();
}

class _OrderDetailPageState extends State<OrderDetailPage> {
  Map<String, dynamic>? _orderData;

  @override
  void initState() {
    super.initState();
    _fetchOrderDetails();
  }

  // Fetch the order details by orderId
  Future<void> _fetchOrderDetails() async {
    try {
      final orderDoc = await FirebaseFirestore.instance.collection('orders').doc(widget.orderId).get();

      setState(() {
        _orderData = orderDoc.data();
      });
    } catch (e) {
      print('Error fetching order details: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_orderData == null) {
      return Scaffold(
        appBar: AppBar(title: Text('Order Details')),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text('Order Details')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Order ID: ${_orderData!['orderId']}', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            Text('Status: ${_orderData!['status']}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Payment Method: ${_orderData!['paymentMethod']}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 10),
            Text('Total: \RM ${_orderData!['total'].toStringAsFixed(2)}', style: TextStyle(fontSize: 16)),
            SizedBox(height: 20),
            Text('Items:', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 10),
            // Display cart items
            for (var item in _orderData!['cartItems']) ...[
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
          ],
        ),
      ),
    );
  }
}
