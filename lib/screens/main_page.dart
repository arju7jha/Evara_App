import 'package:flutter/material.dart';
import '../controller/appbarcontroller.dart';
import '../controller/bottomNavigationBar.dart';
import 'explore/explore_page.dart';
import 'home/home_page.dart';
import 'order/orders_page.dart';
import 'profile/profile_page.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _currentIndex = 0;
  // bool _isSearching = false;
  // final TextEditingController _searchController = TextEditingController();

  final List<Widget> _pages = [
    HomeScreen(),
    ExplorePage(),
    OrderScreen(),
    ProfileScreen(),
  ];

  // void _toggleSearch() {
  //   setState(() {
  //     _isSearching = !_isSearching;
  //     if (!_isSearching) {
  //       _searchController.clear();
  //     }
  //   });
  // }

  void _onBottomNavTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        // isSearching: _isSearching,
        // toggleSearch: _toggleSearch,
        // searchController: _searchController,
      ),
      body: _pages[_currentIndex],
      bottomNavigationBar: CustomBottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: _onBottomNavTapped,
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'explore/explore_page.dart';
// import 'home/home_page.dart';
// import 'order/orders_page.dart';
// import 'profile/profile_page.dart';
//
// class MainPage extends StatefulWidget {
//   @override
//   _MainPageState createState() => _MainPageState();
// }
//
// class _MainPageState extends State<MainPage> {
//   int _currentIndex = 0;
//   bool _isSearching = false;
//   final TextEditingController _searchController = TextEditingController();
//
//   final List<Widget> _pages = [
//     HomeScreen(),
//     ExploreScreen(),
//     OrderScreen(),
//     ProfileScreen(),
//   ];
//
//   @override
//   Widget build(BuildContext context) {
//     double searchBoxWidth = MediaQuery.of(context).size.width * 0.6;
//
//     return Scaffold(
//       appBar: AppBar(
//         elevation: 0,
//         leading: IconButton(
//           icon: Icon(Icons.menu),
//           onPressed: () {
//             // Handle menu button press
//           },
//         ),
//         title: _isSearching
//             ? SizedBox(
//           width: searchBoxWidth, // Responsive width
//           child: TextField(
//             controller: _searchController,
//             style: TextStyle(color: Colors.white),
//             decoration: InputDecoration(
//               hintText: 'Find a medicine',
//               hintStyle: TextStyle(color: Colors.white),
//               border: OutlineInputBorder(
//                 borderSide: BorderSide(color: Colors.white),
//               ),
//               enabledBorder: OutlineInputBorder(
//                 borderSide: BorderSide(color: Colors.white),
//               ),
//               focusedBorder: OutlineInputBorder(
//                 borderSide: BorderSide(color: Colors.white),
//               ),
//               contentPadding: EdgeInsets.symmetric(
//                 vertical: 10.0,
//                 horizontal: 15.0,
//               ),
//             ),
//           ),
//         )
//             : Text('Evara'),
//         actions: [
//           IconButton(
//             icon: Icon(_isSearching ? Icons.close : Icons.search),
//             onPressed: () {
//               setState(() {
//                 _isSearching = !_isSearching;
//                 if (!_isSearching) {
//                   _searchController.clear();
//                 }
//               });
//             },
//           ),
//           IconButton(
//             icon: Icon(Icons.add_shopping_cart_outlined),
//             onPressed: () {
//               // Handle shopping cart button press
//             },
//           ),
//         ],
//       ),
//       body: _pages[_currentIndex],
//       bottomNavigationBar: BottomNavigationBar(
//         type: BottomNavigationBarType.fixed,
//         currentIndex: _currentIndex,
//         onTap: (index) {
//           setState(() {
//             _currentIndex = index;
//           });
//         },
//         selectedItemColor: Color(0xff033464),
//         unselectedItemColor: Colors.grey,
//         items: const [
//           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
//           BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
//           BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Order'),
//           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
//         ],
//       ),
//     );
//   }
// }
//
//
// // import 'package:flutter/material.dart';
// // import 'explore/explore_page.dart';
// // import 'home/home_page.dart';
// // import 'order/orders_page.dart';
// // import 'profile/profile_page.dart';
// //
// //
// // class MainPage extends StatefulWidget {
// //   @override
// //   _MainPageState createState() => _MainPageState();
// // }
// //
// // class _MainPageState extends State<MainPage> {
// //   int _currentIndex = 0;
// //   bool _isSearching = false;
// //   final _searchController = TextEditingController();
// //
// //   final _pages = [
// //     HomeScreen(),
// //     ExploreScreen(),
// //     OrderScreen(),
// //     ProfileScreen(),
// //   ];
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(
// //         //backgroundColor: Colors.white,
// //         elevation: 0,
// //         leading: IconButton(
// //           icon: Icon(Icons.menu),
// //           onPressed: () {},
// //         ),
// //         title: _isSearching
// //             ? Container(
// //           width: 250, // Increase the width of the search box
// //           child: TextField(
// //             controller: _searchController,
// //             style: TextStyle(color: Colors.white), // Text color
// //             decoration: InputDecoration(
// //               hintText: 'Find a medicine',
// //               hintStyle: TextStyle(color: Colors.white), // Hint text color
// //               border: OutlineInputBorder(
// //                 borderSide: BorderSide(color: Colors.white), // Border color
// //               ),
// //               enabledBorder: OutlineInputBorder(
// //                 borderSide: BorderSide(color: Colors.white), // Border color when enabled
// //               ),
// //               focusedBorder: OutlineInputBorder(
// //                 borderSide: BorderSide(color: Colors.white), // Border color when focused
// //               ),
// //               contentPadding: EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0), // Adjust height and add left padding
// //             ),
// //           ),
// //         )
// //             : Text('Evara'), //style: TextStyle(color: Colors.black)),
// //         actions: [
// //           IconButton(
// //             icon: Icon(_isSearching ? Icons.close : Icons.search),
// //             onPressed: () {
// //               setState(() {
// //                 _isSearching = !_isSearching;
// //                 if (!_isSearching) {
// //                   _searchController.clear();
// //                 }
// //               });
// //             },
// //           ),
// //           IconButton(
// //             icon: Icon(Icons.add_shopping_cart_outlined),
// //             onPressed: () {},
// //           ),
// //         ],
// //       ),
// //
// //
// //       body: _pages[_currentIndex],
// //       bottomNavigationBar: BottomNavigationBar(
// //         type: BottomNavigationBarType.fixed,
// //         currentIndex: _currentIndex,
// //         onTap: (index) {
// //           setState(() {
// //             _currentIndex = index;
// //           });
// //         },
// //         selectedItemColor: Color(0xff033464),//Colors.blue,
// //         unselectedItemColor: Colors.grey,
// //         items: [
// //           BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
// //           BottomNavigationBarItem(icon: Icon(Icons.explore), label: 'Explore'),
// //           BottomNavigationBarItem(icon: Icon(Icons.shopping_cart), label: 'Order'),
// //           BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
// //         ],
// //       ),
// //     );
// //   }
// // }