import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
            final price = double.tryParse(productDetails['ptr'] ?? '0') ?? 0;
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
                          width: 70,
                          height: 70,
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
                                    fontSize: 16,
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
                                  fontSize: 16,
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
          final price = double.tryParse(entry.value['ptr'] ?? '0') ?? 0;
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
              Text(
                'Total Amount:',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              Text(
                '\u{20B9} ${totalPrice.toStringAsFixed(2)}',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
              ),
            ],
          ),
        );
      }),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
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
//             return Card(
//               margin: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
//               elevation: 5,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(15.0),
//               ),
//               child: Row(
//                 children: [
//                   // Product Image
//                   Padding(
//                     padding: const EdgeInsets.all(8.0),
//                     child: ClipRRect(
//                       borderRadius: BorderRadius.circular(10.0),
//                       child: Image.network(
//                         productDetails['imagePath'] ?? '',
//                         width: 70,
//                         height: 70,
//                         fit: BoxFit.cover,
//                         errorBuilder: (context, error, stackTrace) {
//                           return Icon(Icons.image, size: 70, color: Colors.grey);
//                         },
//                       ),
//                     ),
//                   ),
//                   // Product Info
//                   Expanded(
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // First Row: Name & Delete Button
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Expanded(
//                               child: Text(
//                                 productDetails['name'] ?? '',
//                                 style: TextStyle(
//                                   fontWeight: FontWeight.bold,
//                                   fontSize: 16,
//                                 ),
//                                 overflow: TextOverflow.ellipsis,
//                               ),
//                             ),
//                             IconButton(
//                               icon: Icon(Icons.delete, color: Colors.red),
//                               onPressed: () {
//                                 cartController.removeCartItem(medicineId);
//                               },
//                             ),
//                           ],
//                         ),
//                         // Second Row: Amount & Quantity Adjustment
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             Text(
//                               'Amount: ${totalAmount}',
//                               style: TextStyle(
//                                 fontWeight: FontWeight.bold,
//                                 fontSize: 16,
//                                 color: Colors.green,
//                               ),
//                             ),
//                             Row(
//                               children: [
//                                 IconButton(
//                                   icon: Icon(Icons.remove_circle_outline, color: Colors.blue),
//                                   onPressed: () {
//                                     if (quantity > 1) {
//                                       cartController.updateCartItem(medicineId, productDetails, quantity - 1);
//                                     }
//                                   },
//                                 ),
//                                 Container(
//                                   width: 40, height: 30,//margin: EdgeInsets.only(bottom:10),
//                                   child: TextField(
//                                     textAlign: TextAlign.center,
//                                     keyboardType: TextInputType.number,
//                                     decoration: InputDecoration(
//                                       border: OutlineInputBorder(),
//                                       contentPadding: EdgeInsets.symmetric(horizontal: 8),
//                                     ),
//                                     controller: TextEditingController(text: quantity.toString()),
//                                     onSubmitted: (value) {
//                                       final newQuantity = int.tryParse(value) ?? 0;
//                                       cartController.updateCartItem(medicineId, productDetails, newQuantity);
//                                     },
//                                   ),
//                                 ),
//                                 IconButton(
//                                   icon: Icon(Icons.add_circle_outline, color: Colors.blue),
//                                   onPressed: () {
//                                     cartController.updateCartItem(medicineId, productDetails, quantity + 1);
//                                   },
//                                 ),
//                               ],
//                             ),
//                           ],
//                         ),
//                       ],
//                     ),
//                   ),
//                 ],
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
//               Text(
//                 'Total Amount:',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//               ),
//               Text(
//                 '${totalPrice.toStringAsFixed(2)}',
//                 style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.green),
//               ),
//             ],
//           ),
//         );
//       }),
//     );
//   }
// }


// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import '../../controller/cart_component/CartController.dart';
//
// class ShoppingCartPage extends StatelessWidget {
//   final CartController cartController = Get.find<CartController>();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Shopping Cart'),
//         actions: [
//           Padding(
//             padding: const EdgeInsets.only(right: 16.0),
//             child: Center(
//               child: Obx(() => Text(
//                 'Items: ${cartController.cartItems.length}',
//                 style: TextStyle(fontSize: 18),
//               )),
//             ),
//           ),
//         ],
//       ),
//       body: Column(
//         children: [
//           Expanded(
//             child: Obx(() {
//               return ListView.builder(
//                 itemCount: cartController.cartItems.length,
//                 itemBuilder: (context, index) {
//                   final cartItem = cartController.cartItems[index];
//                   return Card(
//                     margin: EdgeInsets.all(8.0),
//                     child: ListTile(
//                       leading: Icon(Icons.shopping_bag, size: 40),
//                       title: Text(cartItem.name),
//                       subtitle: Text('Price: \$${cartItem.price.toStringAsFixed(2)}'),
//                       trailing: Container(
//                         width: 120,
//                         child: Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             IconButton(
//                               icon: Icon(Icons.remove_circle_outline),
//                               onPressed: () => cartController.decreaseQuantity(cartItem),
//                             ),
//                             Text('${cartItem.quantity}'),
//                             IconButton(
//                               icon: Icon(Icons.add_circle_outline),
//                               onPressed: () => cartController.increaseQuantity(cartItem),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   );
//                 },
//               );
//             }),
//           ),
//           Container(
//             padding: EdgeInsets.all(16.0),
//             child: Obx(() => Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Text(
//                   'Total:',
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//                 Text(
//                   '\$${cartController.totalPrice.toStringAsFixed(2)}',
//                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
//                 ),
//               ],
//             )),
//           ),
//         ],
//       ),
//     );
//   }
// }
//
//
// //
// // // import 'package:flutter/material.dart';
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
// // // class ShoppingCartPage extends StatefulWidget {
// // //   @override
// // //   _ShoppingCartPageState createState() => _ShoppingCartPageState();
// // // }
// // //
// // // class _ShoppingCartPageState extends State<ShoppingCartPage> {
// // //   List<CartItem> cartItems = [
// // //     CartItem(name: 'Product 1', price: 29.99),
// // //     CartItem(name: 'Product 2', price: 19.99),
// // //     CartItem(name: 'Product 3', price: 9.99),
// // //   ];
// // //
// // //   double get totalPrice => cartItems.fold(0, (total, item) => total + (item.price * item.quantity));
// // //
// // //   void _increaseQuantity(int index) {
// // //     setState(() {
// // //       cartItems[index].quantity++;
// // //     });
// // //   }
// // //
// // //   void _decreaseQuantity(int index) {
// // //     setState(() {
// // //       if (cartItems[index].quantity > 1) {
// // //         cartItems[index].quantity--;
// // //       }
// // //     });
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       appBar: AppBar(
// // //         title: Text('Shopping Cart'),
// // //         actions: [
// // //           Padding(
// // //             padding: const EdgeInsets.only(right: 16.0),
// // //             child: Center(
// // //               child: Text(
// // //                 'Items: ${cartItems.length}',
// // //                 style: TextStyle(fontSize: 18),
// // //               ),
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //       body: Column(
// // //         children: [
// // //           Expanded(
// // //             child: ListView.builder(
// // //               itemCount: cartItems.length,
// // //               itemBuilder: (context, index) {
// // //                 return Card(
// // //                   margin: EdgeInsets.all(8.0),
// // //                   child: ListTile(
// // //                     leading: Icon(Icons.shopping_bag, size: 40),
// // //                     title: Text(cartItems[index].name),
// // //                     subtitle: Text('Price: \$${cartItems[index].price.toStringAsFixed(2)}'),
// // //                     trailing: Container(
// // //                       width: 120,
// // //                       child: Row(
// // //                         mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //                         children: [
// // //                           IconButton(
// // //                             icon: Icon(Icons.remove_circle_outline),
// // //                             onPressed: () => _decreaseQuantity(index),
// // //                           ),
// // //                           Text('${cartItems[index].quantity}'),
// // //                           IconButton(
// // //                             icon: Icon(Icons.add_circle_outline),
// // //                             onPressed: () => _increaseQuantity(index),
// // //                           ),
// // //                         ],
// // //                       ),
// // //                     ),
// // //                   ),
// // //                 );
// // //               },
// // //             ),
// // //           ),
// // //           Container(
// // //             padding: EdgeInsets.all(16.0),
// // //             child: Row(
// // //               mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //               children: [
// // //                 Text(
// // //                   'Total:',
// // //                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
// // //                 ),
// // //                 Text(
// // //                   '\$${totalPrice.toStringAsFixed(2)}',
// // //                   style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
// // //                 ),
// // //               ],
// // //             ),
// // //           ),
// // //         ],
// // //       ),
// // //     );
// // //   }
// // // }
