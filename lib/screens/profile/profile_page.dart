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
  final UserController userController = Get.find<UserController>();

  @override
  void initState() {
    super.initState();
    userController.loadUserData();
    print(userController);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
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
          child: const Icon(Icons.logout),
        )
            : const SizedBox();
      }),
    );
  }

  Widget _buildLoggedInView() {
    return SingleChildScrollView(
      child: Card(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Profile Picture and User Info
              Center(
                child: CircleAvatar(
                  radius: 40,
                  backgroundColor: const Color(0xff25a295),
                  child: Text(
                    userController.userName.value.isNotEmpty
                        ? userController.userName.value[0].toUpperCase()
                        : 'U',
                    style: const TextStyle(fontSize: 24, color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Center(
                child: Text(
                  'Hello, ${userController.userName.value}!',
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 16),
              const Divider(),

              // Email
              _buildInfoTile(
                  icon: Icons.email,
                  title: 'Email',
                  subtitle: userController.email.value),
              // Phone Number
              _buildInfoTile(
                  icon: Icons.phone,
                  title: 'Phone Number',
                  subtitle: userController.phoneNumber.value),
              // Mailing Address
              _buildInfoTile(
                  icon: Icons.location_on_rounded,
                  title: 'Mailing Address',
                  subtitle: userController.mailAddress.value),
              // Delivery Address
              _buildInfoTile(
                  icon: Icons.location_on,
                  title: 'Delivery Address',
                  subtitle: userController.deliveryAddress.value),
              // DL Number
              _buildInfoTile(
                  icon: Icons.medical_information,
                  title: 'DL Number ',
                  subtitle: userController.dlNo.value),
              // DL Expiry
              _buildInfoTile(
                  icon: Icons.medical_services_outlined,
                  title: 'DL Expiry Date',
                  subtitle: userController.dlExpireDate.value),
              // Aadhar Number
              _buildInfoTile(
                  icon: Icons.perm_identity,
                  title: 'Aadhar Number',
                  subtitle: userController.aadharNo.value),
              // GST Number
              _buildInfoTile(
                  icon: Icons.business,
                  title: 'GST Number',
                  subtitle: userController.gstNo.value),
              // PAN Number
              _buildInfoTile(
                  icon: Icons.credit_card,
                  title: 'PAN Number',
                  subtitle: userController.panNo.value),

              const SizedBox(height: 20),

              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    // Implement edit profile functionality
                  },
                  icon: const Icon(Icons.edit, color: Colors.white),
                  label: const Text('Edit Profile'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xffe04545),
                    padding:
                    const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // Helper method to build ListTile with user data
  Widget _buildInfoTile({required IconData icon, required String title, required String subtitle}) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xff25a295)),
      title: Text(title),
      subtitle: Text(subtitle),
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
        const SizedBox(height: 20),
        const Text(
          'Welcome to Our App!',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        const Text(
          'Please log in to continue',
          style: TextStyle(fontSize: 16, color: Colors.grey),
        ),
        const SizedBox(height: 20),
        CustomButton(
          text: 'Login',
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginPage()),
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



// import 'package:evara/features/authentication/login.dart';
// import 'package:evara/screens/main_page.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
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
//
//   @override
//   void initState() {
//     super.initState();
//     // Load user data when screen is initialized
//     userController.loadUserData(); // Call the updated method
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Center(
//           // Obx will observe changes in the isLoggedIn value from UserController
//           child: Obx(() => userController.isLoggedIn.value
//               ? _buildLoggedInView()
//               : _buildLoggedOutView(context)),
//         ),
//       ),
//       floatingActionButton: Obx(() {
//         return userController.isLoggedIn.value
//             ? FloatingActionButton(
//           onPressed: _logout,
//           tooltip: 'Logout',
//           child: Icon(Icons.logout),
//         )
//             : SizedBox(); // Use SizedBox to replace 'null'
//       }),
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
//                   userController.userName.value.isNotEmpty
//                       ? userController.userName.value[0].toUpperCase()
//                       : 'U',
//                   style: TextStyle(fontSize: 24, color: Colors.white),
//                 ),
//               ),
//             ),
//             SizedBox(height: 16),
//             Center(
//               child: Text(
//                 'Hello, ${userController.userName.value}!',
//                 style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
//               ),
//             ),
//             SizedBox(height: 16),
//             Divider(),
//             ListTile(
//               leading: Icon(Icons.email, color: Color(0xff1b3156)),
//               title: Text('Email'),
//               subtitle: Text(userController.email.value),
//             ),
//             ListTile(
//               leading: Icon(Icons.phone, color: Color(0xff1b3156)),
//               title: Text('Phone Number'),
//               subtitle: Text(userController.phoneNumber.value),
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
//
//   void _logout() {
//     userController.logout();
//   }
// }
//
//
//
