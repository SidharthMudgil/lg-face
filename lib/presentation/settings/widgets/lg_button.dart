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
      child: SizedBox(
        width: 300,
        height: 48,
        child: ElevatedButton(
          onPressed: () {
            if (!enabled) {
              return;
            }
            onPressed();
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: enabled ? ThemeData().primaryColor : Colors.grey,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label.toUpperCase(),
                style: TextStyle(
                  color: enabled ? ThemeData().primaryColor : Colors.blueGrey,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              const SizedBox(width: 8), // Adjust the spacing as needed
              Icon(
                icon,
                color: enabled ? ThemeData().primaryColor : Colors.blueGrey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
