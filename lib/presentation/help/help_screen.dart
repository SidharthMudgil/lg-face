import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  static const route = "/help";

  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (can) {
        Navigator.of(context).pushReplacementNamed("/");
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed("/");
            },
          ),
          title: const Text('Help'),
        ),
        body: Container(),
      ),
    );
  }
}
