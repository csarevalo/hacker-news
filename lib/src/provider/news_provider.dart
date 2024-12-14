import 'package:flutter/material.dart';

import '../service/repository.dart';

class NewsProvider extends ChangeNotifier {
  late final Repository _repository;

  NewsProvider({Repository? repository}) {
    _repository = repository ?? Repository();
  }

  DateTime _lastUpdatedTopStoryIds = DateTime.fromMicrosecondsSinceEpoch(0);

  /// Store top story ids within provider to rebuild widgets
  List<int> _topStoryIds = [];

  /// Get top story ids.
  List<int> get topStoryIds => _topStoryIds;

  /// Store top stories within provider to rebuild widgets
  List<StoryModel> _topStories = [];

  /// Get top stories.
  List<StoryModel> get topStories => List.from(_topStories);

  /// Initialize [NewsProvider]...
  Future<void> init() async {
    await _repository.init();
    refresh();
  }

  /// Gets top story ids from [Repository] repo.
  /// Top story ids are only update if its been over five minutes
  /// since the last update.
  Future<void> updateTopStoryIds() async {
    if (DateTime.now().difference(_lastUpdatedTopStoryIds).inMinutes >= 5) {
      _topStoryIds = await _repository.fetchTopStoryIds();
      _lastUpdatedTopStoryIds = DateTime.now();
      notifyListeners();
    }
  }

  /// Store comments within provider to rebuild widgets
  List<CommentModel> _comments = [];

  /// Get comments
  List<CommentModel> get comments => List.from(_comments);

  /// Get story from id.
  Future<StoryModel?> getStory(int id) async {
    return await _repository.fetchStory(id);
  }

  /// Get comment from id.
  Future<void> getCommentWithSubComments(int id) async {
    _comments = [];
    _getCommentWithSubComments(id);
    // notifyListeners();
  }

  Future<void> _getCommentWithSubComments(int id) async {
    _repository.fetchComment(id).then((c) {
      if (c == null) return;
      _comments.add(c);
      notifyListeners();
      if (c.kids.isEmpty) return;
      for (int kidId in c.kids) {
        _getCommentWithSubComments(kidId);
      }
    });
  }

  Future<void> refresh() async {
    await _repository.clear();
    _topStoryIds = await _repository.fetchTopStoryIds();
    notifyListeners();
  }
}
