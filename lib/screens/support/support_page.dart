import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class SupportPage extends StatefulWidget {
  @override
  _SupportPageState createState() => _SupportPageState();
}

class _SupportPageState extends State<SupportPage> {
  String supportNumber = '';
  String supportEmail = '';

  @override
  void initState() {
    super.initState();
    fetchSupportInfo();
  }

  // Function to fetch support info from the API
  Future<void> fetchSupportInfo() async {
    const String apiUrl = 'https://namami-infotech.com/EvaraBackend/src/support/get_support.php';

    try {
      final response = await http.get(Uri.parse(apiUrl));
      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == true && data['data'] != null) {
          setState(() {
            supportNumber = data['data'][0]['phone_number'];
            supportEmail = data['data'][0]['email'];
          });
        } else {
          print('Error: ${data['message']}');
        }
      } else {
        print('Failed to load support info');
      }
    } catch (error) {
      print('Error fetching support info: $error');
    }
  }

  // Function to launch call
  void _callSupportNumber() async {
    if (supportNumber.isNotEmpty) {
      final Uri callUri = Uri(scheme: 'tel', path: supportNumber);
      if (await canLaunchUrl(callUri)) {
        await launchUrl(callUri);
      } else {
        print('Could not launch $supportNumber');
      }
    }
  }

  // Function to launch email
  void _sendSupportEmail() async {
    if (supportEmail.isNotEmpty) {
      final Uri launchUri = Uri(scheme: 'mailto', path: supportEmail);
      if (await canLaunchUrl(launchUri)) {
        await launchUrl(launchUri);
      } else {
        print('Could not send email to $supportEmail');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.pink,
      body: Container(
        // decoration: BoxDecoration(
        //   gradient: LinearGradient(
        //     colors: [Colors.teal[800]!, Colors.teal[400]!],
        //     begin: Alignment.topCenter,
        //     end: Alignment.bottomCenter,
        //   ),
        // ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Icon and Heading
              Icon(
                Icons.support_agent,
                color: Colors.orangeAccent,
                size: 100,
              ),
              const SizedBox(height: 20),
              const Text(
                'We\'re here to help!',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Contact us anytime for support and assistance.',
                style: TextStyle(
                  fontSize: 18,
                  color: Colors.teal,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),

              // Call Support Button
              GestureDetector(
                onTap: _callSupportNumber,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.orangeAccent,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.phone, color: Colors.teal[800], size: 28),
                      const SizedBox(width: 10),
                      Text(
                        'Call Us: ${supportNumber.isNotEmpty ? supportNumber : 'Loading...'}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal[800],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // Email Support Button
              GestureDetector(
                onTap: _sendSupportEmail,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.symmetric(vertical: 15),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.orangeAccent,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black12,
                        blurRadius: 10,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.email, color: Colors.teal[800], size: 28),
                      const SizedBox(width: 10),
                      Text(
                        'Email Us: ${supportEmail.isNotEmpty ? supportEmail : 'Loading...'}',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: Colors.teal[800],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';
//
// class SupportPage extends StatelessWidget {
//   final String supportNumber = '123-456-7890';
//   final String supportEmail = 'support@gmail.com';
//
//   // Function to launch call
//   void _callSupportNumber() async {
//     final Uri callUri = Uri(scheme: 'tel', path: supportNumber);
//     if (await canLaunchUrl(callUri)) {
//       await launchUrl(callUri);
//     } else {
//       print('Could not launch $supportNumber');
//     }
//   }
//
//   // Function to launch email
//   void _sendSupportEmail() async {
//     final Uri launchUri = Uri(
//       scheme: 'mailto',
//       path: supportEmail,
//     );
//     if (await launchUrl(launchUri)) {
//       await launchUrl(launchUri);
//     } else {
//       print('Could not send email to $supportEmail');
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//
//       body: Container(
//         decoration: BoxDecoration(
//           gradient: LinearGradient(
//             colors: [Colors.teal[800]!, Colors.teal[400]!],
//             begin: Alignment.topCenter,
//             end: Alignment.bottomCenter,
//           ),
//         ),
//         child: Padding(
//           padding: const EdgeInsets.all(20.0),
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               // Icon and Heading
//               Icon(
//                 Icons.support_agent,
//                 color: Colors.orangeAccent,
//                 size: 100,
//               ),
//               const SizedBox(height: 20),
//               const Text(
//                 'We\'re here to help!',
//                 style: TextStyle(
//                   fontSize: 32,
//                   fontWeight: FontWeight.bold,
//                   color: Colors.white,
//                 ),
//               ),
//               const SizedBox(height: 10),
//               const Text(
//                 'Contact us anytime for support and assistance.',
//                 style: TextStyle(
//                   fontSize: 18,
//                   color: Colors.white70,
//                 ),
//                 textAlign: TextAlign.center,
//               ),
//               const SizedBox(height: 40),
//
//               // Call Support Button
//               GestureDetector(
//                 onTap: _callSupportNumber,
//                 child: AnimatedContainer(
//                   duration: const Duration(milliseconds: 200),
//                   padding: const EdgeInsets.symmetric(vertical: 15),
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     color: Colors.white,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black12,
//                         blurRadius: 10,
//                         offset: Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.phone, color: Colors.teal[800], size: 28),
//                       const SizedBox(width: 10),
//                       Text(
//                         'Call Us: $supportNumber',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.teal[800],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 20),
//
//               // Email Support Button
//               GestureDetector(
//                 onTap: _sendSupportEmail,
//                 child: AnimatedContainer(
//                   duration: const Duration(milliseconds: 200),
//                   padding: const EdgeInsets.symmetric(vertical: 15),
//                   width: double.infinity,
//                   decoration: BoxDecoration(
//                     borderRadius: BorderRadius.circular(10),
//                     color: Colors.white,
//                     boxShadow: [
//                       BoxShadow(
//                         color: Colors.black12,
//                         blurRadius: 10,
//                         offset: Offset(0, 4),
//                       ),
//                     ],
//                   ),
//                   child: Row(
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Icon(Icons.email, color: Colors.teal[800], size: 28),
//                       const SizedBox(width: 10),
//                       Text(
//                         'Email Us: $supportEmail',
//                         style: TextStyle(
//                           fontSize: 18,
//                           fontWeight: FontWeight.bold,
//                           color: Colors.teal[800],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
