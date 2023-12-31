import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:json_theme/json_theme.dart';
import 'package:lg_face/presentation/help/help_screen.dart';
import 'package:lg_face/presentation/home/home_screen.dart';
import 'package:lg_face/presentation/settings/settings_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final themeStr = await rootBundle.loadString('assets/appainter_theme.json');
  final themeJson = jsonDecode(themeStr);
  final theme = ThemeDecoder.decodeThemeData(themeJson)!;

  runApp(MyApp(theme: theme));
}

class MyApp extends StatelessWidget {
  final ThemeData theme;

  const MyApp({required this.theme, super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'LG Face',
      theme: theme,
      scrollBehavior: ScrollConfiguration.of(context).copyWith(scrollbars: false),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomeScreen(),
        SettingsScreen.route: (context) => const SettingsScreen(),
        HelpScreen.route: (context) => const HelpScreen(),
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(builder: (context) => const HomeScreen());
      },
    );
  }
}
