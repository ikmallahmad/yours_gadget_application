import 'package:flutter/material.dart';
import 'homepage.dart'; // Import the HomePage

class OrderConfirmationPage extends StatelessWidget {
  final String orderId;

  OrderConfirmationPage({required this.orderId});

  void _navigateToHome(BuildContext context) {
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => HomePage()),
      (Route<dynamic> route) => false, // Remove all previous routes
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(140),
        child: AppBar(
          automaticallyImplyLeading: false, // Remove back button
          backgroundColor: Colors.white,
          elevation: 4,
          flexibleSpace: Container(
            height: 140,
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(top: 40.0),
              child: Image.asset(
                'images/logo.png', // Replace with your logo image
                height: 80,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 110), // Adjust the space before the "Thank you" message
            Text(
              "Thank You for Purchasing With Yours Gadget!",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 20),
            Text(
              "Your order ID is: $orderId",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            Spacer(), // To push the button to the bottom
            ElevatedButton(
              onPressed: () => _navigateToHome(context),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green, // Green background
                padding: EdgeInsets.symmetric(horizontal: 40, vertical: 15),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(40),
                ),
              ),
              child: Text(
                "You have placed an order",
                style: TextStyle(fontSize: 16, color: Colors.white),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
