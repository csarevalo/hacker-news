import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/news_provider.dart';
import '../widgets/stories_builder.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Hacker News'),
        ),
        body: const StoriesList(),
        floatingActionButton: FloatingActionButton(
          onPressed: () => context.read<NewsProvider>().refresh(),
          child: const Icon(Icons.refresh),
        ),
      ),
    );
  }
}

class StoriesList extends StatelessWidget {
  const StoriesList({super.key});

  @override
  Widget build(BuildContext context) {
    try {
      return Selector<NewsProvider, List<int>>(
        selector: (_, p) => List.unmodifiable(p.topStoryIds),
        builder: (_, List<int> storyIds, __) {
          if (storyIds.isEmpty) {
            // context.read<NewsProvider>().updateTopStoryIds();
            return const Center(child: CircularProgressIndicator.adaptive());
          }
          return StoriesBuilder(ids: storyIds);
        },
      );
    } catch (e) {
      debugPrint(e.toString());
      return Center(child: Text(e.toString()));
    }
  }
}
