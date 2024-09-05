// import 'package:flutter/material.dart';
//
// class CustomTabBar extends StatelessWidget {
//   final int selectedIndex;
//   final List<String> tabs;
//   final Function(int) onTabSelected;
//
//   const CustomTabBar({super.key,
//     required this.selectedIndex,
//     required this.tabs,
//     required this.onTabSelected,
//   });
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 60,
//       color: const Color(0xff1b3156),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//         children: List.generate(tabs.length, (index) {
//           return GestureDetector(
//             onTap: () => onTabSelected(index),
//             child: Container(
//               padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
//               decoration: BoxDecoration(
//                 color: selectedIndex == index ? Colors.orangeAccent : Colors.grey,
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Text(
//                 tabs[index],
//                 style: TextStyle(
//                   color: selectedIndex == index ? Colors.black : Colors.white,
//                 ),
//               ),
//             ),
//           );
//         }),
//       ),
//     );
//   }
// }
