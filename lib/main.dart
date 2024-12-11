import 'package:flutter/material.dart';
import 'package:hacker_news/src/provider/news_provider.dart';
import 'src/hacker_news_app.dart';
import 'package:provider/provider.dart';

main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final NewsProvider newsProvider = NewsProvider();
  await newsProvider.init();
  runApp(
    ChangeNotifierProvider.value(
      value: newsProvider,
      child: const HackerNewsApp(),
    ),
  );
}
