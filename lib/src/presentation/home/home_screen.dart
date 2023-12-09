import 'package:flutter/material.dart';
import 'package:lg_face/src/presentation/connection/connection_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("jhxx"),
      ),
      body: ConnectionScreen(),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(label: "Asd", icon: Icon(Icons.camera_alt)),
          BottomNavigationBarItem(label: "Asd", icon: Icon(Icons.connected_tv_rounded)),
        ],
      ),
    );
  }
}
