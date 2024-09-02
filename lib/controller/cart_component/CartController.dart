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


//
// import 'package:get/get.dart';
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
//
//   double get totalPrice => cartItems.fold(0, (total, item) => total + (item.price * item.quantity));
//
//   void addItem(CartItem item) {
//     // Check if the item already exists in the cart
//     var existingItem = cartItems.firstWhereOrNull((element) => element.name == item.name);
//     if (existingItem != null) {
//       // Increase the quantity of the existing item
//       existingItem.quantity++;
//       cartItems.refresh();
//     } else {
//       // Add new item to the cart
//       cartItems.add(item);
//     }
//   }
//
//   void removeItem(CartItem item) {
//     cartItems.remove(item);
//   }
//
//   void increaseQuantity(CartItem item) {
//     item.quantity++;
//     cartItems.refresh();
//   }
//
//   void decreaseQuantity(CartItem item) {
//     if (item.quantity > 1) {
//       item.quantity--;
//       cartItems.refresh();
//     }
//   }
// }
//
// //
// // // import 'package:get/get.dart';
// // //
// // // class CartController extends GetxController {
// // //   // A set to store the IDs of products that are in the cart
// // //   final Set<String> _cartItems = <String>{}.obs;
// // //
// // //   // Get the cart items
// // //   Set<String> get cartItems => _cartItems;
// // //
// // //   // Add or remove a product from the cart
// // //   void toggleCartItem(String medicineId) {
// // //     if (_cartItems.contains(medicineId)) {
// // //       _cartItems.remove(medicineId);
// // //     } else {
// // //       _cartItems.add(medicineId);
// // //     }
// // //     update(); // Notify listeners
// // //   }
// // //
// // //   // Check if a product is in the cart
// // //   bool isInCart(String medicineId) {
// // //     return _cartItems.contains(medicineId);
// // //   }
// // // }
