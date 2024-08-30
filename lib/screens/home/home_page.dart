import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'dart:convert'; // To handle JSON data
import 'package:http/http.dart' as http; // Import the http package
import '../../controller/UserController.dart';
import '../explore/searchPage.dart';
import '../widgets/product_details.dart';
import 'package:get/get.dart';
import 'package:evara/controller/cart_component/CartController.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<dynamic> popularMedicines = [];
  List<dynamic> bestSellingProducts = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    final url = Uri.parse(
        'https://namami-infotech.com/EvaraBackend/src/sku/offers_sku.php');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        // Parse the JSON response
        final data = json.decode(response.body);
        setState(() {
          popularMedicines = data['medicines'] ?? [];
          //bestSellingProducts = data['medicines'] ?? [];
        });
        print('API Response: ${response.body}'); // Print the API response
      } else {
        print('Failed to load products');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Bar
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SearchPage()),
                );
              },
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
                decoration: BoxDecoration(
                  color: Color(0xffffffff),
                  borderRadius: BorderRadius.circular(25.0),
                  border: Border.all(
                      color: Colors.black87, width: 2.0), // Add this line
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.orangeAccent[700]),
                    SizedBox(width: 8.0),
                    Text(
                      'Search for products...',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            // Carousel banner
            CarouselSlider(
              items: [
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/img.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/img_1.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image: AssetImage('assets/images/img_2.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ],
              options: CarouselOptions(
                height: 150,
                aspectRatio: 16 / 9,
                viewportFraction: 0.8,
                initialPage: 0,
                enableInfiniteScroll: true,
                reverse: false,
                autoPlay: true,
                autoPlayInterval: Duration(seconds: 5),
                pauseAutoPlayOnTouch: true,
                enlargeCenterPage: true,
                onPageChanged: (index, reason) {
                  print('Page changed to $index');
                },
              ),
            ),
            SizedBox(height: 16),
            // Popular Medicines
            Text(
              'Popular Medicines',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Container(
              height: 250, // Height to accommodate the products
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: popularMedicines.length,
                itemBuilder: (context, index) {
                  final product = popularMedicines[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: ProductCard(
                      medicineId: product['medicine_id'].toString(),
                      imagePath: product['image_url'] ?? '',
                      name: product['name'] ?? '',
                      mrp: '${product['mrp'] ?? '0.00'}',
                      ptr: '${product['ptr'] ?? '0.00'}',
                      companyName: product['company_name'] ?? '',
                      productDetails: product['product_details'] ?? '',
                      salts: product['salts'] ?? '',
                      offer: product['offer'] ?? '',
                    ),
                  );
                },
              ),
            ),

            SizedBox(height: 16),

            // Best Selling Products
            Text(
              'Best Selling Products',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Container(
              //height: 250,
              child: GridView.builder(
                shrinkWrap: true,
                physics:
                    NeverScrollableScrollPhysics(), // Prevents the GridView from scrolling
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.75,
                ),
                itemCount: bestSellingProducts.length,
                itemBuilder: (context, index) {
                  final product = bestSellingProducts[index];
                  return Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: ProductCard(
                      medicineId: product['medicine_id'].toString(),
                      imagePath: product['image_url'] ?? '',
                      name: product['name'] ?? '',
                      mrp: '${product['mrp'] ?? '0.00'}',
                      ptr: '${product['ptr'] ?? '0.00'}',
                      companyName: product['company_name'] ?? '',
                      productDetails: product['product_details'] ?? '',
                      salts: product['salts'] ?? '',
                      offer: product['offer'] ?? '',
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//
// class ProductCard extends StatefulWidget {
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
//   ProductCard({
//     required this.imagePath,
//     required this.name,
//     required this.mrp,
//     required this.ptr,
//     this.companyName = '',
//     this.productDetails = '',
//     this.salts = '',
//     this.offer = '',
//     required this.medicineId,
//
//   });
//
//   @override
//   _ProductCardState createState() => _ProductCardState();
// }
//
// class _ProductCardState extends State<ProductCard> {
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ProductDetailsPage(
//               imagePath: widget.imagePath,
//               name: widget.name,
//               mrp: widget.mrp,
//               ptr: widget.ptr,
//               companyName: widget.companyName,
//               productDetails: widget.productDetails,
//               salts: widget.salts,
//               offer: widget.offer,
//               medicineId: widget.medicineId,
//             ),
//           ),
//         );
//       },
//       child: Stack(
//         children: [
//
//           Card(
//             elevation: 4,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Container(
//               width: 160, // Fixed width for consistency
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Offer Display
//                   if (widget.offer.isNotEmpty)
//                     Container(
//                       //margin: EdgeInsets.only(top: 10),
//                       padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//                       decoration: BoxDecoration(
//                         color: Colors.green,
//                         borderRadius: BorderRadius.only(
//                           topRight: Radius.circular(8),
//                           bottomLeft: Radius.circular(8),
//                         ),
//                       ),
//                       child: Text(
//                         widget.offer,
//                         style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//
//                   Container(
//                     //margin: EdgeInsets.only(top: 10),
//                     height: 80,
//                     width: double.infinity,
//                     child: widget.imagePath.isNotEmpty
//                         ? Image.network(
//                       widget.imagePath,
//                       fit: BoxFit.contain,
//                       errorBuilder: (context, error, stackTrace) {
//                         return Center(child: Text('No Image Uploaded'));
//                       },
//                     )
//                         : Center(child: Text('No Image Uploaded')),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: Center(
//                       child: Column(
//                         children: [
//                           Text(
//                             widget.name,
//                             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis, // Truncate with ellipsis
//                           ),
//                           SizedBox(height: 4),
//                           Text(
//                             'MRP: ${widget.mrp}',
//                             style: TextStyle(fontSize: 14, color: Colors.grey),
//                           ),
//                           Text(
//                             'PTR: ${widget.ptr}',
//                             style: TextStyle(fontSize: 14, color: Colors.grey),
//                           ),
//                           SizedBox(height: 8),
//                           ElevatedButton(
//                             onPressed: () {
//                               // Handle add to cart button press
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Color(0xff033464),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(20), // Border radius
//                               ),
//                             ),
//                             child: Text('Add to Cart'),
//                           ),
//
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }

class ProductCard extends StatelessWidget {
  final String imagePath;
  final String name;
  final String mrp;
  final String ptr;
  final String companyName;
  final String productDetails;
  final String salts;
  final String offer;
  final String medicineId;

  ProductCard({
    required this.imagePath,
    required this.name,
    required this.mrp,
    required this.ptr,
    this.companyName = '',
    this.productDetails = '',
    this.salts = '',
    this.offer = '',
    required this.medicineId,
  });

  @override
  Widget build(BuildContext context) {
    final CartController cartController = Get.find<CartController>();
    final UserController userController = Get.find<UserController>();

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsPage(
              imagePath: imagePath,
              name: name,
              mrp: mrp,
              ptr: ptr,
              companyName: companyName,
              productDetails: productDetails,
              salts: salts,
              offer: offer,
              medicineId: medicineId,
            ),
          ),
        );
      },
      child: Stack(
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
            ),
            child: Container(
              width: 160, // Fixed width for consistency
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Offer Display
                  if (offer.isNotEmpty)
                    Container(
                      padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                      decoration: BoxDecoration(
                        color: Colors.green,
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(8),
                          bottomLeft: Radius.circular(8),
                        ),
                      ),
                      child: Text(
                        offer,
                        style: TextStyle(
                            color: Colors.white, fontWeight: FontWeight.bold),
                      ),
                    ),
                  Container(
                    height: 80,
                    width: double.infinity,
                    child: imagePath.isNotEmpty
                        ? Image.network(
                            imagePath,
                            fit: BoxFit.contain,
                            errorBuilder: (context, error, stackTrace) {
                              return Center(child: Text('No Image Uploaded'));
                            },
                          )
                        : Center(child: Text('No Image Uploaded')),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Center(
                      child: Column(
                        children: [
                          Text(
                            name,
                            style: TextStyle(
                                fontSize: 16, fontWeight: FontWeight.bold),
                            maxLines: 1,
                            overflow:
                                TextOverflow.ellipsis, // Truncate with ellipsis
                          ),
                          SizedBox(height: 4),
                          Text(
                            'MRP: ${mrp}',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          Text(
                            'PTR: ${ptr}',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          SizedBox(height: 8),
                          Obx(() {
                            final isInCart =
                                cartController.isInCart(medicineId);
                            return ElevatedButton(
                              onPressed: () {
                                if (userController.isLoggedIn.value) {
                                  cartController.toggleCartItem(medicineId);
                                  Get.snackbar(
                                    isInCart ? 'Item removed' : 'Item added',
                                    isInCart
                                        ? '$name removed from cart'
                                        : '$name added to cart',
                                    backgroundColor:
                                        Colors.black, // Custom background color
                                    colorText: Colors
                                        .orangeAccent, // Custom text color
                                    snackPosition: SnackPosition.BOTTOM,
                                    margin: EdgeInsets.all(16.0),
                                    borderRadius: 8.0, // Border radius
                                    isDismissible:
                                        true, // Allow dismissing by tapping outside

                                    //dismissDirection: SnackDismissDirection.HORIZONTAL, // Dismiss direction
                                    forwardAnimationCurve:
                                        Curves.easeOut, // Animation curve
                                    reverseAnimationCurve: Curves.easeIn,
                                    icon: isInCart
                                        ? Icon(
                                            Icons.remove_shopping_cart,
                                            color: Colors.deepOrange,
                                          )
                                        : Icon(Icons.add_shopping_cart,
                                            color: Colors.green), // Custom icon
                                    shouldIconPulse:
                                        true, // Animated icon pulse
                                    duration: Duration(
                                        seconds: 3), // Show for 3 seconds
                                  );
                                } else {
                                  Get.snackbar(
                                    'Login Required',
                                    'Please log in to add items to the cart',
                                    backgroundColor: Colors.orangeAccent,
                                    colorText: Colors.black,
                                    snackPosition: SnackPosition.BOTTOM,
                                    margin: EdgeInsets.all(16.0),
                                  );
                                }
                              },
                              child:
                                  Text(isInCart ? 'Go to Cart' : 'Add to Cart'),
                            );
                            // return ElevatedButton(
                            //   onPressed: () {
                            //     if (userController.isLoggedIn.value) {
                            //       cartController.toggleCartItem(medicineId);
                            //       final isInCart = cartController.isInCart(medicineId);
                            //
                            //       // Show a custom Snackbar
                            //       Get.snackbar(
                            //         isInCart ? 'Item removed' : 'Item added',
                            //         isInCart ? '$name removed from cart' : '$name added to cart',
                            //         backgroundColor: Colors.blueGrey, // Custom background color
                            //         colorText: Colors.white, // Custom text color
                            //         icon: isInCart ? Icon(Icons.remove_shopping_cart) : Icon(Icons.add_shopping_cart), // Custom icon
                            //         shouldIconPulse: true, // Animated icon pulse
                            //         duration: Duration(seconds: 3), // Show for 3 seconds
                            //       );
                            //     } else {
                            //       Get.snackbar(
                            //         'Login Required',
                            //         'Please log in to add items to the cart',
                            //         backgroundColor: Colors.red, // Custom background color
                            //         colorText: Colors.white, // Custom text color
                            //         duration: Duration(seconds: 3), // Show for 3 seconds
                            //       );
                            //     }
                            //   },
                            //   child: Text(isInCart ? 'Go to Cart' : 'Add to Cart'),
                            // );

                            // return ElevatedButton(
                            //   onPressed: () {
                            //     if (userController.isLoggedIn.value) {
                            //       cartController.toggleCartItem(medicineId);
                            //       if (isInCart) {
                            //         Get.snackbar('Removed', '$name removed from cart');
                            //       } else {
                            //         Get.snackbar('Added', '$name added to cart');
                            //       }
                            //     } else {
                            //       Get.snackbar('Login Required', 'Please log in to add items to the cart');
                            //     }
                            //   },
                            //   child: Text(isInCart ? 'Go to Cart' : 'Add to Cart'),
                            // );
                          }),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'dart:convert'; // To handle JSON data
// import 'package:http/http.dart' as http; // Import the http package
//
// import '../explore/searchPage.dart';
// import '../widgets/product_details.dart';
//
// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   List<dynamic> popularMedicines = [];
//   List<dynamic> bestSellingProducts = [];
//
//   @override
//   void initState() {
//     super.initState();
//     fetchProducts();
//   }
//
//   Future<void> fetchProducts() async {
//     final url = Uri.parse('https://namami-infotech.com/EvaraBackend/src/sku/offers_sku.php');
//     try {
//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         // Parse the JSON response
//         final data = json.decode(response.body);
//         setState(() {
//           popularMedicines = data['medicines'] ?? [];
//           bestSellingProducts = data['best_selling_products'] ?? [];
//         });
//         print('API Response: ${response.body}'); // Print the API response
//       } else {
//         print('Failed to load products');
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Search Bar
//             GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => SearchPage()),
//                 );
//               },
//               child: Container(
//                 padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
//                 decoration: BoxDecoration(
//                   color: Color(0xffffffff),
//                   borderRadius: BorderRadius.circular(15.0),
//                   border: Border.all(color: Colors.black87, width: 3.0), // Add this line
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(Icons.search, color: Colors.grey),
//                     SizedBox(width: 8.0),
//                     Text(
//                       'Search for products...',
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//
//             // GestureDetector(
//             //   onTap: () {
//             //     Navigator.push(
//             //       context,
//             //       MaterialPageRoute(builder: (context) => SearchPage()),
//             //     );
//             //   },
//             //   child: Container(
//             //     padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
//             //     decoration: BoxDecoration(
//             //       color: Color(0xff3fd9c9),
//             //       borderRadius: BorderRadius.circular(8.0),
//             //     ),
//             //     child: Row(
//             //       children: [
//             //         Icon(Icons.search, color: Colors.grey),
//             //         SizedBox(width: 8.0),
//             //         Text(
//             //           'Search for products...',
//             //           style: TextStyle(color: Colors.grey),
//             //         ),
//             //       ],
//             //     ),
//             //   ),
//             // ),
//             SizedBox(height: 16),
//             // Carousel banner
//             CarouselSlider(
//               items: [
//                 Container(
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                       image: AssetImage('assets/images/img.png'),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//                 Container(
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                       image: AssetImage('assets/images/img_1.png'),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//                 Container(
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                       image: AssetImage('assets/images/img_2.png'),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//               ],
//               options: CarouselOptions(
//                 height: 150,
//                 aspectRatio: 16 / 9,
//                 viewportFraction: 0.8,
//                 initialPage: 0,
//                 enableInfiniteScroll: true,
//                 reverse: false,
//                 autoPlay: true,
//                 autoPlayInterval: Duration(seconds: 5),
//                 pauseAutoPlayOnTouch: true,
//                 enlargeCenterPage: true,
//                 onPageChanged: (index, reason) {
//                   print('Page changed to $index');
//                 },
//               ),
//             ),
//             SizedBox(height: 16),
//
//             // Popular Medicines
//             Text(
//               'Popular Medicines',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8),
//             Container(
//               height: 250, // Height to accommodate the products
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: popularMedicines.length,
//                 itemBuilder: (context, index) {
//                   final product = popularMedicines[index];
//                   return Padding(
//                     padding: const EdgeInsets.only(right: 16.0),
//                     child: ProductCard(
//                       imagePath: product['image_url'] ?? '',
//                       name: product['name'] ?? '',
//                       mrp: '\$${product['mrp'] ?? '0.00'}',
//                       ptr: '\$${product['ptr'] ?? '0.00'}',
//                       companyName: product['company_name'] ?? '',
//                       productDetails: product['product_details'] ?? '',
//                       salts: product['salts'] ?? '',
//                       offer: product['offer'] ?? '',
//                     ),
//                   );
//                 },
//               ),
//             ),
//
//             SizedBox(height: 16),
//
//             // Best Selling Products
//             Text(
//               'Best Selling Products',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8),
//             GridView.builder(
//               shrinkWrap: true,
//               physics: NeverScrollableScrollPhysics(), // Prevents the GridView from scrolling
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 15,
//                 mainAxisSpacing: 16,
//                 childAspectRatio: 0.75,
//               ),
//               itemCount: bestSellingProducts.length,
//               itemBuilder: (context, index) {
//                 final product = bestSellingProducts[index];
//                 return ProductCard(
//                   imagePath: product['image_url'] ?? '',
//                   name: product['name'] ?? '',
//                   mrp: '\$${product['mrp'] ?? '0.00'}',
//                   ptr: '\$${product['ptr'] ?? '0.00'}',
//                   companyName: product['company_name'] ?? '',
//                   productDetails: product['product_details'] ?? '',
//                   salts: product['salts'] ?? '',
//                   offer: product['offer'] ?? '',
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class ProductCard extends StatefulWidget {
//   final String imagePath;
//   final String name;
//   final String mrp;
//   final String ptr;
//   final String companyName;
//   final String productDetails;
//   final String salts;
//   final String offer;
//
//   ProductCard({
//     required this.imagePath,
//     required this.name,
//     required this.mrp,
//     required this.ptr,
//     this.companyName = '',
//     this.productDetails = '',
//     this.salts = '',
//     this.offer = '',
//   });
//
//   @override
//   _ProductCardState createState() => _ProductCardState();
// }
//
// class _ProductCardState extends State<ProductCard> {
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ProductDetailsPage(
//               imagePath: widget.imagePath,
//               name: widget.name,
//               mrp: widget.mrp,
//               ptr: widget.ptr,
//               companyName: widget.companyName,
//               productDetails: widget.productDetails,
//               salts: widget.salts,
//               offer: widget.offer,
//             ),
//           ),
//         );
//       },
//       child: Stack(
//         children: [
//
//           Card(
//             elevation: 4,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Container(
//               width: 160, // Fixed width for consistency
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Offer Display
//                   if (widget.offer.isNotEmpty)
//                     Container(
//                       //margin: EdgeInsets.only(top: 10),
//                       padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//                       decoration: BoxDecoration(
//                         color: Colors.green,
//                         borderRadius: BorderRadius.only(
//                           topRight: Radius.circular(8),
//                           bottomLeft: Radius.circular(8),
//                         ),
//                       ),
//                       child: Text(
//                         widget.offer,
//                         style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   // if (widget.offer.isNotEmpty)
//                   //   Positioned(
//                   //     top: 0,
//                   //     right: 0,
//                   //     child: Container(
//                   //       padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//                   //       decoration: BoxDecoration(
//                   //         color: Colors.green,
//                   //         borderRadius: BorderRadius.only(
//                   //           topRight: Radius.circular(8),
//                   //           bottomLeft: Radius.circular(8),
//                   //         ),
//                   //       ),
//                   //       child: Text(
//                   //         widget.offer,
//                   //         style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//                   //       ),
//                   //     ),
//                   //   ),
//                   // Image Section
//                   Container(
//                     //margin: EdgeInsets.only(top: 10),
//                     height: 80,
//                     width: double.infinity,
//                     child: widget.imagePath.isNotEmpty
//                         ? Image.network(
//                       widget.imagePath,
//                       fit: BoxFit.contain,
//                       errorBuilder: (context, error, stackTrace) {
//                         return Center(child: Text('No Image Uploaded'));
//                       },
//                     )
//                         : Center(child: Text('No Image Uploaded')),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: Center(
//                       child: Column(
//                         children: [
//                           Text(
//                             widget.name,
//                             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis, // Truncate with ellipsis
//                           ),
//                           SizedBox(height: 4),
//                           Text(
//                             'MRP: ${widget.mrp}',
//                             style: TextStyle(fontSize: 14, color: Colors.grey),
//                           ),
//                           Text(
//                             'PTR: ${widget.ptr}',
//                             style: TextStyle(fontSize: 14, color: Colors.grey),
//                           ),
//                           SizedBox(height: 8),
//                           ElevatedButton(
//                             onPressed: () {
//                               // Handle add to cart button press
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Color(0xff033464),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(20), // Border radius
//                               ),
//                             ),
//                             child: Text('Add to Cart'),
//                           ),
//
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           // if (widget.offer.isNotEmpty)
//           //   Positioned(
//           //     top: 0,
//           //     right: 0,
//           //     child: Container(
//           //       padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//           //       decoration: BoxDecoration(
//           //         color: Colors.green,
//           //         borderRadius: BorderRadius.only(
//           //           topRight: Radius.circular(8),
//           //           bottomLeft: Radius.circular(8),
//           //         ),
//           //       ),
//           //       child: Text(
//           //         widget.offer,
//           //         style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//           //       ),
//           //     ),
//           //   ),
//         ],
//       ),
//     );
//   }
// }
//

// import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'dart:convert'; // To handle JSON data
// import 'package:http/http.dart' as http; // Import the http package
//
// import '../explore/searchPage.dart';
// import '../widgets/product_details.dart';
//
// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   List<dynamic> popularMedicines = [];
//   List<dynamic> bestSellingProducts = [];
//
//   @override
//   void initState() {
//     super.initState();
//     fetchProducts();
//   }
//
//   Future<void> fetchProducts() async {
//     final url = Uri.parse('https://namami-infotech.com/EvaraBackend/src/sku/offers_sku.php');
//     try {
//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         // Parse the JSON response
//         final data = json.decode(response.body);
//         setState(() {
//           popularMedicines = data['medicines'] ?? [];
//           bestSellingProducts = data['best_selling_products'] ?? [];
//         });
//         print('API Response: ${response.body}'); // Print the API response
//       } else {
//         print('Failed to load products');
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: SingleChildScrollView(
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             // Search Bar
//             GestureDetector(
//               onTap: () {
//                 Navigator.push(
//                   context,
//                   MaterialPageRoute(builder: (context) => SearchPage()),
//                 );
//               },
//               child: Container(
//                 padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
//                 decoration: BoxDecoration(
//                   color: Colors.grey[200],
//                   borderRadius: BorderRadius.circular(8.0),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(Icons.search, color: Colors.grey),
//                     SizedBox(width: 8.0),
//                     Text(
//                       'Search for products...',
//                       style: TextStyle(color: Colors.grey),
//                     ),
//                   ],
//                 ),
//               ),
//             ),
//             SizedBox(height: 16),
//             // Carousel banner
//             CarouselSlider(
//               items: [
//                 Container(
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                       image: AssetImage('assets/images/img.png'),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//                 Container(
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                       image: AssetImage('assets/images/img_1.png'),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//                 Container(
//                   decoration: BoxDecoration(
//                     image: DecorationImage(
//                       image: AssetImage('assets/images/img_2.png'),
//                       fit: BoxFit.cover,
//                     ),
//                   ),
//                 ),
//               ],
//               options: CarouselOptions(
//                 height: 150,
//                 aspectRatio: 16 / 9,
//                 viewportFraction: 0.8,
//                 initialPage: 0,
//                 enableInfiniteScroll: true,
//                 reverse: false,
//                 autoPlay: true,
//                 autoPlayInterval: Duration(seconds: 5),
//                 pauseAutoPlayOnTouch: true,
//                 enlargeCenterPage: true,
//                 onPageChanged: (index, reason) {
//                   print('Page changed to $index');
//                 },
//               ),
//             ),
//             SizedBox(height: 16),
//
//             // Popular Medicines
//             Text(
//               'Popular Medicines',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8),
//             Container(
//               height: 250, // Height to accommodate the products
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount: popularMedicines.length,
//                 itemBuilder: (context, index) {
//                   final product = popularMedicines[index];
//                   return Padding(
//                     padding: const EdgeInsets.only(right: 16.0),
//                     child: ProductCard(
//                       imagePath: product['image_url'] ?? '',
//                       name: product['name'] ?? '',
//                       mrp: '\$${product['mrp'] ?? '0.00'}',
//                       ptr: '\$${product['ptr'] ?? '0.00'}',
//                       companyName: product['company_name'] ?? '',
//                       productDetails: product['product_details'] ?? '',
//                       salts: product['salts'] ?? '',
//                       offer: product['offer'] ?? '',
//                     ),
//                   );
//                 },
//               ),
//             ),
//
//             SizedBox(height: 16),
//
//             // Best Selling Products
//             Text(
//               'Best Selling Products',
//               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             SizedBox(height: 8),
//             GridView.builder(
//               shrinkWrap: true,
//               physics: NeverScrollableScrollPhysics(), // Prevents the GridView from scrolling
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 2,
//                 crossAxisSpacing: 15,
//                 mainAxisSpacing: 16,
//                 childAspectRatio: 0.75,
//               ),
//               itemCount: bestSellingProducts.length,
//               itemBuilder: (context, index) {
//                 final product = bestSellingProducts[index];
//                 return ProductCard(
//                   imagePath: product['image_url'] ?? '',
//                   name: product['name'] ?? '',
//                   mrp: '\$${product['mrp'] ?? '0.00'}',
//                   ptr: '\$${product['ptr'] ?? '0.00'}',
//                   companyName: product['company_name'] ?? '',
//                   productDetails: product['product_details'] ?? '',
//                   salts: product['salts'] ?? '',
//                   offer: product['offer'] ?? '',
//                 );
//               },
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
// class ProductCard extends StatefulWidget {
//   final String imagePath;
//   final String name;
//   final String mrp;
//   final String ptr;
//   final String companyName;
//   final String productDetails;
//   final String salts;
//   final String offer;
//
//   ProductCard({
//     required this.imagePath,
//     required this.name,
//     required this.mrp,
//     required this.ptr,
//     this.companyName = '',
//     this.productDetails = '',
//     this.salts = '',
//     this.offer = '',
//   });
//
//   @override
//   _ProductCardState createState() => _ProductCardState();
// }
//
// class _ProductCardState extends State<ProductCard> {
//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ProductDetailsPage(
//               imagePath: widget.imagePath,
//               name: widget.name,
//               mrp: widget.mrp,
//               ptr: widget.ptr,
//               companyName: widget.companyName,
//               productDetails: widget.productDetails,
//               salts: widget.salts,
//               offer: widget.offer,
//             ),
//           ),
//         );
//       },
//       child: Stack(
//         children: [
//
//           Card(
//             elevation: 4,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Container(
//               width: 160, // Fixed width for consistency
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   // Offer Display
//                   // if (widget.offer.isNotEmpty)
//                   //   Positioned(
//                   //     top: 0,
//                   //     right: 0,
//                   //     child: Container(
//                   //       padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//                   //       decoration: BoxDecoration(
//                   //         color: Colors.green,
//                   //         borderRadius: BorderRadius.only(
//                   //           topRight: Radius.circular(8),
//                   //           bottomLeft: Radius.circular(8),
//                   //         ),
//                   //       ),
//                   //       child: Text(
//                   //         widget.offer,
//                   //         style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//                   //       ),
//                   //     ),
//                   //   ),
//                   // Image Section
//                   Container(
//                     margin: EdgeInsets.only(top: 10),
//                     height: 100,
//                     width: double.infinity,
//                     child: widget.imagePath.isNotEmpty
//                         ? Image.network(
//                       widget.imagePath,
//                       fit: BoxFit.contain,
//                       errorBuilder: (context, error, stackTrace) {
//                         return Center(child: Text('No Image Uploaded'));
//                       },
//                     )
//                         : Center(child: Text('No Image Uploaded')),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: Center(
//                       child: Column(
//                         children: [
//                           Text(
//                             widget.name,
//                             style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis, // Truncate with ellipsis
//                           ),
//                           SizedBox(height: 4),
//                           Text(
//                             'MRP: ${widget.mrp}',
//                             style: TextStyle(fontSize: 14, color: Colors.grey),
//                           ),
//                           Text(
//                             'PTR: ${widget.ptr}',
//                             style: TextStyle(fontSize: 14, color: Colors.grey),
//                           ),
//                           SizedBox(height: 8),
//                           ElevatedButton(
//                             onPressed: () {
//                               // Handle add to cart button press
//                             },
//                             style: ElevatedButton.styleFrom(
//                               backgroundColor: Color(0xff033464),
//                               shape: RoundedRectangleBorder(
//                                 borderRadius: BorderRadius.circular(20), // Border radius
//                               ),
//                             ),
//                             child: Text('Add to Cart'),
//                           ),
//
//                         ],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//           if (widget.offer.isNotEmpty)
//             Positioned(
//               top: 0,
//               right: 0,
//               child: Container(
//                 padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//                 decoration: BoxDecoration(
//                   color: Colors.green,
//                   borderRadius: BorderRadius.only(
//                     topRight: Radius.circular(8),
//                     bottomLeft: Radius.circular(8),
//                   ),
//                 ),
//                 child: Text(
//                   widget.offer,
//                   style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//                 ),
//               ),
//             ),
//         ],
//       ),
//     );
//   }
// }
//
//
//
