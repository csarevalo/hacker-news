import 'package:flutter/material.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../models/comment_model.dart';
import '../models/story_model.dart';
import '../provider/news_provider.dart';
import '../widgets/comment_tile.dart';

class CommentScreen extends StatelessWidget {
  const CommentScreen({
    super.key,
    required this.story,
  });
  final StoryModel story;

  @override
  Widget build(BuildContext context) {
    debugPrint('(story id): ${story.id}');
    debugPrint('(story kids count): ${story.descendants}');
    final Widget discussionHeading = Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                HtmlWidget(
                  '${story.title}<br><br>',
                  textStyle: const TextStyle(
                    color: Colors.lightBlue,
                    fontSize: 14.0,
                  ),
                ),
                Row(
                  children: [
                    Text(
                      '> Started by ${story.by} at ${DateFormat.yMd().add_jm().format(story.created)}',
                      style: const TextStyle(color: Colors.amber, fontSize: 12),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        story.text.isEmpty
            ? const SizedBox.shrink()
            : Card(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: HtmlWidget(story.text),
                ),
              ),
      ],
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Discussion'), //: ${story.id}'),
      ),
      body: Selector<NewsProvider, List<CommentModel>>(
          selector: (_, p) {
            final topLevelComments = p.comments;
            topLevelComments.retainWhere((c) => story.kids.contains(c.id));
            return topLevelComments;
          },
          shouldRebuild: (previous, next) {
            debugPrint(
              'prev count: ${previous.length}, next count: ${next.length}',
            );
            //always update... i think i may have needed equatable
            return true;
          },
          builder: (context, List<CommentModel> comments, Widget? heading) {
            if (comments.isEmpty) {
              for (int kidId in story.kids) {
                context.read<NewsProvider>().getCommentWithSubComments(kidId);
              }
              return const Center(child: CircularProgressIndicator.adaptive());
              // return const Center(child: Text('No comments.'));
            }
            return CommentsList(
              comments: comments,
              discussionHeading: heading,
            );
          },
          child: Column(children: [
            discussionHeading,
            story.kids.isEmpty
                ? const Center(child: Text('No comments'))
                : const SizedBox.shrink()
          ])),
    );
  }
}

class CommentsList extends StatelessWidget {
  const CommentsList({
    super.key,
    required this.comments,
    this.discussionHeading,
  });

  final List<CommentModel> comments;
  final Widget? discussionHeading;

  @override
  Widget build(BuildContext context) {
    final allComments = context.read<NewsProvider>().comments;
    return ListView.builder(
      itemCount: comments.length + 1,
      itemBuilder: (context, index) {
        debugPrint('NewsProvider Comment count: ${allComments.length}');
        if (index == 0) {
          if (comments.isEmpty) {
            return discussionHeading ?? const SizedBox.shrink();
          }
          return Column(children: [
            discussionHeading ?? const SizedBox.shrink(),
            comments.isEmpty
                ? const Center(child: Text('No comments'))
                : const SizedBox.shrink()
          ]);
        }
        CommentModel comment = comments[index - 1];
        return CommentTile(
          comment: comment,
          depthLevel: 1,
          children: createSubCommentsTiles(comment.kids,
              fromComments: allComments, depthLevel: 1),
        );
        // return CommentBuilder(id: story.kids[index - 1]);
        // return Comment(id: story.kids[index - 1]);
      },
    );
  }

  List<Widget> createSubCommentsTiles(List<int> subCommentIds,
      {required List<CommentModel> fromComments, required int depthLevel}) {
    if (depthLevel >= 5) {
      return [
        TextButton(
            onPressed: () {},
            child: const Padding(
              padding: EdgeInsets.all(12.0),
              child: Text('too many replies.'),
            ))
      ];
    }
    if (subCommentIds.isEmpty) return [];
    if (fromComments.isEmpty) return [];
    List<CommentTile> commentTiles = [];
    final List<CommentModel> subComments = List.from(fromComments);
    subComments.retainWhere((c) => subCommentIds.any((subId) => subId == c.id));
    for (CommentModel subComment in subComments) {
      commentTiles.add(
        CommentTile(
          comment: subComment,
          depthLevel: depthLevel + 1,
          children: createSubCommentsTiles(
            subComment.kids,
            fromComments: fromComments,
            depthLevel: depthLevel + 1,
          ),
        ),
      );
    }

    return commentTiles;
  }
}
