import 'package:evara/utils/urls/urlsclass.dart';
import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/services.dart';
import 'dart:convert'; // To handle JSON data
import 'package:http/http.dart' as http; // Import the http package
import 'package:shared_preferences/shared_preferences.dart';
import '../../controller/UserController.dart';
import '../explore/searchPage.dart';
import '../widgets/allProducts_page.dart';
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
  Map<String, dynamic>? popupBanner; // To store the popup banner if found


  final UserController userController = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    fetchBanners();
    fetchTrendingOfferProducts();
    fetchTopSellingProducts();
  }

  Future<void> fetchTrendingOfferProducts() async {
    final url = Uri.parse(Urlsclass.trendingOfferProductsUrl as String);
    // final url = Uri.parse('https://namami-infotech.com/EvaraBackend/src/sku/offers_sku.php');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          popularMedicines = data['medicines'] ?? [];
        });
        print('API Response: ${response.body}');
      } else {
        print('Failed to load products');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> fetchTopSellingProducts() async {
    final url = Uri.parse(Urlsclass.topSellingProductsUrl as String);
    // final url = Uri.parse('https://namami-infotech.com/EvaraBackend/src/sku/top_selling.php');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          bestSellingProducts = data['products'] ?? [];
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
    final url = Uri.parse(Urlsclass.fetchBannersUrl as String);
    // final url = Uri.parse('https://namami-infotech.com/EvaraBackend/src/banner/get_banner.php');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          banners = data['data'] ?? [];

          // Check if there's a popup banner
          for (var banner in banners) {
            if (banner['Category'] == 'Popup') {
              popupBanner = banner;
              break; // If you only want to display the first popup found
            }
          }

          // If a popup banner is found, show a dialog
          if (popupBanner != null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showPopupDialog(popupBanner!);
            });
          }
        });
        print('Banners Response: ${response.body}');
      } else {
        print('Failed to load banners');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> checkPopupStatus() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool isPopupShown = prefs.getBool('isPopupShown') ?? false;

    if (!isPopupShown) {
      // Show the popup if it hasn't been shown before
      WidgetsBinding.instance.addPostFrameCallback((_) {
        showPopupDialog(popupBanner!);
      });

      // Set flag to true so the popup won't be shown again
      prefs.setBool('isPopupShown', true);
    }
  }

  // Method to show the popup dialog
  void showPopupDialog(Map<String, dynamic> banner) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          child: Stack(
            children: [
              GestureDetector(
                onTap: () async {
                  final productId = banner['ProductID'].toString();
                  Navigator.pop(context); // Close the dialog
                  await fetchProductDetails(productId); // Navigate to product details
                },
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    image: DecorationImage(
                      image: NetworkImage(banner['BannerURL']),
                      //fit: BoxFit.cover,
                    ),
                  ),
                  height: 300,
                  width: double.infinity,
                ),
              ),
              Positioned(
                top: 10,
                right: 10,
                child: IconButton(
                  icon: Icon(Icons.close, color: Colors.black),
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> fetchProductDetails(String medicineId) async {
    final url = Uri.parse(Urlsclass.fetchProductDetailsUrl + medicineId);
    // final url = Uri.parse('https://namami-infotech.com/EvaraBackend/src/sku/get_sku.php?medicine_id=$medicineId');
    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data != null && data['medicine'] != null) {
          final productDetails = data['medicine'];
          final offer = determineOffer(productDetails);
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
                offer: offer,
                medicineId: medicineId,
                sellingPrice: '',
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
            Center(
              child: banners.isNotEmpty
                  ? CarouselSlider(
                items: banners.map((banner) {
                  return GestureDetector(
                    onTap: () async {
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
                  : CircularProgressIndicator(),
            ),
            SizedBox(height: 16),
            Row(
              children: [
                Text(
                  'Trending Offers',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllProductsPage(
                            title:  'Trending Offers',
                            products: popularMedicines,
                          ),
                        ),
                      );
                    },
                    child: Text('See All',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Container(
              height: 260,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount:
                popularMedicines.length > 5 ? 5 : popularMedicines.length,
                itemBuilder: (context, index) {
                  final product = popularMedicines[index];
                  final offer = determineOffer(product);
                  return Padding(
                    padding: const EdgeInsets.only(right: 16.0),
                    child: ProductCard(
                      medicineId: product['medicine_id'].toString(),
                      imagePath: product['image_url'] ?? '',
                      name: product['name'] ?? '',
                      mrp: '${product['mrp'] ?? '0.00'}',
                      ptr: '${product['ptr'] ?? '0.00'}',
                      sellingPrice: '${product['selling_price'] ?? '0.00'}',
                      companyName: product['company_name'] ?? '',
                      productDetails: product['product_details'] ?? '',
                      salts: product['salts'] ?? '',
                      offer: offer,
                    ),
                  );
                },
              ),
            ),
            SizedBox(height: 8),
            SizedBox(height: 16),
            Row(
              children: [
                Text(
                  'Best Selling Products',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                Spacer(),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => AllProductsPage(
                            title: 'Best Selling Products',
                            products: bestSellingProducts,
                          ),
                        ),
                      );
                    },
                    child: Text('See All',
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
                    ),
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Container(
              //height: 260,
              child: GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 15,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.65,
                ),
                itemCount: bestSellingProducts.length > 4
                    ? 4
                    : bestSellingProducts.length,
                itemBuilder: (context, index) {
                  final product = bestSellingProducts[index];
                  final offer = determineOffer(product);
                  return ProductCard(
                    medicineId: product['medicine_id'].toString(),
                    imagePath: product['image_url'] ?? '',
                    name: product['name'] ?? '',
                    mrp: '${product['mrp'] ?? '0.00'}',
                    ptr: '${product['ptr'] ?? '0.00'}',
                    sellingPrice: '${product['selling_price'] ?? '0.00'}',
                    companyName: product['company_name'] ?? '',
                    productDetails: product['product_details'] ?? '',
                    salts: product['salts'] ?? '',
                    offer: offer,
                  );
                },
              ),
            ),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  String determineOffer(Map<String, dynamic> product) {
    final sellingPrice = product['selling_price'] ?? '0.00';
    final ptr = product['ptr'] ?? '0.00';
    final discount = product['discount'] ?? '0.00';
    final formattedOffer = product['formatted_offer'] ?? '';

    if (sellingPrice == '0.00' && ptr != '0.00') {
      return formattedOffer.isNotEmpty
          ? formattedOffer
          : ''; //return discount.isNotEmpty ? discount : '';
    } else if (ptr == '0.00' && sellingPrice != '0.00') {
      return discount.isNotEmpty
          ? discount
          : ''; //return formattedOffer.isNotEmpty ? formattedOffer : '';
    } else {
      return '';
    }
  }
}

class ProductCard extends StatelessWidget {
  final String imagePath;
  final String name;
  final String mrp;
  final String ptr;
  final String sellingPrice;
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
    required this.sellingPrice,
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

    bool showPTR = ptr != '0.00';
    bool showSP = sellingPrice != '0.00';
    bool showMRP = mrp.isNotEmpty;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductDetailsPage(
              imagePath: imagePath,
              name: name,
              mrp: mrp,
              ptr: showPTR ? ptr : '', // Pass PTR if it's being shown
              sellingPrice:
              showSP ? sellingPrice : '', // Pass SP if it's being shown
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
                  // Offer Section with space reserved
                  SizedBox(
                    height: 25, // Adjust this height as needed
                    child: Visibility(
                      visible: offer.isNotEmpty,
                      child: Container(
                        padding:
                        EdgeInsets.symmetric(vertical: 4, horizontal: 8),
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
                          if (showMRP)
                            Text(
                              'MRP: $mrp',
                              style:
                              TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          if (showPTR)
                            Text(
                              'PTR: $ptr',
                              style:
                              TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          if (showSP)
                            Text(
                              'SP: $sellingPrice',
                              style:
                              TextStyle(fontSize: 14, color: Colors.grey),
                            ),
                          SizedBox(height: 8),
                          Obx(() {
                            final quantity = cartController.getProductDetails(
                                medicineId)?['quantity'] ??
                                0;
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
                                        'ptr': showPTR
                                            ? ptr
                                            : '', // Pass PTR or empty
                                        'sellingPrice': showSP
                                            ? sellingPrice
                                            : '', // Pass SP or empty
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
                                    inputFormatters: [
                                      FilteringTextInputFormatter.digitsOnly,  // Allow only digits
                                      LengthLimitingTextInputFormatter(3),     // Limit to 3 digits
                                    ],
                                    onSubmitted: (value) {
                                      final newQuantity = int.tryParse(value) ?? 0;
                                      cartController.updateCartItem(
                                        medicineId,
                                        {
                                          'imagePath': imagePath,
                                          'name': name,
                                          'mrp': mrp,
                                          'ptr': showPTR ? ptr : '', // Pass PTR or empty
                                          'sellingPrice': showSP ? sellingPrice : '', // Pass SP or empty
                                          'companyName': companyName,
                                          'productDetails': productDetails,
                                          'salts': salts,
                                          'offer': offer,
                                        },
                                        newQuantity,
                                      );
                                    },
                                  ),

                                  // TextField(
                                  //   keyboardType: TextInputType.number,
                                  //   textAlign: TextAlign.center,
                                  //   decoration: InputDecoration(
                                  //     border: OutlineInputBorder(),
                                  //     contentPadding:
                                  //     EdgeInsets.symmetric(
                                  //         horizontal: 8),
                                  //   ),
                                  //   controller: TextEditingController(
                                  //       text: quantity.toString()),
                                  //   onSubmitted: (value) {
                                  //     final newQuantity =
                                  //         int.tryParse(value) ?? 0;
                                  //     cartController.updateCartItem(
                                  //       medicineId,
                                  //       {
                                  //         'imagePath': imagePath,
                                  //         'name': name,
                                  //         'mrp': mrp,
                                  //         'ptr': showPTR
                                  //             ? ptr
                                  //             : '', // Pass PTR or empty
                                  //         'sellingPrice': showSP
                                  //             ? sellingPrice
                                  //             : '', // Pass SP or empty
                                  //         'companyName': companyName,
                                  //         'productDetails':
                                  //         productDetails,
                                  //         'salts': salts,
                                  //         'offer': offer,
                                  //       },
                                  //       newQuantity,
                                  //     );
                                  //   },
                                  // ),
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
                                        'ptr': showPTR
                                            ? ptr
                                            : '', // Pass PTR or empty
                                        'sellingPrice': showSP
                                            ? sellingPrice
                                            : '', // Pass SP or empty
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
                                      'ptr': showPTR
                                          ? ptr
                                          : '', // Pass PTR or empty
                                      'sellingPrice': showSP
                                          ? sellingPrice
                                          : '', // Pass SP or empty
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






// import 'package:flutter/material.dart';
// import 'package:carousel_slider/carousel_slider.dart';
// import 'dart:convert'; // To handle JSON data
// import 'package:http/http.dart' as http; // Import the http package
// import '../../controller/UserController.dart';
// import '../explore/searchPage.dart';
// import '../widgets/allProducts_page.dart';
// import '../widgets/product_details.dart';
// import 'package:get/get.dart';
// import 'package:evara/controller/cart_component/CartController.dart';
//
// class HomeScreen extends StatefulWidget {
//   @override
//   _HomeScreenState createState() => _HomeScreenState();
// }
//
// class _HomeScreenState extends State<HomeScreen> {
//   List<dynamic> popularMedicines = [];
//   List<dynamic> bestSellingProducts = [];
//   List<dynamic> banners = [];
//
//   final UserController userController = Get.find<UserController>();
//
//   @override
//   void initState() {
//     super.initState();
//     fetchProducts();
//     fetchBanners();
//     fetchSellingProducts();
//   }
//
//   Future<void> fetchProducts() async {
//     final url = Uri.parse(
//         'https://namami-infotech.com/EvaraBackend/src/sku/offers_sku.php');
//     try {
//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         setState(() {
//           popularMedicines = data['medicines'] ?? [];
//         });
//         print('API Response: ${response.body}');
//       } else {
//         print('Failed to load products');
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//   }
//
//   Future<void> fetchSellingProducts() async {
//     final url = Uri.parse(
//         'https://namami-infotech.com/EvaraBackend/src/sku/top_selling.php');
//     try {
//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         setState(() {
//           bestSellingProducts = data['products'] ?? [];
//         });
//         print('API Response: ${response.body}');
//       } else {
//         print('Failed to load products');
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//   }
//
//   Future<void> fetchBanners() async {
//     final url = Uri.parse(
//         'https://namami-infotech.com/EvaraBackend/src/banner/get_banner.php');
//     try {
//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         setState(() {
//           banners = data['data'] ?? [];
//         });
//         print('Banners Response: ${response.body}');
//       } else {
//         print('Failed to load banners');
//       }
//     } catch (e) {
//       print('Error: $e');
//     }
//   }
//
//   Future<void> fetchProductDetails(String medicineId) async {
//     final url = Uri.parse(
//         'https://namami-infotech.com/EvaraBackend/src/sku/get_sku.php?medicine_id=$medicineId');
//     try {
//       final response = await http.get(url);
//       if (response.statusCode == 200) {
//         final data = json.decode(response.body);
//         if (data != null && data['medicine'] != null) {
//           final productDetails = data['medicine'];
//           final offer = determineOffer(productDetails);
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (context) => ProductDetailsPage(
//                 imagePath: productDetails['image_url'] ?? '',
//                 name: productDetails['name'] ?? '',
//                 mrp: '${productDetails['mrp'] ?? '0.00'}',
//                 ptr: '${productDetails['ptr'] ?? '0.00'}',
//                 companyName: productDetails['company_name'] ?? '',
//                 productDetails: productDetails['product_details'] ?? '',
//                 salts: productDetails['salts'] ?? '',
//                 offer: offer,
//                 medicineId: medicineId,
//                 sellingPrice: '',
//               ),
//             ),
//           );
//         } else {
//           print('Product details not found.');
//         }
//       } else {
//         print('Failed to load product details');
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
//                   borderRadius: BorderRadius.circular(25.0),
//                   border: Border.all(color: Colors.black87, width: 2.0),
//                 ),
//                 child: Row(
//                   children: [
//                     Icon(Icons.search, color: Colors.orangeAccent[700]),
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
//             Center(
//               child: banners.isNotEmpty
//                   ? CarouselSlider(
//                       items: banners.map((banner) {
//                         return GestureDetector(
//                           onTap: () async {
//                             final productId = banner['ProductID'].toString();
//                             await fetchProductDetails(productId);
//                           },
//                           child: Container(
//                             decoration: BoxDecoration(
//                               image: DecorationImage(
//                                 image: NetworkImage(banner['BannerURL']),
//                                 fit: BoxFit.cover,
//                               ),
//                             ),
//                           ),
//                         );
//                       }).toList(),
//                       options: CarouselOptions(
//                         height: 150,
//                         aspectRatio: 16 / 9,
//                         viewportFraction: 0.8,
//                         initialPage: 0,
//                         enableInfiniteScroll: true,
//                         reverse: false,
//                         autoPlay: true,
//                         autoPlayInterval: Duration(seconds: 5),
//                         pauseAutoPlayOnTouch: true,
//                         enlargeCenterPage: true,
//                         onPageChanged: (index, reason) {
//                           print('Page changed to $index');
//                         },
//                       ),
//                     )
//                   : CircularProgressIndicator(),
//             ),
//             SizedBox(height: 16),
//             Row(
//               children: [
//                 Text(
//                   'Popular Medicines',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 Spacer(),
//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: TextButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => AllProductsPage(
//                             title: 'Popular Medicines',
//                             products: popularMedicines,
//                           ),
//                         ),
//                       );
//                     },
//                     child: Text('See All',
//                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 8),
//             Container(
//               height: 260,
//               child: ListView.builder(
//                 scrollDirection: Axis.horizontal,
//                 itemCount:
//                     popularMedicines.length > 5 ? 5 : popularMedicines.length,
//                 itemBuilder: (context, index) {
//                   final product = popularMedicines[index];
//                   final offer = determineOffer(product);
//                   return Padding(
//                     padding: const EdgeInsets.only(right: 16.0),
//                     child: ProductCard(
//                       medicineId: product['medicine_id'].toString(),
//                       imagePath: product['image_url'] ?? '',
//                       name: product['name'] ?? '',
//                       mrp: '${product['mrp'] ?? '0.00'}',
//                       ptr: '${product['ptr'] ?? '0.00'}',
//                       sellingPrice: '${product['selling_price'] ?? '0.00'}',
//                       companyName: product['company_name'] ?? '',
//                       productDetails: product['product_details'] ?? '',
//                       salts: product['salts'] ?? '',
//                       offer: offer,
//                     ),
//                   );
//                 },
//               ),
//             ),
//             SizedBox(height: 8),
//             SizedBox(height: 16),
//             Row(
//               children: [
//                 Text(
//                   'Best Selling Products',
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                 ),
//                 Spacer(),
//                 Align(
//                   alignment: Alignment.centerRight,
//                   child: TextButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(
//                           builder: (context) => AllProductsPage(
//                             title: 'Best Selling Products',
//                             products: bestSellingProducts,
//                           ),
//                         ),
//                       );
//                     },
//                     child: Text('See All',
//                       style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.teal),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//             SizedBox(height: 8),
//             Container(
//               //height: 260,
//               child: GridView.builder(
//                 shrinkWrap: true,
//                 physics: NeverScrollableScrollPhysics(),
//                 gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                   crossAxisCount: 2,
//                   crossAxisSpacing: 15,
//                   mainAxisSpacing: 16,
//                   childAspectRatio: 0.65,
//                 ),
//                 itemCount: bestSellingProducts.length > 4
//                     ? 4
//                     : bestSellingProducts.length,
//                 itemBuilder: (context, index) {
//                   final product = bestSellingProducts[index];
//                   final offer = determineOffer(product);
//                   return ProductCard(
//                     medicineId: product['medicine_id'].toString(),
//                     imagePath: product['image_url'] ?? '',
//                     name: product['name'] ?? '',
//                     mrp: '${product['mrp'] ?? '0.00'}',
//                     ptr: '${product['ptr'] ?? '0.00'}',
//                     sellingPrice: '${product['selling_price'] ?? '0.00'}',
//                     companyName: product['company_name'] ?? '',
//                     productDetails: product['product_details'] ?? '',
//                     salts: product['salts'] ?? '',
//                     offer: offer,
//                   );
//                 },
//               ),
//             ),
//             SizedBox(height: 8),
//           ],
//         ),
//       ),
//     );
//   }
//
//   String determineOffer(Map<String, dynamic> product) {
//     final sellingPrice = product['selling_price'] ?? '0.00';
//     final ptr = product['ptr'] ?? '0.00';
//     final discount = product['discount'] ?? '0.00';
//     final formattedOffer = product['formatted_offer'] ?? '';
//
//     if (sellingPrice == '0.00' && ptr != '0.00') {
//       return formattedOffer.isNotEmpty
//           ? formattedOffer
//           : ''; //return discount.isNotEmpty ? discount : '';
//     } else if (ptr == '0.00' && sellingPrice != '0.00') {
//       return discount.isNotEmpty
//           ? discount
//           : ''; //return formattedOffer.isNotEmpty ? formattedOffer : '';
//     } else {
//       return '';
//     }
//   }
// }
//
// class ProductCard extends StatelessWidget {
//   final String imagePath;
//   final String name;
//   final String mrp;
//   final String ptr;
//   final String sellingPrice;
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
//     required this.sellingPrice,
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
//     bool showPTR = ptr != '0.00';
//     bool showSP = sellingPrice != '0.00';
//     bool showMRP = mrp.isNotEmpty;
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
//               ptr: showPTR ? ptr : '', // Pass PTR if it's being shown
//               sellingPrice:
//                   showSP ? sellingPrice : '', // Pass SP if it's being shown
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
//                   // Offer Section with space reserved
//                   SizedBox(
//                     height: 25, // Adjust this height as needed
//                     child: Visibility(
//                       visible: offer.isNotEmpty,
//                       child: Container(
//                         padding:
//                             EdgeInsets.symmetric(vertical: 4, horizontal: 8),
//                         decoration: BoxDecoration(
//                           color: Colors.green,
//                           borderRadius: BorderRadius.only(
//                             topRight: Radius.circular(8),
//                             bottomLeft: Radius.circular(8),
//                           ),
//                         ),
//                         child: Text(
//                           offer,
//                           style: TextStyle(
//                               color: Colors.white, fontWeight: FontWeight.bold),
//                         ),
//                       ),
//                     ),
//                   ),
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
//                             overflow: TextOverflow.ellipsis,
//                           ),
//                           SizedBox(height: 4),
//                           if (showMRP)
//                             Text(
//                               'MRP: $mrp',
//                               style:
//                                   TextStyle(fontSize: 14, color: Colors.grey),
//                             ),
//                           if (showPTR)
//                             Text(
//                               'PTR: $ptr',
//                               style:
//                                   TextStyle(fontSize: 14, color: Colors.grey),
//                             ),
//                           if (showSP)
//                             Text(
//                               'SP: $sellingPrice',
//                               style:
//                                   TextStyle(fontSize: 14, color: Colors.grey),
//                             ),
//                           SizedBox(height: 8),
//                           Obx(() {
//                             final quantity = cartController.getProductDetails(
//                                     medicineId)?['quantity'] ??
//                                 0;
//                             return quantity > 0
//                                 ? Row(
//                                     mainAxisAlignment: MainAxisAlignment.center,
//                                     children: [
//                                       IconButton(
//                                         icon: Icon(Icons.remove_circle_outline),
//                                         onPressed: () {
//                                           cartController.updateCartItem(
//                                             medicineId,
//                                             {
//                                               'imagePath': imagePath,
//                                               'name': name,
//                                               'mrp': mrp,
//                                               'ptr': showPTR
//                                                   ? ptr
//                                                   : '', // Pass PTR or empty
//                                               'sellingPrice': showSP
//                                                   ? sellingPrice
//                                                   : '', // Pass SP or empty
//                                               'companyName': companyName,
//                                               'productDetails': productDetails,
//                                               'salts': salts,
//                                               'offer': offer,
//                                             },
//                                             quantity - 1,
//                                           );
//                                         },
//                                       ),
//                                       Container(
//                                         width: 40,
//                                         height: 30,
//                                         child: TextField(
//                                           keyboardType: TextInputType.number,
//                                           textAlign: TextAlign.center,
//                                           decoration: InputDecoration(
//                                             border: OutlineInputBorder(),
//                                             contentPadding:
//                                                 EdgeInsets.symmetric(
//                                                     horizontal: 8),
//                                           ),
//                                           controller: TextEditingController(
//                                               text: quantity.toString()),
//                                           onSubmitted: (value) {
//                                             final newQuantity =
//                                                 int.tryParse(value) ?? 0;
//                                             cartController.updateCartItem(
//                                               medicineId,
//                                               {
//                                                 'imagePath': imagePath,
//                                                 'name': name,
//                                                 'mrp': mrp,
//                                                 'ptr': showPTR
//                                                     ? ptr
//                                                     : '', // Pass PTR or empty
//                                                 'sellingPrice': showSP
//                                                     ? sellingPrice
//                                                     : '', // Pass SP or empty
//                                                 'companyName': companyName,
//                                                 'productDetails':
//                                                     productDetails,
//                                                 'salts': salts,
//                                                 'offer': offer,
//                                               },
//                                               newQuantity,
//                                             );
//                                           },
//                                         ),
//                                       ),
//                                       IconButton(
//                                         icon: Icon(Icons.add_circle_outline),
//                                         onPressed: () {
//                                           cartController.updateCartItem(
//                                             medicineId,
//                                             {
//                                               'imagePath': imagePath,
//                                               'name': name,
//                                               'mrp': mrp,
//                                               'ptr': showPTR
//                                                   ? ptr
//                                                   : '', // Pass PTR or empty
//                                               'sellingPrice': showSP
//                                                   ? sellingPrice
//                                                   : '', // Pass SP or empty
//                                               'companyName': companyName,
//                                               'productDetails': productDetails,
//                                               'salts': salts,
//                                               'offer': offer,
//                                             },
//                                             quantity + 1,
//                                           );
//                                         },
//                                       ),
//                                     ],
//                                   )
//                                 : ElevatedButton(
//                                     onPressed: () {
//                                       if (userController.isLoggedIn.value) {
//                                         cartController.updateCartItem(
//                                           medicineId,
//                                           {
//                                             'imagePath': imagePath,
//                                             'name': name,
//                                             'mrp': mrp,
//                                             'ptr': showPTR
//                                                 ? ptr
//                                                 : '', // Pass PTR or empty
//                                             'sellingPrice': showSP
//                                                 ? sellingPrice
//                                                 : '', // Pass SP or empty
//                                             'companyName': companyName,
//                                             'productDetails': productDetails,
//                                             'salts': salts,
//                                             'offer': offer,
//                                           },
//                                           1,
//                                         );
//                                       } else {
//                                         Get.snackbar(
//                                           'Login Required',
//                                           'Please log in to add items to the cart',
//                                           backgroundColor: Colors.orangeAccent,
//                                           colorText: Colors.black,
//                                           snackPosition: SnackPosition.BOTTOM,
//                                           margin: EdgeInsets.all(16.0),
//                                           borderRadius: 8.0,
//                                           isDismissible: true,
//                                         );
//                                       }
//                                     },
//                                     child: Text('Add to Cart'),
//                                   );
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
//
//
//
//
