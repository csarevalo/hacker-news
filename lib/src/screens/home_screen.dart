import 'package:flutter/material.dart';
import 'package:hacker_news/src/widgets/stories_builder.dart';
import 'package:provider/provider.dart';

import '../provider/news_provider.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final newsProvider = Provider.of<NewsProvider>(context, listen: false);
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Hacker News'),
        ),
        body: FutureBuilder<List<int>>(
          future: newsProvider.topStoryIds,
          builder: (BuildContext context, AsyncSnapshot<List<int>> snapshot) {
            if (snapshot.hasError) {
              return Center(child: Text(snapshot.error.toString()));
            }
            if (snapshot.hasData) {
              return StoriesBuilder(storiesIds: snapshot.data!);
            }
            return const Center(
              child: CircularProgressIndicator.adaptive(),
            );
          },
        ),
      ),
    );
  }
}
