import 'package:flutter/material.dart';
import 'package:hacker_news/src/screens/comment_screen.dart';
import 'package:provider/provider.dart';

import '../provider/news_provider.dart';

class StoriesBuilder extends StatelessWidget {
  const StoriesBuilder({
    super.key,
    required this.storiesIds,
  });

  final List<int> storiesIds;

  @override
  Widget build(BuildContext context) {
    final newsProvider = context.read<NewsProvider>();
    return ListView.builder(
      itemCount: storiesIds.length,
      itemBuilder: (BuildContext context, int index) {
        return FutureBuilder(
          future: newsProvider.getStory(storiesIds[index]),
          builder: (context, snapshot2) {
            // debugPrint(snapshot2.connectionState.name);
            if (snapshot2.hasError) {
              Center(child: Text(snapshot2.error.toString()));
            }
            if (snapshot2.hasData) {
              var story = snapshot2.data!;
              return Card(
                child: ListTile(
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => CommentScreen(story: story),
                      ),
                    );
                  },
                  title: Text(story.title),
                  subtitle: Text(
                    '${snapshot2.data!.score} Points by ${story.by} | ${story.descendants} Comments',
                  ),
                ),
              );
            }
            if (snapshot2.connectionState.name == 'done') {
              //don't show empty/null "stories," bc they aren't stories.
              return const SizedBox.shrink();
            }
            return Card(
              child: ListTile(
                title: Text('Loading... ${storiesIds[index]}'),
                subtitle: const LinearProgressIndicator(),
              ),
            );
          },
        );
      },
    );
  }
}
