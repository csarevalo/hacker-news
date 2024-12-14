import 'package:flutter/material.dart';

import '../models/story_model.dart';
import '../screens/comment_screen.dart';

class StoryTile extends StatelessWidget {
  const StoryTile({
    super.key,
    required this.story,
  });

  final StoryModel story;

  @override
  Widget build(BuildContext context) {
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
          '${story.score} Points by ${story.by} | ${story.descendants} Comments',
        ),
      ),
    );
  }
}
