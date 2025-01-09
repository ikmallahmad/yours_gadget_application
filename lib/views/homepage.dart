import 'dart:async'; // Required for Timer
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'cartpage.dart';
import 'categorypage.dart';
import 'userdetailspage.dart';
import 'custom_bottom_navigation_bar.dart'; // Custom bottom navigation bar

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  // List of screens that will be navigated to
  final List<Widget> _screens = [
    HomeScreen(),
    CartPage(),
    UserDetailsPage(),
  ];

  // Handle the bottom navigation tap
  void _onItemTapped(int index) {
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index; // Update the index when tapped
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final List<String> bannerImages = [
    'images/banner.png',
    'images/banner1.png',
  ];
  PageController _pageController = PageController();
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    // Start auto-sliding the banner every 4 seconds
    _startAutoSlide();
  }

  // Function to start the timer for automatic banner sliding
  void _startAutoSlide() {
    _timer = Timer.periodic(Duration(seconds: 4), (timer) {
      int nextPage = (_pageController.page?.toInt() ?? 0) + 1;
      if (nextPage >= bannerImages.length) {
        nextPage = 0; // Loop back to the first banner
      }
      _pageController.animateToPage(nextPage,
          duration: Duration(milliseconds: 300), curve: Curves.easeInOut);
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Cancel the timer when the widget is disposed
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Fixed Header
        Container(
          height: 120,
          color: Colors.white,
          alignment: Alignment.center,
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Image.asset(
              'images/logo.png',
              height: 150, // Adjust logo size here
            ),
          ),
        ),

        // Fixed Banner Section
        Container(
          height: MediaQuery.of(context).size.height * 0.4,
          child: PageView.builder(
            controller: _pageController,
            itemCount: bannerImages.length,
            itemBuilder: (context, index) {
              return Image.asset(
                bannerImages[index],
                fit: BoxFit.cover,
                width: MediaQuery.of(context).size.width,
              );
            },
          ),
        ),

        // Scrollable Categories Section
        Expanded(
          child: GridView.count(
            crossAxisCount: 2,
            padding: EdgeInsets.all(10),
            childAspectRatio: 1.0,
            children: [
              CategoryCard('IPHONE', 'images/iphone16.png', 'iphone'),
              CategoryCard('ANDROID', 'images/redminote13pro.png', 'android'),
              CategoryCard('SET PC', 'images/setpc.png', 'set_pc'),
              CategoryCard('LAPTOP', 'images/acernitrov15.png', 'laptop'),
            ],
          ),
        ),
      ],
    );
  }
}

class CategoryCard extends StatelessWidget {
  final String categoryName;
  final String imagePath;
  final String categoryType;

  CategoryCard(this.categoryName, this.imagePath, this.categoryType);

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => CategoryPage(categoryType: categoryType),
            ),
          );
        },
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              categoryName,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Image.asset(imagePath, height: 80, fit: BoxFit.cover),
          ],
        ),
      ),
    );
  }
}
