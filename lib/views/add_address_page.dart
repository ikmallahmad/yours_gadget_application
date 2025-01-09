import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AddAddressPage extends StatefulWidget {
  final Map<String, dynamic>? address;
  final int? index;

  AddAddressPage({this.address, this.index});

  @override
  _AddAddressPageState createState() => _AddAddressPageState();
}

class _AddAddressPageState extends State<AddAddressPage> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _firstNameController;
  late TextEditingController _lastNameController;
  late TextEditingController _phoneController;
  late TextEditingController _addressController;
  late TextEditingController _countryController;
  late TextEditingController _cityController;
  late TextEditingController _postalCodeController;

  @override
  void initState() {
    super.initState();
    _firstNameController =
        TextEditingController(text: widget.address?['firstName'] ?? '');
    _lastNameController =
        TextEditingController(text: widget.address?['lastName'] ?? '');
    _phoneController =
        TextEditingController(text: widget.address?['phone'] ?? '');
    _addressController =
        TextEditingController(text: widget.address?['address'] ?? '');
    _countryController =
        TextEditingController(text: widget.address?['country'] ?? '');
    _cityController = TextEditingController(text: widget.address?['city'] ?? '');
    _postalCodeController =
        TextEditingController(text: widget.address?['postalCode'] ?? '');
  }

  Future<void> _saveAddress() async {
    if (!_formKey.currentState!.validate()) return;

    final newAddress = {
      'firstName': _firstNameController.text,
      'lastName': _lastNameController.text,
      'phone': _phoneController.text,
      'address': _addressController.text,
      'country': _countryController.text,
      'city': _cityController.text,
      'postalCode': _postalCodeController.text,
    };

    final User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final uid = user.uid;

      try {
        if (widget.index != null) {
          // Update existing address
          final userDoc =
              await FirebaseFirestore.instance.collection('users').doc(uid).get();
          List<dynamic> addresses = userDoc['addresses'] ?? [];
          addresses[widget.index!] = newAddress;

          await FirebaseFirestore.instance
              .collection('users')
              .doc(uid)
              .update({'addresses': addresses});
        } else {
          // Add new address
          await FirebaseFirestore.instance.collection('users').doc(uid).update({
            'addresses': FieldValue.arrayUnion([newAddress]),
          });
        }

        Navigator.pop(context, newAddress);
      } catch (e) {
        print('Error saving address: $e');
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              // Centered Title
              Text(
                "Add a New Address",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: 20),

              // Form with rounded text fields
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    _buildRoundedTextField(
                      controller: _firstNameController,
                      label: "First Name",
                    ),
                    SizedBox(height: 16),
                    _buildRoundedTextField(
                      controller: _lastNameController,
                      label: "Last Name",
                    ),
                    SizedBox(height: 16),
                    _buildRoundedTextField(
                      controller: _phoneController,
                      label: "Phone",
                      keyboardType: TextInputType.phone,
                    ),
                    SizedBox(height: 16),
                    _buildRoundedTextField(
                      controller: _addressController,
                      label: "Address",
                    ),
                    SizedBox(height: 16),
                    _buildRoundedTextField(
                      controller: _countryController,
                      label: "Country",
                    ),
                    SizedBox(height: 16),
                    _buildRoundedTextField(
                      controller: _cityController,
                      label: "City",
                    ),
                    SizedBox(height: 16),
                    _buildRoundedTextField(
                      controller: _postalCodeController,
                      label: "Postal Code",
                      keyboardType: TextInputType.number,
                    ),
                    SizedBox(height: 30),

                    // Save Address Button
                    ElevatedButton(
                      onPressed: _saveAddress,
                      style: ElevatedButton.styleFrom(
                        foregroundColor: Colors.white, backgroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(
                          horizontal: 40,
                          vertical: 15,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        
                      ),
                      child: Text(
                        widget.index == null ? "Add Address" : "Update Address",
                        style: TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRoundedTextField({
    required TextEditingController controller,
    required String label,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(25),
      ),
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 4),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "$label cannot be empty";
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          border: InputBorder.none,
        ),
      ),
    );
  }
}
