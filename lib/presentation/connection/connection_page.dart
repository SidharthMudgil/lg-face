import 'package:flutter/material.dart';

import 'widgets/input_field.dart';
import 'widgets/input_label.dart';

const String connect = "Connect";
const String disconnect = "Disconnect";

class ConnectionPage extends StatefulWidget {
  const ConnectionPage({super.key});

  @override
  State<ConnectionPage> createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionPage> {
  final TextEditingController userController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  final TextEditingController ipController = TextEditingController();
  final TextEditingController portController = TextEditingController();

  double value = 3;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const InputLabel(
            label: "Username",
          ),
          InputField(
            hintText: "lg",
            inputController: userController,
            inputType: TextInputType.name,
          ),
          const SizedBox(
            height: 16,
          ),
          const InputLabel(
            label: "Password",
          ),
          InputField(
            hintText: "lg",
            inputController: passController,
            inputType: TextInputType.visiblePassword,
          ),
          const SizedBox(
            height: 16,
          ),
          const InputLabel(
            label: "IP Address",
          ),
          InputField(
            hintText: "192.168.0.1",
            inputController: ipController,
            inputType: TextInputType.phone,
          ),
          const SizedBox(
            height: 16,
          ),
          const InputLabel(
            label: "Port Number",
          ),
          InputField(
            hintText: "22",
            inputController: portController,
            inputType: TextInputType.number,
          ),
          const SizedBox(
            height: 16,
          ),
          const InputLabel(
            label: "Total Screens",
          ),
          Slider(
            value: value,
            min: 3,
            max: 10,
            divisions: 10,
            label: "${value.toInt()}",
            onChanged: (newValue) {
              setState(() {
                value = newValue;
              });
            },
          ),
          const SizedBox(
            height: 16,
          ),
          Align(
            alignment: Alignment.center,
            child: FilledButton(
              onPressed: () {},
              style: FilledButton.styleFrom(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                ),
              ),
              child: const Text(
                (2 > 1) ? connect : disconnect,
              ),
            ),
          )
        ],
      ),
    );
  }
}
