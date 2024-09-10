import 'dart:convert';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserController extends GetxController {
  var isLoggedIn = false.obs;
  var userName = ''.obs;
  var email = ''.obs;
  var phoneNumber = ''.obs;
  var token = ''.obs;
  var appUrl = ''.obs;
  var userId = ''.obs;
  var mailAddress = ''.obs;
  var deliveryAddress = ''.obs;
  var dnNo = ''.obs;
  var dlPic = ''.obs;
  var dlExpireDate = ''.obs;
  var aadharNo = ''.obs;
  var aadharPic = ''.obs;
  var gstNo = ''.obs;
  var gstDoc = ''.obs;
  var tradeLic = ''.obs;
  var panNo = ''.obs;


  @override
  void onInit() {
    super.onInit();
    loadUserData(); // Update method call here
  }

  // Make this method public (remove the underscore)
  Future<void> loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final allKeys = prefs.getKeys();
    String? userKey = allKeys.isNotEmpty ? allKeys.first : null;

    if (userKey != null) {
      final String? userDataJson = prefs.getString(userKey);
      if (userDataJson != null) {
        final Map<String, dynamic>? responseData = jsonDecode(userDataJson);
        if (responseData != null) {
          final userDataInfo = responseData['userData'];
          isLoggedIn.value = true;
          userId.value = userDataInfo['user_id'].toString() ?? 'UserId not found';
          userName.value = userDataInfo['username'] ?? 'User';
          email.value = userDataInfo['email'] ?? 'No Email';
          phoneNumber.value = userDataInfo['phone_number'] ?? 'No Phone Number';
          token.value = responseData['token'] ?? 'Token not found';
          appUrl.value = responseData['AppURL'] ?? 'AppURL not found';
          mailAddress.value = userDataInfo['mailing_address'] ?? 'Mailing address not found';
          deliveryAddress.value = userDataInfo['delivery_address'] ?? 'Delivery address not found';
          dnNo.value = userDataInfo['dl_no'] ?? 'DL num not found';
          dlPic.value = userDataInfo['dl_pic'] ?? 'DL pic not found';
          dlExpireDate.value = userDataInfo['dl_expire_date'] ?? 'DL expire not found';
          aadharNo.value = userDataInfo['aadhar_no'] ?? 'Aadhar number not found';
          aadharPic.value = userDataInfo['aadhar_pic'] ?? 'Aadhar pic not found';
          gstNo.value = userDataInfo['gst_no'] ?? 'GST number not found';
          gstDoc.value = userDataInfo['gst_doc'] ?? 'GST document not found';
          tradeLic.value = userDataInfo['trade_lic'] ?? 'Trade License not found';
          panNo.value = userDataInfo['pan_no'] ?? 'PAN number not found';

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
//
//           userName.value = userDataInfo['email'] ?? 'User';
//           email.value = userDataInfo['email'] ?? 'No Email';
//           phoneNumber.value = userDataInfo['phone_number'] ?? 'No Phone Number';
//           token.value = userDataInfo['token'] ?? 'no token found';
//           print("asdsdfafew"+userDataInfo.toString());
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