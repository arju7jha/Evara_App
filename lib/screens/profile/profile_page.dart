import 'package:evara/features/authentication/login.dart';
import 'package:evara/screens/main_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controller/UserController.dart';
import '../../features/authentication/custom_widget.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserController userController = Get.find<UserController>(); // Access UserController

  @override
  void initState() {
    super.initState();
    // Load user data when screen is initialized
    userController.loadUserData(); // Call the updated method
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          // Obx will observe changes in the isLoggedIn value from UserController
          child: Obx(() => userController.isLoggedIn.value
              ? _buildLoggedInView()
              : _buildLoggedOutView(context)),
        ),
      ),
      floatingActionButton: Obx(() {
        return userController.isLoggedIn.value
            ? FloatingActionButton(
          onPressed: _logout,
          tooltip: 'Logout',
          child: Icon(Icons.logout),
        )
            : SizedBox(); // Use SizedBox to replace 'null'
      }),
    );
  }

  Widget _buildLoggedInView() {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: CircleAvatar(
                radius: 40,
                backgroundColor: Color(0xff1b3156),
                child: Text(
                  userController.userName.value.isNotEmpty
                      ? userController.userName.value[0].toUpperCase()
                      : 'U',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: Text(
                'Hello, ${userController.userName.value}!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 16),
            Divider(),
            ListTile(
              leading: Icon(Icons.email, color: Color(0xff1b3156)),
              title: Text('Email'),
              subtitle: Text(userController.email.value),
            ),
            ListTile(
              leading: Icon(Icons.phone, color: Color(0xff1b3156)),
              title: Text('Phone Number'),
              subtitle: Text(userController.phoneNumber.value),
            ),
            SizedBox(height: 20),
            Center(
              child: ElevatedButton.icon(
                onPressed: () {
                  // Implement edit profile functionality
                },
                icon: Icon(Icons.edit, color: Colors.white),
                label: Text('Edit Profile'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xffe04545),
                  padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLoggedOutView(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          Icons.account_circle,
          size: 100,
          color: Colors.grey[400],
        ),
        SizedBox(height: 20),
        Text(
          'Welcome to Our App!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 10),
        Text(
          'Please log in to continue',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        SizedBox(height: 20),
        CustomButton(
          text: 'Login',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => LoginPage()),
            );
          },
        ),
      ],
    );
  }

  void _logout() {
    userController.logout();
  }
}

//
// import 'package:evara/features/authentication/login.dart';
// import 'package:evara/screens/main_page.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
// import 'dart:convert';
// import '../../controller/UserController.dart';
// import '../../features/authentication/custom_widget.dart';
//
// class ProfileScreen extends StatefulWidget {
//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends State<ProfileScreen> {
//   final UserController userController = Get.find<UserController>(); // Access UserController
//   bool isLoggedIn = false;
//   String userName = '';
//   String email = '';
//   String phoneNumber = '';
//
//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//   }
//
//   Future<void> _loadUserData() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     final allKeys = prefs.getKeys();
//     String? userKey = allKeys.isNotEmpty ? allKeys.first : null;
//
//     if (userKey != null) {
//       final String? userDataJson = prefs.getString(userKey);
//       if (userDataJson != null) {
//         final Map<String, dynamic>? responseData = jsonDecode(userDataJson);
//         if (responseData != null) {
//           final userDataInfo = responseData['userData'];
//           setState(() {
//             isLoggedIn = true;
//             userName = userDataInfo['email'] ?? 'User';
//             email = userDataInfo['email'] ?? 'No Email';
//             phoneNumber = userDataInfo['phone_number'] ?? 'No Phone Number';
//           });
//         }
//       }
//     }
//   }
//
//   Future<void> _logout() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     final allKeys = prefs.getKeys();
//     String? userKey = allKeys.isNotEmpty ? allKeys.first : null;
//
//     if (userKey != null) {
//       prefs.remove(userKey);
//     }
//     // Navigate to the LoginPage
//     Navigator.pushReplacement(
//       context,
//       MaterialPageRoute(builder: (context) => MainPage()),
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Center(
//           child: isLoggedIn ? _buildLoggedInView() : _buildLoggedOutView(context),
//         ),
//       ),
//       floatingActionButton: isLoggedIn
//           ? FloatingActionButton(
//         onPressed: _logout,
//         tooltip: 'Logout',
//         child: Icon(Icons.logout),
//       )
//           : null,
//     );
//   }
//
//   Widget _buildLoggedInView() {
//     return Card(
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
//       elevation: 4,
//       child: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Center(
//               child: CircleAvatar(
//                 radius: 40,
//                 backgroundColor: Color(0xff1b3156),
//                 child: Text(
//                   userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
//                   style: TextStyle(fontSize: 24, color: Colors.white),
//                 ),
//               ),
//             ),
//             SizedBox(height: 16),
//             Center(
//               child: Text(
//                 'Hello, $userName!',
//                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//               ),
//             ),
//             SizedBox(height: 16),
//             Divider(),
//             ListTile(
//               leading: Icon(Icons.email, color: Color(0xff1b3156)),
//               title: Text('Email'),
//               subtitle: Text(email),
//             ),
//             ListTile(
//               leading: Icon(Icons.phone, color: Color(0xff1b3156)),
//               title: Text('Phone Number'),
//               subtitle: Text(phoneNumber),
//             ),
//             SizedBox(height: 20),
//             Center(
//               child: ElevatedButton.icon(
//                 onPressed: () {
//                   // Implement edit profile functionality
//                 },
//                 icon: Icon(Icons.edit, color: Colors.white),
//                 label: Text('Edit Profile'),
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Color(0xffe04545),
//                   padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildLoggedOutView(BuildContext context) {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       children: [
//         Icon(
//           Icons.account_circle,
//           size: 100,
//           color: Colors.grey[400],
//         ),
//         SizedBox(height: 20),
//         Text(
//           'Welcome to Our App!',
//           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
//         ),
//         SizedBox(height: 10),
//         Text(
//           'Please log in to continue',
//           style: TextStyle(fontSize: 16, color: Colors.grey),
//         ),
//         SizedBox(height: 20),
//         CustomButton(
//           text: 'Login',
//           onPressed: () {
//             Navigator.push(
//               context,
//               MaterialPageRoute(builder: (context) => LoginPage()),
//             );
//           },
//         ),
//       ],
//     );
//   }
// }
//
//
//
//
// // import 'package:evara/features/authentication/login.dart';
// // import 'package:evara/screens/main_page.dart';
// // import 'package:flutter/material.dart';
// // import 'package:shared_preferences/shared_preferences.dart'; // Import for SharedPreferences
// // import 'dart:convert'; // Import for JSON decoding
// // import '../../features/authentication/custom_widget.dart';
// //
// // class ProfileScreen extends StatefulWidget {
// //   @override
// //   _ProfileScreenState createState() => _ProfileScreenState();
// // }
// //
// // class _ProfileScreenState extends State<ProfileScreen> {
// //   bool isLoggedIn = false;
// //   String userName = '';
// //   String email = '';
// //   String phoneNumber = '';
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _loadUserData();
// //   }
// //
// //   // Future<void> _loadUserData() async {
// //   //   final SharedPreferences prefs = await SharedPreferences.getInstance();
// //   //   // Fetch the phone number to get the user data, assuming it's stored
// //   //   final allKeys = prefs.getKeys(); // Get all keys to find the stored user
// //   //   String? userKey = allKeys.isNotEmpty ? allKeys.first : null;
// //   //
// //   //   if (userKey != null) {
// //   //     final String? userDataJson = prefs.getString(userKey);
// //   //     if (userDataJson != null) {
// //   //       final Map<String, dynamic> userData = jsonDecode(userDataJson);
// //   //       print(userData); // Print the user data in the console
// //   //       setState(() {
// //   //         isLoggedIn = true;
// //   //         userName = userData['userData']['data']['email'] ?? 'User'; // Use the email as the username for display
// //   //         email = userData['userData']['data']['email'] ?? 'No Email';
// //   //         phoneNumber = userData['userData']['data']['phone_number'] ?? 'No Phone Number';
// //   //       });
// //   //     }
// //   //   }
// //   // }
// //
// //
// //   Future<void> _loadUserData() async {
// //     final SharedPreferences prefs = await SharedPreferences.getInstance();
// //     // Fetch the phone number to get the user data, assuming it's stored
// //     final allKeys = prefs.getKeys(); // Get all keys to find the stored user
// //     String? userKey = allKeys.isNotEmpty ? allKeys.first : null;
// //
// //     if (userKey != null) {
// //       final String? userDataJson = prefs.getString(userKey);
// //       if (userDataJson != null) {
// //         final Map<String, dynamic>? responseData = jsonDecode(userDataJson);
// //         if (responseData != null) {
// //           print(responseData); // Print the user data in the console
// //
// //           // Access the 'userData' directly from the root level
// //           final userDataInfo = responseData['userData'];
// //           setState(() {
// //             isLoggedIn = true;
// //             userName = userDataInfo['email'] ?? 'User'; // Use the email as the username for display
// //             email = userDataInfo['email'] ?? 'No Email';
// //             phoneNumber = userDataInfo['phone_number'] ?? 'No Phone Number';
// //           });
// //         }
// //       }
// //     }
// //   }
// //
// //   Future<void> _logout() async {
// //     final SharedPreferences prefs = await SharedPreferences.getInstance();
// //     final allKeys = prefs.getKeys(); // Get all keys to find the stored user
// //     String? userKey = allKeys.isNotEmpty ? allKeys.first : null;
// //
// //     if (userKey != null) {
// //       prefs.remove(userKey);
// //     }
// //     // Navigate to the LoginPage
// //     Navigator.pushReplacement(
// //       context,
// //       MaterialPageRoute(builder: (context) => MainPage()),
// //     );
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Center(
// //           child: isLoggedIn ? _buildLoggedInView() : _buildLoggedOutView(context),
// //         ),
// //       ),
// //       floatingActionButton: isLoggedIn
// //           ? FloatingActionButton(
// //         onPressed: _logout,
// //         tooltip: 'Logout',
// //         child: Icon(Icons.logout),
// //        // backgroundColor: Colors.red,
// //       )
// //           : null,
// //     );
// //   }
// //
// //   // Widget to build the UI when the user is logged in
// //   Widget _buildLoggedInView() {
// //     return Card(
// //       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
// //       elevation: 4,
// //       child: Padding(
// //         padding: const EdgeInsets.all(16.0),
// //         child: Column(
// //           mainAxisSize: MainAxisSize.min,
// //           crossAxisAlignment: CrossAxisAlignment.start,
// //           children: [
// //             Center(
// //               child: CircleAvatar(
// //                 radius: 40,
// //                 backgroundColor: Color(0xff1b3156),
// //                 child: Text(
// //                   userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
// //                   style: TextStyle(fontSize: 24, color: Colors.white),
// //                 ),
// //               ),
// //             ),
// //             SizedBox(height: 16),
// //             Center(
// //               child: Text(
// //                 'Hello, $userName!',
// //                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
// //               ),
// //             ),
// //             SizedBox(height: 16),
// //             Divider(),
// //             ListTile(
// //               leading: Icon(Icons.email, color: Color(0xff1b3156)),
// //               title: Text('Email'),
// //               subtitle: Text(email),
// //             ),
// //             ListTile(
// //               leading: Icon(Icons.phone, color: Color(0xff1b3156)),
// //               title: Text('Phone Number'),
// //               subtitle: Text(phoneNumber),
// //             ),
// //             SizedBox(height: 20),
// //             Center(
// //               child: ElevatedButton.icon(
// //                 onPressed: () {
// //                   // Implement edit profile functionality
// //                 },
// //                 icon: Icon(Icons.edit, color: Colors.white),
// //                 label: Text('Edit Profile'),
// //                 style: ElevatedButton.styleFrom(
// //                   backgroundColor: Color(0xffe04545),
// //                   padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
// //                 ),
// //               ),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   // Widget to build the UI when the user is not logged in
// //   Widget _buildLoggedOutView(BuildContext context) {
// //     return Column(
// //       mainAxisSize: MainAxisSize.min,
// //       children: [
// //         Icon(
// //           Icons.account_circle,
// //           size: 100,
// //           color: Colors.grey[400],
// //         ),
// //         SizedBox(height: 20),
// //         Text(
// //           'Welcome to Our App!',
// //           style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
// //         ),
// //         SizedBox(height: 10),
// //         Text(
// //           'Please log in to continue',
// //           style: TextStyle(fontSize: 16, color: Colors.grey),
// //         ),
// //         SizedBox(height: 20),
// //         CustomButton(
// //           text: 'Login',
// //           onPressed: () {
// //             Navigator.push(
// //               context,
// //               MaterialPageRoute(builder: (context) => LoginPage()),
// //             );
// //           },
// //         ),
// //       ],
// //     );
// //   }
// // }
