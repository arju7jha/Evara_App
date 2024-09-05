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
  List<dynamic> banners = [];

  final UserController userController = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    fetchProducts();
    fetchBanners();
  }

  Future<void> fetchProducts() async {
    final url = Uri.parse('https://namami-infotech.com/EvaraBackend/src/sku/offers_sku.php');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          popularMedicines = data['medicines'] ?? [];
          //bestSellingProducts = data['medicines'] ?? [];
        });
        print('API Response: ${response.body}');
      } else {
        print('Failed to load products');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchBanners() async {
    final url = Uri.parse('https://namami-infotech.com/EvaraBackend/src/banner/get_banner.php');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          banners = data['data'] ?? [];
        });
        print('Banners Response: ${response.body}');
      } else {
        print('Failed to load banners');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchProductDetails(String medicineId) async {
    final url = Uri.parse('https://namami-infotech.com/EvaraBackend/src/sku/get_sku.php?medicine_id=$medicineId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data['medicine'] != null) {
          final productDetails = data['medicine'];
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ProductDetailsPage(
                imagePath: productDetails['image_url'] ?? '',
                name: productDetails['name'] ?? '',
                mrp: '${productDetails['mrp'] ?? '0.00'}',
                ptr: '${productDetails['ptr'] ?? '0.00'}',
                companyName: productDetails['company_name'] ?? '',
                productDetails: productDetails['product_details'] ?? '',
                salts: productDetails['salts'] ?? '',
                offer: productDetails['formatted_offer'] ?? '',
                medicineId: medicineId, // This is now passed as String
              ),
            ),
          );
        } else {
          print('Product details not found.');
        }
      } else {
        print('Failed to load product details');
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
                  border: Border.all(color: Colors.black87, width: 2.0),
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
            // Dynamic Carousel Banner
            Center(
              child: banners.isNotEmpty
                  ? CarouselSlider(
                items: banners.map((banner) {
                  return GestureDetector(
                    onTap: () async {
                      // Ensure ProductID is used as a String
                      final productId = banner['ProductID'].toString();
                      await fetchProductDetails(productId);
                    },
                    child: Container(
                      decoration: BoxDecoration(
                        image: DecorationImage(
                          image: NetworkImage(banner['BannerURL']),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  );
                }).toList(),
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
              )
                  : CircularProgressIndicator(), // Replace with a more user-friendly loading indicator
            ),

            SizedBox(height: 16),
            // Popular Medicines
            Text(
              'Popular Medicines',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Container(
              height: 270,
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
                      offer: product['formatted_offer'] ?? '',
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
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
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

// class ProductCard extends StatelessWidget {
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
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final CartController cartController = Get.find<CartController>();
//     final UserController userController = Get.find<UserController>();
//
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ProductDetailsPage(
//               imagePath: imagePath,
//               name: name,
//               mrp: mrp,
//               ptr: ptr,
//               companyName: companyName,
//               productDetails: productDetails,
//               salts: salts,
//               offer: offer,
//               medicineId: medicineId,
//             ),
//           ),
//         );
//       },
//       child: Stack(
//         children: [
//           Card(
//             elevation: 4,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Container(
//               width: 160,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   if (offer.isNotEmpty)
//                     Container(
//                       padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//                       decoration: BoxDecoration(
//                         color: Colors.green,
//                         borderRadius: BorderRadius.only(
//                           topRight: Radius.circular(8),
//                           bottomLeft: Radius.circular(8),
//                         ),
//                       ),
//                       child: Text(
//                         offer,
//                         style: TextStyle(
//                             color: Colors.white, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   Container(
//                     height: 80,
//                     width: double.infinity,
//                     child: imagePath.isNotEmpty
//                         ? Image.network(
//                       imagePath,
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
//                             name,
//                             style: TextStyle(
//                                 fontSize: 16, fontWeight: FontWeight.bold),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           SizedBox(height: 4),
//                           Text(
//                             'MRP: $mrp',
//                             style: TextStyle(fontSize: 14, color: Colors.grey),
//                           ),
//                           Text(
//                             'PTR: $ptr',
//                             style: TextStyle(fontSize: 14, color: Colors.grey),
//                           ),
//                           SizedBox(height: 8),
//                           // Inside your ProductCard widget
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
//                                     borderRadius: 8.0,
//                                     isDismissible: true,
//                                   );
//                                 }
//                               },
//                               child: Text('Add to Cart'),
//                             );
//                           })
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

    // Create a TextEditingController to manage the quantity input
    final TextEditingController _quantityController = TextEditingController();

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
              width: 160,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                            overflow: TextOverflow.ellipsis,
                          ),
                          SizedBox(height: 4),
                          Text(
                            'MRP: $mrp',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          Text(
                            'PTR: $ptr',
                            style: TextStyle(fontSize: 14, color: Colors.grey),
                          ),
                          SizedBox(height: 8),
                          // Inside your ProductCard widget
                          Obx(() {
                            final quantity = cartController.getProductDetails(medicineId)?['quantity'] ?? 0;
                            _quantityController.text = quantity.toString();
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
                                    controller: _quantityController,
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(),
                                      contentPadding: EdgeInsets.symmetric(horizontal: 8),
                                    ),
                                    onSubmitted: (value) {
                                      final newQuantity = int.tryParse(value) ?? 0;
                                      cartController.updateCartItem(
                                        medicineId,
                                        {
                                          'imagePath': imagePath,
                                          'name': name,
                                          'mrp': mrp,
                                          'ptr': ptr,
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
                                  cartController.updateCartItem(
                                    medicineId,
                                    {
                                      'imagePath': imagePath,
                                      'name': name,
                                      'mrp': mrp,
                                      'ptr': ptr,
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
                                    borderRadius: 8.0,
                                    isDismissible: true,
                                  );
                                }
                              },
                              child: Text('Add to Cart'),
                            );
                          })
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





// class ProductCard extends StatelessWidget {
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
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final CartController cartController = Get.find<CartController>();
//
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ProductDetailsPage(
//               imagePath: imagePath,
//               name: name,
//               mrp: mrp,
//               ptr: ptr,
//               companyName: companyName,
//               productDetails: productDetails,
//               salts: salts,
//               offer: offer,
//               medicineId: medicineId,
//             ),
//           ),
//         );
//       },
//       child: Stack(
//         children: [
//           Card(
//             elevation: 4,
//             shape: RoundedRectangleBorder(
//               borderRadius: BorderRadius.circular(8),
//             ),
//             child: Container(
//               width: 160,
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   if (offer.isNotEmpty)
//                     Container(
//                       padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//                       decoration: BoxDecoration(
//                         color: Colors.green,
//                         borderRadius: BorderRadius.only(
//                           topRight: Radius.circular(8),
//                           bottomLeft: Radius.circular(8),
//                         ),
//                       ),
//                       child: Text(
//                         offer,
//                         style: TextStyle(
//                             color: Colors.white, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   Container(
//                     height: 80,
//                     width: double.infinity,
//                     child: imagePath.isNotEmpty
//                         ? Image.network(
//                       imagePath,
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
//                             name,
//                             style: TextStyle(
//                                 fontSize: 16, fontWeight: FontWeight.bold),
//                             maxLines: 1,
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           SizedBox(height: 4),
//                           Text(
//                             'MRP: ${mrp}',
//                             style: TextStyle(fontSize: 14, color: Colors.grey),
//                           ),
//                           Text(
//                             'PTR: ${ptr}',
//                             style: TextStyle(fontSize: 14, color: Colors.grey),
//                           ),
//                           SizedBox(height: 8),
//                           Obx(() {
//                             final quantity = cartController.getProductDetails(medicineId)?['quantity'] ?? 0;
//                             return quantity > 0
//                                 ? Row(
//                               mainAxisAlignment: MainAxisAlignment.center,
//                               children: [
//                                 IconButton(
//                                   icon: Icon(Icons.remove_circle_outline),
//                                   onPressed: () {
//                                     cartController.updateCartItem(medicineId, {
//                                       'imagePath': imagePath,
//                                       'name': name,
//                                       'mrp': mrp,
//                                       'ptr': ptr,
//                                       'companyName': companyName,
//                                       'productDetails': productDetails,
//                                       'salts': salts,
//                                       'offer': offer,
//                                     }, quantity - 1);
//                                   },
//                                 ),
//                                 Container(
//                                   width: 40, height: 30,
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
//                                       cartController.updateCartItem(medicineId, {
//                                         'imagePath': imagePath,
//                                         'name': name,
//                                         'mrp': mrp,
//                                         'ptr': ptr,
//                                         'companyName': companyName,
//                                         'productDetails': productDetails,
//                                         'salts': salts,
//                                         'offer': offer,
//                                       }, newQuantity);
//                                     },
//                                   ),
//                                 ),
//                                 IconButton(
//                                   icon: Icon(Icons.add_circle_outline),
//                                   onPressed: () {
//                                     cartController.updateCartItem(medicineId, {
//                                       'imagePath': imagePath,
//                                       'name': name,
//                                       'mrp': mrp,
//                                       'ptr': ptr,
//                                       'companyName': companyName,
//                                       'productDetails': productDetails,
//                                       'salts': salts,
//                                       'offer': offer,
//                                     }, quantity + 1);
//                                   },
//                                 ),
//                               ],
//                             )
//                                 : ElevatedButton(
//                               onPressed: () {
//                                 cartController.updateCartItem(medicineId, {
//                                   'imagePath': imagePath,
//                                   'name': name,
//                                   'mrp': mrp,
//                                   'ptr': ptr,
//                                   'companyName': companyName,
//                                   'productDetails': productDetails,
//                                   'salts': salts,
//                                   'offer': offer,
//                                 }, 1);
//                               },
//                               child: Text('Add to Cart'),
//                             );
//                           }),
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



// class ProductCard extends StatelessWidget {
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
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     final CartController cartController = Get.find<CartController>();
//     final UserController userController = Get.find<UserController>();
//
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (context) => ProductDetailsPage(
//               imagePath: imagePath,
//               name: name,
//               mrp: mrp,
//               ptr: ptr,
//               companyName: companyName,
//               productDetails: productDetails,
//               salts: salts,
//               offer: offer,
//               medicineId: medicineId,
//             ),
//           ),
//         );
//       },
//       child: Stack(
//         children: [
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
//                   if (offer.isNotEmpty)
//                     Container(
//                       padding: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//                       decoration: BoxDecoration(
//                         color: Colors.green,
//                         borderRadius: BorderRadius.only(
//                           topRight: Radius.circular(8),
//                           bottomLeft: Radius.circular(8),
//                         ),
//                       ),
//                       child: Text(
//                         offer,
//                         style: TextStyle(
//                             color: Colors.white, fontWeight: FontWeight.bold),
//                       ),
//                     ),
//                   Container(
//                     height: 80,
//                     width: double.infinity,
//                     child: imagePath.isNotEmpty
//                         ? Image.network(
//                             imagePath,
//                             fit: BoxFit.contain,
//                             errorBuilder: (context, error, stackTrace) {
//                               return Center(child: Text('No Image Uploaded'));
//                             },
//                           )
//                         : Center(child: Text('No Image Uploaded')),
//                   ),
//                   Padding(
//                     padding: const EdgeInsets.all(10.0),
//                     child: Center(
//                       child: Column(
//                         children: [
//                           Text(
//                             name,
//                             style: TextStyle(
//                                 fontSize: 16, fontWeight: FontWeight.bold),
//                             maxLines: 1,
//                             overflow:
//                                 TextOverflow.ellipsis, // Truncate with ellipsis
//                           ),
//                           SizedBox(height: 4),
//                           Text(
//                             'MRP: ${mrp}',
//                             style: TextStyle(fontSize: 14, color: Colors.grey),
//                           ),
//                           Text(
//                             'PTR: ${ptr}',
//                             style: TextStyle(fontSize: 14, color: Colors.grey),
//                           ),
//                           SizedBox(height: 8),
//                           // Product information
//                           Obx(() {
//                             final isInCart = cartController.cartItems.any((item) => item.name == name);
//                             return ElevatedButton(
//                               onPressed: () {
//                                 if (userController.isLoggedIn.value) {
//                                   cartController.addItem(CartItem(name: name, price: double.parse(ptr)));
//                                   Get.snackbar(
//                                     'Item added',
//                                     '$name added to cart',
//                                     backgroundColor: Colors.black,
//                                     colorText: Colors.orangeAccent,
//                                     snackPosition: SnackPosition.BOTTOM,
//                                   );
//                                 } else {
//                                   Get.snackbar(
//                                     'Login Required',
//                                     'Please log in to add items to the cart',
//                                     backgroundColor: Colors.orangeAccent,
//                                     colorText: Colors.black,
//                                     snackPosition: SnackPosition.BOTTOM,
//                                   );
//                                 }
//                               },
//                               child: Text(isInCart ? 'Go to Cart' : 'Add to Cart'),
//                             );
//                           }),
//                           // Obx(() {
//                           //   final isInCart =
//                           //       cartController.isInCart(medicineId);
//                           //   return ElevatedButton(
//                           //     onPressed: () {
//                           //       if (userController.isLoggedIn.value) {
//                           //         cartController.toggleCartItem(medicineId);
//                           //         Get.snackbar(
//                           //           isInCart ? 'Item removed' : 'Item added',
//                           //           isInCart
//                           //               ? '$name removed from cart'
//                           //               : '$name added to cart',
//                           //           backgroundColor:
//                           //               Colors.black, // Custom background color
//                           //           colorText: Colors
//                           //               .orangeAccent, // Custom text color
//                           //           snackPosition: SnackPosition.BOTTOM,
//                           //           margin: EdgeInsets.all(16.0),
//                           //           borderRadius: 8.0, // Border radius
//                           //           isDismissible:
//                           //               true, // Allow dismissing by tapping outside
//                           //
//                           //           //dismissDirection: SnackDismissDirection.HORIZONTAL, // Dismiss direction
//                           //           forwardAnimationCurve:
//                           //               Curves.easeOut, // Animation curve
//                           //           reverseAnimationCurve: Curves.easeIn,
//                           //           icon: isInCart
//                           //               ? Icon(
//                           //                   Icons.remove_shopping_cart,
//                           //                   color: Colors.deepOrange,
//                           //                 )
//                           //               : Icon(Icons.add_shopping_cart,
//                           //                   color: Colors.green), // Custom icon
//                           //           shouldIconPulse:
//                           //               true, // Animated icon pulse
//                           //           duration: Duration(
//                           //               seconds: 3), // Show for 3 seconds
//                           //         );
//                           //       } else {
//                           //         Get.snackbar(
//                           //           'Login Required',
//                           //           'Please log in to add items to the cart',
//                           //           backgroundColor: Colors.orangeAccent,
//                           //           colorText: Colors.black,
//                           //           snackPosition: SnackPosition.BOTTOM,
//                           //           margin: EdgeInsets.all(16.0),
//                           //         );
//                           //       }
//                           //     },
//                           //     child:
//                           //         Text(isInCart ? 'Go to Cart' : 'Add to Cart'),
//                           //   );
//                           // }),
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

