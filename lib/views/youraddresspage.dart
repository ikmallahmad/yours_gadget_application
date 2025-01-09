import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'add_address_page.dart';

class YourAddressPage extends StatefulWidget {
  @override
  _YourAddressPageState createState() => _YourAddressPageState();
}

class _YourAddressPageState extends State<YourAddressPage> {
  List<Map<String, dynamic>> _addresses = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _getAddressDetails();
  }

  // Fetch the addresses from Firestore
  Future<void> _getAddressDetails() async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final uid = user.uid;

      try {
        DocumentSnapshot userDoc =
            await FirebaseFirestore.instance.collection('users').doc(uid).get();

        if (userDoc.exists) {
          final List<dynamic> addresses = userDoc['addresses'] ?? [];

          setState(() {
            _addresses = List<Map<String, dynamic>>.from(addresses);
            _isLoading = false;
          });
        } else {
          setState(() {
            _addresses = [];
            _isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          _isLoading = false;
        });
        print('Error fetching addresses: $e');
      }
    }
  }

  Future<void> _deleteAddress(int index) async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final uid = user.uid;

      try {
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          "addresses": FieldValue.arrayRemove([_addresses[index]]),
        });
        _getAddressDetails();
      } catch (e) {
        print('Error deleting address: $e');
      }
    }
  }

  void _editAddress(int index) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => AddAddressPage(
          address: _addresses[index],
          index: index,
        ),
      ),
    ).then((updatedAddress) {
      if (updatedAddress != null) {
        setState(() {
          _addresses[index] = updatedAddress;
        });
        _saveAddressesToFirestore();
      }
    });
  }

  Future<void> _saveAddressesToFirestore() async {
    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final uid = user.uid;

      try {
        await FirebaseFirestore.instance.collection('users').doc(uid).update({
          'addresses': _addresses,
        });
      } catch (e) {
        print('Error saving addresses to Firestore: $e');
      }
    }
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
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Your Address",
                      style: TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddAddressPage()),
                        ).then((newAddress) {
                          if (newAddress != null) {
                            setState(() {
                              _addresses.add(newAddress);
                            });
                            _saveAddressesToFirestore();
                          }
                        });
                      },
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Colors.black,
                      ),
                      child: Text("Add a New Address"),
                    ),
                    SizedBox(height: 20),
                    if (_addresses.isEmpty)
                      Center(
                        child: Text(
                          'No addresses saved.',
                          style: TextStyle(fontSize: 16),
                        ),
                      )
                    else
                      ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: _addresses.length,
                        itemBuilder: (context, index) {
                          final address = _addresses[index];
                          return Container(
                            margin: EdgeInsets.symmetric(vertical: 8.0),
                            padding: EdgeInsets.all(16.0),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey.shade300,
                                  blurRadius: 5,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${address['firstName']} ${address['lastName']}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(height: 8),
                                Text('Phone: ${address['phone']}'),
                                SizedBox(height: 8),
                                Text('Address: ${address['address']}'),
                                SizedBox(height: 8),
                                Text('Country: ${address['country']}'),
                                SizedBox(height: 8),
                                Text('City: ${address['city']}'),
                                SizedBox(height: 8),
                                Text('Postal Code: ${address['postalCode']}'),
                                SizedBox(height: 16),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(
                                      icon: Icon(Icons.edit, color: Colors.orange),
                                      onPressed: () => _editAddress(index),
                                    ),
                                    IconButton(
                                      icon: Icon(Icons.delete, color: Colors.red),
                                      onPressed: () => _deleteAddress(index),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                  ],
                ),
              ),
            ),
    );
  }
}
