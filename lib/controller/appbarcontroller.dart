import 'package:flutter/material.dart';

import 'cart_component/ShoppingCartPage.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  //final bool isSearching;
  //final Function toggleSearch;
  //final TextEditingController searchController;

  const CustomAppBar({
    Key? key,
    //required this.isSearching,
    //required this.toggleSearch,
    //required this.searchController,
  }) : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.menu, size: 30,),
        onPressed: () {
          // Handle menu button press
        },
      ),
      title: Text('Evara'), // Always display "Evara" as the title
      // In the CustomAppBar widget's actions array
      actions: [
        IconButton(
          icon: Icon(Icons.add_shopping_cart_outlined, size: 30),
          padding: EdgeInsets.only(right: 20),
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ShoppingCartPage()),
            );
          },
        ),
      ],
    );
  }
}




//
//
//
// import 'package:flutter/material.dart';
//
// class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
//   final bool isSearching;
//   final Function toggleSearch;
//   final TextEditingController searchController;
//
//   const CustomAppBar({
//     Key? key,
//     required this.isSearching,
//     required this.toggleSearch,
//     required this.searchController,
//   }) : super(key: key);
//
//   @override
//   Size get preferredSize => Size.fromHeight(kToolbarHeight);
//
//   @override
//   Widget build(BuildContext context) {
//     double searchBoxWidth = MediaQuery.of(context).size.width * 0.6;
//
//     return AppBar(
//       elevation: 0,
//       leading: IconButton(
//         icon: Icon(Icons.menu),
//         onPressed: () {
//           // Handle menu button press
//         },
//       ),
//       title: isSearching
//           ? SearchBox(searchController: searchController, width: searchBoxWidth)
//           : Text('Evara'),
//       actions: [
//         IconButton(
//           icon: Icon(isSearching ? Icons.close : Icons.search),
//           onPressed: () => toggleSearch(),
//         ),
//         IconButton(
//           icon: Icon(Icons.add_shopping_cart_outlined),
//           onPressed: () {
//             // Handle shopping cart button press
//           },
//         ),
//       ],
//     );
//   }
// }
//
//
// class SearchBox extends StatelessWidget {
//   final TextEditingController searchController;
//   final double width;
//
//   const SearchBox({
//     Key? key,
//     required this.searchController,
//     required this.width,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return SizedBox(
//       width: width,
//       child: TextField(
//         controller: searchController,
//         style: TextStyle(color: Colors.white),
//         decoration: InputDecoration(
//           hintText: 'Find a medicine',
//           hintStyle: TextStyle(color: Colors.white),
//           border: OutlineInputBorder(
//             borderSide: BorderSide(color: Colors.white),
//           ),
//           enabledBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: Colors.white),
//           ),
//           focusedBorder: OutlineInputBorder(
//             borderSide: BorderSide(color: Colors.white),
//           ),
//           contentPadding: EdgeInsets.symmetric(
//             vertical: 10.0,
//             horizontal: 15.0,
//           ),
//         ),
//       ),
//     );
//   }
// }