import 'dart:io';
import 'dart:convert';
import 'package:evara/utils/urls/urlsclass.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
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
  String selectedCategory = 'Pharma'; // Default category

  // Controllers for personal information
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController mailingAddressController = TextEditingController();
  final TextEditingController deliveryAddressController = TextEditingController();

  // Controllers for business information
  final TextEditingController dnNoController = TextEditingController();
  final TextEditingController dlPicNameController = TextEditingController();
  final TextEditingController dlExpireDateController = TextEditingController();
  final TextEditingController aadharNoController = TextEditingController();
  final TextEditingController aadharPicNameController = TextEditingController();
  final TextEditingController gstNoController = TextEditingController();
  final TextEditingController gstDocNameController = TextEditingController();
  final TextEditingController tradeLicController = TextEditingController();
  final TextEditingController panNoController = TextEditingController();

  // Base64 encoded images
  String? dlPicBase64;
  String? aadharPicBase64;
  String? gstDocBase64;

  // Date format
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');

  Future<void> _registerUser() async {
    if (_formKey.currentState!.validate()) {
      final url = Uri.parse(Urlsclass.registration);
      //final url = Uri.parse('https://namami-infotech.com/EvaraBackend/src/auth/register.php');

      final registrationData = {
        "username": usernameController.text,
        "email": emailController.text,
        "phone_number": phoneController.text,
        "mailing_address": mailingAddressController.text,
        "delivery_address": deliveryAddressController.text,
        "category": selectedCategory,
        "dn_no": selectedCategory == 'Pharma' ? dnNoController.text : '',
        "dl_pic": selectedCategory == 'Pharma' ? dlPicBase64 : '',
        "dl_expire_date": selectedCategory == 'Pharma' ? _dateFormat.format(DateTime.parse(dlExpireDateController.text)) : null,
        "aadhar_no": aadharNoController.text,
        "aadhar_pic": aadharPicBase64,
        "gst_no": gstNoController.text,
        "gst_doc": gstDocBase64,
        "trade_lic": tradeLicController.text,
        "pan_no": panNoController.text,
      };

      try {
        final response = await http.post(
          url,
          headers: {
            'Content-Type': 'application/json',
          },
          body: jsonEncode(registrationData),
        );

        if (response.statusCode == 201) {
          final responseData = jsonDecode(response.body);

          if (responseData['message'] == 'Dealer registered successfully.') {
            _showSuccessDialog();
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

  void _showSuccessDialog() {
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
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );

    if (picked != null) {
      controller.text = _dateFormat.format(picked);
    }
  }

  Future<void> _pickImage({
    required TextEditingController nameController,
    required Function(String) onBase64Encoded,
  }) async {
    final ImagePicker _picker = ImagePicker();
    final XFile? image = await _picker.pickImage(
      source: await _showImageSourceDialog(),
    );

    if (image != null) {
      File imageFile = File(image.path);

      // Compress image
      final result = await FlutterImageCompress.compressWithFile(
        imageFile.path,
        minWidth: 800,
        minHeight: 600,
        quality: 85,
      );

      if (result != null) {
        String base64Image = base64Encode(result);

        setState(() {
          nameController.text = image.name;
          onBase64Encoded(base64Image);
        });
      }
    }
  }

  Future<ImageSource> _showImageSourceDialog() async {
    return await showDialog<ImageSource>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Choose Image Source'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.camera),
            child: Text('Camera'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, ImageSource.gallery),
            child: Text('Gallery'),
          ),
        ],
      ),
    ) ?? ImageSource.gallery;
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
                  Image.asset(
                    'assets/logos/evara_logo2.png',
                    height: 230,
                  ),
                  AnimatedSwitcher(
                    duration: Duration(milliseconds: 500),
                    child: showBusinessInfo
                        ? _buildBusinessInfoCard()
                        : _buildPersonalInfoCard(),
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
            SizedBox(height: 10),
            TextFormField(
              controller: usernameController,
              decoration: InputDecoration(labelText: 'Username'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your username';
                }
                return null;
              },
            ),
            TextFormField(
              controller: emailController,
              decoration: InputDecoration(labelText: 'Email'),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your email';
                } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return 'Please enter a valid email address';
                }
                return null;
              },
            ),
            TextFormField(
              controller: phoneController,
              decoration: InputDecoration(labelText: 'Phone Number'),
              keyboardType: TextInputType.phone,
              maxLength: 10,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your phone number';
                } else if (value.length != 10) {
                  return 'Phone number must be 10 digits';
                }
                return null;
              },
            ),
            TextFormField(
              controller: mailingAddressController,
              decoration: InputDecoration(labelText: 'Mailing Address'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your mailing address';
                }
                return null;
              },
            ),
            TextFormField(
              controller: deliveryAddressController,
              decoration: InputDecoration(labelText: 'Delivery Address'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your delivery address';
                }
                return null;
              },
            ),
            SizedBox(height: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Select Category:',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<String>(
                        title: Text('Pharma'),
                        value: 'Pharma',
                        groupValue: selectedCategory,
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value!;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<String>(
                        title: Text('General'),
                        value: 'General',
                        groupValue: selectedCategory,
                        onChanged: (value) {
                          setState(() {
                            selectedCategory = value!;
                          });
                        },
                      ),
                    ),
                  ],
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
            SizedBox(height: 10),
            if (selectedCategory == 'Pharma') ...[
              TextFormField(
                controller: dnNoController,
                decoration: InputDecoration(labelText: 'DN Number'),
                validator: (value) {
                  if (selectedCategory == 'Pharma' && (value == null || value.isEmpty)) {
                    return 'Please enter DN Number';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: dlPicNameController,
                readOnly: true,
                decoration: InputDecoration(
                  labelText: 'DL Picture',
                  suffixIcon: IconButton(
                    icon: Icon(Icons.camera_alt),
                    onPressed: () {
                      _pickImage(
                        nameController: dlPicNameController,
                        onBase64Encoded: (base64) {
                          dlPicBase64 = base64;
                        },
                      );
                    },
                  ),
                ),
                validator: (value) {
                  if (selectedCategory == 'Pharma' && (value == null || value.isEmpty)) {
                    return 'Please provide DL Picture';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: dlExpireDateController,
                decoration: InputDecoration(labelText: 'DL Expiry Date'),
                onTap: () => _selectDate(dlExpireDateController),
                validator: (value) {
                  if (selectedCategory == 'Pharma' && (value == null || value.isEmpty)) {
                    return 'Please provide DL Expiry Date';
                  }
                  return null;
                },
              ),
            ],
            TextFormField(
              controller: aadharNoController,
              decoration: InputDecoration(labelText: 'Aadhar Number'),
              keyboardType: TextInputType.number,
              maxLength: 12,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter your Aadhar number';
                } else if (value.length != 12) {
                  return 'Aadhar number must be 12 digits';
                }
                return null;
              },
            ),
            TextFormField(
              controller: aadharPicNameController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'Aadhar Picture',
                suffixIcon: IconButton(
                  icon: Icon(Icons.camera_alt),
                  onPressed: () {
                    _pickImage(
                      nameController: aadharPicNameController,
                      onBase64Encoded: (base64) {
                        aadharPicBase64 = base64;
                      },
                    );
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please provide Aadhar Picture';
                }
                return null;
              },
            ),
            TextFormField(
              controller: gstNoController,
              decoration: InputDecoration(labelText: 'GST Number'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter GST number';
                }
                return null;
              },
            ),
            TextFormField(
              controller: gstDocNameController,
              readOnly: true,
              decoration: InputDecoration(
                labelText: 'GST Document',
                suffixIcon: IconButton(
                  icon: Icon(Icons.camera_alt),
                  onPressed: () {
                    _pickImage(
                      nameController: gstDocNameController,
                      onBase64Encoded: (base64) {
                        gstDocBase64 = base64;
                      },
                    );
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please provide GST Document';
                }
                return null;
              },
            ),
            TextFormField(
              controller: tradeLicController,
              decoration: InputDecoration(labelText: 'Trade License Number'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter Trade License Number';
                }
                return null;
              },
            ),
            TextFormField(
              controller: panNoController,
              decoration: InputDecoration(labelText: 'PAN Number'),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter PAN Number';
                }
                return null;
              },
            ),
          ],
        ),
      ),
    );
  }
}

