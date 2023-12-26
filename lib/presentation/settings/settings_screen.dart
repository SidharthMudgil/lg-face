import 'package:flutter/material.dart';
import 'package:lg_face/presentation/settings/pages/connection_page.dart';
import 'package:lg_face/presentation/settings/pages/gestures_page.dart';
import 'package:lg_face/presentation/settings/pages/liquid_galaxy_page.dart';

class SettingsScreen extends StatelessWidget {
  static const route = "/settings";

  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3, // Number of tabs
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Settings'),
          bottom: const TabBar(
            tabs: [
              Tab(
                icon: Icon(Icons.connected_tv_rounded),
                text: 'Connection',
              ),
              Tab(
                icon: Icon(Icons.sign_language_rounded),
                text: 'Gestures',
              ),
              Tab(
                icon: Icon(Icons.south_america_rounded),
                text: 'Liquid Galaxy',
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ConnectionPage(),
            LiquidGalaxyPage(),
            GesturesPage(),
          ],
        ),
      ),
    );
  }
}
