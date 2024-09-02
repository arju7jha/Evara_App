
import 'dart:convert'; // For encoding JSON
import 'package:evara/features/authentication/registration.dart';
import 'package:evara/screens/main_page.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http; // For making HTTP requests
import 'package:shared_preferences/shared_preferences.dart'; // For using SharedPreferences
import 'custom_widget.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  Future<void> _login() async {
    final String phoneNumber = _phoneController.text;
    final String password = _passwordController.text;
    const String companyName = "EVARA";

    if (phoneNumber.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter both phone number and password')),
      );
      return;
    }

    final url = Uri.parse('https://namami-infotech.com/EvaraBackend/src/auth/login.php');
    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'phone_number': phoneNumber,
        'password': password,
        'companyname': companyName,
      }),
    );

    if (response.statusCode == 200) {
      final responseData = jsonDecode(response.body);
      print(responseData); // Print the response in the console

      if (responseData['message'] == 'Login successful') {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        // Save the entire response data using phone number as key
        prefs.setString(phoneNumber, jsonEncode(responseData));

        // Navigate to the MainPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainPage()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'] ?? 'Login failed')),
        );
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Server error. Please try again later.')),
      );
    }
  }

  @override
  void initState() {
    super.initState();
    _checkLoginStatus();
  }

  Future<void> _checkLoginStatus() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final phoneNumber = _phoneController.text;
    if (phoneNumber.isNotEmpty) {
      final userData = prefs.getString(phoneNumber);
      if (userData != null) {
        // User is logged in, navigate to the MainPage
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => MainPage()),
        );
      }
    }
  }

  Future<void> _logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final phoneNumber = _phoneController.text;
    if (phoneNumber.isNotEmpty) {
      // Remove user data from SharedPreferences
      prefs.remove(phoneNumber);
      // Optionally, navigate to the login page or perform other actions
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  alignment: Alignment.center,
                  child: Image.asset(
                    'assets/logos/evara_logo2.png',
                    height: 250,
                  ),
                ),
                SizedBox(height: 30),
                TextField(
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    hintText: 'Phone Number',
                    prefixIcon: Icon(Icons.phone),
                  ),
                ),
                SizedBox(height: 20),
                TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    hintText: 'Password',
                    prefixIcon: Icon(Icons.lock),
                  ),
                ),
                SizedBox(height: 20),
                CustomButton(
                  text: 'Login',
                  onPressed: _login, // Use the _login function on button press
                ),
                SizedBox(height: 20),
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegistrationPage()),
                    );
                  },
                  child: Text(
                    "Don't have an account? Register Here",
                    style: TextStyle(
                      color: Color(0xff1b3156),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// // import 'dart:convert'; // For encoding JSON
// // import 'package:evara/features/authentication/registration.dart';
// // import 'package:evara/screens/main_page.dart';
// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http; // For making HTTP requests
// // import 'package:shared_preferences/shared_preferences.dart'; // For using SharedPreferences
// // import 'custom_widget.dart';
// //
// // class LoginPage extends StatefulWidget {
// //   const LoginPage({Key? key}) : super(key: key);
// //
// //   @override
// //   _LoginPageState createState() => _LoginPageState();
// // }
// //
// // class _LoginPageState extends State<LoginPage> {
// //   final TextEditingController _phoneController = TextEditingController();
// //   final TextEditingController _passwordController = TextEditingController();
// //
// //   Future<void> _login() async {
// //     final String phoneNumber = _phoneController.text;
// //     final String password = _passwordController.text;
// //     const String companyName = "EVARA";
// //
// //     if (phoneNumber.isEmpty || password.isEmpty) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('Please enter both phone number and password')),
// //       );
// //       return;
// //     }
// //
// //     final url = Uri.parse('https://namami-infotech.com/EvaraBackend/src/auth/login.php');
// //     final response = await http.post(
// //       url,
// //       headers: {'Content-Type': 'application/json'},
// //       body: jsonEncode({
// //         'phone_number': phoneNumber,
// //         'password': password,
// //         'companyname': companyName,
// //       }),
// //     );
// //
// //     if (response.statusCode == 200) {
// //       final responseData = jsonDecode(response.body);
// //       print(responseData); // Print the response in the console
// //
// //       if (responseData['message'] == 'Login successful') {
// //         // Extract user details from the response
// //         final userData = responseData['userData'];
// //         final String token = responseData['token'];
// //         final String appUrl = responseData['AppURL'];
// //
// //         // Save the entire response data using phone number as key
// //         final SharedPreferences prefs = await SharedPreferences.getInstance();
// //         prefs.setString(phoneNumber, jsonEncode(responseData));
// //
// //         // Save specific details in SharedPreferences
// //         prefs.setString('loggedInUser', jsonEncode(userData));
// //         prefs.setString('token', token);
// //         prefs.setString('appUrl', appUrl);
// //
// //         // Print extracted details in the console
// //         print('User Data: $userData');
// //         print('Token: $token');
// //         print('AppURL: $appUrl');
// //
// //         // Navigate to the MainPage
// //         Navigator.pushReplacement(
// //           context,
// //           MaterialPageRoute(builder: (context) => MainPage()),
// //         );
// //       } else {
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(content: Text(responseData['message'] ?? 'Login failed')),
// //         );
// //       }
// //     } else {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('Server error. Please try again later.')),
// //       );
// //     }
// //   }
// //
// //   @override
// //   void initState() {
// //     super.initState();
// //     _checkLoginStatus();
// //   }
// //
// //   Future<void> _checkLoginStatus() async {
// //     final SharedPreferences prefs = await SharedPreferences.getInstance();
// //     final phoneNumber = _phoneController.text;
// //     if (phoneNumber.isNotEmpty) {
// //       final userData = prefs.getString(phoneNumber);
// //       if (userData != null) {
// //         // User is logged in, navigate to the MainPage
// //         Navigator.pushReplacement(
// //           context,
// //           MaterialPageRoute(builder: (context) => MainPage()),
// //         );
// //       }
// //     }
// //   }
// //
// //   Future<void> _logout() async {
// //     final SharedPreferences prefs = await SharedPreferences.getInstance();
// //     final phoneNumber = _phoneController.text;
// //     if (phoneNumber.isNotEmpty) {
// //       // Remove user data from SharedPreferences
// //       prefs.remove(phoneNumber);
// //       // Optionally, navigate to the login page or perform other actions
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       body: Center(
// //         child: SingleChildScrollView(
// //           child: Padding(
// //             padding: const EdgeInsets.all(20.0),
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               crossAxisAlignment: CrossAxisAlignment.center,
// //               children: [
// //                 Container(
// //                   alignment: Alignment.center,
// //                   child: Image.asset(
// //                     'assets/logos/evara_logo2.png',
// //                     height: 250,
// //                   ),
// //                 ),
// //                 SizedBox(height: 30),
// //                 TextField(
// //                   controller: _phoneController,
// //                   keyboardType: TextInputType.phone,
// //                   decoration: InputDecoration(
// //                     hintText: 'Phone Number',
// //                     prefixIcon: Icon(Icons.phone),
// //                   ),
// //                 ),
// //                 SizedBox(height: 20),
// //                 TextField(
// //                   controller: _passwordController,
// //                   obscureText: true,
// //                   decoration: InputDecoration(
// //                     hintText: 'Password',
// //                     prefixIcon: Icon(Icons.lock),
// //                   ),
// //                 ),
// //                 SizedBox(height: 20),
// //                 CustomButton(
// //                   text: 'Login',
// //                   onPressed: _login, // Use the _login function on button press
// //                 ),
// //                 SizedBox(height: 20),
// //                 TextButton(
// //                   onPressed: () {
// //                     Navigator.push(
// //                       context,
// //                       MaterialPageRoute(builder: (context) => RegistrationPage()),
// //                     );
// //                   },
// //                   child: Text(
// //                     "Don't have an account? Register Here",
// //                     style: TextStyle(
// //                       color: Color(0xff1b3156),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
//
//
// import 'dart:convert'; // For encoding JSON
// import 'package:evara/features/authentication/registration.dart';
// import 'package:evara/screens/main_page.dart';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http; // For making HTTP requests
// import 'package:shared_preferences/shared_preferences.dart'; // For using SharedPreferences
// import 'custom_widget.dart';
//
// class LoginPage extends StatefulWidget {
//   const LoginPage({Key? key}) : super(key: key);
//
//   @override
//   _LoginPageState createState() => _LoginPageState();
// }
//
// class _LoginPageState extends State<LoginPage> {
//   final TextEditingController _phoneController = TextEditingController();
//   final TextEditingController _passwordController = TextEditingController();
//
//   Future<void> _login() async {
//     final String phoneNumber = _phoneController.text;
//     final String password = _passwordController.text;
//     const String companyName = "EVARA";
//
//     if (phoneNumber.isEmpty || password.isEmpty) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Please enter both phone number and password')),
//       );
//       return;
//     }
//
//     final url = Uri.parse('https://namami-infotech.com/EvaraBackend/src/auth/login.php');
//     final response = await http.post(
//       url,
//       headers: {'Content-Type': 'application/json'},
//       body: jsonEncode({
//         'phone_number': phoneNumber,
//         'password': password,
//         'companyname': companyName,
//       }),
//     );
//
//     if (response.statusCode == 200) {
//       final responseData = jsonDecode(response.body);
//       print(responseData); // Print the response in the console
//
//       if (responseData['message'] == 'Login successful') {
//         final SharedPreferences prefs = await SharedPreferences.getInstance();
//         // Save the entire response data using phone number as key
//         prefs.setString(phoneNumber, jsonEncode(responseData));
//
//         // Navigate to the MainPage
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => MainPage()),
//         );
//       } else {
//         ScaffoldMessenger.of(context).showSnackBar(
//           SnackBar(content: Text(responseData['message'] ?? 'Login failed')),
//         );
//       }
//     } else {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Server error. Please try again later.')),
//       );
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _checkLoginStatus();
//   }
//
//   Future<void> _checkLoginStatus() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     final phoneNumber = _phoneController.text;
//     if (phoneNumber.isNotEmpty) {
//       final userData = prefs.getString(phoneNumber);
//       if (userData != null) {
//         // User is logged in, navigate to the MainPage
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(builder: (context) => MainPage()),
//         );
//       }
//     }
//   }
//
//   Future<void> _logout() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     final phoneNumber = _phoneController.text;
//     if (phoneNumber.isNotEmpty) {
//       // Remove user data from SharedPreferences
//       prefs.remove(phoneNumber);
//       // Optionally, navigate to the login page or perform other actions
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Center(
//         child: SingleChildScrollView(
//           child: Padding(
//             padding: const EdgeInsets.all(20.0),
//             child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//                 Container(
//                   alignment: Alignment.center,
//                   child: Image.asset(
//                     'assets/logos/evara_logo2.png',
//                     height: 250,
//                   ),
//                 ),
//                 SizedBox(height: 30),
//                 TextField(
//                   controller: _phoneController,
//                   keyboardType: TextInputType.phone,
//                   decoration: InputDecoration(
//                     hintText: 'Phone Number',
//                     prefixIcon: Icon(Icons.phone),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 TextField(
//                   controller: _passwordController,
//                   obscureText: true,
//                   decoration: InputDecoration(
//                     hintText: 'Password',
//                     prefixIcon: Icon(Icons.lock),
//                   ),
//                 ),
//                 SizedBox(height: 20),
//                 CustomButton(
//                   text: 'Login',
//                   onPressed: _login, // Use the _login function on button press
//                 ),
//                 SizedBox(height: 20),
//                 TextButton(
//                   onPressed: () {
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(builder: (context) => RegistrationPage()),
//                     );
//                   },
//                   child: Text(
//                     "Don't have an account? Register Here",
//                     style: TextStyle(
//                       color: Color(0xff1b3156),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
//
//
//
//
// //
// //
// // import 'dart:convert'; // For encoding JSON
// // import 'package:evara/features/authentication/registration.dart';
// // import 'package:evara/screens/main_page.dart';
// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http; // For making HTTP requests
// // import 'package:shared_preferences/shared_preferences.dart'; // For using SharedPreferences
// // import 'custom_widget.dart';
// //
// // class LoginPage extends StatefulWidget {
// //   const LoginPage({Key? key}) : super(key: key);
// //
// //   @override
// //   _LoginPageState createState() => _LoginPageState();
// // }
// //
// // class _LoginPageState extends State<LoginPage> {
// //   final TextEditingController _phoneController = TextEditingController();
// //   final TextEditingController _passwordController = TextEditingController();
// //
// //   Future<void> _login() async {
// //     final String phoneNumber = _phoneController.text;
// //     final String password = _passwordController.text;
// //     const String companyName = "EVARA";
// //
// //     if (phoneNumber.isEmpty || password.isEmpty) {
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('Please enter both phone number and password')),
// //       );
// //       return;
// //     }
// //
// //     final url = Uri.parse('https://namami-infotech.com/EvaraBackend/src/auth/login.php');
// //     final response = await http.post(
// //       url,
// //       headers: {'Content-Type': 'application/json'},
// //       body: jsonEncode({
// //         'phone_number': phoneNumber,
// //         'password': password,
// //         'companyname': companyName,
// //       }),
// //     );
// //
// //     if (response.statusCode == 200) {
// //       final responseData = jsonDecode(response.body);
// //       print(responseData); // Print the response in the console
// //
// //       // Check if the response contains a success message
// //       if (responseData['message'] == 'Login successful') {
// //         // Save the response data in SharedPreferences
// //         final SharedPreferences prefs = await SharedPreferences.getInstance();
// //         prefs.setString('userData', jsonEncode(responseData));
// //
// //         // Navigate to the MainPage
// //         Navigator.pushReplacement(
// //           context,
// //           MaterialPageRoute(builder: (context) => MainPage()),
// //         );
// //       } else {
// //         // Show error message from the response
// //         ScaffoldMessenger.of(context).showSnackBar(
// //           SnackBar(content: Text(responseData['message'] ?? 'Login failed')),
// //         );
// //       }
// //     } else {
// //       // Show error message for server error
// //       ScaffoldMessenger.of(context).showSnackBar(
// //         SnackBar(content: Text('Server error. Please try again later.')),
// //       );
// //     }
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       body: Center(
// //         child: SingleChildScrollView(
// //           child: Padding(
// //             padding: const EdgeInsets.all(20.0),
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               crossAxisAlignment: CrossAxisAlignment.center,
// //               children: [
// //                 Container(
// //                   alignment: Alignment.center,
// //                   child: Image.asset(
// //                     'assets/logos/evara_logo2.png',
// //                     height: 250,
// //                   ),
// //                 ),
// //                 SizedBox(height: 30),
// //                 TextField(
// //                   controller: _phoneController,
// //                   keyboardType: TextInputType.phone,
// //                   decoration: InputDecoration(
// //                     hintText: 'Phone Number',
// //                     prefixIcon: Icon(Icons.phone),
// //                   ),
// //                 ),
// //                 SizedBox(height: 20),
// //                 TextField(
// //                   controller: _passwordController,
// //                   obscureText: true,
// //                   decoration: InputDecoration(
// //                     hintText: 'Password',
// //                     prefixIcon: Icon(Icons.lock),
// //                   ),
// //                 ),
// //                 SizedBox(height: 20),
// //                 CustomButton(
// //                   text: 'Login',
// //                   onPressed: _login, // Use the _login function on button press
// //                 ),
// //                 SizedBox(height: 20),
// //                 TextButton(
// //                   onPressed: () {
// //                     Navigator.push(
// //                       context,
// //                       MaterialPageRoute(builder: (context) => RegistrationPage()),
// //                     );
// //                   },
// //                   child: Text(
// //                     "Don't have an account? Register Here",
// //                     style: TextStyle(
// //                       color: Color(0xff1b3156),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
//
//
//
//
// //
// // import 'package:evara/features/authentication/registration.dart';
// // import 'package:evara/screens/main_page.dart';
// // import 'package:flutter/material.dart';
// // import 'custom_widget.dart';
// //
// // class LoginPage extends StatelessWidget {
// //   const LoginPage({Key? key}) : super(key: key);
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       body: Center(
// //         child: SingleChildScrollView( // Add scrolling in case the keyboard opens
// //           child: Padding(
// //             padding: const EdgeInsets.all(20.0),
// //             child: Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               crossAxisAlignment: CrossAxisAlignment.center,
// //               children: [
// //                 // Add Image at the center
// //                 Container(
// //                   alignment: Alignment.center,
// //                   child: Image.asset(
// //                     'assets/logos/evara_logo2.png', // Path to your image asset
// //                     height: 250, // Adjust height as needed
// //                   ),
// //                 ),
// //                 SizedBox(height: 30),
// //                 // Text(
// //                 //   'Login',
// //                 //   style: TextStyle(
// //                 //     fontSize: 32,
// //                 //     fontWeight: FontWeight.bold,
// //                 //     color: Colors.deepPurple,
// //                 //   ),
// //                 // ),
// //                 // SizedBox(height: 20),
// //                 // Phone Number TextField
// //                 TextField(
// //                   keyboardType: TextInputType.phone,
// //                   decoration: InputDecoration(
// //                     hintText: 'Phone Number',
// //                     // border: OutlineInputBorder(
// //                     //   borderRadius: BorderRadius.circular(30),
// //                     // ),
// //                     prefixIcon: Icon(Icons.phone),
// //                   ),
// //                 ),
// //                 SizedBox(height: 20),
// //                 // Password TextField
// //                 TextField(
// //                   obscureText: true,
// //                   decoration: InputDecoration(
// //                     hintText: 'Password',
// //                     // border: OutlineInputBorder(
// //                     //   borderRadius: BorderRadius.circular(30),
// //                     // ),
// //                     prefixIcon: Icon(Icons.lock),
// //                   ),
// //                 ),
// //                 SizedBox(height: 20),
// //                 CustomButton(
// //                   text: 'Login',
// //                   onPressed: () {
// //                     Navigator.push(
// //                       context,
// //                       MaterialPageRoute(builder: (context) => MainPage()),
// //                     );
// //                   },
// //                 ),
// //                 SizedBox(height: 20),
// //                 TextButton(
// //                   onPressed: () {
// //                     Navigator.push(
// //                       context,
// //                       MaterialPageRoute(builder: (context) => RegistrationPage()),
// //                     );
// //                   },
// //                   child: Text(
// //                     "Don't have an account? Register Here",
// //                     style: TextStyle(
// //                       color: Color(0xff1b3156),
// //                     ),
// //                   ),
// //                 ),
// //               ],
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }