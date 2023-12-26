import 'package:flutter/material.dart';

class InputField extends StatelessWidget {
  final String hintText;
  final TextEditingController inputController;
  final TextInputType inputType;

  const InputField({required this.hintText, required this.inputController, required this.inputType, super.key});

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: inputController,
      keyboardType: inputType,
      textAlign: TextAlign.start,
      decoration: InputDecoration(
        border: const OutlineInputBorder(
            borderRadius: BorderRadius.all(
                Radius.circular(5)
            )
        ),
        hintText: hintText,
      ),
    );
  }
}
