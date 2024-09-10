import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../controller/UserController.dart';

class OrderScreen extends StatelessWidget {
  final UserController userController = Get.find<UserController>();

  Future<List<dynamic>> fetchOrders() async {
    final userId = userController.userId.value;
    final String url = 'https://namami-infotech.com/EvaraBackend/src/order/get_orders.php?user_id=$userId';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['success'] == true) {
          return data['orders'];
        } else {
          throw Exception('Failed to load orders');
        }
      } else {
        throw Exception('Failed to connect to the server');
      }
    } catch (e) {
      print(e.toString());
      return [];
    }
  }

  Widget buildOrderCard(Map<String, dynamic> order, BuildContext context) {
    // Convert status to lowercase for consistent comparison
    String status = order['status'].toString().toUpperCase();

    return Card(
      elevation: 4,
      child: ExpansionTile(
        tilePadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        childrenPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Order ID: ${order['orderId']}',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
            Chip(
              label: Text(
                order['status'].toString().toUpperCase(), // Display original status text
                style: const TextStyle(color: Colors.white),
              ),
              backgroundColor: status == 'REJECTED'
                  ? Colors.red
                  : status == 'ACCEPTED'
                  ? Colors.green
                  : status == 'DELIVERED'
                  ? Colors.teal
                  : Colors.orange,
            ),
          ],
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 8.0),
          child: Row(
            children: [
              const Icon(Icons.currency_rupee, color: Colors.green, size: 18),
              const SizedBox(width: 5),
              Text(
                '${order['total_amount']}',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
              const Spacer(),
              const Icon(Icons.date_range, color: Colors.blue, size: 18),
              const SizedBox(width: 5),
              Text(
                '${order['order_date']}',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        children: [
          const Divider(thickness: 3.0,color: Colors.teal),
          Row(
            children: [
              const Icon(Icons.delivery_dining, color: Colors.purple, size: 18),
              const SizedBox(width: 5),
              Text(
                'Reach by: ${order['reachby_date'] ?? 'Not Available'}',
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Text(
            'Products:',
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 5),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 4.0),
            child: Row(
              children: [
                // Header for Product Name
                Expanded(
                  flex: 5,
                  child: Text(
                    'Product Name',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                  ),
                ),
                SizedBox(width: 10),

                // Header for Buy Qty
                Expanded(
                  flex: 2,
                  child: Text(
                    'Buy Qt.',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(width: 10),
                // Header for Offer Qty
                Expanded(
                  flex: 2,
                  child: Text(
                    'Offer Qt.',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(width: 10),
                Expanded(
                  flex: 2,
                  child: Text(
                    'Net Qt.',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          Column(
            children: List.generate(order['products'].length, (index) {
              final product = order['products'][index];
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    // Expanded section for product name
                    Expanded(
                      flex: 5, // Flex ratio to occupy half of the space
                      child: Text(
                        '${product['product_name']}',
                        style: const TextStyle(fontSize: 14),
                        overflow: TextOverflow.ellipsis, // Handle long product names gracefully
                        maxLines: 5, // Limit to 2 lines if product name is too long
                      ),
                    ),
                    const SizedBox(width: 10), // Spacing between the product name and quantities

                    // Section for buy_quantity
                    Expanded(
                      flex: 2, // Flex ratio for buy_quantity
                      child: Text(
                        '${product['buy_quantity']}',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 5), // Spacing between the quantities

                    // Section for offer_quantity
                    Expanded(
                      flex: 2, // Flex ratio for offer_quantity
                      child: Text(
                        '${product['offer_quantity']}',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(width: 5), // Spacing between the quantities

                    // Section for offer_quantity
                    Expanded(
                      flex: 2, // Flex ratio for offer_quantity
                      child: Text(
                        '${product['net_quantity']}',
                        style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ],
                ),
              );
            }),
          ),

          const Divider(thickness: 3.0,color: Colors.teal),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Remark: ${order['remark'] ?? 'None'}',
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
              ),
              Text(
                'POD: ${order['pod'] ?? 'Not Available'}',
                style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
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
                        return buildOrderCard(orders[index], context);
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
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:http/http.dart' as http;
// import '../../controller/UserController.dart';
//
// class OrderScreen extends StatelessWidget {
//   final UserController userController = Get.find<UserController>();
//
//   Future<List<dynamic>> fetchOrders() async {
//     final userId = userController.userId.value;
//     final String url = 'https://namami-infotech.com/EvaraBackend/src/order/get_orders.php?user_id=$userId';
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
//   Widget buildOrderCard(Map<String, dynamic> order, BuildContext context) {
//     // Convert status to lowercase for consistent comparison
//     String status = order['status'].toString().toUpperCase();
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
//             Chip(
//               label: Text(
//                 order['status'].toString().toUpperCase(), // Display original status text
//                 style: const TextStyle(color: Colors.white),
//               ),
//               backgroundColor: status == 'REJECTED'
//                   ? Colors.red
//                   : status == 'ACCEPTED'
//                   ? Colors.green
//                   : status == 'DELIVERED'
//                   ? Colors.teal
//                   : Colors.orange,
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
//                 '${order['order_date']}',
//                 style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//               ),
//             ],
//           ),
//         ),
//         children: [
//           const Divider(thickness: 3.0,color: Colors.teal),
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
//
// // Header Row for "Product Name", "Buy Qty", and "Offer Qty"
//           const Padding(
//             padding: EdgeInsets.symmetric(vertical: 4.0),
//             child: Row(
//               children: [
//                 // Header for Product Name
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
//
//                 // Header for Buy Qty
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
//                 // Header for Offer Qty
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
//
// // Product List with Name, Buy Qty, and Offer Qty
//           Column(
//             children: List.generate(order['products'].length, (index) {
//               final product = order['products'][index];
//               return Padding(
//                 padding: const EdgeInsets.symmetric(vertical: 4.0),
//                 child: Row(
//                   children: [
//                     // Expanded section for product name
//                     Expanded(
//                       flex: 5, // Flex ratio to occupy half of the space
//                       child: Text(
//                         '${product['product_name']}',
//                         style: const TextStyle(fontSize: 14),
//                         overflow: TextOverflow.ellipsis, // Handle long product names gracefully
//                         maxLines: 5, // Limit to 2 lines if product name is too long
//                       ),
//                     ),
//                     const SizedBox(width: 10), // Spacing between the product name and quantities
//
//                     // Section for buy_quantity
//                     Expanded(
//                       flex: 2, // Flex ratio for buy_quantity
//                       child: Text(
//                         '${product['buy_quantity']}',
//                         style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                     const SizedBox(width: 5), // Spacing between the quantities
//
//                     // Section for offer_quantity
//                     Expanded(
//                       flex: 2, // Flex ratio for offer_quantity
//                       child: Text(
//                         '${product['offer_quantity']}',
//                         style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//                         textAlign: TextAlign.center,
//                       ),
//                     ),
//                     const SizedBox(width: 5), // Spacing between the quantities
//
//                     // Section for offer_quantity
//                     Expanded(
//                       flex: 2, // Flex ratio for offer_quantity
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
//
//           // Text(
//           //   'Products:',
//           //   style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//           // ),
//           // SizedBox(height: 5),
//           // Column(
//           //   children: List.generate(order['products'].length, (index) {
//           //     final product = order['products'][index];
//           //     return Padding(
//           //       padding: const EdgeInsets.symmetric(vertical: 4.0),
//           //       child: Row(
//           //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           //         children: [
//           //           Expanded(
//           //             child: Text(
//           //               '${product['product_name']}',
//           //               style: TextStyle(fontSize: 14),
//           //             ),
//           //           ),
//           //           Text(
//           //             '${product['buy_quantity']}',
//           //             style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//           //           ),
//           //           SizedBox(width: 10,),
//           //           Text(
//           //             '${product['offer_quantity']}',
//           //             style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//           //           ),
//           //         ],
//           //       ),
//           //     );
//           //   }),
//           // ),
//           const Divider(thickness: 3.0,color: Colors.teal),
//           const SizedBox(height: 10),
//           Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Text(
//                 'Remark: ${order['remark'] ?? 'None'}',
//                 style: TextStyle(fontSize: 14, color: Colors.grey[700]),
//               ),
//               Text(
//                 'POD: ${order['pod'] ?? 'Not Available'}',
//                 style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//               ),
//             ],
//           ),
//           const SizedBox(height: 10),
//         ],
//       ),
//     );
//   }
//
//   // Widget buildOrderCard(Map<String, dynamic> order, BuildContext context) {
//   //   return Card(
//   //     elevation: 4,
//   //     child: ExpansionTile(
//   //       tilePadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
//   //       childrenPadding: EdgeInsets.symmetric(horizontal: 15, vertical: 5),
//   //       title: Row(
//   //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //         children: [
//   //           Text(
//   //             'Order ID: ${order['orderId']}',
//   //             style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
//   //           ),
//   //           Chip(
//   //             label: Text(
//   //               order['status'],
//   //               style: TextStyle(color: Colors.white),
//   //             ),
//   //             backgroundColor: order['status'] == 'rejected'
//   //                 ? Colors.red
//   //                 : order['status'] == 'Accepted'
//   //                 ? Colors.green
//   //                 : order['status'] == 'Delivered'
//   //                 ? Colors.teal
//   //                 : Colors.orange,
//   //           ),
//   //         ],
//   //       ),
//   //       subtitle: Padding(
//   //         padding: const EdgeInsets.only(top: 8.0),
//   //         child: Row(
//   //           children: [
//   //             Icon(Icons.currency_rupee, color: Colors.green, size: 18),
//   //             SizedBox(width: 5),
//   //             Text(
//   //               '${order['total_amount']}',
//   //               style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//   //             ),
//   //             Spacer(),
//   //             Icon(Icons.date_range, color: Colors.blue, size: 18),
//   //             SizedBox(width: 5),
//   //             Text(
//   //               '${order['order_date']}',
//   //               style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//   //             ),
//   //           ],
//   //         ),
//   //       ),
//   //       children: [
//   //         Divider(thickness: 3.0,color: Colors.teal),
//   //         Row(
//   //           children: [
//   //             Icon(Icons.delivery_dining, color: Colors.purple, size: 18),
//   //             SizedBox(width: 5),
//   //             Text(
//   //               'Reach by: ${order['reachby_date'] ?? 'Not Available'}',
//   //               style: TextStyle(fontSize: 14, color: Colors.grey[700]),
//   //             ),
//   //           ],
//   //         ),
//   //         SizedBox(height: 8),
//   //         Text(
//   //           'Products:',
//   //           style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
//   //         ),
//   //         SizedBox(height: 5),
//   //         Column(
//   //           children: List.generate(order['products'].length, (index) {
//   //             final product = order['products'][index];
//   //             return Padding(
//   //               padding: const EdgeInsets.symmetric(vertical: 4.0),
//   //               child: Row(
//   //                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //                 children: [
//   //                   Expanded(
//   //                     child: Text(
//   //                       'Product ID: ${product['product_id']}',
//   //                       style: TextStyle(fontSize: 14),
//   //                     ),
//   //                   ),
//   //                   Text(
//   //                     'Qty: ${product['net_quantity']}',
//   //                     style: TextStyle(fontSize: 14, color: Colors.grey[600]),
//   //                   ),
//   //                 ],
//   //               ),
//   //             );
//   //           }),
//   //         ),
//   //         Divider(thickness: 3.0,color: Colors.teal),
//   //         SizedBox(height: 10),
//   //         Row(
//   //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//   //           children: [
//   //             Text(
//   //               'Remark: ${order['remark'] ?? 'None'}',
//   //               style: TextStyle(fontSize: 14, color: Colors.grey[700]),
//   //             ),
//   //             Text(
//   //               'POD: ${order['pod'] ?? 'Not Available'}',
//   //               style: TextStyle(fontSize: 14, fontWeight: FontWeight.w500),
//   //             ),
//   //           ],
//   //         ),
//   //         SizedBox(height: 10),
//   //       ],
//   //     ),
//   //   );
//   // }
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
//                         return buildOrderCard(orders[index], context);
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
