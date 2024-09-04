import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:evara/controller/cart_component/CartController.dart';

class UserController extends GetxController {
  var isLoggedIn = false.obs;
  var userName = ''.obs;
  var email = ''.obs;
  var phoneNumber = ''.obs;
  var token = ''.obs;
  var appUrl = ''.obs;
  var userId = ''.obs;

  @override
  void onInit() {
    super.onInit();
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
          print(userDataInfo.toString());
          isLoggedIn.value = true;
          userId.value = userDataInfo['user_id'].toString() ?? 'UserId not found';
          userName.value = userDataInfo['email'] ?? 'User';
          email.value = userDataInfo['email'] ?? 'No Email';
          phoneNumber.value = userDataInfo['phone_number'] ?? 'No Phone Number';
          token.value = responseData['token'] ?? 'Token not found';
          appUrl.value = responseData['AppURL'] ?? 'AppURL not found';
          print("Token : " + token.toString());
        }
      }
    }
  }

  Future<void> logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final allKeys = prefs.getKeys();
    String? userKey = allKeys.isNotEmpty ? allKeys.first : null;

    if (userKey != null) {
      prefs.remove(userKey);
    }
    // Clear cart for the logged out user
    final CartController cartController = Get.find<CartController>();
    //await cartController.clearCart();

    isLoggedIn.value = false;
    Get.offAllNamed('/login'); // Navigate to the login page
  }


}


//
// import 'dart:convert';
//
// import 'package:get/get.dart';
// import 'package:shared_preferences/shared_preferences.dart';
//
// class UserController extends GetxController {
//   var isLoggedIn = false.obs;
//   var userName = ''.obs;
//   var email = ''.obs;
//   var phoneNumber = ''.obs;
//   var token = ''.obs;
//   var appUrl = ''.obs;
//   var userId = ''.obs;
//
//   @override
//   void onInit() {
//     super.onInit();
//     _loadUserData();
//   }
//
//   Future<void> _loadUserData() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     final allKeys = prefs.getKeys();
//     String? userKey = allKeys.isNotEmpty ? allKeys.first : null;
//
//     if (userKey != null) {
//       final String? userDataJson = prefs.getString(userKey);
//       if (userDataJson != null) {
//         final Map<String, dynamic>? responseData = jsonDecode(userDataJson);
//         if (responseData != null) {
//           final userDataInfo = responseData['userData'];
//           print(userDataInfo.toString());
//           isLoggedIn.value = true;
//           userId.value = userDataInfo['user_id'].toString() ?? 'UserId not found';
//           userName.value = userDataInfo['email'] ?? 'User';
//           email.value = userDataInfo['email'] ?? 'No Email';
//           phoneNumber.value = userDataInfo['phone_number'] ?? 'No Phone Number';
//           token.value = responseData['token'] ?? 'Token not found';
//           appUrl.value = responseData['AppURL'] ?? 'AppURL not found';
//           print("Token : " + token.toString());
//
//         }
//       }
//     }
//   }
//
//   Future<void> logout() async {
//     final SharedPreferences prefs = await SharedPreferences.getInstance();
//     final allKeys = prefs.getKeys();
//     String? userKey = allKeys.isNotEmpty ? allKeys.first : null;
//
//     if (userKey != null) {
//       prefs.remove(userKey);
//     }
//     isLoggedIn.value = false;
//     Get.offAllNamed('/login'); // Navigate to the login page
//   }
// }
