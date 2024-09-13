import 'package:flutter/material.dart';

class GradientButton extends StatelessWidget {
  final String label;
  final Function() onPressed;

  const GradientButton({required this.label, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      child: ShaderMask(
        shaderCallback: (Rect bounds) {
          return const LinearGradient(
            colors: [Colors.black, Colors.orangeAccent],
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
          ).createShader(bounds);
        },
        child: Text(
          label,
          style: const TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }
}

class CustomRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const CustomRow({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: Colors.purple, size: 18),
        const SizedBox(width: 5),
        Text(text, style: TextStyle(fontSize: 14, color: Colors.grey[700])),
      ],
    );
  }
}

Color getStatusColor(String status) {
  switch (status) {
    case 'REJECTED':
      return Colors.red;
    case 'ACCEPTED':
      return Colors.green;
    case 'DELIVERED':
      return Colors.teal;
    default:
      return Colors.orange;
  }
}

Widget buildExpandedText(String text, {required int flex, bool center = false}) {
  return Expanded(
    flex: flex,
    child: Text(
      text,
      style: TextStyle(fontSize: 14, color: Colors.grey[600]),
      textAlign: center ? TextAlign.center : TextAlign.start,
    ),
  );
}
