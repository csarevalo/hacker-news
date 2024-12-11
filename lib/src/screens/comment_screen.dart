import 'package:flutter/material.dart';
import 'package:hacker_news/src/models/story_model.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';

class CommentScreen extends StatelessWidget {
  const CommentScreen({
    super.key,
    required this.story,
  });
  final StoryModel story;

  @override
  Widget build(BuildContext context) {
    // debugPrint('(story id): story.id.toString()');
    return Scaffold(
      appBar: AppBar(
        title: const Text('Hacker News'),
      ),
      body: ListView.builder(
        itemCount: story.kids.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            if (story.text.isEmpty) {
              return story.kids.isEmpty
                  ? const Center(child: Text('No comments'))
                  : const SizedBox.shrink();
            }
            return Column(
              children: [
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: HtmlWidget(story.text),
                  ),
                ),
                story.kids.isEmpty
                    ? const Center(child: Text('No comments'))
                    : const SizedBox.shrink()
              ],
            );
          }
          return Card(
            child: ExpansionTile(
              initiallyExpanded: true,
              title: HtmlWidget('Comment: ${story.kids[index - 1]}'),
            ),
          );
          // return FutureBuilder(future: future, builder: builder)
        },
      ),
    );
  }
}
