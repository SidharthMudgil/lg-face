import 'package:flutter/material.dart';
import 'package:lg_face/src/presentation/camera/camera_screen.dart';
import 'package:lg_face/src/presentation/connection/connection_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _page = 0;
  late PageController _pageController;

  @override
  void initState() {
    super.initState();
    _pageController = PageController(initialPage: _page);
  }

  void _onTap(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _onPageChanged(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        onPageChanged: _onPageChanged,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 40),
            child: const CameraScreen(),
          ),
          Container(
            margin: const EdgeInsets.only(top: 40),
            child: const ConnectionScreen(),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        selectedItemColor: Theme.of(context).colorScheme.primary,
        unselectedItemColor: Colors.grey,
        currentIndex: _page,
        onTap: _onTap,
        items: const [
          BottomNavigationBarItem(
            label: "Camera",
            icon: Icon(Icons.camera_alt),
          ),
          BottomNavigationBarItem(
            label: "Connection",
            icon: Icon(Icons.connected_tv_rounded),
          ),
        ],
      ),
    );
  }
}
