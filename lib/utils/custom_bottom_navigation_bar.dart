// import 'package:flutter/material.dart';
//
// class CustomBottomNavigationBar extends StatelessWidget {
//   final int currentIndex;
//   final Function(int) onTabTapped;
//
//   const CustomBottomNavigationBar({
//     required this.currentIndex,
//     required this.onTabTapped,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return BottomNavigationBar(
//       selectedItemColor: Colors.black,
//       unselectedItemColor: Colors.black,
//       currentIndex: currentIndex,
//       onTap: onTabTapped,
//       items: [
//         _buildBottomNavigationBarItem(Icons.home, 'Home', 0),
//         // _buildBottomNavigationBarItem(Icons.dashboard, 'Dashboard', 1),
//         _buildBottomNavigationBarItem(Icons.notifications, 'Notification', 1),
//         _buildBottomNavigationBarItem(Icons.account_circle, 'Profile', 2),
//       ],
//     );
//   }
//
//   BottomNavigationBarItem _buildBottomNavigationBarItem(IconData icon, String label, int index) {
//     return BottomNavigationBarItem(
//       icon: currentIndex == index
//           ? Container(
//         padding: const EdgeInsets.all(8.0),
//         decoration: BoxDecoration(
//           color: Colors.orange,
//           shape: BoxShape.circle,
//         ),
//         child: Icon(icon, color: Colors.white),
//       )
//           : Icon(icon),
//       label: label,
//     );
//   }
// }
