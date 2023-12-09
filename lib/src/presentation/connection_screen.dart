import 'package:flutter/material.dart';

class ConnectionScreen extends StatelessWidget {
  const ConnectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text("Username"),
        TextField(),
        Text("Password"),
        TextField(),
        Text("IP Address"),
        TextField(),
        Text("Port Number"),
        TextField(),
        Text("Total Screens"),
        Slider(value: 0.2, onChanged: (double value) {}),
      ],
    );  }
}
