import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:yours_gadget_latest/providers/cart_state.dart';
import 'checkoutpage.dart'; // Import the CheckoutPage

class ProductDetailScreen extends StatefulWidget {
  final String productName;
  final String productImage;
  final List<String> variants;
  final List<String> storageOptions;
  final double price;

  ProductDetailScreen({
    required this.productName,
    required this.productImage,
    required this.variants,
    required this.storageOptions,
    required this.price,
  });

  @override
  _ProductDetailScreenState createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String? selectedVariant;
  String? selectedStorage;

  @override
  void initState() {
    super.initState();
    selectedVariant = widget.variants.isNotEmpty ? widget.variants[0] : null;
    selectedStorage = widget.storageOptions.isNotEmpty ? widget.storageOptions[0] : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(120),
        child: AppBar(
          backgroundColor: Colors.white,
          elevation: 1,
          flexibleSpace: Container(
            height: 140,
            alignment: Alignment.center,
            child: Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Image.asset(
                'images/logo.png', // Your app logo image
                height: 110,
              ),
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Center(
                child: Image.asset(
                  widget.productImage,
                  height: 200,
                  fit: BoxFit.cover,
                ),
              ),
              SizedBox(height: 16),

              // Product Name and Price
              Text(
                widget.productName,
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text(
                'RM ${widget.price.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 20, color: Colors.black),
              ),
              SizedBox(height: 16),

              // Free Shipping, Secure Payment, Return Policy
              Row(
                children: [
                  Icon(Icons.language, size: 20, color: Colors.black),
                  SizedBox(width: 8),
                  Text("Free worldwide shipping"),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.lock, size: 20, color: Colors.black),
                  SizedBox(width: 8),
                  Text("Secure payments"),
                ],
              ),
              SizedBox(height: 8),
              Row(
                children: [
                  Icon(Icons.refresh, size: 20, color: Colors.black),
                  SizedBox(width: 8),
                  Text("7 Days Free Return"),
                ],
              ),
              SizedBox(height: 16),

              // Variant Selection
              if (widget.variants.isNotEmpty) ...[
                Text(
                  'Colour',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Wrap(
                  spacing: 8.0,
                  children: widget.variants.map((variant) {
                    return ChoiceChip(
                      label: Text(
                        variant,
                        style: TextStyle(
                          color: selectedVariant == variant ? Colors.white : Colors.black,
                        ),
                      ),
                      selected: selectedVariant == variant,
                      selectedColor: Colors.black,
                      backgroundColor: Colors.grey[300],
                      onSelected: (isSelected) {
                        setState(() {
                          selectedVariant = variant;
                        });
                      },
                    );
                  }).toList(),
                ),
                SizedBox(height: 16),
              ],

              // Storage Options
              if (widget.storageOptions.isNotEmpty) ...[
                Text(
                  'Storage',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                SizedBox(height: 8),
                Wrap(
                  spacing: 8.0,
                  children: widget.storageOptions.map((storage) {
                    return ChoiceChip(
                      label: Text(
                        storage,
                        style: TextStyle(
                          color: selectedStorage == storage ? Colors.white : Colors.black,
                        ),
                      ),
                      selected: selectedStorage == storage,
                      selectedColor: Colors.black,
                      backgroundColor: Colors.grey[300],
                      onSelected: (isSelected) {
                        setState(() {
                          selectedStorage = storage;
                        });
                      },
                    );
                  }).toList(),
                ),
                SizedBox(height: 16),
              ],

              // Buttons (Center-Aligned)
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Provider.of<CartState>(context, listen: false).addToCart({
                          'name': widget.productName,
                          'image': widget.productImage,
                          'price': widget.price,
                          'variant': selectedVariant,
                          'storage': selectedStorage,
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${widget.productName} added to cart!'),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 55),
                      ),
                      child: Text("Add to Cart", style: TextStyle(color: Colors.white)),
                    ),
                    SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () {
                        // Clear the cart before navigating to the checkout page
                        Provider.of<CartState>(context, listen: false).clearCart();

                        // Add the selected product to the cart immediately for checkout
                        Provider.of<CartState>(context, listen: false).addToCart({
                          'name': widget.productName,
                          'image': widget.productImage,
                          'price': widget.price,
                          'variant': selectedVariant,
                          'storage': selectedStorage,
                        });

                        // Navigate to the checkout page
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CheckoutPage(), // Assuming CheckoutPage exists
                          ),
                        );

                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${widget.productName} purchased and cart cleared!'),
                          ),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color.fromARGB(255, 38, 65, 185),
                        padding: EdgeInsets.symmetric(vertical: 14, horizontal: 60),
                      ),
                      child: Text("Buy Now", style: TextStyle(color: Colors.white)),
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
}
