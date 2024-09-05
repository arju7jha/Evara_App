// import 'dart:convert';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
//
// class ExplorePage extends StatefulWidget {
//   @override
//   _ExplorePageState createState() => _ExplorePageState();
// }
//
// class _ExplorePageState extends State<ExplorePage> {
//   List<dynamic> allMedicines = [];
//   List<dynamic> displayedMedicines = [];
//   bool isLoading = false;
//   bool hasMore = true;
//   int page = 1;
//   String errorMessage = '';
//   final TextEditingController _searchController = TextEditingController();
//
//   @override
//   void initState() {
//     super.initState();
//     fetchMedicines();
//   }
//
//   Future<void> fetchMedicines({bool isSearch = false}) async {
//     if (isSearch) {
//       page = 1;
//       allMedicines = [];
//       displayedMedicines = [];
//     }
//
//     if (isLoading || !hasMore) return;
//     setState(() {
//       isLoading = true;
//     });
//
//     final url = 'https://namami-infotech.com/EvaraBackend/src/sku/list_sku.php?page=$page';
//     try {
//       final response = await http.get(Uri.parse(url));
//       if (response.statusCode == 200) {
//         final data = jsonDecode(response.body);
//         final newMedicines = data['medicines'] ?? [];
//
//         setState(() {
//           if (newMedicines.isEmpty) {
//             hasMore = false;
//           } else {
//             allMedicines.addAll(newMedicines);
//             displayedMedicines = _filterMedicines(allMedicines);
//             page++;
//           }
//           isLoading = false;
//         });
//       } else {
//         setState(() {
//           errorMessage = 'Failed to load products. Please try again later.';
//           isLoading = false;
//         });
//       }
//     } catch (e) {
//       setState(() {
//         errorMessage = 'An error occurred: $e. Please check your internet connection.';
//         isLoading = false;
//       });
//     }
//   }
//
//   List<dynamic> _filterMedicines(List<dynamic> medicines) {
//     final query = _searchController.text.toLowerCase();
//     if (query.isEmpty || query.length < 3) {
//       return medicines.toList(); // Show first 20 items if no search or search < 3 characters
//     } else {
//       return medicines.where((medicine) {
//         final name = (medicine['name'] ?? '').toLowerCase();
//         return name.contains(query);
//       }).toList(); // Show first 20 items that match search
//     }
//   }
//
//   void _onSearchChanged() {
//     setState(() {
//       displayedMedicines = _filterMedicines(allMedicines);
//     });
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Column(
//         crossAxisAlignment: CrossAxisAlignment.start,
//         children: [
//           Text('Explore', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//           SizedBox(height: 8),
//           TextField(
//             controller: _searchController,
//             onChanged: (value) {
//               if (value.length >= 3) {
//                 _onSearchChanged();
//               } else {
//                 setState(() {
//                   displayedMedicines = allMedicines.toList();
//                 });
//               }
//             },
//             decoration: InputDecoration(
//               border: OutlineInputBorder(),
//               hintText: 'Search products...',
//               suffixIcon: Icon(Icons.search),
//             ),
//           ),
//           SizedBox(height: 8),
//           Expanded(
//             child: isLoading && displayedMedicines.isEmpty
//                 ? Center(child: CircularProgressIndicator())
//                 : errorMessage.isNotEmpty
//                 ? Center(child: Text(errorMessage, style: TextStyle(color: Colors.red)))
//                 : ListView.builder(
//               itemCount: displayedMedicines.length + (hasMore ? 1 : 0),
//               itemBuilder: (context, index) {
//                 if (index == displayedMedicines.length) {
//                   fetchMedicines();
//                   return Center(child: CircularProgressIndicator());
//                 }
//
//                 final medicine = displayedMedicines[index];
//                 return Card(
//                   margin: EdgeInsets.symmetric(vertical: 8),
//                   elevation: 4,
//                   child: ListTile(
//                     contentPadding: EdgeInsets.all(12),
//                     leading: medicine['image_url'] != null && medicine['image_url'].isNotEmpty
//                         ? Image.network(medicine['image_url'], width: 60, height: 60, fit: BoxFit.cover)
//                         : Icon(Icons.image, size: 60),
//                     title: Text(medicine['name'] ?? 'No Name', style: TextStyle(fontWeight: FontWeight.bold)),
//                     subtitle: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         Text('PTR: ${medicine['ptr'] ?? 'N/A'}', style: TextStyle(color: Colors.green)),
//                         Text('MRP: ${medicine['mrp'] ?? 'N/A'}', style: TextStyle(color: Colors.red)),
//                       ],
//                     ),
//                     trailing: Icon(Icons.arrow_forward_ios),
//                   ),
//                 );
//               },
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
