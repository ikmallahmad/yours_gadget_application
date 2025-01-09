import 'package:flutter/material.dart';
import 'package:yours_gadget_latest/views/homepage.dart';
import 'package:yours_gadget_latest/views/cartpage.dart';
import 'package:yours_gadget_latest/views/userdetailspage.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  final int currentIndex;
  final Function(int) onTap;

  CustomBottomNavigationBar({required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart_rounded),
          label: '',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.account_circle),
          label: '',
        ),
      ],
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.white,
      backgroundColor: const Color.fromARGB(255, 92, 92, 92),
      showSelectedLabels: false,
      showUnselectedLabels: false,
      elevation: 8,
    );
  }
}
