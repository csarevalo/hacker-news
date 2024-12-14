import 'package:flutter/material.dart';

import '../service/repository.dart';

class TestRepoScreen extends StatelessWidget {
  const TestRepoScreen({
    super.key,
  });

  void testRepo() async {
    final repo = Repository();
    await repo.init();
    await repo.clear();
    try {
      await fetchComment(repo);
      await fetchStory(repo);
      debugPrint('success');
    } catch (e) {
      debugPrint(e.toString());
    }
    await repo.close();
  }

  Future<void> fetchComment(Repository repo) async {
    final comment = await repo.fetchComment(42351670);
    debugPrint('comment: ${comment!.created.toString()}');

    final fetchedComment = await repo.fetchComment(comment.id);
    debugPrint('comment: ${fetchedComment!.created.toString()}');

    final fetchedTwiceComment = await repo.fetchComment(comment.id);
    debugPrint('comment: ${fetchedTwiceComment!.created.toString()}');
  }

  Future<void> fetchStory(Repository repo) async {
    final story = await repo.fetchStory(42351450);
    debugPrint('story: ${story!.created.toString()}');

    final fetchedStory = await repo.fetchStory(story.id);
    debugPrint('story: ${fetchedStory!.created.toString()}');

    final fetchedTwiceStory = await repo.fetchStory(story.id);
    debugPrint('story: ${fetchedTwiceStory!.created.toString()}');

    debugPrint(story.text);
    debugPrint(fetchedStory.text);
    debugPrint(fetchedTwiceStory.text);
  }

  @override
  Widget build(BuildContext context) {
    testRepo();
    return const Scaffold(
      body: Center(
        child: Text('Review Debug Console'),
      ),
    );
  }
}
