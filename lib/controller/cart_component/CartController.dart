// lib/controllers/cart_controller.dart

import 'package:get/get.dart';

class CartController extends GetxController {
  // A set to store the IDs of products that are in the cart
  final Set<String> _cartItems = <String>{}.obs;

  // Get the cart items
  Set<String> get cartItems => _cartItems;

  // Add or remove a product from the cart
  void toggleCartItem(String medicineId) {
    if (_cartItems.contains(medicineId)) {
      _cartItems.remove(medicineId);
    } else {
      _cartItems.add(medicineId);
    }
    update(); // Notify listeners
  }

  // Check if a product is in the cart
  bool isInCart(String medicineId) {
    return _cartItems.contains(medicineId);
  }
}



// import 'package:get/get.dart';
// import 'package:flutter/material.dart';
//
// class CartItem {
//   final String name;
//   final double price;
//   int quantity;
//
//   CartItem({
//     required this.name,
//     required this.price,
//     this.quantity = 1,
//   });
// }
//
// class CartController extends GetxController {
//   var cartItems = <CartItem>[].obs;
//   var isUserLoggedIn = false.obs; // Track the user login state
//
//   double get totalPrice => cartItems.fold(0, (total, item) => total + (item.price * item.quantity));
//
//   void addToCart(CartItem item) {
//     // Check if item already exists in the cart
//     var index = cartItems.indexWhere((element) => element.name == item.name);
//     if (index >= 0) {
//       // Item already in cart, increase quantity
//       cartItems[index].quantity++;
//     } else {
//       // Add new item to cart
//       cartItems.add(item);
//     }
//   }
//
//   void increaseQuantity(int index) {
//     cartItems[index].quantity++;
//   }
//
//   void decreaseQuantity(int index) {
//     if (cartItems[index].quantity > 1) {
//       cartItems[index].quantity--;
//     } else {
//       cartItems.removeAt(index);
//     }
//   }
//
//   void toggleLoginStatus() {
//     isUserLoggedIn.value = !isUserLoggedIn.value;
//   }
// }
