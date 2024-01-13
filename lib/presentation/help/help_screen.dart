import 'package:flutter/material.dart';

import '../../core/constant/constants.dart';
import '../home/home_screen.dart';
import 'widgets/gesture_item.dart';

class HelpScreen extends StatelessWidget {
  static const route = "/help";

  const HelpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (can) {
        Navigator.of(context).pushReplacementNamed(HomeScreen.route);
      },
      child: Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pushReplacementNamed(HomeScreen.route);
            },
          ),
          title: const Text('Help'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: GridView.builder(
            physics: const BouncingScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16.0,
              mainAxisSpacing: 16.0,
              childAspectRatio: 0.7,
            ),
            itemCount: 6,
            itemBuilder: (context, index) {
              return GestureItem(
                asset: gestures[index][0],
                label: gestures[index][1],
              );
            },
          ),
        ),
      ),
    );
  }
}
