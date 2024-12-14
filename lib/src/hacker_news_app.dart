import 'package:flutter/material.dart';

import 'screens/home_screen.dart';
// import 'screens/test_repo_screen.dart';

class HackerNewsApp extends StatelessWidget {
  const HackerNewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Hacker News',
      theme: ThemeData.dark(),
      home: const HomeScreen(),
      // home: const TestRepoScreen(),
    );
  }
}
