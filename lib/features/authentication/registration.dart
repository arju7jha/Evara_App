
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:intl/intl.dart'; // For date formatting

import 'custom_widget.dart';
import 'login.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final _formKey = GlobalKey<FormState>();
  bool showBusinessInfo = false;

  // Controllers for personal information
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController mailingAddressController = TextEditingController();
  final TextEditingController deliveryAddressController = TextEditingController();

  // Controllers for business information
  final TextEditingController dnNoController = TextEditingController();
  final TextEditingController dlPicController = TextEditingController();
  final TextEditingController dlExpireDateController = TextEditingController();
  final TextEditingController aadharNoController = TextEditingController();
  final TextEditingController aadharPicController = TextEditingController();
  final TextEditingController gstNoController = TextEditingController();
  final TextEditingController gstDocController = TextEditingController();
  final TextEditingController tradeLicController = TextEditingController();
  final TextEditingController panNoController = TextEditingController();

  // Date format
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  // Future<void> _registerUser() async {
  //   if (_formKey.currentState!.validate()) {
  //     final url = Uri.parse('https://namami-infotech.com/EvaraBackend/src/auth/register.php');
  //
  //     final registrationData = {
  //       "username": usernameController.text,
  //       "email": emailController.text,
  //       "phone_number": phoneController.text,
  //       "mailing_address": mailingAddressController.text,
  //       "delivery_address": deliveryAddressController.text,
  //       "dn_no": dnNoController.text,
  //       "dl_pic": dlPicController.text,
  //       "dl_expire_date": _dateFormat.format(DateTime.parse(dlExpireDateController.text)),
  //       "aadhar_no": aadharNoController.text,
  //       "aadhar_pic": aadharPicController.text,
  //       "gst_no": gstNoController.text,
  //       "gst_doc": gstDocController.text,
  //       "trade_lic": tradeLicController.text,
  //       "pan_no": panNoController.text,
  //     };
  //
  //     print("Data to be sent for registration: $registrationData"); // Printing data to the console
  //
  //     try {
  //       final response = await http.post(
  //         url,
  //         headers: {
  //           'Content-Type': 'application/json',
  //         },
  //         body: jsonEncode(registrationData),
  //       );
  //
  //       if (response.statusCode == 200) {
  //         final responseData = jsonDecode(response.body);
  //         print(responseData);
  //
  //         if (responseData['message'] == 'Dealer registered successfully.') {
  //           showDialog(
  //             context: context,
  //             builder: (context) {
  //               return AlertDialog(
  //                 title: Text('Registration Successful'),
  //                 content: Text('You have successfully registered. You will be notified by mail after verification.'),
  //                 actions: [
  //                   TextButton(
  //                     onPressed: () {
  //                       Navigator.pop(context);
  //                     },
  //                     child: Text('OK'),
  //                   ),
  //                 ],
  //               );
  //             },
  //           );
  //         } else {
  //           _showErrorDialog(responseData['message'] ?? 'Registration failed. Please try again.');
  //         }
  //       } else {
  //         _showErrorDialog('Error: ${response.statusCode}. Please try again later.');
  //       }
  //     } catch (e) {
  //       _showErrorDialog('Failed to register. Please check your internet connection and try again.');
  //     }
  //   }
  // }

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      final url = Uri.parse('https://namami-infotech.com/EvaraBackend/src/auth/register.php');

      final registrationData = {
        "username": usernameController.text,
        "email": emailController.text,
        "phone_number": phoneController.text,
        "mailing_address": mailingAddressController.text,
        "delivery_address": deliveryAddressController.text,
        "dn_no": dnNoController.text,
        "dl_pic": dlPicController.text,
        "dl_expire_date": _dateFormat.format(DateTime.parse(dlExpireDateController.text)),
        "aadhar_no": aadharNoController.text,
        "aadhar_pic": aadharPicController.text,
        "gst_no": gstNoController.text,
        "gst_doc": gstDocController.text,
        "trade_lic": tradeLicController.text,
        "pan_no": panNoController.text,
      };

      print("Data to be sent for registration: $registrationData"); // Printing data to the console

      try {
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(registrationData),
        );

        print('API Response: ${response.body}'); // Print the API response in the console

        if (response.statusCode == 201) {
          final responseData = jsonDecode(response.body);

          if (responseData['message'] == 'Dealer registered successfully.') {
            showDialog(
              context: context,
              builder: (context) {
                return AlertDialog(
                  title: Text('Registration Successful'),
                  content: Text('You have successfully registered. You will be notified by mail after verification.'),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text('OK'),
                    ),
                  ],
                );
              },
            );
          } else {
            _showErrorDialog(responseData['message'] ?? 'Registration failed. Please try again.');
          }
        } else {
          _showErrorDialog(' ${response.body}');//_showErrorDialog('Error: ${response.statusCode}. Please try again later.');
        }
      } catch (e) {
        _showErrorDialog('Failed to register. Please check your internet connection and try again.');
      }
    }
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Error'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('OK'),
            ),
          ],
        );
      },
    );
  }

  Future<void> _selectDate(TextEditingController controller) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      controller.text = _dateFormat.format(picked);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Logo at the top of the form
                  Image.asset(
                    'assets/logos/evara_logo2.png', // Replace with your logo asset path
                    height: 230,
                   // width: 100,
                  ),
                  // SizedBox(height: 5),
                  // Text(
                  //   'Registration',
                  //   style: TextStyle(
                  //     fontSize: 20,
                  //     fontWeight: FontWeight.bold,
                  //     color: Colors.deepPurple,
                  //   ),
                  // ),
                 // SizedBox(height: 10),
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 500),
                    transitionBuilder: (child, animation) {
                      final rotate = Tween(begin: pi / 2, end: 0.0).animate(animation);
                      return AnimatedBuilder(
                        animation: rotate,
                        child: child,
                        builder: (context, child) {
                          final isUnder = (ValueKey(showBusinessInfo) != child?.key);
                          var tilt = (isUnder ? 0.003 : 0.0) * pi * animation.value;
                          tilt *= isUnder ? -1.0 : 1.0;
                          return Transform(
                            transform: Matrix4.rotationY(rotate.value)..setEntry(3, 0, tilt),
                            alignment: Alignment.center,
                            child: child,
                          );
                        },
                      );
                    },
                    child: showBusinessInfo ? _buildBusinessInfoCard() : _buildPersonalInfoCard(),
                  ),
                  SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (showBusinessInfo)
                        CustomButton(
                          text: 'Previous',
                          onPressed: () {
                            setState(() {
                              showBusinessInfo = false;
                            });
                          },
                        ),
                      CustomButton(
                        text: showBusinessInfo ? 'Submit' : 'Next',
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            if (showBusinessInfo) {
                              _registerUser();
                            } else {
                              setState(() {
                                showBusinessInfo = true;
                              });
                            }
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: 10),
                  TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => LoginPage()),
                      );
                    },
                    child: Text(
                      "Already have an account? Login",
                      style: TextStyle(
                        color: Colors.black,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildPersonalInfoCard() {
    return Card(
      key: ValueKey(false),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(
              'Personal Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(),
            _buildTextField(usernameController, 'Username', Icons.person),
            _buildTextField(emailController, 'Email', Icons.email, inputType: TextInputType.emailAddress),
            _buildTextField(phoneController, 'Phone Number', Icons.phone, inputType: TextInputType.phone),
            _buildTextField(mailingAddressController, 'Mailing Address', Icons.home),
            _buildTextField(deliveryAddressController, 'Delivery Address', Icons.location_on),
          ],
        ),
      ),
    );
  }

  Widget _buildBusinessInfoCard() {
    return Card(
      key: ValueKey(true),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Text(
              'Business Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            Divider(),
            _buildTextField(dnNoController, 'DN No', Icons.business),
            _buildTextField(dlPicController, 'DL Pic URL', Icons.image),
            _buildDatePickerField(dlExpireDateController, 'DL Expire Date'),
            _buildTextField(aadharNoController, 'Aadhar No', Icons.credit_card),
            _buildTextField(aadharPicController, 'Aadhar Pic URL', Icons.image),
            _buildTextField(gstNoController, 'GST No', Icons.credit_card),
            _buildTextField(gstDocController, 'GST Doc URL', Icons.image),
            _buildTextField(tradeLicController, 'Trade License No', Icons.business),
            _buildTextField(panNoController, 'PAN No', Icons.credit_card),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(TextEditingController controller, String hintText, IconData icon, {TextInputType inputType = TextInputType.text}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        decoration: InputDecoration(
          prefixIcon: Icon(icon),
          labelText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please enter $hintText';
          }
          return null;
        },
      ),
    );
  }

  Widget _buildDatePickerField(TextEditingController controller, String labelText) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        onTap: () => _selectDate(controller),
        controller: controller,
        decoration: InputDecoration(
          //prefixIcon: Icon(Icons.date_range),
          labelText: labelText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          prefixIcon: IconButton(
            icon: Icon(Icons.calendar_today),
            onPressed: () => _selectDate(controller),
          ),
        ),
        readOnly: true,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Please select $labelText';
          }
          return null;
        },
      ),
    );
  }
}



// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
//
// import 'custom_widget.dart';
// import 'login.dart';
//
// class RegistrationPage extends StatefulWidget {
//   const RegistrationPage({Key? key}) : super(key: key);
//
//   @override
//   _RegistrationPageState createState() => _RegistrationPageState();
// }
//
// class _RegistrationPageState extends State<RegistrationPage> {
//   final _formKey = GlobalKey<FormState>();
//
//   final TextEditingController usernameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController mailingAddressController = TextEditingController();
//   final TextEditingController deliveryAddressController = TextEditingController();
//   final TextEditingController dnNoController = TextEditingController();
//   final TextEditingController dlPicController = TextEditingController();
//   final TextEditingController dlExpireDateController = TextEditingController();
//   final TextEditingController aadharNoController = TextEditingController();
//   final TextEditingController aadharPicController = TextEditingController();
//   final TextEditingController gstNoController = TextEditingController();
//   final TextEditingController gstDocController = TextEditingController();
//   final TextEditingController tradeLicController = TextEditingController();
//   final TextEditingController panNoController = TextEditingController();
//
//   Future<void> _registerUser() async {
//     if (_formKey.currentState!.validate()) {
//       final url = Uri.parse('https://namami-infotech.com/EvaraBackend/src/auth/register.php');
//
//       final response = await http.post(
//         url,
//         body: {
//           "username": usernameController.text,
//           "email": emailController.text,
//           "phone_number": phoneController.text,
//           "mailing_address": mailingAddressController.text,
//           "delivery_address": deliveryAddressController.text,
//           "dn_no": dnNoController.text,
//           "dl_pic": dlPicController.text,
//           "dl_expire_date": dlExpireDateController.text,
//           "aadhar_no": aadharNoController.text,
//           "aadhar_pic": aadharPicController.text,
//           "gst_no": gstNoController.text,
//           "gst_doc": gstDocController.text,
//           "trade_lic": tradeLicController.text,
//           "pan_no": panNoController.text,
//         },
//       );
//
//       if (response.statusCode == 200) {
//         final responseData = jsonDecode(response.body);
//         print(responseData);
//
//         if (responseData['status'] == 'success') {
//           showDialog(
//             context: context,
//             builder: (context) {
//               return AlertDialog(
//                 title: Text('Registration Successful'),
//                 content: Text('You have successfully registered. You will be notified by mail after verification.'),
//                 actions: [
//                   TextButton(
//                     onPressed: () {
//                       Navigator.pop(context);
//                     },
//                     child: Text('OK'),
//                   ),
//                 ],
//               );
//             },
//           );
//         } else {
//           _showErrorDialog(responseData['message'] ?? 'Registration failed. Please try again.');
//         }
//       } else {
//         _showErrorDialog('Error: ${response.statusCode}. Please try again later.');
//       }
//     }
//   }
//
//   void _showErrorDialog(String message) {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Error'),
//           content: Text(message),
//           actions: [
//             TextButton(
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//               child: Text('OK'),
//             ),
//           ],
//         );
//       },
//     );
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
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   // Logo at the top of the form
//                   Image.asset(
//                     'assets/logos/evara_logo2.png', // Replace with your logo asset path
//                     height: 100,
//                     width: 100,
//                   ),
//                   SizedBox(height: 20),
//                   Text(
//                     'Register',
//                     style: TextStyle(
//                       fontSize: 28,
//                       fontWeight: FontWeight.bold,
//                       color: Colors.deepPurple,
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   // Grouping personal information fields in a Card widget
//                   Card(
//                     elevation: 2,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(12.0),
//                       child: Column(
//                         children: [
//                           Text(
//                             'Personal Information',
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           Divider(),
//                           _buildTextField(usernameController, 'Username', Icons.person),
//                           _buildTextField(emailController, 'Email', Icons.email, inputType: TextInputType.emailAddress),
//                           _buildTextField(phoneController, 'Phone Number', Icons.phone, inputType: TextInputType.phone),
//                           _buildTextField(mailingAddressController, 'Mailing Address', Icons.home),
//                           _buildTextField(deliveryAddressController, 'Delivery Address', Icons.location_on),
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   // Grouping business information fields in a Card widget
//                   Card(
//                     elevation: 2,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(12.0),
//                       child: Column(
//                         children: [
//                           Text(
//                             'Business Information',
//                             style: TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           Divider(),
//                           _buildTextField(dnNoController, 'DN No', Icons.confirmation_number),
//                           _buildTextField(dlPicController, 'DL Pic URL', Icons.image),
//                           _buildTextField(dlExpireDateController, 'DL Expire Date (YYYY-MM-DD)', Icons.calendar_today, inputType: TextInputType.datetime),
//                           _buildTextField(aadharNoController, 'Aadhar No', Icons.fingerprint),
//                           _buildTextField(aadharPicController, 'Aadhar Pic URL', Icons.image),
//                           _buildTextField(gstNoController, 'GST No', Icons.business),
//                           _buildTextField(gstDocController, 'GST Doc URL', Icons.picture_as_pdf),
//                           _buildTextField(tradeLicController, 'Trade License No', Icons.article),
//                           _buildTextField(panNoController, 'PAN No', Icons.perm_identity),
//                         ],
//                       ),
//                     ),
//                   ),
//                   SizedBox(height: 20),
//                   CustomButton(
//                     text: 'Sign Up',
//                     onPressed: _registerUser,
//                   ),
//                   SizedBox(height: 20),
//                   TextButton(
//                     onPressed: () {
//                       Navigator.push(
//                         context,
//                         MaterialPageRoute(builder: (context) => LoginPage()),
//                       );
//                     },
//                     child: Text(
//                       "Already have an account? Login",
//                       style: TextStyle(
//                         color: Colors.deepPurple,
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//             ),
//           ),
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTextField(TextEditingController controller, String hintText, IconData icon, {TextInputType inputType = TextInputType.text}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: TextFormField(
//         controller: controller,
//         keyboardType: inputType,
//         decoration: InputDecoration(
//           hintText: hintText,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(30),
//           ),
//           prefixIcon: Icon(icon),
//         ),
//         validator: (value) {
//           if (value == null || value.isEmpty) {
//             return 'Please enter $hintText';
//           }
//           return null;
//         },
//       ),
//     );
//   }
// }
//
//
// // import 'package:flutter/material.dart';
// // // import 'package:google_fonts/google_fonts.dart';
// // import 'custom_widget.dart';
// // import 'login.dart';
// //
// // class RegistrationPage extends StatelessWidget {
// //   const RegistrationPage({Key? key}) : super(key: key);
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       backgroundColor: Colors.white,
// //       body: Center(
// //         child: Padding(
// //           padding: const EdgeInsets.all(20.0),
// //           child: Column(
// //             mainAxisAlignment: MainAxisAlignment.center,
// //             children: [
// //               Text(
// //                 'Registration',
// //                 style : TextStyle(
// //                     fontSize: 32,
// //                     fontWeight: FontWeight.bold,
// //                     color: Colors.deepPurple,
// //                   ),
// //                 ),
// //               SizedBox(height: 20),
// //               TextField(
// //                 decoration: InputDecoration(
// //                   hintText: 'Email',
// //                   border: OutlineInputBorder(
// //                     borderRadius: BorderRadius.circular(30),
// //                   ),
// //                   prefixIcon: Icon(Icons.email),
// //                 ),
// //               ),
// //               SizedBox(height: 20),
// //               TextField(
// //                 obscureText: true,
// //                 decoration: InputDecoration(
// //                   hintText: 'Password',
// //                   border: OutlineInputBorder(
// //                     borderRadius: BorderRadius.circular(30),
// //                   ),
// //                   prefixIcon: Icon(Icons.lock),
// //                 ),
// //               ),
// //               SizedBox(height: 20),
// //               CustomButton(
// //                 text: 'Sign Up',
// //                 onPressed: () {
// //                   // Handle sign-up logic here
// //                 },
// //               ),
// //               SizedBox(height: 20),
// //               TextButton(
// //                 onPressed: () {
// //                   Navigator.push(
// //                     context,
// //                     MaterialPageRoute(builder: (context) => LoginPage()),
// //                   );
// //                 },
// //                 child: Text(
// //                   "Already have an account? Login",
// //                   style: TextStyle(
// //                     color: Colors.deepPurple,
// //                   ),
// //                 ),
// //               ),
// //             ],
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// // }
