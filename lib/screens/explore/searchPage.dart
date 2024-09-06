import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../home/home_page.dart';

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  List<dynamic> searchResults = [];
  TextEditingController searchController = TextEditingController();
  FocusNode searchFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(searchFocusNode);
    });
  }

  void performSearch(String query) async {
    if (query.length >= 3) {
      final url = Uri.parse('https://namami-infotech.com/EvaraBackend/src/sku/list_sku.php');
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
          });
        } else {
          print('Failed to load products');
        }
      } catch (e) {
        print('Error: $e');
      }
    }
  }

  String determineOffer(Map<String, dynamic> product) {
    final sellingPrice = product['selling_price'] ?? '0.00';
    final ptr = product['ptr'] ?? '0.00';
    final discount = product['discount'] ?? '';
    final formattedOffer = product['formatted_offer'] ?? '';

    if (sellingPrice == '0.00' && ptr != '0.00') {
      // Return the full formatted offer if available
      return formattedOffer.isNotEmpty ? formattedOffer : '';
    } else if (ptr == '0.00' && sellingPrice != '0.00') {
      // Return the full discount if available
      return discount.isNotEmpty ? discount : '';
    } else {
      return '';
    }

  }

  @override
  void dispose() {
    searchFocusNode.dispose();
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false, // Removes default back button
        title: Row(
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back, color: Colors.black, size: 30,),
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
                    hintStyle: TextStyle(color: Colors.black),
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
            SizedBox(height: 16),
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

                    final firstProductOffer = determineOffer(firstProduct); // Calculate offer for first product
                    final secondProductOffer = secondProduct != null
                        ? determineOffer(secondProduct!) : ''; // Calculate offer for second product

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
                            offer: firstProductOffer, // Pass the calculated offer
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
                              offer: secondProductOffer, // Pass the calculated offer
                              medicineId: secondProduct['medicine_id'].toString(),
                              sellingPrice: '${secondProduct['selling_price'] ?? '0.00'}',
                            ),
                          ),
                      ],
                    );
                  } else {
                    return SizedBox.shrink();
                  }
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}

// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import '../home/home_page.dart';
//
// class SearchPage extends StatefulWidget {
//   @override
//   _SearchPageState createState() => _SearchPageState();
// }
//
// class _SearchPageState extends State<SearchPage> {
//   List<dynamic> searchResults = [];
//   TextEditingController searchController = TextEditingController();
//   FocusNode searchFocusNode = FocusNode();
//
//   @override
//   void initState() {
//     super.initState();
//     WidgetsBinding.instance.addPostFrameCallback((_) {
//       FocusScope.of(context).requestFocus(searchFocusNode);
//     });
//   }
//
//   void performSearch(String query) async {
//     if (query.length >= 3) {
//       final url = Uri.parse('https://namami-infotech.com/EvaraBackend/src/sku/list_sku.php');
//       try {
//         final response = await http.get(url);
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
//           });
//         } else {
//           print('Failed to load products');
//         }
//       } catch (e) {
//         print('Error: $e');
//       }
//     }
//   }
//
//   String determineOffer(Map<String, dynamic> product) {
//     final sellingPrice = product['selling_price'] ?? '0.00';
//     final ptr = product['ptr'] ?? '0.00';
//     final discount = product['discount'] ?? '0.00';
//     final formattedOffer = product['formatted_offer'] ?? '';
//
//     if (sellingPrice == '0.00' && ptr != '0.00') {
//       return formattedOffer.isNotEmpty ? formattedOffer : ''; //return discount.isNotEmpty ? discount : '';
//     } else if (ptr == '0.00' && sellingPrice != '0.00') {
//       return discount.isNotEmpty ? discount : ''; //return formattedOffer.isNotEmpty ? formattedOffer : '';
//     } else {
//       return '';
//     }
//   }
//
//
//   @override
//   void dispose() {
//     searchFocusNode.dispose();
//     searchController.dispose();
//     super.dispose();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         automaticallyImplyLeading: false, // Removes default back button
//         title: Row(
//           children: [
//             IconButton(
//               icon: Icon(Icons.arrow_back, color: Colors.black, size: 30,),
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
//                     hintStyle: TextStyle(color: Colors.black),
//                     border: InputBorder.none,
//                     prefixIcon: Icon(Icons.search, color: Colors.orangeAccent[700]),
//                     suffixIcon: Row(
//                       mainAxisSize: MainAxisSize.min,
//                       // children: [
//                       //   Icon(Icons.mic, color: Colors.black),
//                       //   SizedBox(width: 10),
//                       //   Icon(Icons.camera_alt, color: Colors.black),
//                       //   SizedBox(width: 10),
//                       // ],
//                     ),
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
//             SizedBox(height: 16),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: (searchResults.length / 2).ceil(),
//                 itemBuilder: (context, rowIndex) {
//                   final firstProductIndex = rowIndex * 2;
//                   final secondProductIndex = firstProductIndex + 1;
//
//                   if (firstProductIndex < searchResults.length) {
//                     final firstProduct = searchResults[firstProductIndex];
//                     final secondProduct = secondProductIndex < searchResults.length
//                         ? searchResults[secondProductIndex]
//                         : null;
//                     return Row(
//                       children: [
//                         Expanded(
//                           child: ProductCard(
//                             imagePath: firstProduct['image_url'] ?? '',
//                             name: firstProduct['name'] ?? '',
//                             mrp: '${firstProduct['mrp'] ?? '0.00'}',
//                             ptr: '${firstProduct['ptr'] ?? '0.00'}',
//                             companyName: firstProduct['company_name'] ?? '',
//                             productDetails: firstProduct['product_details'] ?? '',
//                             salts: firstProduct['salts'] ?? '',
//                             offer: firstProduct['offer'] ?? '',
//                             medicineId: firstProduct['medicine_id'].toString(),
//                             sellingPrice: '${firstProduct['selling_price'] ?? '0.00'}',
//
//                           ),
//                         ),
//                         if (secondProduct != null)
//                           Expanded(
//                             child: ProductCard(
//                               imagePath: secondProduct['image_url'] ?? '',
//                               name: secondProduct['name'] ?? '',
//                               mrp: '${secondProduct['mrp'] ?? '0.00'}',
//                               ptr: '${secondProduct['ptr'] ?? '0.00'}',
//                               companyName: secondProduct['company_name'] ?? '',
//                               productDetails: secondProduct['product_details'] ?? '',
//                               salts: secondProduct['salts'] ?? '',
//                               offer: secondProduct['offer'] ?? '',
//                               medicineId: secondProduct['medicine_id'].toString(),
//                               sellingPrice: '${secondProduct['selling_price'] ?? '0.00'}',
//
//                             ),
//                           ),
//                       ],
//                     );
//                   } else {
//                     return SizedBox.shrink();
//                   }
//                 },
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
//
