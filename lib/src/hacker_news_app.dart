import 'package:flutter/material.dart';
import 'package:hacker_news/src/screens/test_repo_screen.dart';

class HackerNewsApp extends StatelessWidget {
  const HackerNewsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hacker News',
      theme: ThemeData.dark(),
      home: const TestRepoScreen(),
    );
  }
}
