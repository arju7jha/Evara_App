// import 'package:flutter/material.dart';
//
// class ProductDetailsPage extends StatelessWidget {
//   final String imagePath;
//   final String name;
//   final String mrp;
//   final String ptr;
//   final String companyName;
//   final String productDetails;
//   final String salts;
//   final String offer;
//   final String medicineId;
//
//   ProductDetailsPage({
//     required this.imagePath,
//     required this.name,
//     required this.mrp,
//     required this.ptr,
//     required this.companyName,
//     required this.productDetails,
//     required this.salts,
//     required this.offer,
//     required this.medicineId,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     print('Product Details:');
//     print('Medicine ID: $medicineId');
//     print('Name: $name');
//     print('MRP: $mrp');
//     print('PTR: $ptr');
//     print('Company: $companyName');
//     print('Salts: $salts');
//     print('Offer: $offer');
//     print('Description: $productDetails');
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           name,
//           overflow: TextOverflow.ellipsis,
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Color(0xff033464),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // Offer display (if available)
//               if (offer.isNotEmpty)
//                 Align(
//                   alignment: Alignment.topRight,
//                   child: Container(
//                     padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//                     decoration: BoxDecoration(
//                       color: Colors.green,
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Text(
//                       offer,
//                       style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//                     ),
//                   ),
//                 ),
//               Center(
//                 child: Container(
//                   height: 200,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(8.0),
//                     border: Border.all(color: Colors.grey.shade300),
//                     color: Colors.grey.shade100,
//                   ),
//                   child: imagePath.isNotEmpty
//                       ? Image.network(
//                     imagePath,
//                     fit: BoxFit.cover,
//                     errorBuilder: (context, error, stackTrace) {
//                       return Center(
//                         child: Text(
//                           'No Image Uploaded',
//                           style: TextStyle(color: Colors.grey),
//                         ),
//                       );
//                     },
//                   )
//                       : Center(
//                     child: Text(
//                       'No Image Uploaded',
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20),
//               Center(
//                 child: Container(
//                   width: 500, // Set a fixed width for the card
//                   height: 400,
//                   child: Card(
//                     elevation: 2,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(8),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             name,
//                             style: TextStyle(fontSize: 18, fontWeight: FontWeight.normal),
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           SizedBox(height: 10),
//                           Text(
//                             'MRP: $mrp',
//                             style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold, ),
//                           ),
//                           Text(
//                             'PTR: $ptr',
//                             style: TextStyle(fontSize: 23, fontWeight: FontWeight.bold,),
//                           ),
//                           SizedBox(height: 10),
//                           Text(
//                             'Company: $companyName',
//                             style: TextStyle(fontSize: 16, color: Colors.grey[700]),
//                           ),
//                           SizedBox(height: 10),
//                           Text(
//                             'Salts: $salts',
//                             style: TextStyle(fontSize: 16, color: Colors.grey[700]),
//                           ),
//                           SizedBox(height: 20),
//                           Text(
//                             'Description: ${productDetails.isNotEmpty ? productDetails : "No detailed description available ."}',
//                             style: TextStyle(fontSize: 16),
//                           ),
//                         ],
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Row(
//           children: [
//             Expanded(
//               child: ElevatedButton(
//                 onPressed: () {
//                   // Handle add to cart action
//                 },
//                 style: ElevatedButton.styleFrom(
//                   padding: EdgeInsets.symmetric(vertical: 16),
//                   backgroundColor: Colors.orange,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                 ),
//                 child: Text('Add to Cart', style: TextStyle(color: Colors.white, fontSize: 16)),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//

// lib/widgets/product_details_page.dart

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../controller/UserController.dart';
import '../../controller/cart_component/CartController.dart';

class ProductDetailsPage extends StatelessWidget {
  final String imagePath;
  final String name;
  final String mrp;
  final String ptr;
  final String companyName;
  final String productDetails;
  final String salts;
  final String offer;
  final String medicineId;

  ProductDetailsPage({
    required this.imagePath,
    required this.name,
    required this.mrp,
    required this.ptr,
    required this.companyName,
    required this.productDetails,
    required this.salts,
    required this.offer,
    required this.medicineId,
  });

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();
    final UserController userController = Get.find<UserController>();


    return Scaffold(
      appBar: AppBar(
        title: Text(name,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.white)),
        backgroundColor: Color(0xff033464),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (offer.isNotEmpty)
                Align(
                  alignment: Alignment.topRight,
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      offer,
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              Center(
                child: Container(
                  height: 200,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: Colors.grey.shade300),
                    color: Colors.grey.shade100,
                  ),
                  child: imagePath.isNotEmpty
                      ? Image.network(
                          imagePath,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Center(
                              child: Text('No Image Uploaded',
                                  style: TextStyle(color: Colors.grey)),
                            );
                          },
                        )
                      : Center(
                          child: Text('No Image Uploaded',
                              style: TextStyle(color: Colors.grey)),
                        ),
                ),
              ),
              SizedBox(height: 20),
              Center(
                child: Container(
                  width: 500,
                  height: 400,
                  child: Card(
                    elevation: 2,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                                fontSize: 18, fontWeight: FontWeight.normal),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 10),
                          Text('MRP: $mrp',
                              style: TextStyle(
                                  fontSize: 23, fontWeight: FontWeight.bold)),
                          Text('PTR: $ptr',
                              style: TextStyle(
                                  fontSize: 23, fontWeight: FontWeight.bold)),
                          SizedBox(height: 10),
                          Text('Company: $companyName',
                              style:
                                  TextStyle(fontSize: 16, color: Colors.grey)),
                          SizedBox(height: 10),
                          Text('Details: $productDetails',
                              style: TextStyle(fontSize: 16)),
                          SizedBox(height: 10),
                          Text('Salts: $salts', style: TextStyle(fontSize: 16)),
                          SizedBox(height: 10),
                          // Obx(() {
                          //   final isInCart =
                          //       cartController.isInCart(medicineId);
                          //   return ElevatedButton(
                          //     onPressed: () {
                          //       cartController.toggleCartItem(medicineId);
                          //     },
                          //     style: ElevatedButton.styleFrom(
                          //       backgroundColor: Color(0xff033464),
                          //       shape: RoundedRectangleBorder(
                          //         borderRadius: BorderRadius.circular(
                          //             20), // Border radius
                          //       ),
                          //     ),
                          //     child:
                          //         Text(isInCart ? 'Go to Cart' : 'Add to Cart'),
                          //   );
                          // }),
                          Obx(() {
                            final isInCart = cartController.isInCart(medicineId);
                            return ElevatedButton(
                              onPressed: () {
                                if (userController.isLoggedIn.value) {
                                  cartController.toggleCartItem(medicineId);
                                  if (isInCart) {
                                    Get.snackbar('Removed', '$name removed from cart');
                                  } else {
                                    Get.snackbar('Added', '$name added to cart');
                                  }
                                } else {
                                  Get.snackbar('Login Required', 'Please log in to add items to the cart');
                                }
                              },
                              child: Text(isInCart ? 'Go to Cart' : 'Add to Cart'),
                            );
                          }),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// import 'package:flutter/material.dart';
//
// class ProductDetailsPage extends StatelessWidget {
//   final String imagePath;
//   final String name;
//   final String mrp;
//   final String ptr;
//   final String companyName;
//   final String productDetails;
//   final String salts;
//   final String offer;
//
//   ProductDetailsPage({
//     required this.imagePath,
//     required this.name,
//     required this.mrp,
//     required this.ptr,
//     required this.companyName,
//     required this.productDetails,
//     required this.salts,
//     required this.offer,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(
//           name,
//           overflow: TextOverflow.ellipsis,
//           style: TextStyle(color: Colors.white),
//         ),
//         backgroundColor: Color(0xff033464),
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Offer display (if available)
//             if (offer.isNotEmpty)
//               Align(
//                 alignment: Alignment.topRight,
//                 child: Container(
//                   padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//                   decoration: BoxDecoration(
//                     color: Colors.green,
//                     borderRadius: BorderRadius.circular(8),
//                   ),
//                   child: Text(
//                     offer,
//                     style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//                   ),
//                 ),
//               ),
//             Center(
//               child: Container(
//                 height: 200,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(8.0),
//                   border: Border.all(color: Colors.grey.shade300),
//                   color: Colors.grey.shade100,
//                 ),
//                 child: imagePath.isNotEmpty
//                     ? Image.network(
//                   imagePath,
//                   fit: BoxFit.cover,
//                   errorBuilder: (context, error, stackTrace) {
//                     return Center(
//                       child: Text(
//                         'No Image Uploaded',
//                         style: TextStyle(color: Colors.grey),
//                       ),
//                     );
//                   },
//                 )
//                     : Center(
//                   child: Text(
//                     'No Image Uploaded',
//                     style: TextStyle(color: Colors.grey),
//                   ),
//                 ),
//               ),
//             ),
//             SizedBox(height: 20),
//             Card(
//               elevation: 2,
//               shape: RoundedRectangleBorder(
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: Padding(
//                 padding: const EdgeInsets.all(16.0),
//                 child: Column(
//                   crossAxisAlignment: CrossAxisAlignment.start,
//                   children: [
//                     Text(
//                       name,
//                       style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//                       maxLines: 2,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     SizedBox(height: 10),
//                     Text(
//                       'MRP: $mrp',
//                       style: TextStyle(fontSize: 18, color: Colors.grey[600]),
//                     ),
//                     Text(
//                       'PTR: $ptr',
//                       style: TextStyle(fontSize: 18, color: Colors.grey[600]),
//                     ),
//                     SizedBox(height: 10),
//                     Text(
//                       'Company: $companyName',
//                       style: TextStyle(fontSize: 16, color: Colors.grey[700]),
//                     ),
//                     SizedBox(height: 10),
//                     Text(
//                       'Salts: $salts',
//                       style: TextStyle(fontSize: 16, color: Colors.grey[700]),
//                     ),
//                     SizedBox(height: 20),
//                     Text(
//                       productDetails.isNotEmpty
//                           ? productDetails
//                           : 'No detailed description available.',
//                       style: TextStyle(fontSize: 16),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//       bottomNavigationBar: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Row(
//           children: [
//             Expanded(
//               child: ElevatedButton(
//                 onPressed: () {
//                   // Handle buy now action
//                 },
//                 style: ElevatedButton.styleFrom(
//                   padding: EdgeInsets.symmetric(vertical: 16),
//                   backgroundColor: Color(0xff033464),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                 ),
//                 child: Text('Buy Now', style: TextStyle(color: Colors.white, fontSize: 16)),
//               ),
//             ),
//             SizedBox(width: 16),
//             Expanded(
//               child: ElevatedButton(
//                 onPressed: () {
//                   // Handle add to cart action
//                 },
//                 style: ElevatedButton.styleFrom(
//                   padding: EdgeInsets.symmetric(vertical: 16),
//                   backgroundColor: Colors.orange,
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(30),
//                   ),
//                 ),
//                 child: Text('Add to Cart', style: TextStyle(color: Colors.white, fontSize: 16)),
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
