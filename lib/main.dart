import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'src/provider/news_provider.dart';
import 'src/hacker_news_app.dart';

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
