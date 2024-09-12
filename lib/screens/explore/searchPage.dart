import 'dart:convert';
import 'package:evara/utils/urls/urlsclass.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import '../../controller/UserController.dart';
import '../home/home_page.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final UserController userController = Get.find<UserController>(); // GetX UserController

  List<dynamic> searchResults = [];
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();
  bool isLoading = false;
  String errorMessage = '';

  // Controllers for request product form
  TextEditingController productNameController = TextEditingController();
  TextEditingController companyNameController = TextEditingController();
  TextEditingController remarksController = TextEditingController();
  bool requestSubmitted = false; // Track submission status

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(searchFocusNode);
    });
  }

  Future<void> performSearch(String query) async {
    if (query.length >= 3) {
      setState(() {
        isLoading = true;
        errorMessage = '';
      });
      final url = Uri.parse(Urlsclass.searchPageUrl);
      // final url = Uri.parse('https://namami-infotech.com/EvaraBackend/src/sku/list_sku.php');

      try {
        final response = await http.get(url);

        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          final List<dynamic> allMedicines = data['medicines'] ?? [];
          final results = allMedicines.where((medicine) {
            final name = medicine['name']?.toLowerCase() ?? '';
            return name.contains(query.toLowerCase());
          }).toList();

          setState(() {
            searchResults = results;
            isLoading = false;
            requestSubmitted = false; // Reset request form when new search is made

            if (results.isEmpty) {
              errorMessage = 'No products found for "$query" click here to raise a request !!';
            }
          });
        } else {
          setState(() {
            errorMessage = 'Failed to load products. Server error: ${response.statusCode}';
            isLoading = false;
          });
        }
      } catch (e) {
        setState(() {
          errorMessage = 'An error occurred: $e';
          isLoading = false;
        });
      }
    } else {
      setState(() {
        searchResults = [];
        errorMessage = '';
      });
    }
  }

  String determineOffer(Map<String, dynamic> product) {
    final sellingPrice = product['selling_price'] ?? '0.00';
    final ptr = product['ptr'] ?? '0.00';
    final discount = product['discount'] ?? '';
    final formattedOffer = product['formatted_offer'] ?? '';

    if (sellingPrice == '0.00' && ptr != '0.00') {
      return formattedOffer.isNotEmpty ? formattedOffer : '';
    } else if (ptr == '0.00' && sellingPrice != '0.00') {
      return discount.isNotEmpty ? discount : '';
    } else {
      return '';
    }
  }

  Future<void> submitProductRequest() async {
    // Check if the user is logged in
    if (!userController.isLoggedIn.value) {
      Get.snackbar('Please Login', 'You must be logged in to submit a product request.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black,
        colorText: Colors.orangeAccent,
        margin: const EdgeInsets.all(16.0),
        borderRadius: 8.0,
        isDismissible: true,
        duration: const Duration(seconds: 1),
      );
      return;
    }

    final productName = productNameController.text;
    final companyName = companyNameController.text;
    final remarks = remarksController.text;
    final userId = userController.userId.value;

    if (productName.isEmpty || companyName.isEmpty) {
      Get.snackbar('Error', 'Please fill out all fields.',
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.black,
        colorText: Colors.orangeAccent,
        margin: const EdgeInsets.all(16.0),
        borderRadius: 8.0,
        isDismissible: true,
        duration: const Duration(seconds: 1),
      );
      return;
    }

    // Prepare the request payload
    final requestPayload = {
      'product_name': productName,
      'company_name': companyName,
      'remark': remarks,
      'user_id': int.parse(userId),
    };

    final url = Uri.parse('https://namami-infotech.com/EvaraBackend/src/sku/request_sku.php');

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(requestPayload),
      );

      if (response.statusCode == 200) {
        setState(() {
          requestSubmitted = true;
        });

        Get.snackbar('Success', 'Product request submitted successfully!',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.teal,
          colorText: Colors.black,
          margin: const EdgeInsets.all(16.0),
          borderRadius: 8.0,
          isDismissible: true,
          duration: const Duration(seconds: 1),
        );
        productNameController.clear();
        companyNameController.clear();
        remarksController.clear();
      } else {
        Get.snackbar('Error', 'Failed to submit the request. Please try again later.',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.black,
          colorText: Colors.orangeAccent,
          margin: const EdgeInsets.all(16.0),
          borderRadius: 8.0,
          isDismissible: true,
          duration: const Duration(seconds: 1),
        );
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred: $e', snackPosition: SnackPosition.BOTTOM);
    }
  }

  void showRequestProductDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: const Text('Request Product'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildTextField(productNameController, 'Product Name'),
                const SizedBox(height: 10),
                _buildTextField(companyNameController, 'Company Name'),
                const SizedBox(height: 10),
                _buildTextField(remarksController, 'Remarks (Optional)'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: submitProductRequest,
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    searchFocusNode.dispose();
    searchController.dispose();
    productNameController.dispose();
    companyNameController.dispose();
    remarksController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          children: [
            IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.black, size: 30),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
            Expanded(
              child: Container(
                height: 40,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(25),
                  border: Border.all(color: Colors.black, width: 2),
                ),
                child: TextField(
                  controller: searchController,
                  focusNode: searchFocusNode,
                  decoration: InputDecoration(
                    hintText: 'Search products',
                    hintStyle: const TextStyle(color: Colors.black),
                    border: InputBorder.none,
                    prefixIcon: Icon(Icons.search, color: Colors.orangeAccent[700]),
                  ),
                  onChanged: performSearch,
                ),
              ),
            ),
          ],
        ),
        backgroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            if (isLoading)
              const Center(child: CircularProgressIndicator()),
            if (!isLoading && searchResults.isEmpty && errorMessage.isNotEmpty)
              SingleChildScrollView(
                child: Column(
                  children: [
                    // Display the error message as a clickable button
                    TextButton(
                      onPressed: showRequestProductDialog,
                      child: Text(
                        errorMessage,
                        style: const TextStyle(color: Colors.pink, fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                    ),
                    // Display the image in the center
                    GestureDetector(
                      onTap: showRequestProductDialog,
                      child: Center(
                        child: Image.asset(
                          'assets/images/img_7.png', // Ensure this path is correct
                          width: 450,
                          height: 350,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),

                  ],
                ),
              ),
            if (!isLoading && searchResults.isNotEmpty)
              Expanded(
                child: ListView.builder(
                  itemCount: (searchResults.length / 2).ceil(),
                  itemBuilder: (context, rowIndex) {
                    final firstProductIndex = rowIndex * 2;
                    final secondProductIndex = firstProductIndex + 1;

                    if (firstProductIndex < searchResults.length) {
                      final firstProduct = searchResults[firstProductIndex];
                      final secondProduct = secondProductIndex < searchResults.length
                          ? searchResults[secondProductIndex]
                          : null;

                      final firstProductOffer = determineOffer(firstProduct);
                      final secondProductOffer = secondProduct != null
                          ? determineOffer(secondProduct!) : '';

                      return Row(
                        children: [
                          Expanded(
                            child: ProductCard(
                              imagePath: firstProduct['image_url'] ?? '',
                              name: firstProduct['name'] ?? '',
                              mrp: '${firstProduct['mrp'] ?? '0.00'}',
                              ptr: '${firstProduct['ptr'] ?? '0.00'}',
                              companyName: firstProduct['company_name'] ?? '',
                              productDetails: firstProduct['product_details'] ?? '',
                              salts: firstProduct['salts'] ?? '',
                              offer: firstProductOffer,
                              medicineId: firstProduct['medicine_id'].toString(),
                              sellingPrice: '${firstProduct['selling_price'] ?? '0.00'}',
                            ),
                          ),
                          if (secondProduct != null)
                            Expanded(
                              child: ProductCard(
                                imagePath: secondProduct['image_url'] ?? '',
                                name: secondProduct['name'] ?? '',
                                mrp: '${secondProduct['mrp'] ?? '0.00'}',
                                ptr: '${secondProduct['ptr'] ?? '0.00'}',
                                companyName: secondProduct['company_name'] ?? '',
                                productDetails: secondProduct['product_details'] ?? '',
                                salts: secondProduct['salts'] ?? '',
                                offer: secondProductOffer,
                                medicineId: secondProduct['medicine_id'].toString(),
                                sellingPrice: '${secondProduct['selling_price'] ?? '0.00'}',
                              ),
                            ),
                        ],
                      );
                    } else {
                      return const SizedBox.shrink();
                    }
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hint) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.black),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(25),
        ),
        contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
      ),
    );
  }
}


// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'package:get/get.dart';
// import '../../controller/UserController.dart';
// import '../home/home_page.dart';
//
// class SearchPage extends StatefulWidget {
//   @override
//   _SearchPageState createState() => _SearchPageState();
// }
//
// class _SearchPageState extends State<SearchPage> {
//   final UserController userController = Get.find<UserController>(); // GetX UserController
//
//   List<dynamic> searchResults = [];
//   TextEditingController searchController = TextEditingController();
//   FocusNode searchFocusNode = FocusNode();
//   bool isLoading = false;
//   String errorMessage = '';
//
//   // Controllers for request product form
//   TextEditingController productNameController = TextEditingController();
//   TextEditingController companyNameController = TextEditingController();
//   TextEditingController remarksController = TextEditingController();
//   bool requestSubmitted = false; // Track submission status
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       FocusScope.of(context).requestFocus(searchFocusNode);
//     });
//   }
//
//   Future<void> performSearch(String query) async {
//     if (query.length >= 3) {
//       setState(() {
//         isLoading = true;
//         errorMessage = '';
//       });
//
//       final url = Uri.parse('https://namami-infotech.com/EvaraBackend/src/sku/list_sku.php');
//       try {
//         final response = await http.get(url);
//
//         if (response.statusCode == 200) {
//           final data = json.decode(response.body);
//           final List<dynamic> allMedicines = data['medicines'] ?? [];
//           final results = allMedicines.where((medicine) {
//             final name = medicine['name']?.toLowerCase() ?? '';
//             return name.contains(query.toLowerCase());
//           }).toList();
//
//           setState(() {
//             searchResults = results;
//             isLoading = false;
//             requestSubmitted = false; // Reset request form when new search is made
//
//             if (results.isEmpty) {
//               errorMessage = 'No products found for "$query".';
//             }
//           });
//         } else {
//           setState(() {
//             errorMessage = 'Failed to load products. Server error: ${response.statusCode}';
//             isLoading = false;
//           });
//         }
//       } catch (e) {
//         setState(() {
//           errorMessage = 'An error occurred: $e';
//           isLoading = false;
//         });
//       }
//     } else {
//       setState(() {
//         searchResults = [];
//         errorMessage = '';
//       });
//     }
//   }
//
//   String determineOffer(Map<String, dynamic> product) {
//     final sellingPrice = product['selling_price'] ?? '0.00';
//     final ptr = product['ptr'] ?? '0.00';
//     final discount = product['discount'] ?? '';
//     final formattedOffer = product['formatted_offer'] ?? '';
//
//     if (sellingPrice == '0.00' && ptr != '0.00') {
//       return formattedOffer.isNotEmpty ? formattedOffer : '';
//     } else if (ptr == '0.00' && sellingPrice != '0.00') {
//       return discount.isNotEmpty ? discount : '';
//     } else {
//       return '';
//     }
//   }
//
//   Future<void> submitProductRequest() async {
//     // Check if the user is logged in
//     if (!userController.isLoggedIn.value) {
//       Get.snackbar('Please Login', 'You must be logged in to submit a product request.',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.black,
//         colorText: Colors.orangeAccent,
//         margin: const EdgeInsets.all(16.0),
//         borderRadius: 8.0,
//         isDismissible: true,
//         duration: const Duration(seconds: 1),
//       );
//       return;
//     }
//
//     final productName = productNameController.text;
//     final companyName = companyNameController.text;
//     final remarks = remarksController.text;
//     final userId = userController.userId.value;
//
//     if (productName.isEmpty || companyName.isEmpty) {
//       Get.snackbar('Error', 'Please fill out all fields.',
//         snackPosition: SnackPosition.BOTTOM,
//         backgroundColor: Colors.black,
//         colorText: Colors.orangeAccent,
//         margin: const EdgeInsets.all(16.0),
//         borderRadius: 8.0,
//         isDismissible: true,
//         duration: const Duration(seconds: 1),
//       );
//       return;
//     }
//
//     // Prepare the request payload
//     final requestPayload = {
//       'product_name': productName,
//       'company_name': companyName,
//       'remark': remarks,
//       'user_id': int.parse(userId),
//     };
//
//     final url = Uri.parse('https://namami-infotech.com/EvaraBackend/src/sku/request_sku.php');
//
//     try {
//       final response = await http.post(
//         url,
//         headers: {"Content-Type": "application/json"},
//         body: jsonEncode(requestPayload),
//       );
//
//       if (response.statusCode == 200) {
//         setState(() {
//           requestSubmitted = true;
//         });
//
//         Get.snackbar('Success', 'Product request submitted successfully!',
//             snackPosition: SnackPosition.BOTTOM,
//             backgroundColor: Colors.teal,
//             colorText: Colors.black,
//             margin: const EdgeInsets.all(16.0),
//             borderRadius: 8.0,
//             isDismissible: true,
//             duration: const Duration(seconds: 1),
//         );
//         productNameController.clear();
//         companyNameController.clear();
//         remarksController.clear();
//       } else {
//         Get.snackbar('Error', 'Failed to submit the request. Please try again later.',
//             snackPosition: SnackPosition.BOTTOM,
//           backgroundColor: Colors.black,
//           colorText: Colors.orangeAccent,
//           margin: const EdgeInsets.all(16.0),
//           borderRadius: 8.0,
//           isDismissible: true,
//           duration: const Duration(seconds: 1),
//         );
//       }
//     } catch (e) {
//       Get.snackbar('Error', 'An error occurred: $e', snackPosition: SnackPosition.BOTTOM);
//     }
//   }
//
//   @override
//   void dispose() {
//     searchFocusNode.dispose();
//     searchController.dispose();
//     productNameController.dispose();
//     companyNameController.dispose();
//     remarksController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false,
//         title: Row(
//           children: [
//             IconButton(
//               icon: const Icon(Icons.arrow_back, color: Colors.black, size: 30),
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//             ),
//             Expanded(
//               child: Container(
//                 height: 40,
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(25),
//                   border: Border.all(color: Colors.black, width: 2),
//                 ),
//                 child: TextField(
//                   controller: searchController,
//                   focusNode: searchFocusNode,
//                   decoration: InputDecoration(
//                     hintText: 'Search products',
//                     hintStyle: const TextStyle(color: Colors.black),
//                     border: InputBorder.none,
//                     prefixIcon: Icon(Icons.search, color: Colors.orangeAccent[700]),
//                   ),
//                   onChanged: performSearch,
//                 ),
//               ),
//             ),
//           ],
//         ),
//         backgroundColor: Colors.white,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             const SizedBox(height: 16),
//             if (isLoading)
//               const Center(child: CircularProgressIndicator()),
//             if (!isLoading && errorMessage.isNotEmpty)
//               Column(
//                 children: [
//                   Center(
//                     child: Text(
//                       errorMessage,
//                       style: const TextStyle(color: Colors.orange, fontSize: 16),
//                     ),
//                   ),
//                   const SizedBox(height: 20),
//                   if (!requestSubmitted)
//                     Card(
//                       elevation: 8,
//                       shadowColor: Colors.grey.withOpacity(0.5),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(15),
//                       ),
//                       child: Padding(
//                         padding: const EdgeInsets.all(16.0),
//                         child: Column(
//                           crossAxisAlignment: CrossAxisAlignment.start,
//                           children: [
//                             const Text(
//                               'Request Product',
//                               style: TextStyle(
//                                   fontSize: 18,
//                                   fontWeight: FontWeight.bold,
//                                   //color: Colors.orangeAccent[700]
//                                 ),
//                             ),
//                             const SizedBox(height: 10),
//                             _buildTextField(productNameController, 'Product Name'),
//                             const SizedBox(height: 10),
//                             _buildTextField(companyNameController, 'Company Name'),
//                             const SizedBox(height: 10),
//                             _buildTextField(remarksController, 'Remarks (Optional)'),
//                             const SizedBox(height: 20),
//                             Center(
//                               child: ElevatedButton(
//                                 onPressed: submitProductRequest,
//                                 style: ElevatedButton.styleFrom(
//                                   padding: const EdgeInsets.symmetric(
//                                       horizontal: 40, vertical: 15),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(25),
//                                   ),
//                                   //primary: Colors.orangeAccent[700], // Button color
//                                 ),
//                                 child: const Text(
//                                   'Submit Request',
//                                   style: TextStyle(
//                                       fontSize: 16,
//                                       fontWeight: FontWeight.bold,
//                                       color: Colors.white),
//                                 ),
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ),
//                   if (requestSubmitted)
//                     const Center(
//                       child: Text(
//                         'Product request submitted successfully!',
//                         style: TextStyle(color: Colors.green, fontSize: 16),
//                       ),
//                     ),
//                 ],
//               ),
//             if (!isLoading && searchResults.isNotEmpty)
//               Expanded(
//                 child: ListView.builder(
//                   itemCount: (searchResults.length / 2).ceil(),
//                   itemBuilder: (context, rowIndex) {
//                     final firstProductIndex = rowIndex * 2;
//                     final secondProductIndex = firstProductIndex + 1;
//
//                     if (firstProductIndex < searchResults.length) {
//                       final firstProduct = searchResults[firstProductIndex];
//                       final secondProduct = secondProductIndex < searchResults.length
//                           ? searchResults[secondProductIndex]
//                           : null;
//
//                       final firstProductOffer = determineOffer(firstProduct);
//                       final secondProductOffer = secondProduct != null
//                           ? determineOffer(secondProduct!) : '';
//
//                       return Row(
//                         children: [
//                           Expanded(
//                             child: ProductCard(
//                               imagePath: firstProduct['image_url'] ?? '',
//                               name: firstProduct['name'] ?? '',
//                               mrp: '${firstProduct['mrp'] ?? '0.00'}',
//                               ptr: '${firstProduct['ptr'] ?? '0.00'}',
//                               companyName: firstProduct['company_name'] ?? '',
//                               productDetails: firstProduct['product_details'] ?? '',
//                               salts: firstProduct['salts'] ?? '',
//                               offer: firstProductOffer,
//                               medicineId: firstProduct['medicine_id'].toString(),
//                               sellingPrice: '${firstProduct['selling_price'] ?? '0.00'}',
//                             ),
//                           ),
//                           if (secondProduct != null)
//                             Expanded(
//                               child: ProductCard(
//                                 imagePath: secondProduct['image_url'] ?? '',
//                                 name: secondProduct['name'] ?? '',
//                                 mrp: '${secondProduct['mrp'] ?? '0.00'}',
//                                 ptr: '${secondProduct['ptr'] ?? '0.00'}',
//                                 companyName: secondProduct['company_name'] ?? '',
//                                 productDetails: secondProduct['product_details'] ?? '',
//                                 salts: secondProduct['salts'] ?? '',
//                                 offer: secondProductOffer,
//                                 medicineId: secondProduct['medicine_id'].toString(),
//                                 sellingPrice: '${secondProduct['selling_price'] ?? '0.00'}',
//                               ),
//                             ),
//                         ],
//                       );
//                     } else {
//                       return const SizedBox.shrink();
//                     }
//                   },
//                 ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTextField(TextEditingController controller, String hint) {
//     return TextField(
//       controller: controller,
//       decoration: InputDecoration(
//         hintText: hint,
//         hintStyle: const TextStyle(color: Colors.black),
//         border: OutlineInputBorder(
//           borderRadius: BorderRadius.circular(25),
//         ),
//         contentPadding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
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
