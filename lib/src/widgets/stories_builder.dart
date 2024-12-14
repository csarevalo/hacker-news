import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'story_tile.dart';
import '../provider/news_provider.dart';

class StoriesBuilder extends StatelessWidget {
  const StoriesBuilder({
    super.key,
    required this.ids,
  });

  final List<int> ids;

  @override
  Widget build(BuildContext context) {
    final newsProvider = context.read<NewsProvider>();
    return ListView.builder(
      itemCount: ids.length,
      itemBuilder: (BuildContext context, int index) {
        return FutureBuilder(
          future: newsProvider.getStory(ids[index]),
          builder: (context, snapshot2) {
            // debugPrint(snapshot2.connectionState.name);
            if (snapshot2.hasError) {
              Center(child: Text(snapshot2.error.toString()));
            }
            if (snapshot2.hasData) {
              var story = snapshot2.data!;
              return StoryTile(story: story);
            }
            if (snapshot2.connectionState.name == 'done') {
              //don't show empty or null stories.
              return const SizedBox.shrink();
            }
            return Card(
              child: ListTile(
                title: Text('Loading... ${ids[index]}'),
                subtitle: const LinearProgressIndicator(),
              ),
            );
          },
        );
      },
    );
  }
}
