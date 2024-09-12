import 'dart:convert'; // For encoding JSON
import 'package:evara/utils/urls/urlsclass.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:evara/controller/cart_component/CartController.dart';
import '../UserController.dart';

class CheckoutSummaryPage extends StatefulWidget {
  @override
  _CheckoutSummaryPageState createState() => _CheckoutSummaryPageState();
}

class _CheckoutSummaryPageState extends State<CheckoutSummaryPage> {
  Map<String, String> productOffers = {};

  @override
  void initState() {
    super.initState();
    loadOffers();
  }

  Future<void> loadOffers() async {
    final offers = await fetchProductOffers();
    setState(() {
      productOffers = offers;
    });
  }

  Future<Map<String, String>> fetchProductOffers() async {
    try {
      final response = await http.get(
        Uri.parse('https://namami-infotech.com/EvaraBackend/src/sku/offers_sku.php'),
      );
      if (response.statusCode == 200) {
        final offersData = json.decode(response.body);

        if (offersData != null &&
            offersData['medicines'] != null &&
            offersData['medicines'] is List) {
          final offersMap = <String, String>{};

          for (var medicine in offersData['medicines']) {
            final productId = medicine['medicine_id']?.toString() ?? '';
            final formattedOffer = medicine['formatted_offer']?.toString() ?? '';
            final ptr = medicine['ptr']?.toString() ?? '0.00';

            if (productId.isNotEmpty && formattedOffer.isNotEmpty && ptr != '0.00') {
              offersMap[productId] = formattedOffer;
            }
          }

          return offersMap;
        } else {
          print('No valid medicines data found in the response.');
          return {};
        }
      } else {
        throw Exception('Failed to load offers: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching offers: $e');
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();
    final UserController userController = Get.find<UserController>();

    return Scaffold(
      appBar: AppBar(
        title: Text('Order Summary'),
        backgroundColor: Colors.teal,
      ),
      body: Obx(() {
        final cartItems = cartController.cartItems;
        final totalPrice = cartItems.entries.fold(0.0, (total, entry) {
          final ptr = entry.value['ptr'] ?? '0';
          final sellingPrice = entry.value['sellingPrice'] ?? '0';
          final displayPrice = (ptr.isNotEmpty && double.tryParse(ptr) != 0)
              ? ptr
              : sellingPrice;
          final price = double.tryParse(displayPrice) ?? 0;
          return total + (price * entry.value['quantity']);
        });

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(vertical: 10.0),
                itemCount: cartItems.length,
                itemBuilder: (context, index) {
                  final medicineId = cartItems.keys.elementAt(index);
                  final productDetails = cartItems[medicineId]!;
                  final quantity = productDetails['quantity'] as int;

                  final ptr = productDetails['ptr'] ?? '0';
                  final sellingPrice = productDetails['sellingPrice'] ?? '0';
                  final displayPrice = (ptr.isNotEmpty && double.tryParse(ptr) != 0)
                      ? ptr
                      : sellingPrice;

                  final price = double.tryParse(displayPrice) ?? 0;
                  final totalAmount = (price * quantity).toStringAsFixed(2);

                  final offer = productOffers[medicineId] ?? '';
                  int freeQuantity = 0;
                  if (offer.isNotEmpty) {
                    final offerParts = RegExp(r'Buy (\d+) Get (\d+)').firstMatch(offer);
                    if (offerParts != null) {
                      final buyQuantity = int.tryParse(offerParts.group(1) ?? '0') ?? 0;
                      final freeOfferQuantity = int.tryParse(offerParts.group(2) ?? '0') ?? 0;
                      if (buyQuantity > 0) {
                        freeQuantity = (quantity ~/ buyQuantity) * freeOfferQuantity;
                      }
                    }
                  }

                  return Card(
                    margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15.0),
                    ),
                    child: ListTile(
                      contentPadding: EdgeInsets.all(12.0),
                      leading: Image.network(
                        productDetails['imagePath'] ?? '',
                        width: 60,
                        height: 60,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.image, size: 60, color: Colors.grey);
                        },
                      ),
                      title: Text(productDetails['name'] ?? '', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Quantity: $quantity', style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold)),
                          Text('Amount: \u{20B9} $totalAmount', style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold)),
                          if (offer.isNotEmpty) ...[
                            SizedBox(height: 4),
                            Text('Offer: $offer', style: TextStyle(color: Colors.orange, fontWeight: FontWeight.bold)),
                            if (freeQuantity > 0)
                              Text('You have unlocked $freeQuantity free items!', style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold)),
                          ],
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Summary Report',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Total Items: ${cartItems.length}',
                    style: TextStyle(fontSize: 16),
                  ),
                  SizedBox(height: 5),
                  Text(
                    'Total Amount: \u{20B9} ${totalPrice.toStringAsFixed(2)}',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Colors.green,
                    ),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () async {
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
                        final userId = userController.userId.value;
                        final cartItemsData = cartItems.entries.map((entry) {
                          final productDetails = entry.value;
                          final quantity = productDetails['quantity'];
                          final buyQuantity = quantity;
                          final freeQuantity = (productOffers[entry.key] != null)
                              ? (quantity ~/ int.parse(RegExp(r'Buy (\d+)').firstMatch(productOffers[entry.key]!)?.group(1) ?? '1')) *
                              (int.parse(RegExp(r'Get (\d+)').firstMatch(productOffers[entry.key]!)?.group(1) ?? '0'))
                              : 0;
                          final offerQuantity = freeQuantity;
                          final netQuantity = buyQuantity + offerQuantity;

                          return {
                            "product_id": entry.key,
                            "net_quantity": netQuantity,
                            "buy_quantity": buyQuantity,
                            "offer_quantity": offerQuantity,
                          };
                        }).toList();

                        final orderData = {
                          "user_id": userId,
                          "products": cartItemsData,
                          "status": "pending",
                          "total_amount": totalPrice,
                        };

                        print('Order Data: ${jsonEncode(orderData)}');

                        final response = await http.post(
                          Uri.parse(Urlsclass.orderSummaryPageUrl),
                          // Uri.parse('https://namami-infotech.com/EvaraBackend/src/order/order_product.php'),
                          headers: {'Content-Type': 'application/json'},
                          body: jsonEncode(orderData),
                        );

                        if (response.statusCode == 200) {
                          Navigator.of(context).pop();
                          _showSuccessDialog(context, totalPrice, cartController);
                          cartController.clearCart();
                        } else {
                          throw Exception('Failed to place order. Status code: ${response.statusCode}');
                        }
                      } catch (e) {
                        Navigator.of(context).pop();
                        _showErrorDialog(context, e.toString());
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      backgroundColor: Colors.teal,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    child: Text(
                      'Place Order',
                      style: TextStyle(fontSize: 18),
                    ),
                  ),
                ],
              ),
            ),
          ],
        );
      }),
    );
  }

  void _showSuccessDialog(BuildContext context, double totalPrice, CartController cartController) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0),
          ),
          child: Container(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.check_circle_outline,
                  color: Colors.green,
                  size: 50.0,
                ),
                SizedBox(height: 16.0),
                Text(
                  'Order Placed!',
                  style: TextStyle(
                    fontSize: 20.0,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 8.0),
                Text(
                  'You have successfully placed an order of total amount',
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8.0),
                Text(
                  '₹${totalPrice.toStringAsFixed(2)}',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.bold,
                    color: Colors.orange,
                  ),
                ),
                SizedBox(height: 16.0),
                ElevatedButton(
                  onPressed: () {
                    cartController.clearCart(); // Clear the cart
                    Navigator.of(context).popUntil(
                            (route) => route.isFirst); // Go back to HomePage
                  },
                  child: Text('OK'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
  // void _showSuccessDialog(BuildContext context, double totalPrice, CartController cartController) {
  //   showDialog(
  //     context: context,
  //     builder: (BuildContext context) {
  //       return AlertDialog(
  //         title: Text('Order Placed'),
  //         content: Text('Your order has been successfully placed. Total amount: \u{20B9} ${totalPrice.toStringAsFixed(2)}'),
  //         actions: [
  //           TextButton(
  //             onPressed: () {
  //               cartController.clearCart(); // Clear the cart
  //               Navigator.of(context).pop(); // Close the dialog
  //               Navigator.of(context).pop(); // Close the summary page
  //             },
  //             child: Text('OK'),
  //           ),
  //         ],
  //       );
  //     },
  //   );
  // }

  void _showErrorDialog(BuildContext context, String error) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text('An error occurred: $error'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
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
// import '../UserController.dart';
//
//
// class CheckoutSummaryPage extends StatefulWidget {
//   @override
//   _CheckoutSummaryPageState createState() => _CheckoutSummaryPageState();
// }
//
// class _CheckoutSummaryPageState extends State<CheckoutSummaryPage> {
//   Map<String, String> productOffers = {};
//
//   @override
//   void initState() {
//     super.initState();
//     loadOffers();
//   }
//
//   Future<void> loadOffers() async {
//     final offers = await fetchProductOffers();
//     setState(() {
//       productOffers = offers;
//     });
//   }
//
//   Future<Map<String, String>> fetchProductOffers() async {
//     try {
//       final response = await http.get(
//         Uri.parse('https://namami-infotech.com/EvaraBackend/src/sku/offers_sku.php'),
//       );
//
//       if (response.statusCode == 200) {
//         final offersData = json.decode(response.body);
//
//         // Ensure that 'medicines' exists and is not null
//         if (offersData != null && offersData['medicines'] != null && offersData['medicines'] is List) {
//           final offersMap = <String, String>{};
//
//           // Parse through 'medicines' instead of 'data'
//           for (var medicine in offersData['medicines']) {
//             final productId = medicine['medicine_id']?.toString() ?? '';
//             final formattedOffer = medicine['formatted_offer']?.toString() ?? '';
//
//             // Only add the offer if the productId and formattedOffer are valid
//             if (productId.isNotEmpty && formattedOffer.isNotEmpty) {
//               offersMap[productId] = formattedOffer;
//             }
//           }
//
//           return offersMap; // Returns a map of product_id to offer
//         } else {
//           print('No valid medicines data found in the response.');
//           return {}; // Return an empty map if no valid data
//         }
//       } else {
//         throw Exception('Failed to load offers: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error fetching offers: $e');
//       return {};
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     final CartController cartController = Get.find<CartController>();
//     final UserController userController = Get.find<UserController>();
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Order Summary'),
//         backgroundColor: Colors.teal,
//       ),
//       body: Obx(() {
//         final cartItems = cartController.cartItems;
//         final totalPrice = cartItems.entries.fold(0.0, (total, entry) {
//           final ptr = entry.value['ptr'] ?? '0';
//           final sellingPrice = entry.value['sellingPrice'] ?? '0';
//           final displayPrice = (ptr.isNotEmpty && double.tryParse(ptr) != 0)
//               ? ptr
//               : sellingPrice;
//           final price = double.tryParse(displayPrice) ?? 0;
//           return total + (price * entry.value['quantity']);
//         });
//
//         return Column(
//           children: [
//             Expanded(
//               child: ListView.builder(
//                 padding: const EdgeInsets.symmetric(vertical: 10.0),
//                 itemCount: cartItems.length,
//                 itemBuilder: (context, index) {
//                   final medicineId = cartItems.keys.elementAt(index);
//                   final productDetails = cartItems[medicineId]!;
//                   final quantity = productDetails['quantity'] as int;
//
//                   final ptr = productDetails['ptr'] ?? '0';
//                   final sellingPrice = productDetails['sellingPrice'] ?? '0';
//                   final displayPrice = (ptr.isNotEmpty && double.tryParse(ptr) != 0)
//                       ? ptr
//                       : sellingPrice;
//
//                   final price = double.tryParse(displayPrice) ?? 0;
//                   final totalAmount = (price * quantity).toStringAsFixed(2);
//
//                   // Check if there's an offer for this product
//                   final offer = productOffers[medicineId] ?? '';
//
//                   // Calculate free products based on the offer
//                   int freeQuantity = 0;
//                   if (offer.isNotEmpty) {
//                     final offerParts = RegExp(r'Buy (\d+) Get (\d+)').firstMatch(offer);
//                     if (offerParts != null) {
//                       final buyQuantity = int.tryParse(offerParts.group(1) ?? '0') ?? 0;
//                       final freeOfferQuantity = int.tryParse(offerParts.group(2) ?? '0') ?? 0;
//                       if (buyQuantity > 0) {
//                         freeQuantity = (quantity ~/ buyQuantity) * freeOfferQuantity;
//                       }
//                     }
//                   }
//
//                   return Card(
//                     margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//                     elevation: 5,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(15.0),
//                     ),
//                     child: ListTile(
//                       leading: Image.network(
//                         productDetails['imagePath'] ?? '',
//                         width: 50,
//                         height: 50,
//                         fit: BoxFit.cover,
//                         errorBuilder: (context, error, stackTrace) {
//                           return Icon(Icons.image, size: 50, color: Colors.grey);
//                         },
//                       ),
//                       title: Text(productDetails['name'] ?? ''),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text('Quantity: $quantity\nAmount: \u{20B9} $totalAmount'),
//                           if (offer.isNotEmpty) ...[
//                             Text('Offer: $offer', style: TextStyle(color: Colors.orange)),
//                             if (freeQuantity > 0)
//                               Text('You will get $freeQuantity free items!', style: TextStyle(color: Colors.green)),
//                           ],
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             // Summary Section
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   Text(
//                     'Summary Report',
//                     style: TextStyle(
//                       fontSize: 18,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.teal,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   SizedBox(height: 10),
//                   Text(
//                     'Total Items: ${cartItems.length}',
//                     style: TextStyle(fontSize: 16),
//                   ),
//                   SizedBox(height: 5),
//                   Text(
//                     'Total Amount: \u{20B9} ${totalPrice.toStringAsFixed(2)}',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.green,
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: () async {
//                       // Show loading animation
//                       showDialog(
//                         context: context,
//                         barrierDismissible: false,
//                         builder: (BuildContext context) {
//                           return Center(
//                             child: SpinKitCircle(
//                               color: Colors.teal,
//                               size: 50.0,
//                             ),
//                           );
//                         },
//                       );
//
//                       try {
//                         final userId = userController.userId.value;
//                         final cartItemsData = cartItems.entries.map((entry) {
//                           final productDetails = entry.value;
//                           final netQuantity = productDetails['quantity'];
//                           final buyQuantity = netQuantity;
//                           final offerQuantity =
//                           0; // Modify logic for offer if needed
//                           return {
//                             "product_id": entry.key,
//                             "net_quantity": netQuantity,
//                             "buy_quantity": buyQuantity,
//                             "offer_quantity": offerQuantity,
//                           };
//                         }).toList();
//
//                         final orderData = {
//                           "user_id": userId,
//                           "products": cartItemsData,
//                           "status": "pending",
//                           "total_amount": totalPrice,
//                         };
//
//                         final response = await http.post(
//                           Uri.parse(
//                               'https://namami-infotech.com/EvaraBackend/src/order/order_product.php'),
//                           headers: {'Content-Type': 'application/json'},
//                           body: jsonEncode(orderData),
//                         );
//
//                         if (response.statusCode == 200) {
//                           Navigator.of(context)
//                               .pop(); // Dismiss loading animation
//                           _showSuccessDialog(
//                               context, totalPrice, cartController);
//                         } else {
//                           throw Exception(
//                               'Failed to place order. Status code: ${response.statusCode}');
//                         }
//                       } catch (e) {
//                         Navigator.of(context)
//                             .pop(); // Dismiss loading animation
//                         _showErrorDialog(context, e.toString());
//                       }
//                     },
//                     style: ElevatedButton.styleFrom(
//                       padding:
//                       EdgeInsets.symmetric(horizontal: 20, vertical: 12),
//                       backgroundColor: Colors.teal,
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(10.0),
//                       ),
//                     ),
//                     child: Text(
//                       'Buy Now',
//                       style:
//                       TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         );
//       }),
//     );
//   }
//
//   void _showSuccessDialog(BuildContext context, double totalPrice, CartController cartController) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(12.0),
//           ),
//           child: Container(
//             padding: EdgeInsets.all(16.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(
//                   Icons.check_circle_outline,
//                   color: Colors.green,
//                   size: 50.0,
//                 ),
//                 SizedBox(height: 16.0),
//                 Text(
//                   'Order Placed!',
//                   style: TextStyle(
//                     fontSize: 20.0,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 SizedBox(height: 8.0),
//                 Text(
//                   'You have successfully placed an order of total amount',
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(height: 8.0),
//                 Text(
//                   '₹${totalPrice.toStringAsFixed(2)}',
//                   style: TextStyle(
//                     fontSize: 18.0,
//                     fontWeight: FontWeight.bold,
//                     color: Colors.orange,
//                   ),
//                 ),
//                 SizedBox(height: 16.0),
//                 ElevatedButton(
//                   onPressed: () {
//                     //cartController.clearCart(); // Clear the cart
//                     Navigator.of(context).popUntil(
//                             (route) => route.isFirst); // Go back to HomePage
//                   },
//                   child: Text('OK'),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
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
// // import 'dart:convert'; // For encoding JSON
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:http/http.dart' as http;
// // import 'package:flutter_spinkit/flutter_spinkit.dart';
// // import 'package:evara/controller/cart_component/CartController.dart';
// // import '../../screens/widgets/product_details.dart';
// // import '../UserController.dart';
// //
// //
// // class CheckoutSummaryPage extends StatefulWidget {
// //   @override
// //   _CheckoutSummaryPageState createState() => _CheckoutSummaryPageState();
// // }
// //
// // class _CheckoutSummaryPageState extends State<CheckoutSummaryPage> {
// //   Map<String, String> productOffers = {};
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     loadOffers();
// //   }
// //
// //   Future<void> loadOffers() async {
// //     final offers = await fetchProductOffers();
// //     setState(() {
// //       productOffers = offers;
// //     });
// //   }
// //
// //   Future<Map<String, String>> fetchProductOffers() async {
// //     try {
// //       final response = await http.get(
// //         Uri.parse('https://namami-infotech.com/EvaraBackend/src/sku/offers_sku.php'),
// //       );
// //
// //       if (response.statusCode == 200) {
// //         final offersData = json.decode(response.body);
// //
// //         // Ensure that 'medicines' exists and is not null
// //         if (offersData != null && offersData['medicines'] != null && offersData['medicines'] is List) {
// //           final offersMap = <String, String>{};
// //
// //           // Parse through 'medicines' instead of 'data'
// //           for (var medicine in offersData['medicines']) {
// //             final productId = medicine['medicine_id']?.toString() ?? '';
// //             final formattedOffer = medicine['formatted_offer']?.toString() ?? '';
// //
// //             // Only add the offer if the productId and formattedOffer are valid
// //             if (productId.isNotEmpty && formattedOffer.isNotEmpty) {
// //               offersMap[productId] = formattedOffer;
// //             }
// //           }
// //
// //           return offersMap; // Returns a map of product_id to offer
// //         } else {
// //           print('No valid medicines data found in the response.');
// //           return {}; // Return an empty map if no valid data
// //         }
// //       } else {
// //         throw Exception('Failed to load offers: ${response.statusCode}');
// //       }
// //     } catch (e) {
// //       print('Error fetching offers: $e');
// //       return {};
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     final CartController cartController = Get.find<CartController>();
// //     final UserController userController = Get.find<UserController>();
// //
// //     return Scaffold(
// //       appBar: AppBar(
// //         title: Text('Order Summary'),
// //         backgroundColor: Colors.teal,
// //       ),
// //       body: Obx(() {
// //         final cartItems = cartController.cartItems;
// //         final totalPrice = cartItems.entries.fold(0.0, (total, entry) {
// //           final ptr = entry.value['ptr'] ?? '0';
// //           final sellingPrice = entry.value['sellingPrice'] ?? '0';
// //           final displayPrice = (ptr.isNotEmpty && double.tryParse(ptr) != 0)
// //               ? ptr
// //               : sellingPrice;
// //           final price = double.tryParse(displayPrice) ?? 0;
// //           return total + (price * entry.value['quantity']);
// //         });
// //
// //         return Column(
// //           children: [
// //             Expanded(
// //               child: ListView.builder(
// //                 padding: const EdgeInsets.symmetric(vertical: 10.0),
// //                 itemCount: cartItems.length,
// //                 itemBuilder: (context, index) {
// //                   final medicineId = cartItems.keys.elementAt(index);
// //                   final productDetails = cartItems[medicineId]!;
// //                   final quantity = productDetails['quantity'] as int;
// //
// //                   final ptr = productDetails['ptr'] ?? '0';
// //                   final sellingPrice = productDetails['sellingPrice'] ?? '0';
// //                   final displayPrice = (ptr.isNotEmpty && double.tryParse(ptr) != 0)
// //                       ? ptr
// //                       : sellingPrice;
// //
// //                   final price = double.tryParse(displayPrice) ?? 0;
// //                   final totalAmount = (price * quantity).toStringAsFixed(2);
// //
// //                   // Check if there's an offer for this product
// //                   final offer = productOffers[medicineId] ?? '';
// //
// //                   // Calculate free products based on the offer
// //                   int freeQuantity = 0;
// //                   if (offer.isNotEmpty) {
// //                     final offerParts = RegExp(r'Buy (\d+) Get (\d+)').firstMatch(offer);
// //                     if (offerParts != null) {
// //                       final buyQuantity = int.tryParse(offerParts.group(1) ?? '0') ?? 0;
// //                       final freeOfferQuantity = int.tryParse(offerParts.group(2) ?? '0') ?? 0;
// //                       if (buyQuantity > 0) {
// //                         freeQuantity = (quantity ~/ buyQuantity) * freeOfferQuantity;
// //                       }
// //                     }
// //                   }
// //
// //                   return Card(
// //                     margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
// //                     elevation: 5,
// //                     shape: RoundedRectangleBorder(
// //                       borderRadius: BorderRadius.circular(15.0),
// //                     ),
// //                     child: ListTile(
// //                       leading: Image.network(
// //                         productDetails['imagePath'] ?? '',
// //                         width: 50,
// //                         height: 50,
// //                         fit: BoxFit.cover,
// //                         errorBuilder: (context, error, stackTrace) {
// //                           return Icon(Icons.image, size: 50, color: Colors.grey);
// //                         },
// //                       ),
// //                       title: Text(productDetails['name'] ?? ''),
// //                       subtitle: Column(
// //                         crossAxisAlignment: CrossAxisAlignment.start,
// //                         children: [
// //                           Text('Quantity: $quantity\nAmount: \u{20B9} $totalAmount'),
// //                           if (offer.isNotEmpty) ...[
// //                             Text('Offer: $offer', style: TextStyle(color: Colors.orange)),
// //                             if (freeQuantity > 0)
// //                               Text('You will get $freeQuantity free items!', style: TextStyle(color: Colors.green)),
// //                           ],
// //                         ],
// //                       ),
// //                     ),
// //                   );
// //                 },
// //               ),
// //             ),
// //             // Summary Section
// //             Padding(
// //               padding: const EdgeInsets.all(16.0),
// //               child: Column(
// //                 crossAxisAlignment: CrossAxisAlignment.stretch,
// //                 children: [
// //                   Text(
// //                     'Summary Report',
// //                     style: TextStyle(
// //                       fontSize: 18,
// //                       fontWeight: FontWeight.bold,
// //                       color: Colors.teal,
// //                     ),
// //                     textAlign: TextAlign.center,
// //                   ),
// //                   SizedBox(height: 10),
// //                   Text(
// //                     'Total Items: ${cartItems.length}',
// //                     style: TextStyle(fontSize: 16),
// //                   ),
// //                   SizedBox(height: 5),
// //                   Text(
// //                     'Total Amount: \u{20B9} ${totalPrice.toStringAsFixed(2)}',
// //                     style: TextStyle(
// //                       fontSize: 20,
// //                       fontWeight: FontWeight.bold,
// //                       color: Colors.green,
// //                     ),
// //                   ),
// //                   SizedBox(height: 20),
// //                   ElevatedButton(
// //                     onPressed: () async {
// //                       // Place order logic
// //                     },
// //                     style: ElevatedButton.styleFrom(
// //                       padding:
// //                       EdgeInsets.symmetric(horizontal: 20, vertical: 12),
// //                       backgroundColor: Colors.teal,
// //                       shape: RoundedRectangleBorder(
// //                         borderRadius: BorderRadius.circular(10.0),
// //                       ),
// //                     ),
// //                     child: Text(
// //                       'Buy Now',
// //                       style:
// //                       TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ],
// //         );
// //       }),
// //     );
// //   }
// // }
// //
// //
// //
// // // class CheckoutSummaryPage extends StatelessWidget {
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     final CartController cartController = Get.find<CartController>();
// // //     final UserController userController = Get.find<UserController>();
// // //
// // //
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: Text('Order Summary'),
// // //         backgroundColor: Colors.teal,
// // //       ),
// // //       body: Obx(() {
// // //         final cartItems = cartController.cartItems;
// // //         final totalPrice = cartItems.entries.fold(0.0, (total, entry) {
// // //           final ptr = entry.value['ptr'] ?? '0';
// // //           final sellingPrice = entry.value['sellingPrice'] ?? '0';
// // //           final displayPrice = (ptr.isNotEmpty && double.tryParse(ptr) != 0)
// // //               ? ptr
// // //               : sellingPrice;
// // //           final price = double.tryParse(displayPrice) ?? 0;
// // //           return total + (price * entry.value['quantity']);
// // //         });
// // //
// // //         return Column(
// // //           children: [
// // //             Expanded(
// // //               child: ListView.builder(
// // //                 padding: const EdgeInsets.symmetric(vertical: 10.0),
// // //                 itemCount: cartItems.length,
// // //                 itemBuilder: (context, index) {
// // //                   final medicineId = cartItems.keys.elementAt(index);
// // //                   final productDetails = cartItems[medicineId]!;
// // //                   final quantity = productDetails['quantity'] as int;
// // //
// // //                   final ptr = productDetails['ptr'] ?? '0';
// // //                   final sellingPrice = productDetails['sellingPrice'] ?? '0';
// // //                   final displayPrice =
// // //                       (ptr.isNotEmpty && double.tryParse(ptr) != 0)
// // //                           ? ptr
// // //                           : sellingPrice;
// // //
// // //                   final price = double.tryParse(displayPrice) ?? 0;
// // //                   final totalAmount = (price * quantity).toStringAsFixed(2);
// // //
// // //                   return Card(
// // //                     margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
// // //                     elevation: 5,
// // //                     shape: RoundedRectangleBorder(
// // //                       borderRadius: BorderRadius.circular(15.0),
// // //                     ),
// // //                     child: ListTile(
// // //                       leading: Image.network(
// // //                         productDetails['imagePath'] ?? '',
// // //                         width: 50,
// // //                         height: 50,
// // //                         fit: BoxFit.cover,
// // //                         errorBuilder: (context, error, stackTrace) {
// // //                           return Icon(Icons.image, size: 50, color: Colors.grey);
// // //                         },
// // //                       ),
// // //                       title: Text(productDetails['name'] ?? ''),
// // //                       subtitle: Text(
// // //                           'Quantity: $quantity\nAmount: \u{20B9} $totalAmount'),
// // //                     ),
// // //                   );
// // //                 },
// // //               ),
// // //             ),
// // //             // Summary Section
// // //             Padding(
// // //               padding: const EdgeInsets.all(16.0),
// // //               child: Column(
// // //                 crossAxisAlignment: CrossAxisAlignment.stretch,
// // //                 children: [
// // //                   Text(
// // //                     'Summary Report',
// // //                     style: TextStyle(
// // //                       fontSize: 18,
// // //                       fontWeight: FontWeight.bold,
// // //                       color: Colors.teal,
// // //                     ),
// // //                     textAlign: TextAlign.center,
// // //                   ),
// // //                   SizedBox(height: 10),
// // //                   Text(
// // //                     'Total Items: ${cartItems.length}',
// // //                     style: TextStyle(fontSize: 16),
// // //                   ),
// // //                   SizedBox(height: 5),
// // //                   Text(
// // //                     'Total Amount: \u{20B9} ${totalPrice.toStringAsFixed(2)}',
// // //                     style: TextStyle(
// // //                       fontSize: 20,
// // //                       fontWeight: FontWeight.bold,
// // //                       color: Colors.green,
// // //                     ),
// // //                   ),
// // //                   SizedBox(height: 20),
// // //                   ElevatedButton(
// // //                     onPressed: () async {
// // //                       // Show loading animation
// // //                       showDialog(
// // //                         context: context,
// // //                         barrierDismissible: false,
// // //                         builder: (BuildContext context) {
// // //                           return Center(
// // //                             child: SpinKitCircle(
// // //                               color: Colors.teal,
// // //                               size: 50.0,
// // //                             ),
// // //                           );
// // //                         },
// // //                       );
// // //
// // //                       try {
// // //                         final userId = userController.userId.value;
// // //                         final cartItemsData = cartItems.entries.map((entry) {
// // //                           final productDetails = entry.value;
// // //                           final netQuantity = productDetails['quantity'];
// // //                           final buyQuantity = netQuantity;
// // //                           final offerQuantity =
// // //                               0; // Modify logic for offer if needed
// // //                           return {
// // //                             "product_id": entry.key,
// // //                             "net_quantity": netQuantity,
// // //                             "buy_quantity": buyQuantity,
// // //                             "offer_quantity": offerQuantity,
// // //                           };
// // //                         }).toList();
// // //
// // //                         final orderData = {
// // //                           "user_id": userId,
// // //                           "products": cartItemsData,
// // //                           "status": "pending",
// // //                           "total_amount": totalPrice,
// // //                         };
// // //
// // //                         final response = await http.post(
// // //                           Uri.parse(
// // //                               'https://namami-infotech.com/EvaraBackend/src/order/order_product.php'),
// // //                           headers: {'Content-Type': 'application/json'},
// // //                           body: jsonEncode(orderData),
// // //                         );
// // //
// // //                         if (response.statusCode == 200) {
// // //                           Navigator.of(context)
// // //                               .pop(); // Dismiss loading animation
// // //                           _showSuccessDialog(
// // //                               context, totalPrice, cartController);
// // //                         } else {
// // //                           throw Exception(
// // //                               'Failed to place order. Status code: ${response.statusCode}');
// // //                         }
// // //                       } catch (e) {
// // //                         Navigator.of(context)
// // //                             .pop(); // Dismiss loading animation
// // //                         _showErrorDialog(context, e.toString());
// // //                       }
// // //                     },
// // //                     style: ElevatedButton.styleFrom(
// // //                       padding:
// // //                           EdgeInsets.symmetric(horizontal: 20, vertical: 12),
// // //                       backgroundColor: Colors.teal,
// // //                       shape: RoundedRectangleBorder(
// // //                         borderRadius: BorderRadius.circular(10.0),
// // //                       ),
// // //                     ),
// // //                     child: Text(
// // //                       'Buy Now',
// // //                       style:
// // //                           TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// // //                     ),
// // //                   ),
// // //                 ],
// // //               ),
// // //             ),
// // //           ],
// // //         );
// // //       }),
// // //     );
// // //   }
// // //
// // //   void _showSuccessDialog(
// // //       BuildContext context, double totalPrice, CartController cartController) {
// // //     showDialog(
// // //       context: context,
// // //       builder: (BuildContext context) {
// // //         return Dialog(
// // //           shape: RoundedRectangleBorder(
// // //             borderRadius: BorderRadius.circular(12.0),
// // //           ),
// // //           child: Container(
// // //             padding: EdgeInsets.all(16.0),
// // //             child: Column(
// // //               mainAxisSize: MainAxisSize.min,
// // //               children: [
// // //                 Icon(
// // //                   Icons.check_circle_outline,
// // //                   color: Colors.green,
// // //                   size: 50.0,
// // //                 ),
// // //                 SizedBox(height: 16.0),
// // //                 Text(
// // //                   'Order Placed!',
// // //                   style: TextStyle(
// // //                     fontSize: 20.0,
// // //                     fontWeight: FontWeight.bold,
// // //                   ),
// // //                 ),
// // //                 SizedBox(height: 8.0),
// // //                 Text(
// // //                   'You have successfully placed an order of total amount',
// // //                   textAlign: TextAlign.center,
// // //                 ),
// // //                 SizedBox(height: 8.0),
// // //                 Text(
// // //                   '₹${totalPrice.toStringAsFixed(2)}',
// // //                   style: TextStyle(
// // //                     fontSize: 18.0,
// // //                     fontWeight: FontWeight.bold,
// // //                     color: Colors.orange,
// // //                   ),
// // //                 ),
// // //                 SizedBox(height: 16.0),
// // //                 ElevatedButton(
// // //                   onPressed: () {
// // //                     //cartController.clearCart(); // Clear the cart
// // //                     Navigator.of(context).popUntil(
// // //                         (route) => route.isFirst); // Go back to HomePage
// // //                   },
// // //                   child: Text('OK'),
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //         );
// // //       },
// // //     );
// // //   }
// // //
// // //   void _showErrorDialog(BuildContext context, String errorMessage) {
// // //     showDialog(
// // //       context: context,
// // //       builder: (BuildContext context) {
// // //         return AlertDialog(
// // //           title: Text('Error'),
// // //           content: Text('Failed to place order: $errorMessage'),
// // //           actions: [
// // //             TextButton(
// // //               onPressed: () {
// // //                 Navigator.of(context).pop(); // Close dialog
// // //               },
// // //               child: Text('OK'),
// // //             ),
// // //           ],
// // //         );
// // //       },
// // //     );
// // //   }
// // // }
