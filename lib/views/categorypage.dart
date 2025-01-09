import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'productdetailscreen.dart';
import 'package:yours_gadget_latest/providers/cart_state.dart';
import 'package:yours_gadget_latest/views/homepage.dart';
import 'package:yours_gadget_latest/views/cartpage.dart';
import 'package:yours_gadget_latest/views/userdetailspage.dart';
import 'custom_bottom_navigation_bar.dart';

class CategoryPage extends StatefulWidget {
  final String categoryType;

  CategoryPage({required this.categoryType});

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> with TickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;
  late Animation<double> _iconSizeAnimation;

  final Map<String, List<Map<String, dynamic>>> categoryProducts = {
    'iphone': [
      {
        'name': 'iPhone 16',
        'image': 'images/iphone16.png',
        'price': 4999.99,
        'variants': ['Black', 'White', 'Pink'],
        'storage': ['128GB', '256GB', '512GB']
      },
      {
        'name': 'iPhone 14 Pro',
        'image': 'images/iphone14problack.png',
        'price': 3899.99,
        'variants': ['Black', 'White', 'Gold'],
        'storage': ['128GB', '256GB']
      },
    ],
    'android': [
      {
        'name': 'Redmi Note 13 Pro',
        'image': 'images/redminote13pro.png',
        'price': 2599.99,
        'variants': ['Black', 'Silver'],
        'storage': ['128GB', '256GB']
      },
      {
        'name': 'Samsung Galaxy Fold 6',
        'image': 'images/samsungfoldsilver.png',
        'price': 2799.99,
        'variants': ['Black', 'Silver'],
        'storage': ['256GB', '512GB']
      },
    ],
    'set_pc': [
      {
        'name': 'Gaming PC',
        'image': 'images/setpc.png',
        'price': 2299.99,
        'variants': [],
        'storage': []
      },
    ],
    'laptop': [
      {
        'name': 'Acer Aspire 3',
        'image': 'images/aceraspire.png',
        'price': 1699.99,
        'specifications': 'Intel i5, 8GB RAM, 512GB SSD'
      },
      {
        'name': 'Acer Nitro V15',
        'image': 'images/acernitrov15.png',
        'price': 3899.99,
        'specifications': 'Intel i7, 16GB RAM, 1TB SSD'
      },
    ],
  };

  void _onItemTapped(int index) {
    if (index == 0) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => HomePage()));
    } else if (index == 1) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => CartPage()));
    } else if (index == 2) {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => UserDetailsPage()));
    }
  }

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 200),
      vsync: this,
    );

    _iconSizeAnimation = Tween<double>(begin: 1.0, end: 1.2).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final products = categoryProducts[widget.categoryType] ?? [];

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
                'images/logo.png',
                height: 110,
              ),
            ),
          ),
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              widget.categoryType.toUpperCase(),
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
          ),
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(10),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                childAspectRatio: 0.8,
              ),
              itemCount: products.length,
              itemBuilder: (context, index) {
                final product = products[index];
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailScreen(
                          productName: product['name'],
                          productImage: product['image'],
                          variants: List<String>.from(product['variants'] ?? []),
                          storageOptions: List<String>.from(product['storage'] ?? []),
                          price: product['price'],
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Image.asset(
                          product['image'],
                          height: 130,
                          width: 130,
                          fit: BoxFit.cover,
                        ),
                        SizedBox(height: 5),
                        Text(
                          product['name'],
                          style: TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 7),
                        Text(
                          '\RM ${product['price'].toStringAsFixed(2)}',
                          style: TextStyle(
                            color: Colors.black,
                            fontWeight: FontWeight.bold,
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
    );
  }
}
