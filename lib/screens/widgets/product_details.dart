import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/UserController.dart';
import '../../controller/cart_component/CartController.dart';
import '../../controller/cart_component/ShoppingCartPage.dart';

class ProductDetailsPage extends StatelessWidget {
  final String imagePath;
  final String name;
  final String mrp;
  final String ptr;
  final String sellingPrice; // Added sellingPrice parameter
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
    required this.sellingPrice, // Initialized sellingPrice
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

    // Determine the price to display
    final displayPrice = ptr.isNotEmpty && double.tryParse(ptr) != 0 ? ptr : sellingPrice;

    return Scaffold(
      appBar: AppBar(
        title: Text(name,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: Colors.white)),
        //backgroundColor: Color(0xff033464),
        actions: [
          IconButton(
            icon: Icon(Icons.add_shopping_cart_outlined, size: 30, color: Colors.orange,),
            padding: EdgeInsets.only(right: 20),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => ShoppingCartPage()),
              );
            },
          ),
        ],
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
                          Text('Price: $displayPrice',
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

                          Obx(() {
                            final quantity = cartController.getProductDetails(medicineId)?['quantity'] ?? 0;
                            return quantity > 0
                                ? Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove_circle_outline),
                                  onPressed: () {
                                    cartController.updateCartItem(
                                      medicineId,
                                      {
                                        'imagePath': imagePath,
                                        'name': name,
                                        'mrp': mrp,
                                        'ptr': ptr,
                                        'sellingPrice': sellingPrice, // Include sellingPrice
                                        'companyName': companyName,
                                        'productDetails': productDetails,
                                        'salts': salts,
                                        'offer': offer,
                                      },
                                      quantity - 1,
                                    );
                                  },
                                ),
                                Container(
                                  width: 40,
                                  height: 30,
                                  child: TextField(
                                    keyboardType: TextInputType.number,
                                    textAlign: TextAlign.center,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                                    ),
                                    controller: TextEditingController(text: quantity.toString()),
                                    onSubmitted: (value) {
                                      final newQuantity = int.tryParse(value) ?? 0;
                                      cartController.updateCartItem(
                                        medicineId,
                                        {
                                          'imagePath': imagePath,
                                          'name': name,
                                          'mrp': mrp,
                                          'ptr': ptr,
                                          'sellingPrice': sellingPrice, // Include sellingPrice
                                          'companyName': companyName,
                                          'productDetails': productDetails,
                                          'salts': salts,
                                          'offer': offer,
                                        },
                                        newQuantity,
                                      );
                                    },
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.add_circle_outline),
                                  onPressed: () {
                                    cartController.updateCartItem(
                                      medicineId,
                                      {
                                        'imagePath': imagePath,
                                        'name': name,
                                        'mrp': mrp,
                                        'ptr': ptr,
                                        'sellingPrice': sellingPrice, // Include sellingPrice
                                        'companyName': companyName,
                                        'productDetails': productDetails,
                                        'salts': salts,
                                        'offer': offer,
                                      },
                                      quantity + 1,
                                    );
                                  },
                                ),
                              ],
                            )
                                : ElevatedButton(
                              onPressed: () {
                                if (userController.isLoggedIn.value) {
                                  Get.snackbar(
                                    'Item added',
                                    '$name added to cart',
                                    backgroundColor: Colors.black,
                                    colorText: Colors.orangeAccent,
                                    snackPosition: SnackPosition.BOTTOM,
                                    margin: EdgeInsets.all(16.0),
                                    borderRadius: 8.0, // Border radius
                                    isDismissible: true, // Allow dismissing by tapping outside

                                  );
                                  cartController.updateCartItem(
                                    medicineId,
                                    {
                                      'imagePath': imagePath,
                                      'name': name,
                                      'mrp': mrp,
                                      'ptr': ptr,
                                      'sellingPrice': sellingPrice, // Include sellingPrice
                                      'companyName': companyName,
                                      'productDetails': productDetails,
                                      'salts': salts,
                                      'offer': offer,
                                    },
                                    1,
                                  );
                                } else {
                                  Get.snackbar(
                                    'Login Required',
                                    'Please log in to add items to the cart',
                                    backgroundColor: Colors.orangeAccent,
                                    colorText: Colors.black,
                                    snackPosition: SnackPosition.BOTTOM,
                                    margin: EdgeInsets.all(16.0),
                                    borderRadius: 8.0, // Border radius
                                    isDismissible: true, // Allow dismissing by tapping outside

                                  );
                                }
                              },
                              child: Text('Add to Cart'),
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
// import 'package:get/get.dart';
// import '../../controller/UserController.dart';
// import '../../controller/cart_component/CartController.dart';
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
//     final CartController cartController = Get.find<CartController>();
//     final UserController userController = Get.find<UserController>();
//
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(name,
//             overflow: TextOverflow.ellipsis,
//             style: TextStyle(color: Colors.white)),
//         backgroundColor: Color(0xff033464),
//       ),
//       body: SingleChildScrollView(
//         child: Padding(
//           padding: const EdgeInsets.all(16.0),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
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
//                       style: TextStyle(
//                           color: Colors.white, fontWeight: FontWeight.bold),
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
//                         child: Text('No Image Uploaded',
//                             style: TextStyle(color: Colors.grey)),
//                       );
//                     },
//                   )
//                       : Center(
//                     child: Text('No Image Uploaded',
//                         style: TextStyle(color: Colors.grey)),
//                   ),
//                 ),
//               ),
//               SizedBox(height: 20),
//               Center(
//                 child: Container(
//                   width: 500,
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
//                             style: TextStyle(
//                                 fontSize: 18, fontWeight: FontWeight.normal),
//                             maxLines: 2,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           SizedBox(height: 10),
//                           Text('MRP: $mrp',
//                               style: TextStyle(
//                                   fontSize: 23, fontWeight: FontWeight.bold)),
//                           Text('PTR: $ptr',
//                               style: TextStyle(
//                                   fontSize: 23, fontWeight: FontWeight.bold)),
//                           SizedBox(height: 10),
//                           Text('Company: $companyName',
//                               style:
//                               TextStyle(fontSize: 16, color: Colors.grey)),
//                           SizedBox(height: 10),
//                           Text('Details: $productDetails',
//                               style: TextStyle(fontSize: 16)),
//                           SizedBox(height: 10),
//                           Text('Salts: $salts', style: TextStyle(fontSize: 16)),
//                           SizedBox(height: 10),
//
//                           Obx(() {
//                             final quantity = cartController.getProductDetails(medicineId)?['quantity'] ?? 0;
//                             return quantity > 0
//                                 ? Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 IconButton(
//                                   icon: Icon(Icons.remove_circle_outline),
//                                   onPressed: () {
//                                     cartController.updateCartItem(
//                                       medicineId,
//                                       {
//                                         'imagePath': imagePath,
//                                         'name': name,
//                                         'mrp': mrp,
//                                         'ptr': ptr,
//                                         'companyName': companyName,
//                                         'productDetails': productDetails,
//                                         'salts': salts,
//                                         'offer': offer,
//                                       },
//                                       quantity - 1,
//                                     );
//                                   },
//                                 ),
//                                 Container(
//                                   width: 40,
//                                   height: 30,
//                                   child: TextField(
//                                     keyboardType: TextInputType.number,
//                                     textAlign: TextAlign.center,
//                                     decoration: InputDecoration(
//                                       border: OutlineInputBorder(),
//                                       contentPadding: EdgeInsets.symmetric(horizontal: 8),
//                                     ),
//                                     controller: TextEditingController(text: quantity.toString()),
//                                     onSubmitted: (value) {
//                                       final newQuantity = int.tryParse(value) ?? 0;
//                                       cartController.updateCartItem(
//                                         medicineId,
//                                         {
//                                           'imagePath': imagePath,
//                                           'name': name,
//                                           'mrp': mrp,
//                                           'ptr': ptr,
//                                           'companyName': companyName,
//                                           'productDetails': productDetails,
//                                           'salts': salts,
//                                           'offer': offer,
//                                         },
//                                         newQuantity,
//                                       );
//                                     },
//                                   ),
//                                 ),
//                                 IconButton(
//                                   icon: Icon(Icons.add_circle_outline),
//                                   onPressed: () {
//                                     cartController.updateCartItem(
//                                       medicineId,
//                                       {
//                                         'imagePath': imagePath,
//                                         'name': name,
//                                         'mrp': mrp,
//                                         'ptr': ptr,
//                                         'companyName': companyName,
//                                         'productDetails': productDetails,
//                                         'salts': salts,
//                                         'offer': offer,
//                                       },
//                                       quantity + 1,
//                                     );
//                                   },
//                                 ),
//                               ],
//                             )
//                                 : ElevatedButton(
//                               onPressed: () {
//                                 if (userController.isLoggedIn.value) {
//                                   Get.snackbar(
//                                     'Item added',
//                                     '$name added to cart',
//                                     backgroundColor: Colors.black,
//                                     colorText: Colors.orangeAccent,
//                                     snackPosition: SnackPosition.BOTTOM,
//                                     margin: EdgeInsets.all(16.0),
//                                     borderRadius: 8.0, // Border radius
//                                     isDismissible: true, // Allow dismissing by tapping outside
//
//                                   );
//                                   cartController.updateCartItem(
//                                     medicineId,
//                                     {
//                                       'imagePath': imagePath,
//                                       'name': name,
//                                       'mrp': mrp,
//                                       'ptr': ptr,
//                                       'companyName': companyName,
//                                       'productDetails': productDetails,
//                                       'salts': salts,
//                                       'offer': offer,
//                                     },
//                                     1,
//                                   );
//                                 } else {
//                                   Get.snackbar(
//                                     'Login Required',
//                                     'Please log in to add items to the cart',
//                                     backgroundColor: Colors.orangeAccent,
//                                     colorText: Colors.black,
//                                     snackPosition: SnackPosition.BOTTOM,
//                                     margin: EdgeInsets.all(16.0),
//                                     borderRadius: 8.0, // Border radius
//                                     isDismissible: true, // Allow dismissing by tapping outside
//
//                                   );
//                                 }
//                               },
//                               child: Text('Add to Cart'),
//                             );
//                           }),
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
//     );
//   }
// }
//
