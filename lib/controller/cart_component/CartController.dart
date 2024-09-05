import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../controller/UserController.dart';

class CartController extends GetxController {
  final RxMap<String, Map<String, dynamic>> _cartItems = <String, Map<String, dynamic>>{}.obs;

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
    saveCartToSharedPreferences(); // Save the cart state
  }

  // Get the product details of a product in the cart
  Map<String, dynamic>? getProductDetails(String medicineId) {
    return _cartItems[medicineId];
  }

  void removeCartItem(String medicineId) {
    _cartItems.remove(medicineId);
    update(); // Notify listeners
    saveCartToSharedPreferences(); // Save the cart state
  }

  Future<void> saveCartToSharedPreferences() async {
    final UserController userController = Get.find<UserController>();
    final prefs = await SharedPreferences.getInstance();
    final userId = userController.userId.value;

    if (userId.isNotEmpty) {
      final cartJson = jsonEncode(_cartItems);
      await prefs.setString('cart_$userId', cartJson);
    }
  }

  Future<void> loadCartFromSharedPreferences() async {
    final UserController userController = Get.find<UserController>();
    final prefs = await SharedPreferences.getInstance();
    final userId = userController.userId.value;

    if (userId.isNotEmpty) {
      final cartJson = prefs.getString('cart_$userId');
      if (cartJson != null) {
        final Map<String, dynamic> cartData = jsonDecode(cartJson);
        _cartItems.clear(); // Clear existing cart items to prevent duplicate entries
        _cartItems.addAll(cartData.map((key, value) => MapEntry(key, Map<String, dynamic>.from(value))));
        update(); // Notify listeners
      }
    }
  }

  void clearCart() {
    _cartItems.clear();
    update(); // Notify listeners
    saveCartToSharedPreferences(); // Save the cart state
  }

  @override
  void onInit() {
    super.onInit();
    final UserController userController = Get.find<UserController>();
    userController.userId.listen((userId) {
      if (userId.isNotEmpty) {
        loadCartFromSharedPreferences(); // Load cart state when a valid user ID is available
      }
    });
  }
}



// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';
// import '../../controller/UserController.dart'; // Adjust the import path to your UserController
//
// class CartController extends GetxController {
//   // A map to store the product details and quantities in the cart
//   final RxMap<String, Map<String, dynamic>> _cartItems = <String, Map<String, dynamic>>{}.obs;
//
//   // Get the cart items
//   Map<String, Map<String, dynamic>> get cartItems => _cartItems;
//
//   // Add or update a product in the cart
//   void updateCartItem(String medicineId, Map<String, dynamic> productDetails, int quantity) {
//     if (quantity <= 0) {
//       _cartItems.remove(medicineId);
//     } else {
//       _cartItems[medicineId] = {
//         ...productDetails,
//         'quantity': quantity,
//       };
//     }
//     update(); // Notify listeners
//     saveCartToSharedPreferences(); // Save the cart state
//   }
//
//   // Get the product details of a product in the cart
//   Map<String, dynamic>? getProductDetails(String medicineId) {
//     return _cartItems[medicineId];
//   }
//
//   // Method to remove an item from the cart
//   void removeCartItem(String medicineId) {
//     _cartItems.remove(medicineId);
//     update(); // Notify listeners
//     saveCartToSharedPreferences(); // Save the cart state
//   }
//
//   // Method to save cart items to shared preferences
//   Future<void> saveCartToSharedPreferences() async {
//     final UserController userController = Get.find<UserController>();
//     final prefs = await SharedPreferences.getInstance();
//     final userId = userController.userId.value;
//
//     if (userId.isNotEmpty) {
//       final cartJson = jsonEncode(_cartItems);
//       await prefs.setString('cart_$userId', cartJson);
//     }
//   }
//
//   // Method to load cart items from shared preferences
//   Future<void> loadCartFromSharedPreferences() async {
//     final UserController userController = Get.find<UserController>();
//     final prefs = await SharedPreferences.getInstance();
//     final userId = userController.userId.value;
//
//     if (userId.isNotEmpty) {
//       final cartJson = prefs.getString('cart_$userId');
//       if (cartJson != null) {
//         final Map<String, dynamic> cartData = jsonDecode(cartJson);
//         _cartItems.clear(); // Clear existing cart items to prevent duplicate entries
//         _cartItems.addAll(cartData.map((key, value) => MapEntry(key, Map<String, dynamic>.from(value))));
//         update(); // Notify listeners
//       }
//     }
//   }
//
//   // Clear the cart
//   void clearCart() {
//     _cartItems.clear();
//     update(); // Notify listeners
//     saveCartToSharedPreferences(); // Save the cart state
//   }
//
//   @override
//   void onInit() {
//     super.onInit();
//     // Ensure that the user controller is initialized and has a valid userId before loading cart data
//     final UserController userController = Get.find<UserController>();
//     userController.userId.listen((userId) {
//       if (userId.isNotEmpty) {
//         loadCartFromSharedPreferences(); // Load cart state when a valid user ID is available
//       }
//     });
//   }
// }
//
//
// // import 'package:get/get.dart';
// // import 'package:shared_preferences/shared_preferences.dart';
// // import 'dart:convert';
// //
// // class CartController extends GetxController {
// //   // A map to store the product details and quantities in the cart
// //   final Map<String, Map<String, dynamic>> _cartItems = <String, Map<String, dynamic>>{}.obs;
// //
// //   // Get the cart items
// //   Map<String, Map<String, dynamic>> get cartItems => _cartItems;
// //
// //   // Add or update a product in the cart
// //   void updateCartItem(String medicineId, Map<String, dynamic> productDetails, int quantity) {
// //     if (quantity <= 0) {
// //       _cartItems.remove(medicineId);
// //     } else {
// //       _cartItems[medicineId] = {
// //         ...productDetails,
// //         'quantity': quantity,
// //       };
// //     }
// //     update(); // Notify listeners
// //     saveCartToSharedPreferences(); // Save the cart state
// //   }
// //
// //   // Get the product details of a product in the cart
// //   Map<String, dynamic>? getProductDetails(String medicineId) {
// //     return _cartItems[medicineId];
// //   }
// //
// //   // Method to remove an item from the cart
// //   void removeCartItem(String medicineId) {
// //     _cartItems.remove(medicineId);
// //     update(); // Notify listeners
// //     saveCartToSharedPreferences(); // Save the cart state
// //   }
// //
// //   // Method to save cart items to shared preferences
// //   Future<void> saveCartToSharedPreferences() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     final cartJson = jsonEncode(_cartItems);
// //     await prefs.setString('cartItems', cartJson);
// //   }
// //
// //   // Method to load cart items from shared preferences
// //   Future<void> loadCartFromSharedPreferences() async {
// //     final prefs = await SharedPreferences.getInstance();
// //     final cartJson = prefs.getString('cartItems');
// //     if (cartJson != null) {
// //       final Map<String, dynamic> cartData = jsonDecode(cartJson);
// //       _cartItems.addAll(cartData.map((key, value) => MapEntry(key, Map<String, dynamic>.from(value))));
// //       update(); // Notify listeners
// //     }
// //   }
// //
// //   // Clear the cart
// //   void clearCart() {
// //     _cartItems.clear();
// //     update(); // Notify listeners
// //     saveCartToSharedPreferences(); // Save the cart state
// //   }
// //
// //   @override
// //   void onInit() {
// //     super.onInit();
// //     loadCartFromSharedPreferences(); // Load cart state on initialization
// //   }
// // }
//
//
// // import 'package:get/get.dart';
// //
// // class CartController extends GetxController {
// //   // A map to store the product details and quantities in the cart
// //   final Map<String, Map<String, dynamic>> _cartItems = <String, Map<String, dynamic>>{}.obs;
// //
// //   // Get the cart items
// //   Map<String, Map<String, dynamic>> get cartItems => _cartItems;
// //
// //   // Add or update a product in the cart
// //   void updateCartItem(String medicineId, Map<String, dynamic> productDetails, int quantity) {
// //     if (quantity <= 0) {
// //       _cartItems.remove(medicineId);
// //     } else {
// //       _cartItems[medicineId] = {
// //         ...productDetails,
// //         'quantity': quantity,
// //       };
// //     }
// //     update(); // Notify listeners
// //   }
// //
// //   // Get the product details of a product in the cart
// //   Map<String, dynamic>? getProductDetails(String medicineId) {
// //     return _cartItems[medicineId];
// //   }
// //
// //   // Method to remove an item from the cart
// //   void removeCartItem(String medicineId) {
// //     cartItems.remove(medicineId);
// //   }
// // }
// //
// //
// // //
// // // import 'package:get/get.dart';
// // //
// // // class CartItem {
// // //   final String name;
// // //   final double price;
// // //   int quantity;
// // //
// // //   CartItem({
// // //     required this.name,
// // //     required this.price,
// // //     this.quantity = 1,
// // //   });
// // // }
// // //
// // // class CartController extends GetxController {
// // //   var cartItems = <CartItem>[].obs;
// // //
// // //   double get totalPrice => cartItems.fold(0, (total, item) => total + (item.price * item.quantity));
// // //
// // //   void addItem(CartItem item) {
// // //     // Check if the item already exists in the cart
// // //     var existingItem = cartItems.firstWhereOrNull((element) => element.name == item.name);
// // //     if (existingItem != null) {
// // //       // Increase the quantity of the existing item
// // //       existingItem.quantity++;
// // //       cartItems.refresh();
// // //     } else {
// // //       // Add new item to the cart
// // //       cartItems.add(item);
// // //     }
// // //   }
// // //
// // //   void removeItem(CartItem item) {
// // //     cartItems.remove(item);
// // //   }
// // //
// // //   void increaseQuantity(CartItem item) {
// // //     item.quantity++;
// // //     cartItems.refresh();
// // //   }
// // //
// // //   void decreaseQuantity(CartItem item) {
// // //     if (item.quantity > 1) {
// // //       item.quantity--;
// // //       cartItems.refresh();
// // //     }
// // //   }
// // // }
// // //
//
