import 'package:get/get.dart';

class CartController extends GetxController {
  // A map to store the product details and quantities in the cart
  final Map<String, Map<String, dynamic>> _cartItems = <String, Map<String, dynamic>>{}.obs;

  // Get the cart items
  Map<String, Map<String, dynamic>> get cartItems => _cartItems;

  // Add or update a product in the cart
  void updateCartItem(String medicineId, Map<String, dynamic> productDetails, int quantity) {
    if (quantity <= 0) {
      _cartItems.remove(medicineId);
    } else {
      _cartItems[medicineId] = {
        ...productDetails,
        'quantity': quantity,
      };
    }
    update(); // Notify listeners
  }

  // Get the product details of a product in the cart
  Map<String, dynamic>? getProductDetails(String medicineId) {
    return _cartItems[medicineId];
  }

  // Method to remove an item from the cart
  void removeCartItem(String medicineId) {
    cartItems.remove(medicineId);
  }
}


