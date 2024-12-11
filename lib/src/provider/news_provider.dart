import 'package:flutter/material.dart';
import 'package:hacker_news/src/service/repository.dart';

class NewsProvider extends ChangeNotifier {
  late final Repository _repository;

  NewsProvider({Repository? repository}) {
    _repository = repository ?? Repository();
  }

  /// Initialize [NewsProvider]...
  Future<void> init() async {
    await _repository.init();
  }

  /// Get top story ids.
  Future<List<int>> get topStoryIds => _getTopStoryIds();

  /// Gets top story ids from [Repository] repo.
  Future<List<int>> _getTopStoryIds() async {
    return await _repository.fetchTopStoryIds();
  }

  /// Get story from id.
  Future<StoryModel?> getStory(int id) async {
    return await _repository.fetchStory(id);
  }
}
