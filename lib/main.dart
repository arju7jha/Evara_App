import 'package:evara/features/authentication/login.dart';
import 'package:evara/screens/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'controller/UserController.dart';
import 'controller/cart_component/CartController.dart';
import 'screens/splashscreen/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
   SharedPreferences.getInstance();
  // Initialize GetX controller
  Get.lazyPut(()=>UserController());
  Get.put(CartController());
  //Get.put(UserController());

  runApp(Phoenix(
    child: MyApp(),
  ));//runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Evara',

      theme: ThemeData(
        primaryColor: const Color(0xffffffff),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          primary: const Color(0xff009688),//Color(0xff1b3156),
          secondary: const Color(0xff009688)//Color(0xff1b3156), //secondary: const Color(0xffE7333E),
        ),
      ),
      home: SplashScreenPage(),//MainPage(),//MainPage(),//SplashScreenPage(),
    );
  }
}










// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:hr_smile/screens/splashscreen/splash_screen.dart';
// import 'features/authentication/login.dart';
//
//
// void main() {
//   runApp(MyApp());
// }
//
// class MyApp extends StatelessWidget {
//   const MyApp({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'HR Smile',
//       theme: ThemeData(
//         primaryColor: const Color(0xff1b3156),
//         colorScheme: ColorScheme.fromSwatch().copyWith(
//           primary: const Color(0xff1b3156),
//           secondary: const Color(0xff1b3156),
//         ),
//       ),
//       home: SplashScreenPage(), //MainPage(),
//     );
//   }
// }
