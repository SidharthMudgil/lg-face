import 'package:flutter/material.dart';

class LGButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Function() onPressed;
  final bool enabled;

  const LGButton({
    required this.label,
    required this.icon,
    required this.onPressed,
    required this.enabled,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 16),
      child: ElevatedButton(
        onPressed: () {
          if (!enabled) {
            return;
          }
          onPressed();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: enabled ? ThemeData().primaryColor : Colors.grey,
          minimumSize: const Size(300, 48),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              color: ThemeData().primaryColor,
            ),
            const SizedBox(width: 8), // Adjust the spacing as needed
            Text(
              label,
              style: TextStyle(
                color: ThemeData().primaryColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
