import 'dart:async';
import 'package:flutter/material.dart';

import '../main_page.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  @override
  void initState() {
    super.initState();
    // Delay navigation to MainPage
    Future.delayed(Duration(seconds: 1), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MainPage()),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
          child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Center(
                  child: Container(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Image.asset(
                        'assets/logos/evara_logo2.png', // Add your image asset path
                        height: 200,
                      ),
                    ),
                  ),
                ),
              ])),
    );
  }
}



// import 'dart:async';
// import 'package:flutter/material.dart';
// import 'package:hr_smile/features/authentication/login.dart';
// import 'package:hr_smile/screens/main_page.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class SplashScreenPage extends StatefulWidget {
//   const SplashScreenPage({super.key});
//
//   @override
//   State<SplashScreenPage> createState() => _SplashScreenPageState();
// }
//
// class _SplashScreenPageState extends State<SplashScreenPage> {
//   @override
//   void initState() {
//     // TODO: implement initState
//     super.initState();
//     storedata();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//           child: Column(
//               mainAxisAlignment: MainAxisAlignment.center,
//               crossAxisAlignment: CrossAxisAlignment.center,
//               children: [
//             Center(
//               child: Container(
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Image.asset(
//                     'assets/logos/splash_Logo.jpg', // Add your image asset path
//                     height: 200,
//                   ),
//                 ),
//               ),
//             ),
//           ])),
//     );
//   }
//
//   void storedata() async {
//     SharedPreferences prefs = await SharedPreferences.getInstance();
//     var emp_id = prefs.getString("emp_id") ?? "";
//     print("data: " + emp_id.toString());
//     Timer(Duration(seconds: 1), () {
//       if (emp_id != "null" && emp_id != "") {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => MainPage(),
//           ),
//         );
//       } else {
//         Navigator.pushReplacement(
//           context,
//           MaterialPageRoute(
//             builder: (context) => LoginPage(),
//           ),
//         );
//       }
//     });
//   }
// }