// import 'dart:io';
// import 'dart:convert';
// import 'package:evara/features/authentication/custom_widget.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:flutter_image_compress/flutter_image_compress.dart';
// import 'package:intl/intl.dart';
// import 'package:http/http.dart' as http;
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
//   String selectedCategory = 'Pharma'; // Default category
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
//   final TextEditingController dlPicNameController = TextEditingController();
//   final TextEditingController dlExpireDateController = TextEditingController();
//   final TextEditingController aadharNoController = TextEditingController();
//   final TextEditingController aadharPicNameController = TextEditingController();
//   final TextEditingController gstNoController = TextEditingController();
//   final TextEditingController gstDocNameController = TextEditingController();
//   final TextEditingController tradeLicController = TextEditingController();
//   final TextEditingController panNoController = TextEditingController();
//
//   // Base64 encoded images
//   String? dlPicBase64;
//   String? aadharPicBase64;
//   String? gstDocBase64;
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
//         "category": selectedCategory,
//         "dn_no": selectedCategory == 'Pharma' ? dnNoController.text : '',
//         "dl_pic": selectedCategory == 'Pharma' ? dlPicBase64 : '',
//         "dl_expire_date": selectedCategory == 'Pharma' ? _dateFormat.format(DateTime.parse(dlExpireDateController.text)) : null,
//         "aadhar_no": aadharNoController.text,
//         "aadhar_pic": aadharPicBase64,
//         "gst_no": gstNoController.text,
//         "gst_doc": gstDocBase64,
//         "trade_lic": tradeLicController.text,
//         "pan_no": panNoController.text,
//       };
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
//         if (response.statusCode == 201) {
//           final responseData = jsonDecode(response.body);
//
//           if (responseData['message'] == 'Dealer registered successfully.') {
//             _showSuccessDialog();
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
//   void _showSuccessDialog() {
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: Text('Registration Successful'),
//           content: Text('You have successfully registered. You will be notified by mail after verification.'),
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
//       firstDate: DateTime.now(),
//       lastDate: DateTime(2101),
//     );
//
//     if (picked != null) {
//       controller.text = _dateFormat.format(picked);
//     }
//   }
//
//   Future<void> _pickImage({
//     required TextEditingController nameController,
//     required Function(String) onBase64Encoded,
//   }) async {
//     final ImagePicker _picker = ImagePicker();
//     final XFile? image = await _picker.pickImage(
//       source: await _showImageSourceDialog(),
//     );
//
//     if (image != null) {
//       File imageFile = File(image.path);
//
//       // Compress image
//       final result = await FlutterImageCompress.compressWithFile(
//         imageFile.path,
//         minWidth: 800,
//         minHeight: 600,
//         quality: 85,
//       );
//
//       if (result != null) {
//         String base64Image = base64Encode(result);
//
//         setState(() {
//           nameController.text = image.name;
//           onBase64Encoded(base64Image);
//         });
//       }
//     }
//   }
//
//   Future<ImageSource> _showImageSourceDialog() async {
//     return await showDialog<ImageSource>(
//       context: context,
//       builder: (context) => AlertDialog(
//         title: Text('Choose Image Source'),
//         actions: [
//           TextButton(
//             onPressed: () => Navigator.pop(context, ImageSource.camera),
//             child: Text('Camera'),
//           ),
//           TextButton(
//             onPressed: () => Navigator.pop(context, ImageSource.gallery),
//             child: Text('Gallery'),
//           ),
//         ],
//       ),
//     ) ?? ImageSource.gallery;
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
//                     'assets/logos/evara_logo2.png',
//                     height: 230,
//                   ),
//                   AnimatedSwitcher(
//                     duration: Duration(milliseconds: 500),
//                     child: showBusinessInfo
//                         ? _buildBusinessInfoCard()
//                         : _buildPersonalInfoCard(),
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
//   Widget _buildPersonalInfoCard() {
//     return Card(
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
//             SizedBox(height: 10),
//             TextFormField(
//               controller: usernameController,
//               decoration: InputDecoration(labelText: 'Username'),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter your username';
//                 }
//                 return null;
//               },
//             ),
//             TextFormField(
//               controller: emailController,
//               decoration: InputDecoration(labelText: 'Email'),
//               keyboardType: TextInputType.emailAddress,
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter your email';
//                 } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
//                   return 'Please enter a valid email address';
//                 }
//                 return null;
//               },
//             ),
//             TextFormField(
//               controller: phoneController,
//               decoration: InputDecoration(labelText: 'Phone Number'),
//               keyboardType: TextInputType.phone,
//               maxLength: 10,
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter your phone number';
//                 } else if (value.length != 10) {
//                   return 'Phone number must be 10 digits';
//                 }
//                 return null;
//               },
//             ),
//             TextFormField(
//               controller: mailingAddressController,
//               decoration: InputDecoration(labelText: 'Mailing Address'),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter your mailing address';
//                 }
//                 return null;
//               },
//             ),
//             TextFormField(
//               controller: deliveryAddressController,
//               decoration: InputDecoration(labelText: 'Delivery Address'),
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter your delivery address';
//                 }
//                 return null;
//               },
//             ),
//             SizedBox(height: 10),
//             Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   'Select Category:',
//                   style: TextStyle(
//                     fontSize: 16,
//                     fontWeight: FontWeight.bold,
//                   ),
//                 ),
//                 Row(
//                   children: [
//                     Expanded(
//                       child: RadioListTile<String>(
//                         title: Text('Pharma'),
//                         value: 'Pharma',
//                         groupValue: selectedCategory,
//                         onChanged: (value) {
//                           setState(() {
//                             selectedCategory = value!;
//                           });
//                         },
//                       ),
//                     ),
//                     Expanded(
//                       child: RadioListTile<String>(
//                         title: Text('General'),
//                         value: 'General',
//                         groupValue: selectedCategory,
//                         onChanged: (value) {
//                           setState(() {
//                             selectedCategory = value!;
//                           });
//                         },
//                       ),
//                     ),
//                   ],
//                 ),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
//
//   Widget _buildBusinessInfoCard() {
//     return Card(
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
//             SizedBox(height: 10),
//             if (selectedCategory == 'Pharma') ...[
//               TextFormField(
//                 controller: dnNoController,
//                 decoration: InputDecoration(labelText: 'DN Number'),
//               ),
//               TextFormField(
//                 controller: dlPicNameController,
//                 readOnly: true,
//                 decoration: InputDecoration(
//                   labelText: 'DL Picture',
//                   suffixIcon: IconButton(
//                     icon: Icon(Icons.camera_alt),
//                     onPressed: () {
//                       _pickImage(
//                         nameController: dlPicNameController,
//                         onBase64Encoded: (base64) {
//                           dlPicBase64 = base64;
//                         },
//                       );
//                     },
//                   ),
//                 ),
//               ),
//               TextFormField(
//                 controller: dlExpireDateController,
//                 decoration: InputDecoration(labelText: 'DL Expiry Date'),
//                 onTap: () => _selectDate(dlExpireDateController),
//               ),
//             ],
//             TextFormField(
//               controller: aadharNoController,
//               decoration: InputDecoration(labelText: 'Aadhar Number'),
//               keyboardType: TextInputType.number,
//               maxLength: 12,
//               validator: (value) {
//                 if (value == null || value.isEmpty) {
//                   return 'Please enter your Aadhar number';
//                 } else if (value.length != 12) {
//                   return 'Aadhar number must be 12 digits';
//                 }
//                 return null;
//               },
//             ),
//             TextFormField(
//               controller: aadharPicNameController,
//               readOnly: true,
//               decoration: InputDecoration(
//                 labelText: 'Aadhar Picture',
//                 suffixIcon: IconButton(
//                   icon: Icon(Icons.camera_alt),
//                   onPressed: () {
//                     _pickImage(
//                       nameController: aadharPicNameController,
//                       onBase64Encoded: (base64) {
//                         aadharPicBase64 = base64;
//                       },
//                     );
//                   },
//                 ),
//               ),
//             ),
//             TextFormField(
//               controller: gstNoController,
//               decoration: InputDecoration(labelText: 'GST Number'),
//             ),
//             TextFormField(
//               controller: gstDocNameController,
//               readOnly: true,
//               decoration: InputDecoration(
//                 labelText: 'GST Document',
//                 suffixIcon: IconButton(
//                   icon: Icon(Icons.camera_alt),
//                   onPressed: () {
//                     _pickImage(
//                       nameController: gstDocNameController,
//                       onBase64Encoded: (base64) {
//                         gstDocBase64 = base64;
//                       },
//                     );
//                   },
//                 ),
//               ),
//             ),
//             TextFormField(
//               controller: tradeLicController,
//               decoration: InputDecoration(labelText: 'Trade License Number'),
//             ),
//             TextFormField(
//               controller: panNoController,
//               decoration: InputDecoration(labelText: 'PAN Number'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
//
//
// // import 'dart:io';
// // import 'dart:convert';
// // import 'package:flutter/material.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:flutter_image_compress/flutter_image_compress.dart';
// // import 'package:intl/intl.dart';
// // import 'package:http/http.dart' as http;
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
// //   String selectedCategory = 'Pharma'; // Default category
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
// //   final TextEditingController dlPicNameController = TextEditingController();
// //   final TextEditingController dlExpireDateController = TextEditingController();
// //   final TextEditingController aadharNoController = TextEditingController();
// //   final TextEditingController aadharPicNameController = TextEditingController();
// //   final TextEditingController gstNoController = TextEditingController();
// //   final TextEditingController gstDocNameController = TextEditingController();
// //   final TextEditingController tradeLicController = TextEditingController();
// //   final TextEditingController panNoController = TextEditingController();
// //
// //   // Base64 encoded images
// //   String? dlPicBase64;
// //   String? aadharPicBase64;
// //   String? gstDocBase64;
// //
// //   // Date format
// //   final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
// //
// //   Future<void> _registerUser() async {
// //     if (_formKey.currentState!.validate()) {
// //       final url = Uri.parse(
// //           'https://namami-infotech.com/EvaraBackend/src/auth/register.php');
// //
// //       final registrationData = {
// //         "username": usernameController.text,
// //         "email": emailController.text,
// //         "phone_number": phoneController.text,
// //         "mailing_address": mailingAddressController.text,
// //         "delivery_address": deliveryAddressController.text,
// //         "category": selectedCategory,
// //         "dn_no": selectedCategory == 'Pharma' ? dnNoController.text : '',
// //         "dl_pic": selectedCategory == 'Pharma' ? dlPicBase64 : '',
// //         "dl_expire_date": selectedCategory == 'Pharma'
// //             ? _dateFormat.format(DateTime.parse(dlExpireDateController.text))
// //             : null,
// //         "aadhar_no": aadharNoController.text,
// //         "aadhar_pic": aadharPicBase64,
// //         "gst_no": gstNoController.text,
// //         "gst_doc": gstDocBase64,
// //         "trade_lic": tradeLicController.text,
// //         "pan_no": panNoController.text,
// //       };
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
// //         if (response.statusCode == 201) {
// //           final responseData = jsonDecode(response.body);
// //
// //           if (responseData['message'] == 'Dealer registered successfully.') {
// //             _showSuccessDialog();
// //           } else {
// //             _showErrorDialog(responseData['message'] ??
// //                 'Registration failed. Please try again.');
// //           }
// //         } else {
// //           _showErrorDialog(' ${response.body}');
// //         }
// //       } catch (e) {
// //         _showErrorDialog('Failed to register. Please check your internet connection and try again.');
// //       }
// //     }
// //   }
// //
// //   void _showSuccessDialog() {
// //     showDialog(
// //       context: context,
// //       builder: (context) {
// //         return AlertDialog(
// //           title: Text('Registration Successful'),
// //           content: Text('You have successfully registered. You will be notified by mail after verification.'),
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
// //       firstDate: DateTime.now(),
// //       lastDate: DateTime(2101),
// //     );
// //
// //     if (picked != null) {
// //       controller.text = _dateFormat.format(picked);
// //     }
// //   }
// //
// //   Future<void> _pickImage({
// //     required TextEditingController nameController,
// //     required Function(String) onBase64Encoded,
// //   }) async {
// //     final ImagePicker _picker = ImagePicker();
// //     final XFile? image = await _picker.pickImage(
// //       source: await _showImageSourceDialog(),
// //     );
// //
// //     if (image != null) {
// //       File imageFile = File(image.path);
// //
// //       // Compress image
// //       final result = await FlutterImageCompress.compressWithFile(
// //         imageFile.path,
// //         minWidth: 800,
// //         minHeight: 600,
// //         quality: 85,
// //       );
// //
// //       if (result != null) {
// //         String base64Image = base64Encode(result);
// //
// //         setState(() {
// //           nameController.text = image.name; // Only show image name
// //           onBase64Encoded(base64Image); // Store base64 for sending to server
// //         });
// //       }
// //     }
// //   }
// //
// //   Future<ImageSource> _showImageSourceDialog() async {
// //     return await showDialog<ImageSource>(
// //       context: context,
// //       builder: (context) => AlertDialog(
// //         title: Text('Choose Image Source'),
// //         actions: [
// //           TextButton(
// //             onPressed: () => Navigator.pop(context, ImageSource.camera),
// //             child: Text('Camera'),
// //           ),
// //           TextButton(
// //             onPressed: () => Navigator.pop(context, ImageSource.gallery),
// //             child: Text('Gallery'),
// //           ),
// //         ],
// //       ),
// //     ) ?? ImageSource.gallery;
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
// //                   Image.asset(
// //                     'assets/logos/evara_logo2.png',
// //                     height: 230,
// //                   ),
// //                   AnimatedSwitcher(
// //                     duration: Duration(milliseconds: 500),
// //                     child: showBusinessInfo
// //                         ? _buildBusinessInfoCard()
// //                         : _buildPersonalInfoCard(),
// //                   ),
// //                   SizedBox(height: 10),
// //                   Row(
// //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// //                     children: [
// //                       if (showBusinessInfo)
// //                         CustomButtons(
// //                           text: 'Previous',
// //                           onPressed: () {
// //                             setState(() {
// //                               showBusinessInfo = false;
// //                             });
// //                           },
// //                         ),
// //                       CustomButtons(
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
// //         elevation: 2,
// //         shape: RoundedRectangleBorder(
// //           borderRadius: BorderRadius.circular(10),
// //         ),
// //         child: Padding(
// //         padding: const EdgeInsets.all(12.0),
// //     child: Column(
// //     children: [
// //     Text(
// //       'Personal Information',
// //       style: TextStyle(
// //         fontSize: 18,
// //         fontWeight: FontWeight.bold,
// //       ),
// //     ),
// //       SizedBox(height: 10),
// //       TextFormField(
// //         controller: usernameController,
// //         decoration: InputDecoration(labelText: 'Username'),
// //         validator: (value) {
// //           if (value == null || value.isEmpty) {
// //             return 'Please enter your username';
// //           }
// //           return null;
// //         },
// //       ),
// //       TextFormField(
// //         controller: emailController,
// //         decoration: InputDecoration(labelText: 'Email'),
// //         keyboardType: TextInputType.emailAddress,
// //         validator: (value) {
// //           if (value == null || value.isEmpty) {
// //             return 'Please enter your email';
// //           } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
// //             return 'Please enter a valid email address';
// //           }
// //           return null;
// //         },
// //       ),
// //       TextFormField(
// //         controller: phoneController,
// //         decoration: InputDecoration(labelText: 'Phone Number'),
// //         keyboardType: TextInputType.phone,
// //         maxLength: 10,
// //         validator: (value) {
// //           if (value == null || value.isEmpty) {
// //             return 'Please enter your phone number';
// //           } else if (value.length != 10) {
// //             return 'Phone number must be 10 digits';
// //           }
// //           return null;
// //         },
// //       ),
// //       TextFormField(
// //         controller: mailingAddressController,
// //         decoration: InputDecoration(labelText: 'Mailing Address'),
// //         validator: (value) {
// //           if (value == null || value.isEmpty) {
// //             return 'Please enter your mailing address';
// //           }
// //           return null;
// //         },
// //       ),
// //       TextFormField(
// //         controller: deliveryAddressController,
// //         decoration: InputDecoration(labelText: 'Delivery Address'),
// //         validator: (value) {
// //           if (value == null || value.isEmpty) {
// //             return 'Please enter your delivery address';
// //           }
// //           return null;
// //         },
// //       ),
// //     ],
// //     ),
// //         ),
// //     );
// //   }
// //
// //   Widget _buildBusinessInfoCard() {
// //     return Card(
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
// //             SizedBox(height: 10),
// //             if (selectedCategory == 'Pharma') ...[
// //               TextFormField(
// //                 controller: dnNoController,
// //                 decoration: InputDecoration(labelText: 'DN Number'),
// //               ),
// //               TextFormField(
// //                 controller: dlPicNameController,
// //                 readOnly: true,
// //                 decoration: InputDecoration(
// //                   labelText: 'DL Picture',
// //                   suffixIcon: IconButton(
// //                     icon: Icon(Icons.camera_alt),
// //                     onPressed: () {
// //                       _pickImage(
// //                         nameController: dlPicNameController,
// //                         onBase64Encoded: (base64) {
// //                           dlPicBase64 = base64;
// //                         },
// //                       );
// //                     },
// //                   ),
// //                 ),
// //               ),
// //               TextFormField(
// //                 controller: dlExpireDateController,
// //                 decoration: InputDecoration(labelText: 'DL Expiry Date'),
// //                 onTap: () => _selectDate(dlExpireDateController),
// //               ),
// //             ],
// //             TextFormField(
// //               controller: aadharNoController,
// //               decoration: InputDecoration(labelText: 'Aadhar Number'),
// //               keyboardType: TextInputType.number,
// //               maxLength: 12,
// //               validator: (value) {
// //                 if (value == null || value.isEmpty) {
// //                   return 'Please enter your Aadhar number';
// //                 } else if (value.length != 12) {
// //                   return 'Aadhar number must be 12 digits';
// //                 }
// //                 return null;
// //               },
// //             ),
// //             TextFormField(
// //               controller: aadharPicNameController,
// //               readOnly: true,
// //               decoration: InputDecoration(
// //                 labelText: 'Aadhar Picture',
// //                 suffixIcon: IconButton(
// //                   icon: Icon(Icons.camera_alt),
// //                   onPressed: () {
// //                     _pickImage(
// //                       nameController: aadharPicNameController,
// //                       onBase64Encoded: (base64) {
// //                         aadharPicBase64 = base64;
// //                       },
// //                     );
// //                   },
// //                 ),
// //               ),
// //             ),
// //             TextFormField(
// //               controller: gstNoController,
// //               decoration: InputDecoration(labelText: 'GST Number'),
// //             ),
// //             TextFormField(
// //               controller: gstDocNameController,
// //               readOnly: true,
// //               decoration: InputDecoration(
// //                 labelText: 'GST Document',
// //                 suffixIcon: IconButton(
// //                   icon: Icon(Icons.camera_alt),
// //                   onPressed: () {
// //                     _pickImage(
// //                       nameController: gstDocNameController,
// //                       onBase64Encoded: (base64) {
// //                         gstDocBase64 = base64;
// //                       },
// //                     );
// //                   },
// //                 ),
// //               ),
// //             ),
// //             TextFormField(
// //               controller: tradeLicController,
// //               decoration: InputDecoration(labelText: 'Trade License Number'),
// //             ),
// //             TextFormField(
// //               controller: panNoController,
// //               decoration: InputDecoration(labelText: 'PAN Number'),
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// // }
// //
// // class CustomButtons extends StatelessWidget {
// //   final String text;
// //   final VoidCallback onPressed;
// //
// //   const CustomButtons({required this.text, required this.onPressed, Key? key}) : super(key: key);
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return ElevatedButton(
// //       onPressed: onPressed,
// //       child: Text(text),
// //       style: ElevatedButton.styleFrom(
// //         minimumSize: Size(100, 40),
// //       ),
// //     );
// //   }
// // }
//
//
//
//
// // import 'dart:io';
// // import 'dart:convert';
// // import 'package:flutter/material.dart';
// // import 'package:image_picker/image_picker.dart';
// // import 'package:intl/intl.dart';
// // import 'package:http/http.dart' as http;
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
// //   String selectedCategory = 'Pharma'; // Default category
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
// //       final url = Uri.parse(
// //           'https://namami-infotech.com/EvaraBackend/src/auth/register.php');
// //
// //       final registrationData = {
// //         "username": usernameController.text,
// //         "email": emailController.text,
// //         "phone_number": phoneController.text,
// //         "mailing_address": mailingAddressController.text,
// //         "delivery_address": deliveryAddressController.text,
// //         "category": selectedCategory,
// //         "dn_no": selectedCategory == 'Pharma' ? dnNoController.text : '',
// //         "dl_pic": selectedCategory == 'Pharma' ? dlPicController.text : '',
// //         "dl_expire_date": selectedCategory == 'Pharma'
// //             ? _dateFormat.format(DateTime.parse(dlExpireDateController.text))
// //             : null,
// //         "aadhar_no": aadharNoController.text,
// //         "aadhar_pic": aadharPicController.text,
// //         "gst_no": gstNoController.text,
// //         "gst_doc": gstDocController.text,
// //         "trade_lic": tradeLicController.text,
// //         "pan_no": panNoController.text,
// //       };
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
// //         if (response.statusCode == 201) {
// //           final responseData = jsonDecode(response.body);
// //
// //           if (responseData['message'] == 'Dealer registered successfully.') {
// //             _showSuccessDialog();
// //           } else {
// //             _showErrorDialog(responseData['message'] ??
// //                 'Registration failed. Please try again.');
// //           }
// //         } else {
// //           _showErrorDialog(' ${response.body}');
// //         }
// //       } catch (e) {
// //         _showErrorDialog('Failed to register. Please check your internet connection and try again.');
// //       }
// //     }
// //   }
// //
// //   void _showSuccessDialog() {
// //     showDialog(
// //       context: context,
// //       builder: (context) {
// //         return AlertDialog(
// //           title: Text('Registration Successful'),
// //           content: Text('You have successfully registered. You will be notified by mail after verification.'),
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
// //       firstDate: DateTime.now(),
// //       lastDate: DateTime(2101),
// //     );
// //
// //     if (picked != null) {
// //       controller.text = _dateFormat.format(picked);
// //     }
// //   }
// //
// //   // Helper function to pick image and convert to base64
// //   Future<void> _pickImage(TextEditingController controller) async {
// //     final ImagePicker _picker = ImagePicker();
// //     final XFile? image = await _picker.pickImage(
// //       source: await _showImageSourceDialog(),
// //     );
// //
// //     if (image != null) {
// //       File imageFile = File(image.path);
// //       List<int> imageBytes = await imageFile.readAsBytes();
// //       String base64Image = base64Encode(imageBytes);
// //
// //       setState(() {
// //         controller.text = base64Image;
// //       });
// //     }
// //   }
// //
// //   // Dialog to select image source (camera or gallery)
// //   Future<ImageSource> _showImageSourceDialog() async {
// //     return await showDialog<ImageSource>(
// //       context: context,
// //       builder: (context) => AlertDialog(
// //         title: Text('Choose Image Source'),
// //         actions: [
// //           TextButton(
// //             onPressed: () => Navigator.pop(context, ImageSource.camera),
// //             child: Text('Camera'),
// //           ),
// //           TextButton(
// //             onPressed: () => Navigator.pop(context, ImageSource.gallery),
// //             child: Text('Gallery'),
// //           ),
// //         ],
// //       ),
// //     ) ?? ImageSource.gallery;
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
// //                   Image.asset(
// //                     'assets/logos/evara_logo2.png',
// //                     height: 230,
// //                   ),
// //                   AnimatedSwitcher(
// //                     duration: Duration(milliseconds: 500),
// //                     child: showBusinessInfo
// //                         ? _buildBusinessInfoCard()
// //                         : _buildPersonalInfoCard(),
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
// //             SizedBox(height: 10),
// //             Column(
// //               crossAxisAlignment: CrossAxisAlignment.start,
// //               children: [
// //                 Text(
// //                   'Select Category:',
// //                   style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
// //                 ),
// //                 Row(
// //                   mainAxisAlignment: MainAxisAlignment.start,
// //                   children: [
// //                     Expanded(
// //                       child: RadioListTile<String>(
// //                         title: Text('Pharma'),
// //                         value: 'Pharma',
// //                         groupValue: selectedCategory,
// //                         onChanged: (value) {
// //                           setState(() {
// //                             selectedCategory = value!;
// //                           });
// //                         },
// //                       ),
// //                     ),
// //                     Expanded(
// //                       child: RadioListTile<String>(
// //                         title: Text('General'),
// //                         value: 'General',
// //                         groupValue: selectedCategory,
// //                         onChanged: (value) {
// //                           setState(() {
// //                             selectedCategory = value!;
// //                           });
// //                         },
// //                       ),
// //                     ),
// //                   ],
// //                 ),
// //               ],
// //             ),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildBusinessInfoCard() {
// //     return Card(
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
// //               style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
// //             ),
// //             Divider(),
// //             if (selectedCategory == 'Pharma') ...[
// //               _buildTextField(dnNoController, 'DL Number', Icons.credit_card),
// //               _buildTextField(dlPicController, 'DL Picture', Icons.image, onTap: () => _pickImage(dlPicController)),
// //               _buildTextField(dlExpireDateController, 'DL Expiry Date', Icons.date_range,
// //                   inputType: TextInputType.datetime, onTap: () => _selectDate(dlExpireDateController)),
// //             ],
// //             _buildTextField(aadharNoController, 'Aadhar Number', Icons.credit_card),
// //             _buildTextField(aadharPicController, 'Aadhar Picture', Icons.image, onTap: () => _pickImage(aadharPicController)),
// //             _buildTextField(gstNoController, 'GST Number', Icons.business),
// //             _buildTextField(gstDocController, 'GST Document', Icons.file_copy, onTap: () => _pickImage(gstDocController)),
// //             _buildTextField(tradeLicController, 'Trade License', Icons.document_scanner),
// //             _buildTextField(panNoController, 'PAN Number', Icons.credit_card),
// //           ],
// //         ),
// //       ),
// //     );
// //   }
// //
// //   Widget _buildTextField(
// //       TextEditingController controller,
// //       String label,
// //       IconData icon, {
// //         TextInputType inputType = TextInputType.text,
// //         VoidCallback? onTap,
// //       }) {
// //     return Padding(
// //       padding: const EdgeInsets.symmetric(vertical: 8.0),
// //       child: TextFormField(
// //         controller: controller,
// //         decoration: InputDecoration(
// //           labelText: label,
// //           prefixIcon: Icon(icon),
// //           border: OutlineInputBorder(),
// //         ),
// //         keyboardType: inputType,
// //         readOnly: onTap != null, // Read-only for image fields
// //         onTap: onTap,
// //         validator: (value) {
// //           if (value == null || value.isEmpty) {
// //             if (label.contains('DL Number') || label.contains('DL Picture') || label.contains('DL Expiry Date')) {
// //               return selectedCategory == 'Pharma' ? 'Please enter $label' : null;
// //             } else {
// //               return 'Please enter $label';
// //             }
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
// //
// //
// //
// //
// // // import 'dart:math';
// // // import 'package:flutter/material.dart';
// // // import 'package:http/http.dart' as http;
// // // import 'dart:convert';
// // // import 'package:intl/intl.dart'; // For date formatting
// // // import 'custom_widget.dart';
// // // import 'login.dart';
// // //
// // // class RegistrationPage extends StatefulWidget {
// // //   const RegistrationPage({Key? key}) : super(key: key);
// // //
// // //   @override
// // //   _RegistrationPageState createState() => _RegistrationPageState();
// // // }
// // //
// // // class _RegistrationPageState extends State<RegistrationPage> {
// // //   final _formKey = GlobalKey<FormState>();
// // //   bool showBusinessInfo = false;
// // //   String selectedCategory = 'Pharma'; // Default category
// // //
// // //   // Controllers for personal information
// // //   final TextEditingController usernameController = TextEditingController();
// // //   final TextEditingController emailController = TextEditingController();
// // //   final TextEditingController phoneController = TextEditingController();
// // //   final TextEditingController mailingAddressController =
// // //   TextEditingController();
// // //   final TextEditingController deliveryAddressController =
// // //   TextEditingController();
// // //
// // //   // Controllers for business information
// // //   final TextEditingController dnNoController = TextEditingController();
// // //   final TextEditingController dlPicController = TextEditingController();
// // //   final TextEditingController dlExpireDateController = TextEditingController();
// // //   final TextEditingController aadharNoController = TextEditingController();
// // //   final TextEditingController aadharPicController = TextEditingController();
// // //   final TextEditingController gstNoController = TextEditingController();
// // //   final TextEditingController gstDocController = TextEditingController();
// // //   final TextEditingController tradeLicController = TextEditingController();
// // //   final TextEditingController panNoController = TextEditingController();
// // //
// // //   // Date format
// // //   final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
// // //
// // //   Future<void> _registerUser() async {
// // //     if (_formKey.currentState!.validate()) {
// // //       final url = Uri.parse(
// // //           'https://namami-infotech.com/EvaraBackend/src/auth/register.php');
// // //
// // //       final registrationData = {
// // //         "username": usernameController.text,
// // //         "email": emailController.text,
// // //         "phone_number": phoneController.text,
// // //         "mailing_address": mailingAddressController.text,
// // //         "delivery_address": deliveryAddressController.text,
// // //         "category":
// // //         selectedCategory, // Include category in the registration data
// // //         "dn_no": selectedCategory == 'Pharma' ? dnNoController.text : '',
// // //         "dl_pic": selectedCategory == 'Pharma' ? dlPicController.text : '',
// // //         "dl_expire_date": selectedCategory == 'Pharma'
// // //             ? _dateFormat.format(DateTime.parse(dlExpireDateController.text))
// // //             : null,
// // //         "aadhar_no": aadharNoController.text,
// // //         "aadhar_pic": aadharPicController.text,
// // //         "gst_no": gstNoController.text,
// // //         "gst_doc": gstDocController.text,
// // //         "trade_lic": tradeLicController.text,
// // //         "pan_no": panNoController.text,
// // //       };
// // //
// // //       print(
// // //           "Data to be sent for registration: $registrationData"); // Printing data to the console
// // //
// // //       try {
// // //         final response = await http.post(
// // //           url,
// // //           headers: {
// // //             'Content-Type': 'application/json',
// // //           },
// // //           body: jsonEncode(registrationData),
// // //         );
// // //
// // //         print(
// // //             'API Response: ${response.body}'); // Print the API response in the console
// // //
// // //         if (response.statusCode == 201) {
// // //           final responseData = jsonDecode(response.body);
// // //
// // //           if (responseData['message'] == 'Dealer registered successfully.') {
// // //             showDialog(
// // //               context: context,
// // //               builder: (context) {
// // //                 return AlertDialog(
// // //                   title: Text('Registration Successful'),
// // //                   content: Text(
// // //                       'You have successfully registered. You will be notified by mail after verification.'),
// // //                   actions: [
// // //                     TextButton(
// // //                       onPressed: () {
// // //                         Navigator.pop(context);
// // //                       },
// // //                       child: Text('OK'),
// // //                     ),
// // //                   ],
// // //                 );
// // //               },
// // //             );
// // //           } else {
// // //             _showErrorDialog(responseData['message'] ??
// // //                 'Registration failed. Please try again.');
// // //           }
// // //         } else {
// // //           _showErrorDialog(' ${response.body}');
// // //         }
// // //       } catch (e) {
// // //         _showErrorDialog(
// // //             'Failed to register. Please check your internet connection and try again.');
// // //       }
// // //     }
// // //   }
// // //
// // //   void _showErrorDialog(String message) {
// // //     showDialog(
// // //       context: context,
// // //       builder: (context) {
// // //         return AlertDialog(
// // //           title: Text('Error'),
// // //           content: Text(message),
// // //           actions: [
// // //             TextButton(
// // //               onPressed: () {
// // //                 Navigator.pop(context);
// // //               },
// // //               child: Text('OK'),
// // //             ),
// // //           ],
// // //         );
// // //       },
// // //     );
// // //   }
// // //
// // //   Future<void> _selectDate(TextEditingController controller) async {
// // //     final DateTime? picked = await showDatePicker(
// // //       context: context,
// // //       initialDate: DateTime.now(),
// // //       firstDate: DateTime.now(),//DateTime(2000),
// // //       lastDate: DateTime(2101),
// // //     );
// // //
// // //     if (picked != null) {
// // //       controller.text = _dateFormat.format(picked);
// // //     }
// // //   }
// // //
// // //   @override
// // //   Widget build(BuildContext context) {
// // //     return Scaffold(
// // //       backgroundColor: Colors.white,
// // //       body: Center(
// // //         child: SingleChildScrollView(
// // //           child: Padding(
// // //             padding: const EdgeInsets.all(25.0),
// // //             child: Form(
// // //               key: _formKey,
// // //               child: Column(
// // //                 mainAxisAlignment: MainAxisAlignment.center,
// // //                 children: [
// // //                   // Logo at the top of the form
// // //                   Image.asset(
// // //                     'assets/logos/evara_logo2.png', // Replace with your logo asset path
// // //                     height: 230,
// // //                   ),
// // //                   AnimatedSwitcher(
// // //                     duration: Duration(milliseconds: 500),
// // //                     transitionBuilder: (child, animation) {
// // //                       final rotate =
// // //                       Tween(begin: pi / 2, end: 0.0).animate(animation);
// // //                       return AnimatedBuilder(
// // //                         animation: rotate,
// // //                         child: child,
// // //                         builder: (context, child) {
// // //                           final isUnder =
// // //                           (ValueKey(showBusinessInfo) != child?.key);
// // //                           var tilt =
// // //                               (isUnder ? 0.003 : 0.0) * pi * animation.value;
// // //                           tilt *= isUnder ? -1.0 : 1.0;
// // //                           return Transform(
// // //                             transform: Matrix4.rotationY(rotate.value)
// // //                               ..setEntry(3, 0, tilt),
// // //                             alignment: Alignment.center,
// // //                             child: child,
// // //                           );
// // //                         },
// // //                       );
// // //                     },
// // //                     child: showBusinessInfo
// // //                         ? _buildBusinessInfoCard()
// // //                         : _buildPersonalInfoCard(),
// // //                   ),
// // //                   SizedBox(height: 10),
// // //                   Row(
// // //                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
// // //                     children: [
// // //                       if (showBusinessInfo)
// // //                         CustomButton(
// // //                           text: 'Previous',
// // //                           onPressed: () {
// // //                             setState(() {
// // //                               showBusinessInfo = false;
// // //                             });
// // //                           },
// // //                         ),
// // //                       CustomButton(
// // //                         text: showBusinessInfo ? 'Submit' : 'Next',
// // //                         onPressed: () {
// // //                           if (_formKey.currentState!.validate()) {
// // //                             if (showBusinessInfo) {
// // //                               _registerUser();
// // //                             } else {
// // //                               setState(() {
// // //                                 showBusinessInfo = true;
// // //                               });
// // //                             }
// // //                           }
// // //                         },
// // //                       ),
// // //                     ],
// // //                   ),
// // //                   SizedBox(height: 10),
// // //                   TextButton(
// // //                     onPressed: () {
// // //                       Navigator.push(
// // //                         context,
// // //                         MaterialPageRoute(builder: (context) => LoginPage()),
// // //                       );
// // //                     },
// // //                     child: Text(
// // //                       "Already have an account? Login",
// // //                       style: TextStyle(
// // //                         color: Colors.black,
// // //                       ),
// // //                     ),
// // //                   ),
// // //                 ],
// // //               ),
// // //             ),
// // //           ),
// // //         ),
// // //       ),
// // //     );
// // //   }
// // //
// // //   Widget _buildPersonalInfoCard() {
// // //     return Card(
// // //       key: ValueKey(false),
// // //       elevation: 2,
// // //       shape: RoundedRectangleBorder(
// // //         borderRadius: BorderRadius.circular(10),
// // //       ),
// // //       child: Padding(
// // //         padding: const EdgeInsets.all(12.0),
// // //         child: Column(
// // //           children: [
// // //             Text(
// // //               'Personal Information',
// // //               style: TextStyle(
// // //                 fontSize: 18,
// // //                 fontWeight: FontWeight.bold,
// // //               ),
// // //             ),
// // //             Divider(),
// // //             _buildTextField(usernameController, 'Username', Icons.person),
// // //             _buildTextField(emailController, 'Email', Icons.email, inputType: TextInputType.emailAddress),
// // //             _buildTextField(phoneController, 'Phone Number', Icons.phone, inputType: TextInputType.phone),
// // //             _buildTextField(mailingAddressController, 'Mailing Address', Icons.home),
// // //             _buildTextField(deliveryAddressController, 'Delivery Address',
// // //                 Icons.location_on),
// // //             SizedBox(height: 10),
// // //             Column(
// // //               crossAxisAlignment: CrossAxisAlignment.start,
// // //               children: [
// // //                 Text(
// // //                   'Select Category:',
// // //                   style: TextStyle(
// // //                     fontSize: 16,
// // //                     fontWeight: FontWeight.bold,
// // //                   ),
// // //                 ),
// // //                 Row(
// // //                   mainAxisAlignment: MainAxisAlignment.start,
// // //                   children: [
// // //                     Expanded(
// // //                       child: RadioListTile<String>(
// // //                         title: Text('Pharma'),
// // //                         value: 'Pharma',
// // //                         groupValue: selectedCategory,
// // //                         onChanged: (value) {
// // //                           setState(() {
// // //                             selectedCategory = value!;
// // //                           });
// // //                         },
// // //                       ),
// // //                     ),
// // //                     Expanded(
// // //                       child: RadioListTile<String>(
// // //                         title: Text('General'),
// // //                         value: 'General',
// // //                         groupValue: selectedCategory,
// // //                         onChanged: (value) {
// // //                           setState(() {
// // //                             selectedCategory = value!;
// // //                           });
// // //                         },
// // //                       ),
// // //                     ),
// // //                   ],
// // //                 ),
// // //               ],
// // //             ),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // //
// // //   Widget _buildBusinessInfoCard() {
// // //     return Card(
// // //       key: ValueKey(true),
// // //       elevation: 2,
// // //       shape: RoundedRectangleBorder(
// // //         borderRadius: BorderRadius.circular(10),
// // //       ),
// // //       child: Padding(
// // //         padding: const EdgeInsets.all(12.0),
// // //         child: Column(
// // //           children: [
// // //             Text(
// // //               'Business Information',
// // //               style: TextStyle(
// // //                 fontSize: 18,
// // //                 fontWeight: FontWeight.bold,
// // //               ),
// // //             ),
// // //             Divider(),
// // //             if (selectedCategory == 'Pharma') ...[
// // //               _buildTextField(dnNoController, 'DL Number', Icons.credit_card),
// // //               _buildTextField(dlPicController, 'DL Picture', Icons.image),
// // //               _buildTextField(
// // //                   dlExpireDateController, 'DL Expiry Date', Icons.date_range,
// // //                   inputType: TextInputType.datetime,
// // //                   onTap: () => _selectDate(dlExpireDateController)),
// // //             ],
// // //             _buildTextField(
// // //                 aadharNoController, 'Aadhar Number', Icons.credit_card),
// // //             _buildTextField(aadharPicController, 'Aadhar Picture', Icons.image, inputType: TextInputType.number),
// // //             _buildTextField(gstNoController, 'GST Number', Icons.business),
// // //             _buildTextField(gstDocController, 'GST Document', Icons.file_copy),
// // //             _buildTextField(tradeLicController, 'Trade License', Icons.document_scanner),
// // //             _buildTextField(panNoController, 'PAN Number', Icons.credit_card),
// // //           ],
// // //         ),
// // //       ),
// // //     );
// // //   }
// // //
// // //   Widget _buildTextField(
// // //       TextEditingController controller,
// // //       String label,
// // //       IconData icon, {
// // //         TextInputType inputType = TextInputType.text,
// // //         VoidCallback? onTap,
// // //       }) {
// // //     return Padding(
// // //       padding: const EdgeInsets.symmetric(vertical: 8.0),
// // //       child: TextFormField(
// // //         controller: controller,
// // //         decoration: InputDecoration(
// // //           labelText: label,
// // //           prefixIcon: Icon(icon),
// // //           border: OutlineInputBorder(),
// // //         ),
// // //         keyboardType: inputType,
// // //         onTap: onTap,
// // //         validator: (value) {
// // //           if (value == null || value.isEmpty) {
// // //             if (label.contains('DL Number') ||
// // //                 label.contains('DL Picture') ||
// // //                 label.contains('DL Expiry Date')) {
// // //               return selectedCategory == 'Pharma'
// // //                   ? 'Please enter $label'
// // //                   : null;
// // //             } else {
// // //               return 'Please enter $label';
// // //             }
// // //           }
// // //           return null;
// // //         },
// // //       ),
// // //     );
// // //   }
// // // }
// // //
// // //
// // //
