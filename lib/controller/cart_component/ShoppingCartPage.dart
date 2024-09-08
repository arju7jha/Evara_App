import 'dart:convert'; // For encoding JSON
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:evara/controller/cart_component/CartController.dart';
import '../../screens/widgets/product_details.dart';

class ShoppingCartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Shopping Cart'),
        backgroundColor: Colors.teal,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Center(
              child: Obx(() {
                return Text(
                  'Items: ${cartController.cartItems.length}',
                  style: TextStyle(fontSize: 18),
                );
              }),
            ),
          ),
        ],
      ),
      body: Obx(() {
        final cartItems = cartController.cartItems;
        return ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          itemCount: cartItems.length,
          itemBuilder: (context, index) {
            final medicineId = cartItems.keys.elementAt(index);
            final productDetails = cartItems[medicineId]!;
            final quantity = productDetails['quantity'] as int;

            // Calculate displayPrice (SP/PTR)
            final ptr = productDetails['ptr'] ?? '0';
            final sellingPrice = productDetails['sellingPrice'] ?? '0';
            final displayPrice = (ptr.isNotEmpty && double.tryParse(ptr) != 0)
                ? ptr
                : sellingPrice;

            final price = double.tryParse(displayPrice) ?? 0;
            final totalAmount = (price * quantity).toStringAsFixed(2);

            return GestureDetector(
              onTap: () {
                // Navigate to ProductDetailsPage
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => ProductDetailsPage(
                      imagePath: productDetails['imagePath'] ?? '',
                      name: productDetails['name'] ?? '',
                      mrp: productDetails['mrp'] ?? '',
                      ptr: productDetails['ptr'] ?? '',
                      companyName: productDetails['companyName'] ?? '',
                      productDetails: productDetails['productDetails'] ?? '',
                      salts: productDetails['salts'] ?? '',
                      offer: productDetails['offer'] ?? '',
                      medicineId: medicineId,
                      sellingPrice: sellingPrice,
                    ),
                  ),
                );
              },
              child: Card(
                margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                elevation: 5,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Row(
                  children: [
                    // Product Image
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10.0),
                        child: Image.network(
                          productDetails['imagePath'] ?? '',
                          width: 60,
                          height: 60,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Icon(Icons.image, size: 70, color: Colors.grey);
                          },
                        ),
                      ),
                    ),
                    // Product Info
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // First Row: Name & Delete Button
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  productDetails['name'] ?? '',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              IconButton(
                                icon: Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  cartController.removeCartItem(medicineId);
                                },
                              ),
                            ],
                          ),
                          // Second Row: Amount & Quantity Adjustment
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Amount: $totalAmount',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.green,
                                ),
                              ),
                              Row(
                                children: [
                                  IconButton(
                                    icon: Icon(Icons.remove_circle_outline, color: Colors.blue),
                                    onPressed: () {
                                      if (quantity > 1) {
                                        cartController.updateCartItem(medicineId, productDetails, quantity - 1);
                                      }
                                    },
                                  ),
                                  Container(
                                    width: 40,
                                    height: 30,
                                    child: TextField(
                                      textAlign: TextAlign.center,
                                      keyboardType: TextInputType.number,
                                      decoration: InputDecoration(
                                        border: OutlineInputBorder(),
                                        contentPadding: EdgeInsets.symmetric(horizontal: 8),
                                      ),
                                      controller: TextEditingController(text: quantity.toString()),
                                      onSubmitted: (value) {
                                        final newQuantity = int.tryParse(value) ?? 0;
                                        cartController.updateCartItem(medicineId, productDetails, newQuantity);
                                      },
                                    ),
                                  ),
                                  IconButton(
                                    icon: Icon(Icons.add_circle_outline, color: Colors.blue),
                                    onPressed: () {
                                      cartController.updateCartItem(medicineId, productDetails, quantity + 1);
                                    },
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
      bottomNavigationBar: Obx(() {
        final totalPrice = cartController.cartItems.entries.fold(0.0, (total, entry) {
          // Calculate displayPrice for total price calculation
          final ptr = entry.value['ptr'] ?? '0';
          final sellingPrice = entry.value['sellingPrice'] ?? '0';
          final displayPrice = (ptr.isNotEmpty && double.tryParse(ptr) != 0)
              ? ptr
              : sellingPrice;

          final price = double.tryParse(displayPrice) ?? 0;
          return total + (price * entry.value['quantity']);
        });
        return Container(
          padding: const EdgeInsets.all(16.0),
          decoration: BoxDecoration(
            color: Colors.teal[50],
            borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
            boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 10.0)],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Total Amount
              Text(
                'Total: \u{20B9} ${totalPrice.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              // Buy Now Button
              ElevatedButton(
                onPressed: () async {
                  // Show loading animation
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (BuildContext context) {
                      return Center(
                        child: SpinKitCircle(
                          color: Colors.teal,
                          size: 50.0,
                        ),
                      );
                    },
                  );

                  try {
                    final cartItems = cartController.cartItems.entries.map((entry) {
                      final productDetails = entry.value;
                      final netQuantity = productDetails['quantity'];
                      final buyQuantity = netQuantity; // Assuming no offer quantities for now
                      final offerQuantity = 0; // Can modify logic based on actual data
                      return {
                        "product_id": entry.key,
                        "net_quantity": netQuantity,
                        "buy_quantity": buyQuantity,
                        "offer_quantity": offerQuantity,
                      };
                    }).toList();

                    final orderData = {
                      "user_id": 1, // Replace with actual user ID
                      "products": cartItems,
                      "status": "pending",
                      "total_amount": totalPrice,
                    };

                    print('Order Data: ${jsonEncode(orderData)}');

                    // Send the data to the API
                    final response = await http.post(
                      Uri.parse('https://namami-infotech.com/EvaraBackend/src/order/order_product.php'),
                      headers: {'Content-Type': 'application/json'},
                      body: jsonEncode(orderData),
                    );

                    if (response.statusCode == 200) {
                      Navigator.of(context).pop(); // Dismiss loading animation
                      _showSuccessDialog(context, totalPrice);
                    } else {
                      throw Exception('Failed to place order. Status code: ${response.statusCode}');
                    }
                  } catch (e) {
                    Navigator.of(context).pop(); // Dismiss loading animation
                    _showErrorDialog(context, e.toString());
                  }
                },
                style: ElevatedButton.styleFrom(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  backgroundColor: Colors.teal,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
                child: Text(
                  'Buy Now',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }


// Success dialog function
  void _showSuccessDialog(BuildContext context, double totalPrice) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Order Placed!'),
          content: Text(
            'You have successfully placed an order of total amount \u{20B9} ${totalPrice.toStringAsFixed(2)}.',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  // Error dialog function
  void _showErrorDialog(BuildContext context, String errorMessage) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('Failed to place order: $errorMessage'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close dialog
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }
}


// import 'dart:convert'; // For encoding JSON
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:evara/controller/cart_component/CartController.dart';
// import '../../screens/widgets/product_details.dart';
//
// class ShoppingCartPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     final CartController cartController = Get.find<CartController>();
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Shopping Cart'),
//         backgroundColor: Colors.teal,
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 16.0),
//             child: Center(
//               child: Obx(() {
//                 return Text(
//                   'Items: ${cartController.cartItems.length}',
//                   style: TextStyle(fontSize: 18),
//                 );
//               }),
//             ),
//           ),
//         ],
//       ),
//       body: Obx(() {
//         final cartItems = cartController.cartItems;
//         return ListView.builder(
//           padding: const EdgeInsets.symmetric(vertical: 10.0),
//           itemCount: cartItems.length,
//           itemBuilder: (context, index) {
//             final medicineId = cartItems.keys.elementAt(index);
//             final productDetails = cartItems[medicineId]!;
//             final quantity = productDetails['quantity'] as int;
//             final price = double.tryParse(productDetails['ptr'] ?? '0') ?? 0;
//             final totalAmount = (price * quantity).toStringAsFixed(2);
//
//             return GestureDetector(
//               onTap: () {
//                 // Navigate to ProductDetailsPage
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(
//                     builder: (context) => ProductDetailsPage(
//                       imagePath: productDetails['imagePath'] ?? '',
//                       name: productDetails['name'] ?? '',
//                       mrp: productDetails['mrp'] ?? '',
//                       ptr: productDetails['ptr'] ?? '',
//                       companyName: productDetails['companyName'] ?? '',
//                       productDetails: productDetails['productDetails'] ?? '',
//                       salts: productDetails['salts'] ?? '',
//                       offer: productDetails['offer'] ?? '',
//                       medicineId: medicineId,
//                       sellingPrice: '',
//                     ),
//                   ),
//                 );
//               },
//               child: Card(
//                 margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//                 elevation: 5,
//                 shape: RoundedRectangleBorder(
//                   borderRadius: BorderRadius.circular(15.0),
//                 ),
//                 child: Row(
//                   children: [
//                     // Product Image
//                     Padding(
//                       padding: const EdgeInsets.all(8.0),
//                       child: ClipRRect(
//                         borderRadius: BorderRadius.circular(10.0),
//                         child: Image.network(
//                           productDetails['imagePath'] ?? '',
//                           width: 60,
//                           height: 60,
//                           fit: BoxFit.cover,
//                           errorBuilder: (context, error, stackTrace) {
//                             return Icon(Icons.image, size: 70, color: Colors.grey);
//                           },
//                         ),
//                       ),
//                     ),
//                     // Product Info
//                     Expanded(
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           // First Row: Name & Delete Button
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Expanded(
//                                 child: Text(
//                                   productDetails['name'] ?? '',
//                                   style: TextStyle(
//                                     fontWeight: FontWeight.bold,
//                                     fontSize: 15,
//                                   ),
//                                   overflow: TextOverflow.ellipsis,
//                                 ),
//                               ),
//                               IconButton(
//                                 icon: Icon(Icons.delete, color: Colors.red),
//                                 onPressed: () {
//                                   cartController.removeCartItem(medicineId);
//                                 },
//                               ),
//                             ],
//                           ),
//                           // Second Row: Amount & Quantity Adjustment
//                           Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                             children: [
//                               Text(
//                                 'Amount: $totalAmount',
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 14,
//                                   color: Colors.green,
//                                 ),
//                               ),
//                               Row(
//                                 children: [
//                                   IconButton(
//                                     icon: Icon(Icons.remove_circle_outline, color: Colors.blue),
//                                     onPressed: () {
//                                       if (quantity > 1) {
//                                         cartController.updateCartItem(medicineId, productDetails, quantity - 1);
//                                       }
//                                     },
//                                   ),
//                                   Container(
//                                     width: 40,
//                                     height: 30,
//                                     child: TextField(
//                                       textAlign: TextAlign.center,
//                                       keyboardType: TextInputType.number,
//                                       decoration: InputDecoration(
//                                         border: OutlineInputBorder(),
//                                         contentPadding: EdgeInsets.symmetric(horizontal: 8),
//                                       ),
//                                       controller: TextEditingController(text: quantity.toString()),
//                                       onSubmitted: (value) {
//                                         final newQuantity = int.tryParse(value) ?? 0;
//                                         cartController.updateCartItem(medicineId, productDetails, newQuantity);
//                                       },
//                                     ),
//                                   ),
//                                   IconButton(
//                                     icon: Icon(Icons.add_circle_outline, color: Colors.blue),
//                                     onPressed: () {
//                                       cartController.updateCartItem(medicineId, productDetails, quantity + 1);
//                                     },
//                                   ),
//                                 ],
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//             );
//           },
//         );
//       }),
//       bottomNavigationBar: Obx(() {
//         final totalPrice = cartController.cartItems.entries.fold(0.0, (total, entry) {
//           final price = double.tryParse(entry.value['ptr'] ?? '0') ?? 0;
//           return total + (price * entry.value['quantity']);
//         });
//         return Container(
//           padding: const EdgeInsets.all(16.0),
//           decoration: BoxDecoration(
//             color: Colors.teal[50],
//             borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
//             boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 10.0)],
//           ),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               // Total Amount
//               Text(
//                 'Total: \u{20B9} ${totalPrice.toStringAsFixed(2)}',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               // Buy Now Button
//               ElevatedButton(
//                 onPressed: () async {
//                   // Show loading animation
//                   showDialog(
//                     context: context,
//                     barrierDismissible: false,
//                     builder: (BuildContext context) {
//                       return Center(
//                         child: SpinKitCircle(
//                           color: Colors.teal,
//                           size: 50.0,
//                         ),
//                       );
//                     },
//                   );
//
//                   try {
//                     final cartItems = cartController.cartItems.entries.map((entry) {
//                       final productDetails = entry.value;
//                       final netQuantity = productDetails['quantity'];
//                       final buyQuantity = netQuantity; // Assuming no offer quantities for now
//                       final offerQuantity = 0; // Can modify logic based on actual data
//                       return {
//                         "product_id": entry.key,
//                         "net_quantity": netQuantity,
//                         "buy_quantity": buyQuantity,
//                         "offer_quantity": offerQuantity,
//                       };
//                     }).toList();
//
//                     final orderData = {
//                       "user_id": 1, // Replace with actual user ID
//                       "products": cartItems,
//                       "status": "pending",
//                       "total_amount": totalPrice,
//                     };
//
//                     print('Order Data: ${jsonEncode(orderData)}');
//
//                     // Send the data to the API
//                     final response = await http.post(
//                       Uri.parse('https://namami-infotech.com/EvaraBackend/src/order/order_product.php'),
//                       headers: {'Content-Type': 'application/json'},
//                       body: jsonEncode(orderData),
//                     );
//
//                     if (response.statusCode == 200) {
//                       Navigator.of(context).pop(); // Dismiss loading animation
//                       _showSuccessDialog(context, totalPrice);
//                     } else {
//                       throw Exception('Failed to place order. Status code: ${response.statusCode}');
//                     }
//                   } catch (e) {
//                     Navigator.of(context).pop(); // Dismiss loading animation
//                     _showErrorDialog(context, e.toString());
//                   }
//                 },
//                 style: ElevatedButton.styleFrom(
//                   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                   backgroundColor: Colors.teal,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(10.0),
//                   ),
//                 ),
//                 child: Text(
//                   'Buy Now',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
//
//   // Success dialog function
//   void _showSuccessDialog(BuildContext context, double totalPrice) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Order Placed!'),
//           content: Text(
//             'You have successfully placed an order of total amount \u{20B9} ${totalPrice.toStringAsFixed(2)}.',
//           ),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close dialog
//               },
//               child: Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }
//
//   // Error dialog function
//   void _showErrorDialog(BuildContext context, String errorMessage) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Text('Error'),
//           content: Text('Failed to place order: $errorMessage'),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.of(context).pop(); // Close dialog
//               },
//               child: Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
//
//
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:evara/controller/cart_component/CartController.dart';
// // import '../../screens/widgets/product_details.dart';
// //
// // class ShoppingCartPage extends StatelessWidget {
// //   @override
// //   Widget build(BuildContext context) {
// //     final CartController cartController = Get.find<CartController>();
// //
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Shopping Cart'),
// //         backgroundColor: Colors.teal,
// //         actions: [
// //           Padding(
// //             padding: const EdgeInsets.only(right: 16.0),
// //             child: Center(
// //               child: Obx(() {
// //                 return Text(
// //                   'Items: ${cartController.cartItems.length}',
// //                   style: TextStyle(fontSize: 18),
// //                 );
// //               }),
// //             ),
// //           ),
// //         ],
// //       ),
// //       body: Obx(() {
// //         final cartItems = cartController.cartItems;
// //         return ListView.builder(
// //           padding: const EdgeInsets.symmetric(vertical: 10.0),
// //           itemCount: cartItems.length,
// //           itemBuilder: (context, index) {
// //             final medicineId = cartItems.keys.elementAt(index);
// //             final productDetails = cartItems[medicineId]!;
// //             final quantity = productDetails['quantity'] as int;
// //             final price = double.tryParse(productDetails['ptr'] ?? '0') ?? 0;
// //             final totalAmount = (price * quantity).toStringAsFixed(2);
// //
// //             return GestureDetector(
// //               onTap: () {
// //                 // Navigate to ProductDetailsPage
// //                 Navigator.push(
// //                   context,
// //                   MaterialPageRoute(
// //                     builder: (context) => ProductDetailsPage(
// //                       imagePath: productDetails['imagePath'] ?? '',
// //                       name: productDetails['name'] ?? '',
// //                       mrp: productDetails['mrp'] ?? '',
// //                       ptr: productDetails['ptr'] ?? '',
// //                       companyName: productDetails['companyName'] ?? '',
// //                       productDetails: productDetails['productDetails'] ?? '',
// //                       salts: productDetails['salts'] ?? '',
// //                       offer: productDetails['offer'] ?? '',
// //                       medicineId: medicineId,
// //                       sellingPrice: '',
// //                     ),
// //                   ),
// //                 );
// //               },
// //               child: Card(
// //                 margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
// //                 elevation: 5,
// //                 shape: RoundedRectangleBorder(
// //                   borderRadius: BorderRadius.circular(15.0),
// //                 ),
// //                 child: Row(
// //                   children: [
// //                     // Product Image
// //                     Padding(
// //                       padding: const EdgeInsets.all(8.0),
// //                       child: ClipRRect(
// //                         borderRadius: BorderRadius.circular(10.0),
// //                         child: Image.network(
// //                           productDetails['imagePath'] ?? '',
// //                           width: 60,
// //                           height: 60,
// //                           fit: BoxFit.cover,
// //                           errorBuilder: (context, error, stackTrace) {
// //                             return Icon(Icons.image, size: 70, color: Colors.grey);
// //                           },
// //                         ),
// //                       ),
// //                     ),
// //                     // Product Info
// //                     Expanded(
// //                       child: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           // First Row: Name & Delete Button
// //                           Row(
// //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                             children: [
// //                               Expanded(
// //                                 child: Text(
// //                                   productDetails['name'] ?? '',
// //                                   style: TextStyle(
// //                                     fontWeight: FontWeight.bold,
// //                                     fontSize: 15,
// //                                   ),
// //                                   overflow: TextOverflow.ellipsis,
// //                                 ),
// //                               ),
// //                               IconButton(
// //                                 icon: Icon(Icons.delete, color: Colors.red),
// //                                 onPressed: () {
// //                                   cartController.removeCartItem(medicineId);
// //                                 },
// //                               ),
// //                             ],
// //                           ),
// //                           // Second Row: Amount & Quantity Adjustment
// //                           Row(
// //                             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                             children: [
// //                               Text(
// //                                 'Amount: $totalAmount',
// //                                 style: TextStyle(
// //                                   fontWeight: FontWeight.bold,
// //                                   fontSize: 14,
// //                                   color: Colors.green,
// //                                 ),
// //                               ),
// //                               Row(
// //                                 children: [
// //                                   IconButton(
// //                                     icon: Icon(Icons.remove_circle_outline, color: Colors.blue),
// //                                     onPressed: () {
// //                                       if (quantity > 1) {
// //                                         cartController.updateCartItem(medicineId, productDetails, quantity - 1);
// //                                       }
// //                                     },
// //                                   ),
// //                                   Container(
// //                                     width: 40,
// //                                     height: 30,
// //                                     child: TextField(
// //                                       textAlign: TextAlign.center,
// //                                       keyboardType: TextInputType.number,
// //                                       decoration: InputDecoration(
// //                                         border: OutlineInputBorder(),
// //                                         contentPadding: EdgeInsets.symmetric(horizontal: 8),
// //                                       ),
// //                                       controller: TextEditingController(text: quantity.toString()),
// //                                       onSubmitted: (value) {
// //                                         final newQuantity = int.tryParse(value) ?? 0;
// //                                         cartController.updateCartItem(medicineId, productDetails, newQuantity);
// //                                       },
// //                                     ),
// //                                   ),
// //                                   IconButton(
// //                                     icon: Icon(Icons.add_circle_outline, color: Colors.blue),
// //                                     onPressed: () {
// //                                       cartController.updateCartItem(medicineId, productDetails, quantity + 1);
// //                                     },
// //                                   ),
// //                                 ],
// //                               ),
// //                             ],
// //                           ),
// //                         ],
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ),
// //             );
// //           },
// //         );
// //       }),
// //       bottomNavigationBar: Obx(() {
// //         final totalPrice = cartController.cartItems.entries.fold(0.0, (total, entry) {
// //           final price = double.tryParse(entry.value['ptr'] ?? '0') ?? 0;
// //           return total + (price * entry.value['quantity']);
// //         });
// //         return Container(
// //           padding: const EdgeInsets.all(16.0),
// //           decoration: BoxDecoration(
// //             color: Colors.teal[50],
// //             borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
// //             boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.3), blurRadius: 10.0)],
// //           ),
// //           child: Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //             children: [
// //               // Total Amount
// //               Text(
// //                 'Total: \u{20B9} ${totalPrice.toStringAsFixed(2)}',
// //                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
// //               ),
// //               // Buy Now Button
// //               ElevatedButton(
// //                 onPressed: () {
// //                   // Handle buy now action
// //                   print('Buy Now Pressed');
// //                 },
// //                 style: ElevatedButton.styleFrom(
// //                   padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
// //                   backgroundColor: Colors.teal,
// //                   shape: RoundedRectangleBorder(
// //                     borderRadius: BorderRadius.circular(10.0),
// //                   ),
// //                 ),
// //                 child: Text(
// //                   'Buy Now',
// //                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         );
// //       }),
// //     );
// //   }
// // }
// //
// //
// //
