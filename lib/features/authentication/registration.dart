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
  String selectedCategory = 'PHARMA'; // Default category

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

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      final url = Uri.parse('https://namami-infotech.com/EvaraBackend/src/auth/register.php');

      final registrationData = {
        "username": usernameController.text,
        "email": emailController.text,
        "phone_number": phoneController.text,
        "mailing_address": mailingAddressController.text,
        "delivery_address": deliveryAddressController.text,
        "category": selectedCategory, // Include category in the registration data
        "dn_no": selectedCategory == 'PHARMA' ? dnNoController.text : '',
        "dl_pic": selectedCategory == 'PHARMA' ? dlPicController.text : '',
        "dl_expire_date": selectedCategory == 'PHARMA' ? _dateFormat.format(DateTime.parse(dlExpireDateController.text)) : '',
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
          _showErrorDialog(' ${response.body}');
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
                  ),
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
            SizedBox(height: 10),
            Text(
              'Category',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Expanded(
                  child: ListTile(
                    title: Text('PHARMA'),
                    leading: Radio<String>(
                      value: 'PHARMA',
                      groupValue: selectedCategory,
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value!;
                        });
                      },
                    ),
                  ),
                ),
                Expanded(
                  child: ListTile(
                    title: Text('FMCG'),
                    leading: Radio<String>(
                      value: 'FMCG',
                      groupValue: selectedCategory,
                      onChanged: (value) {
                        setState(() {
                          selectedCategory = value!;
                        });
                      },
                    ),
                  ),
                ),
              ],
            ),
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
            if (selectedCategory == 'PHARMA') ...[
              _buildTextField(dnNoController, 'DL Number', Icons.credit_card),
              _buildTextField(dlPicController, 'DL Picture', Icons.image),
              _buildTextField(dlExpireDateController, 'DL Expiry Date', Icons.date_range, inputType: TextInputType.datetime, onTap: () => _selectDate(dlExpireDateController)),
            ],
            _buildTextField(aadharNoController, 'Aadhar Number', Icons.credit_card),
            _buildTextField(aadharPicController, 'Aadhar Picture', Icons.image),
            _buildTextField(gstNoController, 'GST Number', Icons.business),
            _buildTextField(gstDocController, 'GST Document', Icons.file_copy),
            _buildTextField(tradeLicController, 'Trade License', Icons.document_scanner),
            _buildTextField(panNoController, 'PAN Number', Icons.credit_card),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      TextEditingController controller,
      String label,
      IconData icon, {
        TextInputType inputType = TextInputType.text,
        VoidCallback? onTap,
      }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon),
          border: OutlineInputBorder(),
        ),
        keyboardType: inputType,
        onTap: onTap,
        validator: (value) {
          if (value == null || value.isEmpty) {
            if (label.contains('DL Number') || label.contains('DL Picture') || label.contains('DL Expiry Date')) {
              return selectedCategory == 'PHARMA' ? 'Please enter $label' : null;
            } else {
              return 'Please enter $label';
            }
          }
          return null;
        },
      ),
    );
  }
}


