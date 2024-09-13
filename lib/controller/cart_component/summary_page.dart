// import 'dart:convert'; // For encoding JSON
// import 'package:evara/utils/urls/urlsclass.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter_spinkit/flutter_spinkit.dart';
// import 'package:evara/controller/cart_component/CartController.dart';
// import '../../screens/support/support_page.dart';
// import '../UserController.dart';
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
//         Uri.parse(
//             'https://namami-infotech.com/EvaraBackend/src/sku/offers_sku.php'),
//       );
//       if (response.statusCode == 200) {
//         final offersData = json.decode(response.body);
//
//         if (offersData != null &&
//             offersData['medicines'] != null &&
//             offersData['medicines'] is List) {
//           final offersMap = <String, String>{};
//
//           for (var medicine in offersData['medicines']) {
//             final productId = medicine['medicine_id']?.toString() ?? '';
//             final formattedOffer =
//                 medicine['formatted_offer']?.toString() ?? '';
//             final ptr = medicine['ptr']?.toString() ?? '0.00';
//
//             if (productId.isNotEmpty &&
//                 formattedOffer.isNotEmpty &&
//                 ptr != '0.00') {
//               offersMap[productId] = formattedOffer;
//             }
//           }
//           return offersMap;
//         } else {
//           print('No valid medicines data found in the response.');
//           return {};
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
//         title: const Text('Order Summary'),
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
//           crossAxisAlignment: CrossAxisAlignment.start,
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
//                   final displayPrice =
//                       (ptr.isNotEmpty && double.tryParse(ptr) != 0)
//                           ? ptr
//                           : sellingPrice;
//
//                   final price = double.tryParse(displayPrice) ?? 0;
//                   final totalAmount = (price * quantity).toStringAsFixed(2);
//
//                   final offer = productOffers[medicineId] ?? '';
//                   int freeQuantity = 0;
//                   if (offer.isNotEmpty) {
//                     final offerParts =
//                         RegExp(r'Buy (\d+) Get (\d+)').firstMatch(offer);
//                     if (offerParts != null) {
//                       final buyQuantity =
//                           int.tryParse(offerParts.group(1) ?? '0') ?? 0;
//                       final freeOfferQuantity =
//                           int.tryParse(offerParts.group(2) ?? '0') ?? 0;
//                       if (buyQuantity > 0) {
//                         freeQuantity =
//                             (quantity ~/ buyQuantity) * freeOfferQuantity;
//                       }
//                     }
//                   }
//
//                   return Card(
//                     margin:
//                         const EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//                     elevation: 5,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(15.0),
//                     ),
//                     child: ListTile(
//                       contentPadding: const EdgeInsets.all(12.0),
//                       leading: Image.network(
//                         productDetails['imagePath'] ?? '',
//                         width: 60,
//                         height: 60,
//                         fit: BoxFit.cover,
//                         errorBuilder: (context, error, stackTrace) {
//                           return const Icon(Icons.image,
//                               size: 60, color: Colors.grey);
//                         },
//                       ),
//                       title: Text(productDetails['name'] ?? '',
//                           style: const TextStyle(
//                               fontWeight: FontWeight.bold, fontSize: 16)),
//                       subtitle: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text('Quantity: $quantity',
//                               style: const TextStyle(
//                                   color: Colors.black,
//                                   fontWeight: FontWeight.bold)),
//                           Text('Amount: \u{20B9} $totalAmount',
//                               style: const TextStyle(
//                                   color: Colors.green,
//                                   fontWeight: FontWeight.bold)),
//                           if (offer.isNotEmpty) ...[
//                             const SizedBox(height: 4),
//                             Text('Offer: $offer',
//                                 style: const TextStyle(
//                                     color: Colors.orange,
//                                     fontWeight: FontWeight.bold)),
//                             if (freeQuantity > 0)
//                               Text(
//                                   'You have unlocked $freeQuantity free items!',
//                                   style: const TextStyle(
//                                       color: Colors.teal,
//                                       fontWeight: FontWeight.bold)),
//                           ],
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.all(16.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.stretch,
//                 children: [
//                   const Text(
//                     'Summary Report',
//                     style: TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.teal,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                   const SizedBox(height: 10),
//                   Text(
//                     'Total Items: ${cartItems.length}',
//                     style: const TextStyle(fontSize: 16),
//                   ),
//                   const SizedBox(height: 5),
//                   Text(
//                     'Total Amount: \u{20B9} ${totalPrice.toStringAsFixed(2)}',
//                     style: const TextStyle(
//                       fontSize: 20,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.green,
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   ElevatedButton(
//                     onPressed: ( ) async {
//                       cartController.clearCart();
//                       showDialog(
//                         context: context,
//                         barrierDismissible: false,
//                         builder: (BuildContext context) {
//                           return const Center(
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
//                           final quantity = productDetails['quantity'];
//                           final buyQuantity = quantity;
//                           final freeQuantity = (productOffers[entry.key] !=
//                                   null)
//                               ? (quantity ~/
//                                       int.parse(RegExp(r'Buy (\d+)')
//                                               .firstMatch(
//                                                   productOffers[entry.key]!)
//                                               ?.group(1) ??
//                                           '1')) *
//                                   (int.parse(RegExp(r'Get (\d+)')
//                                           .firstMatch(productOffers[entry.key]!)
//                                           ?.group(1) ??
//                                       '0'))
//                               : 0;
//                           final offerQuantity = freeQuantity;
//                           final netQuantity = buyQuantity + offerQuantity;
//
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
//                         print('Order Data: ${jsonEncode(orderData)}');
//
//                         final response = await http.post(
//                           Uri.parse(Urlsclass.orderSummaryPageUrl),
//                           headers: {'Content-Type': 'application/json'},
//                           body: jsonEncode(orderData),
//                         );
//
//                         // Print the response for debugging
//                         print('API Response: ${response.body}');
//
//                         if (response.statusCode == 200) {
//                           final responseData = json.decode(response.body);
//                           if (responseData['success'] == true) {
//                             Navigator.of(context).pop();
//                             _showSuccessDialog(context, totalPrice,
//                                 responseData['order_id'] ?? 0, cartController);
//                           } else {
//                             Navigator.of(context).pop();
//                             _showErrorDialog(context,
//                                 responseData['message'] ?? 'An error occurred');
//                           }
//                         } else {
//                           Navigator.of(context).pop();
//                           _showErrorDialog(context,
//                               'Failed to place the order: ${response.statusCode}');
//                         }
//                       } catch (e) {
//                         Navigator.of(context).pop();
//                         _showErrorDialog(context, 'An error occurred: $e');
//                       }
//                     },
//                     child: const Text('Place Order'),
//                     style: ElevatedButton.styleFrom(
//                       //primary: Colors.teal,
//                       padding: const EdgeInsets.symmetric(vertical: 15),
//                       textStyle: const TextStyle(fontSize: 18),
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
//   // Redesigned Success Dialog with enhanced visual appeal
//   void _showSuccessDialog(BuildContext context, double totalAmount, int orderId, CartController cartController) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(15.0),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 Icon(Icons.check_circle, color: Colors.green, size: 60),
//                 SizedBox(height: 16),
//                 Text(
//                   'Order Placed Successfully!',
//                   style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                   textAlign: TextAlign.center,
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   'Order ID: #$orderId',
//                   style: TextStyle(fontSize: 18, color: Colors.teal),
//                 ),
//                 SizedBox(height: 8),
//                 Text(
//                   'Total Amount: \u{20B9} ${totalAmount.toStringAsFixed(2)}',
//                   style: TextStyle(fontSize: 18, color: Colors.orange),
//                 ),
//                 SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: () {
//                     cartController.clearCart();
//                     Navigator.of(context).popUntil((route) => route.isFirst); // Navigate to HomePage
//                   },
//                   style: ElevatedButton.styleFrom(
//                     // primary: Colors.teal,
//                     padding: EdgeInsets.symmetric(horizontal: 40, vertical: 12),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   child: Text('OK', style: TextStyle(fontSize: 18)),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
//
// // Redesigned Error Dialog with better visual design
//   void _showErrorDialog(BuildContext context, String message) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return Dialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(15.0),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(16.0),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               children: [
//                 const Icon(Icons.error_outline, color: Colors.red, size: 60),
//                 const SizedBox(height: 16),
//                 const Text(
//                   'Error',
//                   style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.red),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 8),
//                 Text(
//                   message,
//                   style: const TextStyle(fontSize: 16, color: Colors.black87),
//                   textAlign: TextAlign.center,
//                 ),
//                 const SizedBox(height: 16),
//                 ElevatedButton(
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                     Navigator.of(context).push(
//                       MaterialPageRoute(builder: (context) => SupportPage()), // Navigate to SupportPage
//                     );
//                   },
//                   style: ElevatedButton.styleFrom(
//                     //primary: Colors.red,
//                     padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                   ),
//                   child: const Text('Go to Support', style: TextStyle(fontSize: 18)),
//                 ),
//               ],
//             ),
//           ),
//         );
//       },
//     );
//   }
// }
//


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


