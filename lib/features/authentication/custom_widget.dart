import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const CustomButton({
    Key? key,
    required this.text,
    required this.onPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        //backgroundColor: Color(0xff1b3156), // Button color
        padding: EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
      ),
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(fontSize: 18, color: Colors.white),
      ),
    );
  }
}


// import 'package:flutter/material.dart';
//
// class CustomTextField extends StatelessWidget {
//   final IconData prefixIcon;
//   final String labelText;
//   final bool obscureText;
//   final TextEditingController controller;
//
//   const CustomTextField({
//     Key? key,
//     required this.prefixIcon,
//     required this.labelText,
//     this.obscureText = false,
//     required this.controller,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return TextField(
//       controller: controller,
//       obscureText: obscureText,
//       decoration: InputDecoration(
//         prefixIcon: Icon(prefixIcon),
//         labelText: labelText,
//         border: const OutlineInputBorder(),
//       ),
//     );
//   }
// }
//
// // class CustomTextField extends StatelessWidget {
// //   final IconData prefixIcon;
// //   final String labelText;
// //   final bool obscureText;
// //
// //   const CustomTextField({
// //     Key? key,
// //     required this.prefixIcon,
// //     required this.labelText,
// //     this.obscureText = false,
// //   }) : super(key: key);
// //
// //   @override
// //   Widget build(BuildContext context) {
// //     return TextField(
// //       obscureText: obscureText,
// //       decoration: InputDecoration(
// //         prefixIcon: Icon(prefixIcon),
// //         labelText: labelText,
// //         border: OutlineInputBorder(
// //           borderRadius: BorderRadius.circular(10),
// //         ),
// //       ),
// //     );
// //   }
// // }
//
// class CustomButton extends StatelessWidget {
//   final VoidCallback onPressed;
//   final String text;
//   final EdgeInsetsGeometry padding;
//
//   const CustomButton({
//     Key? key,
//     required this.onPressed,
//     required this.text,
//     this.padding = const EdgeInsets.symmetric(vertical: 16),
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: onPressed,
//       style: ElevatedButton.styleFrom(
//         // primary: const Color(0xffffffff),
//         shape: RoundedRectangleBorder(
//           borderRadius: BorderRadius.circular(25),
//         ),
//         padding: padding,
//         textStyle: const TextStyle(fontSize: 18),
//       ),
//       child: Text(text),
//     );
//   }
// }
