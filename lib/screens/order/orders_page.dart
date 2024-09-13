import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:evara/screens/order/widgets/OrderCard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:evara/controller/UserController.dart';
import '../../utils/urls/urlsclass.dart';

class OrderScreen extends StatelessWidget {
  final UserController userController = Get.find<UserController>();

  Future<List<dynamic>> fetchOrders() async {
    final userId = userController.userId.value;
    final String url = Urlsclass.orderPageUrl + userId;

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return data['success'] == true ? data['orders'] : [];
      } else {
        throw Exception('Failed to connect to the server');
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: FutureBuilder<List<dynamic>>(
                future: fetchOrders(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(child: Text('No orders found'));
                  } else {
                    final orders = snapshot.data!;
                    return ListView.builder(
                      itemCount: orders.length,
                      itemBuilder: (context, index) {
                        final order = orders[index];
                        return OrderCard(order: order);
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}



// import 'dart:convert';
// import 'package:evara/utils/urls/urlsclass.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_file_downloader/flutter_file_downloader.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter/services.dart';
// import '../../controller/UserController.dart';
//
// class OrderScreen extends StatelessWidget {
//   final UserController userController = Get.find<UserController>();
//
//   Future<List<dynamic>> fetchOrders() async {
//     final userId = userController.userId.value;
//     final String url = Urlsclass.orderPageUrl + userId;
//
//     try {
//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         return data['success'] == true ? data['orders'] : [];
//       } else {
//         throw Exception('Failed to connect to the server');
//       }
//     } catch (e) {
//       print(e.toString());
//       return [];
//     }
//   }
//
//   void _showPOD(BuildContext context, String? pod) {
//     if (pod != null && pod.startsWith('data:image')) {
//       final base64Image = pod.split(',')[1];
//       final imageBytes = base64Decode(base64Image);
//       Navigator.push(
//         context,
//         MaterialPageRoute(
//           builder: (_) => Scaffold(
//             appBar: AppBar(title: const Text("POD Image")),
//             body: Center(child: Image.memory(imageBytes)),
//           ),
//         ),
//       );
//     } else {
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text("POD Not Available"),
//           content: const Text("Proof of Delivery is not available for this order."),
//           actions: [
//             TextButton(onPressed: () => Navigator.pop(context), child: const Text("OK")),
//           ],
//         ),
//       );
//     }
//   }
//
//   void _downloadInvoice(String invoiceUrl) {
//     FileDownloader.downloadFile(
//       url: invoiceUrl,
//       onDownloadCompleted: (path) {
//         Get.snackbar(
//           'Download Complete',
//           'Invoice downloaded at $path',
//           snackPosition: SnackPosition.TOP,
//           backgroundColor: Colors.orangeAccent,
//           colorText: Colors.black,
//           margin: const EdgeInsets.all(16.0),
//           borderRadius: 8.0,
//           icon: const Icon(Icons.save_alt_outlined, color: Colors.green),
//           duration: const Duration(seconds: 1),
//         );
//       },
//       onDownloadError: (error) {
//         Get.snackbar(
//           'Download Failed',
//           'Unable to download invoice',
//           snackPosition: SnackPosition.TOP,
//           backgroundColor: Colors.orangeAccent,
//           colorText: Colors.black,
//           margin: const EdgeInsets.all(16.0),
//           borderRadius: 8.0,
//           icon: const Icon(Icons.error, color: Colors.white),
//           duration: const Duration(seconds: 1),
//         );
//       },
//     );
//   }
//
//   Widget _buildGradientButton(String label, Function() onPressed) {
//     return TextButton(
//       onPressed: onPressed,
//       child: ShaderMask(
//         shaderCallback: (Rect bounds) {
//           return const LinearGradient(
//             colors: [Colors.black, Colors.orangeAccent],
//             begin: Alignment.centerLeft,
//             end: Alignment.centerRight,
//           ).createShader(bounds);
//         },
//         child: Text(
//           label,
//           style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
//         ),
//       ),
//     );
//   }
//
//   Widget buildOrderCard(Map<String, dynamic> order, BuildContext context) {
//     String status = order['status'].toString().toUpperCase();
//     String? invoiceUrl = order['invoice_url'];
//
//     return Card(
//       elevation: 4,
//       child: ExpansionTile(
//         tilePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//         childrenPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               'Order ID: ${order['orderId']}',
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//             ),
//             Row(
//               children: [
//                 if (invoiceUrl != null && invoiceUrl.isNotEmpty)
//                   _buildGradientButton('Invoice', () => _downloadInvoice(invoiceUrl)),
//                 Chip(
//                   label: Text(
//                     status,
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                   backgroundColor: _getStatusColor(status),
//                 ),
//               ],
//             ),
//           ],
//         ),
//         subtitle: Padding(
//           padding: const EdgeInsets.only(top: 8.0),
//           child: Row(
//             children: [
//               const Icon(Icons.currency_rupee, color: Colors.green, size: 18),
//               const SizedBox(width: 5),
//               Text(
//                 '${order['total_amount']}',
//                 style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//               ),
//               const Spacer(),
//               const Icon(Icons.date_range, color: Colors.blue, size: 18),
//               const SizedBox(width: 5),
//               Text(
//                 '${order['order_date'].split(' ')[0]}',
//                 style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//               ),
//             ],
//           ),
//         ),
//         children: [
//           const Divider(thickness: 3.0, color: Colors.teal),
//           _buildRow(Icons.delivery_dining, 'Reach by: ${order['reachby_date'] ?? 'Not Available'}'),
//           const SizedBox(height: 8),
//           _buildProductList(order['products']),
//           const Divider(thickness: 3.0, color: Colors.teal),
//           const SizedBox(height: 10),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                 flex: 7,
//                 child: Text(
//                   'Remark: ${order['remark'] ?? 'None'}',
//                   style: TextStyle(fontSize: 14, color: Colors.grey[900]),
//                   overflow: TextOverflow.ellipsis,
//                   maxLines: 5,
//                 ),
//               ),
//               Expanded(
//                 flex: 3,
//                 child: Align(
//                   alignment: Alignment.centerRight,
//                   child: _buildGradientButton('POD', () => _showPOD(context, order['pod'])),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//         ],
//       ),
//     );
//   }
//
//   Widget _buildRow(IconData icon, String text) {
//     return Row(
//       children: [
//         Icon(icon, color: Colors.purple, size: 18),
//         const SizedBox(width: 5),
//         Text(text, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
//       ],
//     );
//   }
//
//   Widget _buildProductList(List<dynamic> products) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         const Text(
//           'Products:',
//           style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//         ),
//         const SizedBox(height: 5),
//         _buildProductHeaders(),
//         Column(
//           children: List.generate(products.length, (index) {
//             final product = products[index];
//             return Padding(
//               padding: const EdgeInsets.symmetric(vertical: 4.0),
//               child: Row(
//                 children: [
//                   _buildExpandedText('${product['product_name']}', flex: 5),
//                   _buildExpandedText('${product['buy_quantity']}', flex: 2, center: true),
//                   _buildExpandedText('${product['offer_quantity']}', flex: 2, center: true),
//                   _buildExpandedText('${product['net_quantity']}', flex: 2, center: true),
//                 ],
//               ),
//             );
//           }),
//         ),
//       ],
//     );
//   }
//
//   Widget _buildProductHeaders() {
//     return const Padding(
//       padding: EdgeInsets.symmetric(vertical: 4.0),
//       child: Row(
//         children: [
//           Expanded(flex: 5, child: Text('Product Name', style: _headerTextStyle)),
//           SizedBox(width: 10),
//           Expanded(flex: 2, child: Text('Buy Qt.', style: _headerTextStyle, textAlign: TextAlign.center)),
//           SizedBox(width: 10),
//           Expanded(flex: 2, child: Text('Offer Qt.', style: _headerTextStyle, textAlign: TextAlign.center)),
//           SizedBox(width: 10),
//           Expanded(flex: 2, child: Text('Net Qt.', style: _headerTextStyle, textAlign: TextAlign.center)),
//         ],
//       ),
//     );
//   }
//
//   static const TextStyle _headerTextStyle = TextStyle(
//     fontSize: 14,
//     fontWeight: FontWeight.bold,
//     color: Colors.teal,
//   );
//
//   Widget _buildExpandedText(String text, {required int flex, bool center = false}) {
//     return Expanded(
//       flex: flex,
//       child: Text(
//         text,
//         style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//         textAlign: center ? TextAlign.center : TextAlign.start,
//       ),
//     );
//   }
//
//   Color _getStatusColor(String status) {
//     switch (status) {
//       case 'REJECTED':
//         return Colors.red;
//       case 'ACCEPTED':
//         return Colors.green;
//       case 'DELIVERED':
//         return Colors.teal;
//       default:
//         return Colors.orange;
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               child: FutureBuilder<List<dynamic>>(
//                 future: fetchOrders(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(child: CircularProgressIndicator());
//                   } else if (snapshot.hasError) {
//                     return Center(child: Text('Error: ${snapshot.error}'));
//                   } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                     return const Center(child: Text('No orders found'));
//                   } else {
//                     return ListView.builder(
//                       itemCount: snapshot.data!.length,
//                       itemBuilder: (context, index) {
//                         return buildOrderCard(snapshot.data![index], context);
//                       },
//                     );
//                   }
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


// import 'dart:convert';
// import 'package:evara/utils/urls/urlsclass.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_file_downloader/flutter_file_downloader.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import 'package:flutter/services.dart';
// import '../../controller/UserController.dart';
//
// class OrderScreen extends StatelessWidget {
//   final UserController userController = Get.find<UserController>();
//
//   Future<List<dynamic>> fetchOrders() async {
//     final userId = userController.userId.value;
//     final String url = Urlsclass.orderPageUrl + userId ;
//
//     // final String url = 'https://namami-infotech.com/EvaraBackend/src/order/get_orders.php?user_id=$userId';
//
//     try {
//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         if (data['success'] == true) {
//           return data['orders'];
//         } else {
//           throw Exception('Failed to load orders');
//         }
//       } else {
//         throw Exception('Failed to connect to the server');
//       }
//     } catch (e) {
//       print(e.toString());
//       return [];
//     }
//   }
//
//   // Method to display the POD image or a popup message
//   void _showPOD(BuildContext context, String? pod) {
//     if (pod != null && pod.startsWith('data:image')) {
//       // Extracting the base64 image from the POD string
//       final base64Image = pod.split(',')[1];
//       final imageBytes = base64Decode(base64Image);
//       Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => Scaffold(
//               appBar: AppBar(title: const Text("POD Image")),
//               body: Center(
//                 child: Image.memory(imageBytes),
//               ),
//             ),
//           ));
//     } else {
//       // Show a popup if POD is not available
//       showDialog(
//         context: context,
//         builder: (context) => AlertDialog(
//           title: const Text("POD Not Available"),
//           content:
//               const Text("Proof of Delivery is not available for this order."),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("OK"),
//             ),
//           ],
//         ),
//       );
//     }
//   }
//
//   Widget buildOrderCard(Map<String, dynamic> order, BuildContext context) {
//     String status = order['status'].toString().toUpperCase();
//     String? invoiceUrl = order['invoice_url'];
//
//     return Card(
//       elevation: 4,
//       child: ExpansionTile(
//         tilePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//         childrenPadding:
//             const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
//         title: Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             Text(
//               'Order ID: ${order['orderId']}',
//               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//             ),
//             Row(
//               children: [
//                 if (invoiceUrl != null && invoiceUrl.isNotEmpty)
//                   TextButton(
//                     onPressed: () async {
//                       FileDownloader.downloadFile(
//                         url: invoiceUrl,
//                         onDownloadCompleted: (path) {
//                           Get.snackbar(
//                             'Download Complete',
//                             'Invoice downloaded at $path',
//                             snackPosition: SnackPosition.TOP,
//                             backgroundColor: Colors.orangeAccent,
//                             colorText: Colors.black,
//                             margin: const EdgeInsets.all(16.0),
//                             borderRadius: 8.0,
//                             isDismissible: true,
//                             duration: const Duration(seconds: 1),
//                             icon: const Icon(
//                               Icons
//                                   .save_alt_outlined, // You can choose any appropriate icon
//                               color: Colors.green,
//                             ),
//                           );
//                         },
//                         onDownloadError: (error) {
//                           Get.snackbar(
//                             'Download Failed',
//                             'Unable to download invoice',
//                             snackPosition: SnackPosition.TOP,
//                             backgroundColor: Colors.orangeAccent,
//                             colorText: Colors.black,
//                             margin: const EdgeInsets.all(16.0),
//                             borderRadius: 8.0,
//                             isDismissible: true,
//                             duration: const Duration(seconds: 1),
//                             icon: const Icon(
//                               Icons
//                                   .error, // You can choose any appropriate icon
//                               color: Colors.white,
//                             ),
//                           );
//                         },
//                       );
//                     },
//                     child: ShaderMask(
//                       shaderCallback: (Rect bounds) {
//                         return LinearGradient(
//                           colors: [
//                             Colors.black,
//                             Colors.orangeAccent,
//                           ], // Customize your gradient colors
//                           begin: Alignment.centerLeft,
//                           end: Alignment.centerRight,
//                         ).createShader(bounds);
//                       },
//                       child: Text(
//                         'Invoice',
//                         style: TextStyle(
//                           fontSize: 16.0,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                   ),
//                 Chip(
//                   label: Text(
//                     status,
//                     style: const TextStyle(color: Colors.white),
//                   ),
//                   backgroundColor: status == 'REJECTED'
//                       ? Colors.red
//                       : status == 'ACCEPTED'
//                           ? Colors.green
//                           : status == 'DELIVERED'
//                               ? Colors.teal
//                               : Colors.orange,
//                 ),
//               ],
//             ),
//           ],
//         ),
//         subtitle: Padding(
//           padding: const EdgeInsets.only(top: 8.0),
//           child: Row(
//             children: [
//               const Icon(Icons.currency_rupee, color: Colors.green, size: 18),
//               const SizedBox(width: 5),
//               Text(
//                 '${order['total_amount']}',
//                 style:
//                     const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//               ),
//               const Spacer(),
//               const Icon(Icons.date_range, color: Colors.blue, size: 18),
//               const SizedBox(width: 5),
//               Text(
//                 '${order['order_date'].split(' ')[0]}',
//                 style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//               ),
//               // Text(
//               //   '${order['order_date']}',
//               //   style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//               // ),
//             ],
//           ),
//         ),
//         children: [
//           const Divider(thickness: 3.0, color: Colors.teal),
//           Row(
//             children: [
//               const Icon(Icons.delivery_dining, color: Colors.purple, size: 18),
//               const SizedBox(width: 5),
//               Text(
//                 'Reach by: ${order['reachby_date'] ?? 'Not Available'}',
//                 style: TextStyle(fontSize: 14, color: Colors.grey[700]),
//               ),
//             ],
//           ),
//           const SizedBox(height: 8),
//           const Text(
//             'Products:',
//             style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//           ),
//           const SizedBox(height: 5),
//           const Padding(
//             padding: EdgeInsets.symmetric(vertical: 4.0),
//             child: Row(
//               children: [
//                 Expanded(
//                   flex: 5,
//                   child: Text(
//                     'Product Name',
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.teal,
//                     ),
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 Expanded(
//                   flex: 2,
//                   child: Text(
//                     'Buy Qt.',
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.teal,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 Expanded(
//                   flex: 2,
//                   child: Text(
//                     'Offer Qt.',
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.teal,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//                 SizedBox(width: 10),
//                 Expanded(
//                   flex: 2,
//                   child: Text(
//                     'Net Qt.',
//                     style: TextStyle(
//                       fontSize: 14,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.teal,
//                     ),
//                     textAlign: TextAlign.center,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           Column(
//             children: List.generate(order['products'].length, (index) {
//               final product = order['products'][index];
//               return Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 4.0),
//                 child: Row(
//                   children: [
//                     Expanded(
//                       flex: 5,
//                       child: Text(
//                         '${product['product_name']}',
//                         style: const TextStyle(fontSize: 14),
//                         overflow: TextOverflow.ellipsis,
//                         maxLines: 5,
//                       ),
//                     ),
//                     const SizedBox(width: 10),
//                     Expanded(
//                       flex: 2,
//                       child: Text(
//                         '${product['buy_quantity']}',
//                         style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                     const SizedBox(width: 5),
//                     Expanded(
//                       flex: 2,
//                       child: Text(
//                         '${product['offer_quantity']}',
//                         style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                     const SizedBox(width: 5),
//                     Expanded(
//                       flex: 2,
//                       child: Text(
//                         '${product['net_quantity']}',
//                         style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             }),
//           ),
//           const Divider(thickness: 3.0, color: Colors.teal),
//           const SizedBox(height: 10),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Expanded(
//                 flex: 7,
//                 child: Text(
//                   'Remark: ${order['remark'] ?? 'None'}',
//                   style: TextStyle(fontSize: 14, color: Colors.grey[900]),
//                   overflow: TextOverflow.ellipsis,
//                   maxLines: 5,
//                 ),
//               ),
//               Expanded(
//                 flex: 3,
//                 child: Align(
//                   alignment: Alignment.centerRight,
//                   child: TextButton(
//
//                     onPressed: () => _showPOD(context, order['pod']),
//                     child: ShaderMask(
//                       shaderCallback: (Rect bounds) {
//                         return LinearGradient(
//                           colors: [
//                             Colors.black,
//                             Colors.orangeAccent,
//                           ], // Customize your gradient colors
//                           begin: Alignment.centerLeft,
//                           end: Alignment.centerRight,
//                         ).createShader(bounds);
//                       },
//                       child: Text(
//                         'POD',
//                         style: TextStyle(
//                           fontSize: 16.0,
//                           fontWeight: FontWeight.bold,
//                         ),
//                       ),
//                     ),
//                     // child: const Text(
//                     //   'POD',
//                     //   style: TextStyle(
//                     //       color: Colors.blue, fontWeight: FontWeight.bold),
//                     // ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//         ],
//       ),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(10.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               child: FutureBuilder<List<dynamic>>(
//                 future: fetchOrders(),
//                 builder: (context, snapshot) {
//                   if (snapshot.connectionState == ConnectionState.waiting) {
//                     return const Center(child: CircularProgressIndicator());
//                   } else if (snapshot.hasError) {
//                     return Center(child: Text('Error: ${snapshot.error}'));
//                   } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
//                     return const Center(child: Text('No orders found'));
//                   } else {
//                     final orders = snapshot.data!;
//                     return ListView.builder(
//                       itemCount: orders.length,
//                       itemBuilder: (context, index) {
//                         final order = orders[index];
//                         return buildOrderCard(order, context);
//                       },
//                     );
//                   }
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
//
//
//
//
// // import 'dart:convert';
// // import 'package:flutter/material.dart';
// // import 'package:get/get.dart';
// // import 'package:http/http.dart' as http;
// // import '../../controller/UserController.dart';
// //
// // class OrderScreen extends StatelessWidget {
// //   final UserController userController = Get.find<UserController>();
// //
// //   Future<List<dynamic>> fetchOrders() async {
// //     final userId = userController.userId.value;
// //     final String url = 'https://namami-infotech.com/EvaraBackend/src/order/get_orders.php?user_id=$userId';
// //
// //     try {
// //       final response = await http.get(Uri.parse(url));
// //       if (response.statusCode == 200) {
// //         final data = jsonDecode(response.body);
// //         if (data['success'] == true) {
// //           return data['orders'];
// //         } else {
// //           throw Exception('Failed to load orders');
// //         }
// //       } else {
// //         throw Exception('Failed to connect to the server');
// //       }
// //     } catch (e) {
// //       print(e.toString());
// //       return [];
// //     }
// //   }
// //
// //   Widget buildOrderCard(Map<String, dynamic> order, BuildContext context) {
// //     String status = order['status'].toString().toUpperCase();
// //
// //     return Card(
// //       elevation: 4,
// //       child: ExpansionTile(
// //         tilePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
// //         childrenPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
// //         title: Row(
// //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //           children: [
// //             Text(
// //               'Order ID: ${order['orderId']}',
// //               style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
// //             ),
// //             Chip(
// //               label: Text(
// //                 order['status'].toString().toUpperCase(), // Display original status text
// //                 style: const TextStyle(color: Colors.white),
// //               ),
// //               backgroundColor: status == 'REJECTED'
// //                   ? Colors.red
// //                   : status == 'ACCEPTED'
// //                   ? Colors.green
// //                   : status == 'DELIVERED'
// //                   ? Colors.teal
// //                   : Colors.orange,
// //             ),
// //           ],
// //         ),
// //         subtitle: Padding(
// //           padding: const EdgeInsets.only(top: 8.0),
// //           child: Row(
// //             children: [
// //               const Icon(Icons.currency_rupee, color: Colors.green, size: 18),
// //               const SizedBox(width: 5),
// //               Text(
// //                 '${order['total_amount']}',
// //                 style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
// //               ),
// //               const Spacer(),
// //               const Icon(Icons.date_range, color: Colors.blue, size: 18),
// //               const SizedBox(width: 5),
// //               Text(
// //                 '${order['order_date']}',
// //                 style: TextStyle(fontSize: 14, color: Colors.grey[600]),
// //               ),
// //             ],
// //           ),
// //         ),
// //         children: [
// //           const Divider(thickness: 3.0,color: Colors.teal),
// //           Row(
// //             children: [
// //               const Icon(Icons.delivery_dining, color: Colors.purple, size: 18),
// //               const SizedBox(width: 5),
// //               Text(
// //                 'Reach by: ${order['reachby_date'] ?? 'Not Available'}',
// //                 style: TextStyle(fontSize: 14, color: Colors.grey[700]),
// //               ),
// //             ],
// //           ),
// //           const SizedBox(height: 8),
// //           const Text(
// //             'Products:',
// //             style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
// //           ),
// //           const SizedBox(height: 5),
// //           const Padding(
// //             padding: EdgeInsets.symmetric(vertical: 4.0),
// //             child: Row(
// //               children: [
// //                 // Header for Product Name
// //                 Expanded(
// //                   flex: 5,
// //                   child: Text(
// //                     'Product Name',
// //                     style: TextStyle(
// //                       fontSize: 14,
// //                       fontWeight: FontWeight.bold,
// //                       color: Colors.teal,
// //                     ),
// //                   ),
// //                 ),
// //                 SizedBox(width: 10),
// //
// //                 // Header for Buy Qty
// //                 Expanded(
// //                   flex: 2,
// //                   child: Text(
// //                     'Buy Qt.',
// //                     style: TextStyle(
// //                       fontSize: 14,
// //                       fontWeight: FontWeight.bold,
// //                       color: Colors.teal,
// //                     ),
// //                     textAlign: TextAlign.center,
// //                   ),
// //                 ),
// //                 SizedBox(width: 10),
// //                 // Header for Offer Qty
// //                 Expanded(
// //                   flex: 2,
// //                   child: Text(
// //                     'Offer Qt.',
// //                     style: TextStyle(
// //                       fontSize: 14,
// //                       fontWeight: FontWeight.bold,
// //                       color: Colors.teal,
// //                     ),
// //                     textAlign: TextAlign.center,
// //                   ),
// //                 ),
// //                 SizedBox(width: 10),
// //                 Expanded(
// //                   flex: 2,
// //                   child: Text(
// //                     'Net Qt.',
// //                     style: TextStyle(
// //                       fontSize: 14,
// //                       fontWeight: FontWeight.bold,
// //                       color: Colors.teal,
// //                     ),
// //                     textAlign: TextAlign.center,
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //           Column(
// //             children: List.generate(order['products'].length, (index) {
// //               final product = order['products'][index];
// //               return Padding(
// //                 padding: const EdgeInsets.symmetric(vertical: 4.0),
// //                 child: Row(
// //                   children: [
// //                     // Expanded section for product name
// //                     Expanded(
// //                       flex: 5, // Flex ratio to occupy half of the space
// //                       child: Text(
// //                         '${product['product_name']}',
// //                         style: const TextStyle(fontSize: 14),
// //                         overflow: TextOverflow.ellipsis, // Handle long product names gracefully
// //                         maxLines: 5, // Limit to 2 lines if product name is too long
// //                       ),
// //                     ),
// //                     const SizedBox(width: 10), // Spacing between the product name and quantities
// //
// //                     // Section for buy_quantity
// //                     Expanded(
// //                       flex: 2, // Flex ratio for buy_quantity
// //                       child: Text(
// //                         '${product['buy_quantity']}',
// //                         style: TextStyle(fontSize: 14, color: Colors.grey[600]),
// //                         textAlign: TextAlign.center,
// //                       ),
// //                     ),
// //                     const SizedBox(width: 5), // Spacing between the quantities
// //
// //                     // Section for offer_quantity
// //                     Expanded(
// //                       flex: 2, // Flex ratio for offer_quantity
// //                       child: Text(
// //                         '${product['offer_quantity']}',
// //                         style: TextStyle(fontSize: 14, color: Colors.grey[600]),
// //                         textAlign: TextAlign.center,
// //                       ),
// //                     ),
// //                     const SizedBox(width: 5), // Spacing between the quantities
// //
// //                     // Section for offer_quantity
// //                     Expanded(
// //                       flex: 2, // Flex ratio for offer_quantity
// //                       child: Text(
// //                         '${product['net_quantity']}',
// //                         style: TextStyle(fontSize: 14, color: Colors.grey[600]),
// //                         textAlign: TextAlign.center,
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               );
// //             }),
// //           ),
// //
// //           const Divider(thickness: 3.0,color: Colors.teal),
// //           const SizedBox(height: 10),
// //           Row(
// //             mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //             children: [
// //               Expanded(
// //                 flex: 7,
// //                 child: Text(
// //                   'Remark: ${order['remark'] ?? 'None'}',
// //                   style: TextStyle(fontSize: 14, color: Colors.grey[900]),
// //                   overflow: TextOverflow.ellipsis, // Handle long product names gracefully
// //                   maxLines: 5,
// //                 ),
// //               ),
// //               Expanded(
// //                 flex: 3,
// //                 child: Align(
// //                   alignment: Alignment.centerRight,
// //                   child: Text(
// //                     'POD: ${order['pod']}',
// //                     style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //           const SizedBox(height: 10),
// //         ],
// //       ),
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: Padding(
// //         padding: const EdgeInsets.all(10.0),
// //         child: Column(
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Expanded(
// //               child: FutureBuilder<List<dynamic>>(
// //                 future: fetchOrders(),
// //                 builder: (context, snapshot) {
// //                   if (snapshot.connectionState == ConnectionState.waiting) {
// //                     return const Center(child: CircularProgressIndicator());
// //                   } else if (snapshot.hasError) {
// //                     return Center(child: Text('Error: ${snapshot.error}'));
// //                   } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
// //                     return const Center(child: Text('No orders found'));
// //                   } else {
// //                     final orders = snapshot.data!;
// //                     return ListView.builder(
// //                       itemCount: orders.length,
// //                       itemBuilder: (context, index) {
// //                         return buildOrderCard(orders[index], context);
// //                       },
// //                     );
// //                   }
// //                 },
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// //
// //
