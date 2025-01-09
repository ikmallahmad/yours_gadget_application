import 'package:flutter/material.dart';

class CartState with ChangeNotifier {
  final List<Map<String, dynamic>> _cartItems = [];

  // Getter for cart items
  List<Map<String, dynamic>> get cartItems => _cartItems;

  // Getter for total price
  double get totalPrice {
    return _cartItems.fold(
      0.0,
      (sum, item) => sum + ((item['price'] as double) * (item['quantity'] ?? 1)),
    );
  }

  // Add an item to the cart
  void addToCart(Map<String, dynamic> item) {
    // Check if the item already exists in the cart (matching by name, variant, and storage)
    final existingItemIndex = _cartItems.indexWhere((cartItem) =>
        cartItem['name'] == item['name'] &&
        cartItem['variant'] == item['variant'] &&
        cartItem['storage'] == item['storage']);

    if (existingItemIndex != -1) {
      // If item exists, increase its quantity
      _cartItems[existingItemIndex]['quantity'] =
          (_cartItems[existingItemIndex]['quantity'] ?? 1) + 1;
    } else {
      // If item doesn't exist, add it with a quantity of 1
      _cartItems.add({...item, 'quantity': 1});
    }
    notifyListeners();
  }

  // Remove an item from the cart
  void removeFromCart(Map<String, dynamic> item) {
    _cartItems.remove(item);
    notifyListeners();
  }

  // Update the quantity of an item in the cart
  void updateQuantity(Map<String, dynamic> item, int newQuantity) {
    final itemIndex = _cartItems.indexWhere((cartItem) =>
        cartItem['name'] == item['name'] &&
        cartItem['variant'] == item['variant'] &&
        cartItem['storage'] == item['storage']);

    if (itemIndex != -1) {
      if (newQuantity > 0) {
        _cartItems[itemIndex]['quantity'] = newQuantity; // Update quantity
      } else {
        _cartItems.removeAt(itemIndex); // Remove item if quantity is 0 or less
      }
      notifyListeners();
    }
  }

  // Clear the cart
  void clearCart() {
    _cartItems.clear();
    notifyListeners(); // Notify listeners to update the UI
  }
}
