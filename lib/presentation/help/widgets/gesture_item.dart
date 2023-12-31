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
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: Image.asset(
              asset,
              fit: BoxFit.cover,
            ),
          ),
        ),
        const SizedBox(height: 8),
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