// import 'dart:math';
// import 'package:flutter/material.dart';
// import 'package:http/http.dart' as http;
// import 'dart:convert';
// import 'package:intl/intl.dart'; // For date formatting
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
//   bool showBusinessInfo = false;
//   String category = 'PHARMA'; // Default category is PHARMA
//
//   // Controllers for personal information
//   final TextEditingController usernameController = TextEditingController();
//   final TextEditingController emailController = TextEditingController();
//   final TextEditingController phoneController = TextEditingController();
//   final TextEditingController mailingAddressController = TextEditingController();
//   final TextEditingController deliveryAddressController = TextEditingController();
//
//   // Controllers for business information
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
//   // Date format
//   final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
//
//   Future<void> _registerUser() async {
//     if (_formKey.currentState!.validate()) {
//       final url = Uri.parse('https://namami-infotech.com/EvaraBackend/src/auth/register.php');
//
//       final registrationData = {
//         "username": usernameController.text,
//         "email": emailController.text,
//         "phone_number": phoneController.text,
//         "mailing_address": mailingAddressController.text,
//         "delivery_address": deliveryAddressController.text,
//         "category": category,  // Add the category field to registration data
//         "dn_no": dnNoController.text,
//         "dl_pic": dlPicController.text,
//         "dl_expire_date": dlExpireDateController.text.isNotEmpty ? _dateFormat.format(DateTime.parse(dlExpireDateController.text)) : null,
//         "aadhar_no": aadharNoController.text,
//         "aadhar_pic": aadharPicController.text,
//         "gst_no": gstNoController.text,
//         "gst_doc": gstDocController.text,
//         "trade_lic": tradeLicController.text,
//         "pan_no": panNoController.text,
//       };
//
//       print("Data to be sent for registration: $registrationData");
//
//       try {
//         final response = await http.post(
//           url,
//           headers: {
//             'Content-Type': 'application/json',
//           },
//           body: jsonEncode(registrationData),
//         );
//
//         print('API Response: ${response.body}');
//
//         if (response.statusCode == 201) {
//           final responseData = jsonDecode(response.body);
//
//           if (responseData['message'] == 'Dealer registered successfully.') {
//             showDialog(
//               context: context,
//               builder: (context) {
//                 return AlertDialog(
//                   title: Text('Registration Successful'),
//                   content: Text('You have successfully registered. You will be notified by mail after verification.'),
//                   actions: [
//                     TextButton(
//                       onPressed: () {
//                         Navigator.pop(context);
//                       },
//                       child: Text('OK'),
//                     ),
//                   ],
//                 );
//               },
//             );
//           } else {
//             _showErrorDialog(responseData['message'] ?? 'Registration failed. Please try again.');
//           }
//         } else {
//           _showErrorDialog(' ${response.body}');
//         }
//       } catch (e) {
//         _showErrorDialog('Failed to register. Please check your internet connection and try again.');
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
//   Future<void> _selectDate(TextEditingController controller) async {
//     final DateTime? picked = await showDatePicker(
//       context: context,
//       initialDate: DateTime.now(),
//       firstDate: DateTime(2000),
//       lastDate: DateTime(2101),
//     );
//
//     if (picked != null) {
//       controller.text = _dateFormat.format(picked);
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
//             padding: const EdgeInsets.all(25.0),
//             child: Form(
//               key: _formKey,
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Image.asset(
//                     'assets/logos/evara_logo2.png', // Replace with your logo asset path
//                     height: 230,
//                   ),
//                   _buildCategorySelection(), // Add category selection
//                   AnimatedSwitcher(
//                     duration: Duration(milliseconds: 500),
//                     transitionBuilder: (child, animation) {
//                       final rotate = Tween(begin: pi / 2, end: 0.0).animate(animation);
//                       return AnimatedBuilder(
//                         animation: rotate,
//                         child: child,
//                         builder: (context, child) {
//                           final isUnder = (ValueKey(showBusinessInfo) != child?.key);
//                           var tilt = (isUnder ? 0.003 : 0.0) * pi * animation.value;
//                           tilt *= isUnder ? -1.0 : 1.0;
//                           return Transform(
//                             transform: Matrix4.rotationY(rotate.value)..setEntry(3, 0, tilt),
//                             alignment: Alignment.center,
//                             child: child,
//                           );
//                         },
//                       );
//                     },
//                     child: showBusinessInfo ? _buildBusinessInfoCard() : _buildPersonalInfoCard(),
//                   ),
//                   SizedBox(height: 10),
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       if (showBusinessInfo)
//                         CustomButton(
//                           text: 'Previous',
//                           onPressed: () {
//                             setState(() {
//                               showBusinessInfo = false;
//                             });
//                           },
//                         ),
//                       CustomButton(
//                         text: showBusinessInfo ? 'Submit' : 'Next',
//                         onPressed: () {
//                           if (_formKey.currentState!.validate()) {
//                             if (showBusinessInfo) {
//                               _registerUser();
//                             } else {
//                               setState(() {
//                                 showBusinessInfo = true;
//                               });
//                             }
//                           }
//                         },
//                       ),
//                     ],
//                   ),
//                   SizedBox(height: 10),
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
//                         color: Colors.black,
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
//    _buildCategorySelection() {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         Text(
//           'Select Category:',
//           style: TextStyle(
//             fontSize: 16,
//             fontWeight: FontWeight.bold,
//           ),
//         ),
//         Row(
//           children: [
//             Expanded(
//               child: RadioListTile<String>(
//                 title: Text('PHARMA'),
//                 value: 'PHARMA',
//                 groupValue: category,
//                 onChanged: (value) {
//                   setState(() {
//                     category = value!;
//                   });
//                 },
//               ),
//             ),
//             Expanded(
//               child: RadioListTile<String>(
//                 title: Text('FMCG'),
//                 value: 'FMCG',
//                 groupValue: category,
//                 onChanged: (value) {
//                   setState(() {
//                     category = value!;
//                   });
//                 },
//               ),
//             ),
//           ],
//         ),
//       ],
//     );
//   }
//
//   // Widget _buildPersonalInfoCard() {
//   //   return Card(
//   //     key: ValueKey(false),
//   //     elevation: 2,
//   //     shape: RoundedRectangleBorder(
//   //       borderRadius: BorderRadius.circular(10),
//   //     ),
//   //     child: Padding(
//   //       padding: const EdgeInsets.all(12.0),
//   //       child: Column(
//   //         children: [
//   //           Text(
//   //             'Personal Information',
//   //             style: TextStyle(
//   //               fontSize: 18,
//   //               fontWeight: FontWeight.bold,
//   //             ),
//   //           ),
//   //           Divider(),
//   //           _buildTextField(usernameController, 'Username', Icons.person),
//   //           _buildTextField(emailController, 'Email', Icons.email, inputType: TextInputType.emailAddress),
//   //           _buildTextField(phoneController, 'Phone Number', Icons.phone, inputType: TextInputType.phone),
//   //           _buildTextField(mailingAddressController, 'Mailing Address', Icons.home),
//   //           _buildTextField(deliveryAddressController, 'Delivery Address', Icons.location_on),
//   //         ],
//   //       ),
//   //     ),
//   //   );
//   // }
//
//   Widget _buildPersonalInfoCard() {
//     return Card(
//       key: ValueKey(false),
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           children: [
//             Text(
//               'Personal Information',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Divider(),
//             _buildTextField(usernameController, 'Username', Icons.person),
//             _buildTextField(emailController, 'Email', Icons.email, inputType: TextInputType.emailAddress),
//             _buildTextField(phoneController, 'Phone Number', Icons.phone, inputType: TextInputType.phone),
//             _buildTextField(mailingAddressController, 'Mailing Address', Icons.home),
//             _buildTextField(deliveryAddressController, 'Delivery Address', Icons.location_on),
//
//             // Adding Category Selection below the Delivery Address field
//             SizedBox(height: 10),  // Adding space before category selection
//             _buildCategorySelection(),  // Category selection widget
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildBusinessInfoCard() {
//     return Card(
//       key: ValueKey(true),
//       elevation: 2,
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//       ),
//       child: Padding(
//         padding: const EdgeInsets.all(12.0),
//         child: Column(
//           children: [
//             Text(
//               'Business Information',
//               style: TextStyle(
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//             Divider(),
//             _buildTextField(dnNoController, 'DN No', Icons.business,
//                 isMandatory: category == 'PHARMA'), // Conditional validation
//             _buildTextField(dlPicController, 'DL Pic URL', Icons.image,
//                 isMandatory: category == 'PHARMA'), // Conditional validation
//             _buildDatePickerField(dlExpireDateController, 'DL Expire Date',
//                 isMandatory: category == 'PHARMA'), // Conditional validation
//             _buildTextField(aadharNoController, 'Aadhar No', Icons.credit_card),
//             _buildTextField(aadharPicController, 'Aadhar Pic URL', Icons.image),
//             _buildTextField(gstNoController, 'GST No', Icons.credit_card),
//             _buildTextField(gstDocController, 'GST Doc URL', Icons.image),
//             _buildTextField(tradeLicController, 'Trade License No', Icons.business),
//             _buildTextField(panNoController, 'PAN No', Icons.credit_card),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildTextField(TextEditingController controller, String hintText, IconData icon,
//       {TextInputType inputType = TextInputType.text, bool isMandatory = true}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: TextFormField(
//         controller: controller,
//         keyboardType: inputType,
//         decoration: InputDecoration(
//           prefixIcon: Icon(icon),
//           labelText: hintText,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//           ),
//         ),
//         validator: isMandatory
//             ? (value) {
//           if (value == null || value.isEmpty) {
//             return 'Please enter $hintText';
//           }
//           return null;
//         }
//             : null, // Validator is null if not mandatory
//       ),
//     );
//   }
//
//   Widget _buildDatePickerField(TextEditingController controller, String labelText, {bool isMandatory = true}) {
//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 8.0),
//       child: TextFormField(
//         onTap: () => _selectDate(controller),
//         controller: controller,
//         decoration: InputDecoration(
//           labelText: labelText,
//           border: OutlineInputBorder(
//             borderRadius: BorderRadius.circular(8),
//           ),
//           prefixIcon: IconButton(
//             icon: Icon(Icons.calendar_today),
//             onPressed: () => _selectDate(controller),
//           ),
//         ),
//         readOnly: true,
//         validator: isMandatory
//             ? (value) {
//           if (value == null || value.isEmpty) {
//             return 'Please select $labelText';
//           }
//           return null;
//         }
//             : null, // Validator is null if not mandatory
//       ),
//     );
//   }
// }
//
//
// //
// // import 'dart:math';
// //
// // import 'package:flutter/material.dart';
// // import 'package:http/http.dart' as http;
// // import 'dart:convert';
// // import 'package:intl/intl.dart'; // For date formatting
// //
// // import 'custom_widget.dart';
// // import 'login.dart';
// //
// // class RegistrationPage extends StatefulWidget {
// //   const RegistrationPage({Key? key}) : super(key: key);
// //
// //   @override
// //   _RegistrationPageState createState() => _RegistrationPageState();
// // }
// //
// // class _RegistrationPageState extends State<RegistrationPage> {
// //   final _formKey = GlobalKey<FormState>();
// //   bool showBusinessInfo = false;
// //
// //   // Controllers for personal information
// //   final TextEditingController usernameController = TextEditingController();
// //   final TextEditingController emailController = TextEditingController();
// //   final TextEditingController phoneController = TextEditingController();
// //   final TextEditingController mailingAddressController = TextEditingController();
// //   final TextEditingController deliveryAddressController = TextEditingController();
// //
// //   // Controllers for business information
// //   final TextEditingController dnNoController = TextEditingController();
// //   final TextEditingController dlPicController = TextEditingController();
// //   final TextEditingController dlExpireDateController = TextEditingController();
// //   final TextEditingController aadharNoController = TextEditingController();
// //   final TextEditingController aadharPicController = TextEditingController();
// //   final TextEditingController gstNoController = TextEditingController();
// //   final TextEditingController gstDocController = TextEditingController();
// //   final TextEditingController tradeLicController = TextEditingController();
// //   final TextEditingController panNoController = TextEditingController();
// //
// //   // Date format
// //   final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
// //
// //   Future<void> _registerUser() async {
// //     if (_formKey.currentState!.validate()) {
// //       final url = Uri.parse('https://namami-infotech.com/EvaraBackend/src/auth/register.php');
// //
// //       final registrationData = {
// //         "username": usernameController.text,
// //         "email": emailController.text,
// //         "phone_number": phoneController.text,
// //         "mailing_address": mailingAddressController.text,
// //         "delivery_address": deliveryAddressController.text,
// //         "dn_no": dnNoController.text,
// //         "dl_pic": dlPicController.text,
// //         "dl_expire_date": _dateFormat.format(DateTime.parse(dlExpireDateController.text)),
// //         "aadhar_no": aadharNoController.text,
// //         "aadhar_pic": aadharPicController.text,
// //         "gst_no": gstNoController.text,
// //         "gst_doc": gstDocController.text,
// //         "trade_lic": tradeLicController.text,
// //         "pan_no": panNoController.text,
// //       };
// //
// //       print("Data to be sent for registration: $registrationData"); // Printing data to the console
// //
// //       try {
// //         final response = await http.post(
// //           url,
// //           headers: {
// //             'Content-Type': 'application/json',
// //           },
// //           body: jsonEncode(registrationData),
// //         );
// //
// //         print('API Response: ${response.body}'); // Print the API response in the console
// //
// //         if (response.statusCode == 201) {
// //           final responseData = jsonDecode(response.body);
// //
// //           if (responseData['message'] == 'Dealer registered successfully.') {
// //             showDialog(
// //               context: context,
// //               builder: (context) {
// //                 return AlertDialog(
// //                   title: Text('Registration Successful'),
// //                   content: Text('You have successfully registered. You will be notified by mail after verification.'),
// //                   actions: [
// //                     TextButton(
// //                       onPressed: () {
// //                         Navigator.pop(context);
// //                       },
// //                       child: Text('OK'),
// //                     ),
// //                   ],
// //                 );
// //               },
// //             );
// //           } else {
// //             _showErrorDialog(responseData['message'] ?? 'Registration failed. Please try again.');
// //           }
// //         } else {
// //           _showErrorDialog(' ${response.body}');//_showErrorDialog('Error: ${response.statusCode}. Please try again later.');
// //         }
// //       } catch (e) {
// //         _showErrorDialog('Failed to register. Please check your internet connection and try again.');
// //       }
// //     }
// //   }
// //
// //   void _showErrorDialog(String message) {
// //     showDialog(
// //       context: context,
// //       builder: (context) {
// //         return AlertDialog(
// //           title: Text('Error'),
// //           content: Text(message),
// //           actions: [
// //             TextButton(
// //               onPressed: () {
// //                 Navigator.pop(context);
// //               },
// //               child: Text('OK'),
// //             ),
// //           ],
// //         );
// //       },
// //     );
// //   }
// //
// //   Future<void> _selectDate(TextEditingController controller) async {
// //     final DateTime? picked = await showDatePicker(
// //       context: context,
// //       initialDate: DateTime.now(),
// //       firstDate: DateTime(2000),
// //       lastDate: DateTime(2101),
// //     );
// //
// //     if (picked != null) {
// //       controller.text = _dateFormat.format(picked);
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
// //             padding: const EdgeInsets.all(25.0),
// //             child: Form(
// //               key: _formKey,
// //               child: Column(
// //                 mainAxisAlignment: MainAxisAlignment.center,
// //                 children: [
// //                   // Logo at the top of the form
// //                   Image.asset(
// //                     'assets/logos/evara_logo2.png', // Replace with your logo asset path
// //                     height: 230,
// //                    // width: 100,
// //                   ),
// //                   // SizedBox(height: 5),
// //                   // Text(
// //                   //   'Registration',
// //                   //   style: TextStyle(
// //                   //     fontSize: 20,
// //                   //     fontWeight: FontWeight.bold,
// //                   //     color: Colors.deepPurple,
// //                   //   ),
// //                   // ),
// //                  // SizedBox(height: 10),
// //                   AnimatedSwitcher(
// //                     duration: Duration(milliseconds: 500),
// //                     transitionBuilder: (child, animation) {
// //                       final rotate = Tween(begin: pi / 2, end: 0.0).animate(animation);
// //                       return AnimatedBuilder(
// //                         animation: rotate,
// //                         child: child,
// //                         builder: (context, child) {
// //                           final isUnder = (ValueKey(showBusinessInfo) != child?.key);
// //                           var tilt = (isUnder ? 0.003 : 0.0) * pi * animation.value;
// //                           tilt *= isUnder ? -1.0 : 1.0;
// //                           return Transform(
// //                             transform: Matrix4.rotationY(rotate.value)..setEntry(3, 0, tilt),
// //                             alignment: Alignment.center,
// //                             child: child,
// //                           );
// //                         },
// //                       );
// //                     },
// //                     child: showBusinessInfo ? _buildBusinessInfoCard() : _buildPersonalInfoCard(),
// //                   ),
// //                   SizedBox(height: 10),
// //                   Row(
// //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                     children: [
// //                       if (showBusinessInfo)
// //                         CustomButton(
// //                           text: 'Previous',
// //                           onPressed: () {
// //                             setState(() {
// //                               showBusinessInfo = false;
// //                             });
// //                           },
// //                         ),
// //                       CustomButton(
// //                         text: showBusinessInfo ? 'Submit' : 'Next',
// //                         onPressed: () {
// //                           if (_formKey.currentState!.validate()) {
// //                             if (showBusinessInfo) {
// //                               _registerUser();
// //                             } else {
// //                               setState(() {
// //                                 showBusinessInfo = true;
// //                               });
// //                             }
// //                           }
// //                         },
// //                       ),
// //                     ],
// //                   ),
// //                   SizedBox(height: 10),
// //                   TextButton(
// //                     onPressed: () {
// //                       Navigator.push(
// //                         context,
// //                         MaterialPageRoute(builder: (context) => LoginPage()),
// //                       );
// //                     },
// //                     child: Text(
// //                       "Already have an account? Login",
// //                       style: TextStyle(
// //                         color: Colors.black,
// //                       ),
// //                     ),
// //                   ),
// //                 ],
// //               ),
// //             ),
// //           ),
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildPersonalInfoCard() {
// //     return Card(
// //       key: ValueKey(false),
// //       elevation: 2,
// //       shape: RoundedRectangleBorder(
// //         borderRadius: BorderRadius.circular(10),
// //       ),
// //       child: Padding(
// //         padding: const EdgeInsets.all(12.0),
// //         child: Column(
// //           children: [
// //             Text(
// //               'Personal Information',
// //               style: TextStyle(
// //                 fontSize: 18,
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),
// //             Divider(),
// //             _buildTextField(usernameController, 'Username', Icons.person),
// //             _buildTextField(emailController, 'Email', Icons.email, inputType: TextInputType.emailAddress),
// //             _buildTextField(phoneController, 'Phone Number', Icons.phone, inputType: TextInputType.phone),
// //             _buildTextField(mailingAddressController, 'Mailing Address', Icons.home),
// //             _buildTextField(deliveryAddressController, 'Delivery Address', Icons.location_on),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildBusinessInfoCard() {
// //     return Card(
// //       key: ValueKey(true),
// //       elevation: 2,
// //       shape: RoundedRectangleBorder(
// //         borderRadius: BorderRadius.circular(10),
// //       ),
// //       child: Padding(
// //         padding: const EdgeInsets.all(12.0),
// //         child: Column(
// //           children: [
// //             Text(
// //               'Business Information',
// //               style: TextStyle(
// //                 fontSize: 18,
// //                 fontWeight: FontWeight.bold,
// //               ),
// //             ),
// //             Divider(),
// //             _buildTextField(dnNoController, 'DN No', Icons.business),
// //             _buildTextField(dlPicController, 'DL Pic URL', Icons.image),
// //             _buildDatePickerField(dlExpireDateController, 'DL Expire Date'),
// //             _buildTextField(aadharNoController, 'Aadhar No', Icons.credit_card),
// //             _buildTextField(aadharPicController, 'Aadhar Pic URL', Icons.image),
// //             _buildTextField(gstNoController, 'GST No', Icons.credit_card),
// //             _buildTextField(gstDocController, 'GST Doc URL', Icons.image),
// //             _buildTextField(tradeLicController, 'Trade License No', Icons.business),
// //             _buildTextField(panNoController, 'PAN No', Icons.credit_card),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildTextField(TextEditingController controller, String hintText, IconData icon, {TextInputType inputType = TextInputType.text}) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(vertical: 8.0),
// //       child: TextFormField(
// //         controller: controller,
// //         keyboardType: inputType,
// //         decoration: InputDecoration(
// //           prefixIcon: Icon(icon),
// //           labelText: hintText,
// //           border: OutlineInputBorder(
// //             borderRadius: BorderRadius.circular(8),
// //           ),
// //         ),
// //         validator: (value) {
// //           if (value == null || value.isEmpty) {
// //             return 'Please enter $hintText';
// //           }
// //           return null;
// //         },
// //       ),
// //     );
// //   }
// //
// //   Widget _buildDatePickerField(TextEditingController controller, String labelText) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(vertical: 8.0),
// //       child: TextFormField(
// //         onTap: () => _selectDate(controller),
// //         controller: controller,
// //         decoration: InputDecoration(
// //           //prefixIcon: Icon(Icons.date_range),
// //           labelText: labelText,
// //           border: OutlineInputBorder(
// //             borderRadius: BorderRadius.circular(8),
// //           ),
// //           prefixIcon: IconButton(
// //             icon: Icon(Icons.calendar_today),
// //             onPressed: () => _selectDate(controller),
// //           ),
// //         ),
// //         readOnly: true,
// //         validator: (value) {
// //           if (value == null || value.isEmpty) {
// //             return 'Please select $labelText';
// //           }
// //           return null;
// //         },
// //       ),
// //     );
// //   }
// // }
// //
// //
// //
