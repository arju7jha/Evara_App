// import 'package:evara/features/authentication/login.dart';
// import 'package:evara/screens/main_page.dart';
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart'; // Import for SharedPreferences
// import 'dart:convert'; // Import for JSON decoding
// import '../../features/authentication/custom_widget.dart';
//
// class ProfileScreen extends StatefulWidget {
//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends State<ProfileScreen> {
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
//   // Future<void> _loadUserData() async {
//   //   final SharedPreferences prefs = await SharedPreferences.getInstance();
//   //   // Fetch the phone number to get the user data, assuming it's stored
//   //   final allKeys = prefs.getKeys(); // Get all keys to find the stored user
//   //   String? userKey = allKeys.isNotEmpty ? allKeys.first : null;
//   //
//   //   if (userKey != null) {
//   //     final String? userDataJson = prefs.getString(userKey);
//   //     if (userDataJson != null) {
//   //       final Map<String, dynamic> userData = jsonDecode(userDataJson);
//   //       print(userData); // Print the user data in the console
//   //       setState(() {
//   //         isLoggedIn = true;
//   //         userName = userData['userData']['data']['email'] ?? 'User'; // Use the email as the username for display
//   //         email = userData['userData']['data']['email'] ?? 'No Email';
//   //         phoneNumber = userData['userData']['data']['phone_number'] ?? 'No Phone Number';
//   //       });
//   //     }
//   //   }
//   // }
//
//
//   Future<void> _loadUserData() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     // Fetch the phone number to get the user data, assuming it's stored
//     final allKeys = prefs.getKeys(); // Get all keys to find the stored user
//     String? userKey = allKeys.isNotEmpty ? allKeys.first : null;
//
//     if (userKey != null) {
//       final String? userDataJson = prefs.getString(userKey);
//       if (userDataJson != null) {
//         final Map<String, dynamic>? responseData = jsonDecode(userDataJson);
//         if (responseData != null) {
//           print(responseData); // Print the user data in the console
//
//           // Access the 'userData' directly from the root level
//           final userDataInfo = responseData['userData'];
//           setState(() {
//             isLoggedIn = true;
//             userName = userDataInfo['email'] ?? 'User'; // Use the email as the username for display
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
//     final allKeys = prefs.getKeys(); // Get all keys to find the stored user
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
//        // backgroundColor: Colors.red,
//       )
//           : null,
//     );
//   }
//
//   // Widget to build the UI when the user is logged in
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
//   // Widget to build the UI when the user is not logged in
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



import 'package:evara/features/authentication/login.dart';
import 'package:evara/screens/main_page.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../controller/UserController.dart';
import '../../features/authentication/custom_widget.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final UserController userController = Get.find<UserController>(); // Access UserController
  bool isLoggedIn = false;
  String userName = '';
  String email = '';
  String phoneNumber = '';

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final allKeys = prefs.getKeys();
    String? userKey = allKeys.isNotEmpty ? allKeys.first : null;

    if (userKey != null) {
      final String? userDataJson = prefs.getString(userKey);
      if (userDataJson != null) {
        final Map<String, dynamic>? responseData = jsonDecode(userDataJson);
        if (responseData != null) {
          final userDataInfo = responseData['userData'];
          setState(() {
            isLoggedIn = true;
            userName = userDataInfo['email'] ?? 'User';
            email = userDataInfo['email'] ?? 'No Email';
            phoneNumber = userDataInfo['phone_number'] ?? 'No Phone Number';
          });
        }
      }
    }
  }

  Future<void> _logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final allKeys = prefs.getKeys();
    String? userKey = allKeys.isNotEmpty ? allKeys.first : null;

    if (userKey != null) {
      prefs.remove(userKey);
    }
    // Navigate to the LoginPage
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => MainPage()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: isLoggedIn ? _buildLoggedInView() : _buildLoggedOutView(context),
        ),
      ),
      floatingActionButton: isLoggedIn
          ? FloatingActionButton(
        onPressed: _logout,
        tooltip: 'Logout',
        child: Icon(Icons.logout),
      )
          : null,
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
                  userName.isNotEmpty ? userName[0].toUpperCase() : 'U',
                  style: TextStyle(fontSize: 24, color: Colors.white),
                ),
              ),
            ),
            SizedBox(height: 16),
            Center(
              child: Text(
                'Hello, $userName!',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 16),
            Divider(),
            ListTile(
              leading: Icon(Icons.email, color: Color(0xff1b3156)),
              title: Text('Email'),
              subtitle: Text(email),
            ),
            ListTile(
              leading: Icon(Icons.phone, color: Color(0xff1b3156)),
              title: Text('Phone Number'),
              subtitle: Text(phoneNumber),
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
}



// import 'dart:convert'; // For decoding JSON
// import 'package:flutter/material.dart';
// import 'package:shared_preferences/shared_preferences.dart'; // For using SharedPreferences
// import '../../features/authentication/login.dart';
// import '../../features/authentication/custom_widget.dart';
//
// class ProfileScreen extends StatefulWidget {
//   @override
//   _ProfileScreenState createState() => _ProfileScreenState();
// }
//
// class _ProfileScreenState extends State<ProfileScreen> {
//   bool _isLoggedIn = false;
//   String _userName = '';
//   String _userEmail = ''; // Add more fields as needed
//   String _userPhoneNumber = '';
//
//   @override
//   void initState() {
//     super.initState();
//     _loadUserData();
//   }
//
//   Future<void> _loadUserData() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     final phoneNumber = prefs.getString('phoneNumber'); // Get phone number as key
//
//     if (phoneNumber != null) {
//       final userData = prefs.getString(phoneNumber);
//       if (userData != null) {
//         final Map<String, dynamic> data = jsonDecode(userData);
//         setState(() {
//           _isLoggedIn = true;
//           _userName = data['userName'] ?? '';
//           _userEmail = data['email'] ?? '';
//           _userPhoneNumber = data['phoneNumber'] ?? '';
//         });
//       }
//     }
//   }
//
//   Future<void> _logout() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     final phoneNumber = prefs.getString('phoneNumber');
//
//     if (phoneNumber != null) {
//       await prefs.remove(phoneNumber);
//       setState(() {
//         _isLoggedIn = false;
//         _userName = '';
//         _userEmail = '';
//         _userPhoneNumber = '';
//       });
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Center(
//           child: _isLoggedIn ? _buildLoggedInView() : _buildLoggedOutView(context),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildLoggedInView() {
//     return Column(
//       mainAxisSize: MainAxisSize.min,
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         CircleAvatar(
//           radius: 40,
//           backgroundColor: Colors.blueAccent,
//           child: Text(
//             _userName.isNotEmpty ? _userName[0] : '?', // Display the first letter of the user's name
//             style: TextStyle(fontSize: 24, color: Colors.white),
//           ),
//         ),
//         SizedBox(height: 16),
//         Text(
//           'Hello, $_userName!',
//           style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//         ),
//         SizedBox(height: 8),
//         ListTile(
//           leading: Icon(Icons.email),
//           title: Text('Email'),
//           subtitle: Text(_userEmail.isNotEmpty ? _userEmail : 'N/A'),
//         ),
//         ListTile(
//           leading: Icon(Icons.phone),
//           title: Text('Phone Number'),
//           subtitle: Text(_userPhoneNumber.isNotEmpty ? _userPhoneNumber : 'N/A'),
//         ),
//         SizedBox(height: 16),
//         ElevatedButton(
//           onPressed: () {
//             // Implement edit profile functionality
//           },
//           child: Text('Edit Profile'),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.blueAccent,
//             padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//           ),
//         ),
//         SizedBox(height: 16),
//         ElevatedButton(
//           onPressed: _logout,
//           child: Text('Logout'),
//           style: ElevatedButton.styleFrom(
//             backgroundColor: Colors.redAccent,
//             padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
//           ),
//         ),
//       ],
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
// // import 'package:evara/features/authentication/login.dart';
// // import 'package:flutter/material.dart';
// //
// // import '../../features/authentication/custom_widget.dart';
// //
// // class ProfileScreen extends StatelessWidget {
// //   final bool isLoggedIn; // Simulates the logged-in state
// //   final String userName; // Stores the logged-in user's name
// //
// //   ProfileScreen({this.isLoggedIn = false, this.userName = ''});
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
// //     );
// //   }
// //
// //   // Widget to build the UI when the user is logged in
// //   Widget _buildLoggedInView() {
// //     return Column(
// //       mainAxisSize: MainAxisSize.min,
// //       crossAxisAlignment: CrossAxisAlignment.start,
// //       children: [
// //         CircleAvatar(
// //           radius: 40,
// //           backgroundColor: Colors.blueAccent,
// //           child: Text(
// //             userName[0], // Display the first letter of the user's name
// //             style: TextStyle(fontSize: 24, color: Colors.white),
// //           ),
// //         ),
// //         SizedBox(height: 16),
// //         Text(
// //           'Hello, $userName!',
// //           style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
// //         ),
// //         SizedBox(height: 8),
// //         ListTile(
// //           leading: Icon(Icons.email),
// //           title: Text('Email'),
// //           subtitle: Text('johndoe@example.com'), // Example email, make dynamic in real apps
// //         ),
// //         ListTile(
// //           leading: Icon(Icons.phone),
// //           title: Text('Phone Number'),
// //           subtitle: Text('123-456-7890'), // Example phone, make dynamic in real apps
// //         ),
// //         SizedBox(height: 16),
// //         ElevatedButton(
// //           onPressed: () {
// //             // Implement edit profile functionality
// //           },
// //           child: Text('Edit Profile'),
// //           style: ElevatedButton.styleFrom(
// //             backgroundColor: Colors.blueAccent,
// //             padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
// //           ),
// //         ),
// //       ],
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
// //
// //       ],
// //     );
// //