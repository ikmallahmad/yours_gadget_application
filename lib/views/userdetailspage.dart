import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'add_address_page.dart'; // Import the Add Address Page
import 'youraddresspage.dart'; // Import the Your Address Page (you need to create this page)
import 'my_account_page.dart';
import 'orderhistorypage.dart'; // Import the OrderHistoryPage

class UserDetailsPage extends StatefulWidget {
  @override
  _UserDetailsPageState createState() => _UserDetailsPageState();
}

class _UserDetailsPageState extends State<UserDetailsPage> {
  User? _user;
  String _username = '';
  String _profilePictureUrl = '';
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getUserDetails();
  }

  // Fetch user details from Firestore
  Future<void> _getUserDetails() async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final uid = user.uid;

      try {
        // Fetch user data from Firestore
        DocumentSnapshot userDoc = await FirebaseFirestore.instance.collection('users').doc(uid).get();

        if (userDoc.exists) {
          setState(() {
            _username = userDoc['username'] ?? 'No Username';
            _profilePictureUrl = userDoc['profilePicture'] ?? '';
            _isLoading = false;  // Data fetched, stop loading indicator
          });
        } else {
          setState(() {
            _username = 'No Username';
            _profilePictureUrl = '';
            _isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        // Handle error
        print('Error fetching user details: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 1,
        centerTitle: true,
        flexibleSpace: Container(
          height: 150,
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: const EdgeInsets.only(bottom: 1.0),
            child: Image.asset(
              'images/logo.png',
              height: 70,
            ),
          ),
        ),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator()) // Show loading spinner
          : SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile Picture and Username
                  SizedBox(height: 100),
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: _profilePictureUrl.isEmpty
                        ? AssetImage('images/default_icon.png') // Default image
                        : NetworkImage(_profilePictureUrl) as ImageProvider,
                  ),
                  SizedBox(height: 20),
                  Text(
                    _username,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 50),
                  Divider(),
                  // My Account Functions
                  ListTile(
                    leading: Icon(Icons.account_circle_rounded, color: Colors.black),
                    title: Text('My account', style: TextStyle(color: Colors.black)),
                    onTap: () {
                      // Navigate to My Account Details
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MyAccountPage()), // Add MyAccountPage
                      );
                    },
                  ),
                  Divider(),
                  // Directly navigate to Your Address Page
                  ListTile(
                    leading: Icon(Icons.location_pin, color: Colors.black),
                    title: Text('Your Address', style: TextStyle(color: Colors.black)),
                    onTap: () {
                      // Always navigate to Your Address page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => YourAddressPage()), // Directly navigate here
                      );
                    },
                  ),
                  Divider(),
                  // Navigate to Order History Page
                  ListTile(
                    leading: Icon(Icons.history, color: Colors.black),
                    title: Text('Order History', style: TextStyle(color: Colors.black)),
                    onTap: () {
                      // Navigate to Order History Page
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => OrderHistoryPage()),
                      );
                    },
                  ),
                  Divider(),
                  // Logout Function
                  ListTile(
                    leading: Icon(Icons.logout, color: Colors.red),
                    title: Text('Log Out', style: TextStyle(color: Colors.red)),
                    onTap: () async {
                      // Log out functionality
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => LoginScreen()), // Redirect to Login
                      );
                    },
                  ),
                ],
              ),
            ),
    );
  }
}
