import 'package:flutter/material.dart';
import 'package:lg_face/presentation/settings/pages/connection_page.dart';
import 'package:lg_face/presentation/settings/pages/liquid_galaxy_page.dart';

class SettingsScreen extends StatelessWidget {
  static const route = "/settings";

  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (can) {
        Navigator.of(context).pushReplacementNamed("/");
      },
      child: DefaultTabController(
        length: 3, // Number of tabs
        child: Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pushReplacementNamed("/");
              },
            ),
            title: const Text('Settings'),
            bottom: const TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.connected_tv_rounded),
                  text: 'Connection',
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
            ],
          ),
        ),
      ),
    );
  }
}
