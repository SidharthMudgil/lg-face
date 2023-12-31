import 'package:flutter/material.dart';

class GestureItem extends StatelessWidget {
  final String asset;
  final String label;

  const GestureItem({
    required this.asset,
    required this.label,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Image.asset(
          asset,
          // width: double.infinity,
          // height: double.infinity,
        ),
        const SizedBox(height: 8), // Add some spacing between image and label
        Text(
          label,
          style: const TextStyle(
            fontSize: 16, // Set the font size as needed
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
