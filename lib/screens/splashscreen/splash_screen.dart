import 'dart:async';
import 'dart:convert';  // For decoding JSON
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;  // Import http package

import '../../utils/urls/urlsclass.dart';
import '../main_page.dart';

class SplashScreenPage extends StatefulWidget {
  const SplashScreenPage({super.key});

  @override
  State<SplashScreenPage> createState() => _SplashScreenPageState();
}

class _SplashScreenPageState extends State<SplashScreenPage> {
  String appUrl = '';  // Variable to store the AppURL

  @override
  void initState() {
    super.initState();
    _fetchCompanyData();  // Fetch data when the widget is initialized

    // Delay navigation to MainPage
    Future.delayed(Duration(seconds: 1), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => MainPage()),
      );
    });
  }

  Future<void> _fetchCompanyData() async {
    final url = 'https://namami-infotech.com/Company/company.php?company=EVARA';
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        // If the server returns an OK response, parse the JSON
        final data = json.decode(response.body);
        print('API Response: $data');  // Print the response data

        // Extract the AppURL from the response
        if (data['success'] == true && data['accounts'] != null && data['accounts'].isNotEmpty) {
          final appUrlFromResponse = data['accounts'][0]['AppURL'] ?? '';
          setState(() {
            appUrl = appUrlFromResponse;  // Store the AppURL in the variable
          });
          print('Extracted AppURL: $appUrl');

          // Update the baseUrl in Urlsclass
          Urlsclass.updateBaseUrl(appUrl);
        } else {
          print('No valid account data found.');
        }
      } else {
        // If the server did not return a 200 OK response, throw an error
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      // Handle any errors
      print('Error fetching data: $e');
    }
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
          ],
        ),
      ),
    );
  }
}


// import 'dart:async';
// import 'dart:convert';  // For decoding JSON
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;  // Import http package
//
// import '../main_page.dart';
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
//     super.initState();
//     _fetchCompanyData();  // Fetch data when the widget is initialized
//
//     // Delay navigation to MainPage
//     Future.delayed(Duration(seconds: 1), () {
//       Navigator.of(context).pushReplacement(
//         MaterialPageRoute(builder: (context) => MainPage()),
//       );
//     });
//   }
//
//   Future<void> _fetchCompanyData() async {
//     final url = 'https://namami-infotech.com/Company/company.php?company=EVARA';
//     try {
//       final response = await http.get(Uri.parse(url));
//
//       if (response.statusCode == 200) {
//         // If the server returns an OK response, parse the JSON
//         final data = json.decode(response.body);
//         print('API Response: $data');  // Print the response data
//       } else {
//         // If the server did not return a 200 OK response, throw an error
//         print('Failed to load data: ${response.statusCode}');
//       }
//     } catch (e) {
//       // Handle any errors
//       print('Error fetching data: $e');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Container(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             Center(
//               child: Container(
//                 child: Padding(
//                   padding: const EdgeInsets.all(8.0),
//                   child: Image.asset(
//                     'assets/logos/evara_logo2.png', // Add your image asset path
//                     height: 200,
//                   ),
//                 ),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
//
// // import 'dart:async';
// // import 'package:flutter/material.dart';
// //
// // import '../main_page.dart';
// //
// // class SplashScreenPage extends StatefulWidget {
// //   const SplashScreenPage({super.key});
// //
// //   @override
// //   State<SplashScreenPage> createState() => _SplashScreenPageState();
// // }
// //
// // class _SplashScreenPageState extends State<SplashScreenPage> {
// //   @override
// //   void initState() {
// //     super.initState();
// //     // Delay navigation to MainPage
// //     Future.delayed(Duration(seconds: 1), () {
// //       Navigator.of(context).pushReplacement(
// //         MaterialPageRoute(builder: (context) => MainPage()),
// //       );
// //     });
// //   }
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       body: Container(
// //           child: Column(
// //               mainAxisAlignment: MainAxisAlignment.center,
// //               crossAxisAlignment: CrossAxisAlignment.center,
// //               children: [
// //             Center(
// //               child: Container(
// //                 child: Padding(
// //                   padding: const EdgeInsets.all(8.0),
// //                   child: Image.asset(
// //                     'assets/logos/evara_logo2.png', // Add your image asset path
// //                     height: 200,
// //                   ),
// //                 ),
// //               ),
// //             ),
// //           ])),
// //     );
// //   }
// // }
