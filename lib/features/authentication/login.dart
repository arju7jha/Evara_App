import 'dart:convert';
import 'package:evara/features/authentication/registration.dart';
import 'package:evara/screens/main_page.dart';
import 'package:evara/utils/urls/urlsclass.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http; // For making HTTP requests
import 'package:shared_preferences/shared_preferences.dart'; // For using SharedPreferences
import '../../controller/UserController.dart';
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

    final url = Uri.parse(Urlsclass.login);
    // final url = Uri.parse('https://namami-infotech.com/EvaraBackend/src/auth/login.php');
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
      print(responseData);
      if (responseData['message'] == 'Login successful') {
        final SharedPreferences prefs = await SharedPreferences.getInstance();
        // Save the entire response data using phone number as key
        prefs.setString(phoneNumber, jsonEncode(responseData));
        // Update the UserController with the logged-in user's data
        final UserController userController = Get.find<UserController>();
        userController.isLoggedIn.value = true;
        userController.userName.value = responseData['userData']['username'];
        userController.email.value = responseData['userData']['email'];
        userController.phoneNumber.value = responseData['userData']['phone_number'];
        userController.token.value = responseData['token'];
        userController.userId.value = responseData['userData']['user_id'].toString();
        userController.appUrl.value = responseData['AppURL'];
        userController.mailAddress.value = responseData['userData']['mailing_address'].toString();
        userController.deliveryAddress.value = responseData['userData']['delivery_address'].toString();
        userController.dnNo.value = responseData['userData']['dl_no'].toString();
        userController.dlPic.value = responseData['userData']['dl_pic'].toString();
        userController.dlExpireDate.value = responseData['userData']['dl_expire_date'].toString();
        userController.aadharNo.value = responseData['userData']['aadhar_no'].toString();
        userController.aadharPic.value = responseData['userData']['aadhar_pic'].toString();
        userController.gstNo.value = responseData['userData']['gst_no'].toString();
        userController.gstDoc.value = responseData['userData']['gst_doc'].toString();
        userController.tradeLic.value = responseData['userData']['trade_lic'].toString();
        userController.panNo.value = responseData['userData']['pan_no'].toString();

        // Restart the app using Phoenix
        Get.offAll(() => MainPage());
        Phoenix.rebirth(context);
      }

      else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(responseData['message'] ?? 'Login failed')),
        );
      }
    }
    else {
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
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(10), // Restrict to 10 characters
                  ],
                  // maxLength: 10,
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
                  onPressed: _login,
                  // Use the _login function on button press
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
                      //color: Color(0xff1b3156),
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
//     }
//
//
//     else {
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
