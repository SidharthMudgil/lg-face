import 'dart:async';

import 'package:flutter/material.dart';
import 'package:lg_face/core/constant/constants.dart';

import 'home_screen.dart';

class SplashScreen extends StatefulWidget {
  static const route = "/";

  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    startTimer();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void startTimer() {
    Future.delayed(const Duration(seconds: 4), () {
      Navigator.of(context).pushReplacementNamed(HomeScreen.route);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding:
            const EdgeInsets.only(top: 50.0, bottom: 30, left: 30, right: 30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              lgLogo,
              width: 270,
            ),
            const Text(
              "Flutter KISS Application",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color.fromARGB(255, 159, 202, 255),
                fontWeight: FontWeight.bold,
                fontSize: 30,
              ),
            ),
            const Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "github.com/",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      sidharthGithub,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color.fromARGB(255, 159, 202, 255),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 5,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "github.com/",
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      lgGithub,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: Color.fromARGB(255, 159, 202, 255),
                      ),
                    ),
                  ],
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
