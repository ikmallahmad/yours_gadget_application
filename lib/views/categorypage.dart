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
        'price': 6499.00, // Approx MYR Price
        'variants': ['Black', 'White', 'Pink'],
        'storage': ['128GB', '256GB', '512GB']
      },
      {
        'name': 'iPhone 14 Pro',
        'image': 'images/iphone14problack.png',
        'price': 5899.00, // Approx MYR Price
        'variants': ['Black', 'White', 'Gold'],
        'storage': ['128GB', '256GB']
      },
      {
        'name': 'iPhone 13 Mini',
        'image': 'images/iphone13mini.png',
        'price': 4399.00, // Approx MYR Price
        'variants': ['Black', 'Blue', 'Red'],
        'storage': ['128GB', '256GB']
      },
      {
        'name': 'iPhone SE (2022)',
        'image': 'images/iphonese2022.png',
        'price': 2499.00, // Approx MYR Price
        'variants': ['Black', 'White', 'Red'],
        'storage': ['64GB', '128GB']
      },
      {
        'name': 'iPhone 12 Pro',
        'image': 'images/iphone12pro.png',
        'price': 4999.00, // Approx MYR Price
        'variants': ['Black', 'Silver', 'Graphite'],
        'storage': ['128GB', '256GB']
      },
      {
        'name': 'iPhone XR',
        'image': 'images/iphonexr.png',
        'price': 3299.00, // Approx MYR Price
        'variants': ['Black', 'White', 'Blue'],
        'storage': ['64GB', '128GB']
      },
    ],
    'android': [
      {
        'name': 'Redmi Note 13 Pro',
        'image': 'images/redminote13pro.png',
        'price': 1399.00, // Approx MYR Price
        'variants': ['Black', 'Silver'],
        'storage': ['128GB', '256GB']
      },
      {
        'name': 'Samsung Galaxy Fold 6',
        'image': 'images/samsungfoldsilver.png',
        'price': 8999.00, // Approx MYR Price
        'variants': ['Black', 'Silver'],
        'storage': ['256GB', '512GB']
      },
      {
        'name': 'Google Pixel 6',
        'image': 'images/pixel6.png',
        'price': 2799.00, // Approx MYR Price
        'variants': ['Black', 'Green', 'White'],
        'storage': ['128GB', '256GB']
      },
      {
        'name': 'OnePlus 9 Pro',
        'image': 'images/oneplus9pro.png',
        'price': 4999.00, // Approx MYR Price
        'variants': ['Black', 'Silver'],
        'storage': ['128GB', '256GB']
      },
      {
        'name': 'Xiaomi Mi 11',
        'image': 'images/xiaomi11.png',
        'price': 2499.00, // Approx MYR Price
        'variants': ['Blue', 'Black'],
        'storage': ['128GB', '256GB']
      },
      {
        'name': 'Oppo Find X3 Pro',
        'image': 'images/oppofindx3pro.png',
        'price': 4999.00, // Approx MYR Price
        'variants': ['Black', 'Silver'],
        'storage': ['256GB', '512GB']
      },
    ],
    'set_pc': [
      {
        'name': 'Gaming PC',
        'image': 'images/setpc.png',
        'price': 3000.00, // Default price for basic gaming PC
        'variants': [],
        'storage': []
      },
      {
        'name': 'Custom PC Build',
        'image': 'images/custompc.png',
        'price': 3500.00, // Starting price for custom build
        'variants': [],
        'storage': []
      },
      {
        'name': 'Desktop PC',
        'image': 'images/desktoppc.png',
        'price': 2500.00, // Default price for office PC
        'variants': [],
        'storage': []
      },
      {
        'name': 'PC for Streaming',
        'image': 'images/pcstreaming.png',
        'price': 4000.00, // Default price for streaming PC
        'variants': [],
        'storage': []
      },
    ],
    'laptop': [
      {
        'name': 'Acer Aspire 3',
        'image': 'images/aceraspire.png',
        'price': 2499.00, // Approx MYR Price
        'specifications': 'Intel i5, 8GB RAM, 512GB SSD'
      },
      {
        'name': 'Acer Nitro V15',
        'image': 'images/acernitrov15.png',
        'price': 4499.00, // Approx MYR Price
        'specifications': 'Intel i7, 16GB RAM, 1TB SSD'
      },
      {
        'name': 'MacBook Air M1',
        'image': 'images/macbookairm1.png',
        'price': 5299.00, // Approx MYR Price
        'specifications': 'Apple M1 Chip, 8GB RAM, 256GB SSD'
      },
      {
        'name': 'HP Spectre x360',
        'image': 'images/hpspectrex360.png',
        'price': 6999.00, // Approx MYR Price
        'specifications': 'Intel i7, 16GB RAM, 512GB SSD'
      },
      {
        'name': 'Lenovo ThinkPad X1',
        'image': 'images/lenovothinkpadx1.png',
        'price': 6999.00, // Approx MYR Price
        'specifications': 'Intel i7, 16GB RAM, 1TB SSD'
      },
      {
        'name': 'Dell XPS 13',
        'image': 'images/dellxps13.png',
        'price': 5999.00, // Approx MYR Price
        'specifications': 'Intel i7, 16GB RAM, 512GB SSD'
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

  String _formatCategoryName(String categoryType) {
    return categoryType.replaceAll('_', ' ').split(' ').map((word) {
      return word[0].toUpperCase() + word.substring(1).toLowerCase();
    }).join(' ');
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
              _formatCategoryName(widget.categoryType),  // Using formatted category name
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
                          'RM ${product['price'].toStringAsFixed(2)}', // Price in MYR
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
