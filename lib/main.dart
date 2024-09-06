import 'package:evara/features/authentication/login.dart';
import 'package:evara/screens/main_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:get/get.dart';

import 'controller/UserController.dart';
import 'controller/cart_component/CartController.dart';
import 'screens/splashscreen/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetX controller
  Get.put(CartController());
  Get.put(UserController());

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
          primary: const Color(0xff1b3156),
          secondary: const Color(0xff1b3156), //secondary: const Color(0xffE7333E),
        ),
      ),
      home: SplashScreenPage(),//MainPage(),//MainPage(),//SplashScreenPage(),
    );
  }
}
