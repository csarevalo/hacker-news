import 'dart:io' show Directory;

import 'package:flutter/foundation.dart' show kIsWeb, debugPrint;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p show join;

import 'news_api.dart';
import 'sqflite_db.dart';
import '../models/comment_model.dart';
import '../models/story_model.dart';
export '../models/comment_model.dart';
export '../models/story_model.dart';

class Repository implements Source, Cache {
  final SqfliteDb _sqfliteDb = SqfliteDb();
  final NewsApi _newsApi = NewsApi();
  final List<Source> sources = [];
  final List<Cache> caches = [];

  @override
  String id = 'repo';

  /// Initialize [Repository].
  Future<void> init() async {
    _addSources();
    _addCaches();
    String path = '';
    if (!kIsWeb) {
      final Directory dir = await getApplicationCacheDirectory();
      path = dir.path;
    }
    path = p.join(path, 'Hacker News', 'demo.db');
    debugPrint('[sqflite_db] path: $path');
    await open(path);
  }

  /// Add [Source]s to [Repository].
  void _addSources() {
    sources.add(_sqfliteDb);
    sources.add(_newsApi);
  }

  /// Add [Cache]s to [Repository].
  void _addCaches() {
    caches.add(_sqfliteDb);
  }

  /// Fetch top story ids from the first available [Source].
  @override
  Future<List<int>> fetchTopStoryIds() async {
    for (var source in sources) {
      List<int> topIds = await source.fetchTopStoryIds();
      if (topIds.isNotEmpty) return topIds;
    }
    return [];
  }

  /// Fetch story from the first available [Cache].
  @override
  Future<StoryModel?> fetchStory(int id) async {
    StoryModel? story;
    String usedSourceId = '';
    for (var source in sources) {
      story = await source.fetchStory(id);
      usedSourceId = source.id;
      if (story != null) break;
    }
    if (story == null) return null;
    if (usedSourceId.isEmpty) {
      throw Exception('Failed to determine source of story.');
    }

    for (var cache in caches) {
      if (cache.id != usedSourceId) {
        cache.addStory(story);
      }
    }
    return story;
  }

  /// Fetch comment from the first available [Cache].
  @override
  Future<CommentModel?> fetchComment(int id) async {
    CommentModel? comment;
    String usedSourceId = '';
    for (var source in sources) {
      comment = await source.fetchComment(id);
      usedSourceId = source.id;
      if (comment != null) break;
    }
    if (comment == null) return null;
    if (usedSourceId.isEmpty) {
      throw Exception('Failed to determine source of comment.');
    }
    for (var cache in caches) {
      if (cache.id != usedSourceId) {
        cache.addComment(comment);
      }
    }
    return comment;
  }

  /// Add comment to all [Cache]s.
  @override
  Future<void> addComment(CommentModel comment) async {
    for (var cache in caches) {
      cache.addComment(comment);
    }
  }

  /// Add story to all [Cache]s.
  @override
  Future<void> addStory(StoryModel story) async {
    for (var cache in caches) {
      cache.addStory(story);
    }
  }

  /// Open [Repository] by opening all caches.
  @override
  Future<void> open(String path) async {
    for (var cache in caches) {
      await cache.open(path);
    }
  }

  /// Close [Repository] by closing all caches.
  @override
  Future<void> close() async {
    for (var cache in caches) {
      await cache.close();
    }
  }

  /// Clear [Repository] by clearing data from [Cache]s.
  @override
  Future<void> clear() async {
    for (var cache in caches) {
      await cache.clear();
    }
  }
}

abstract class Cache {
  late final String id;
  Future<void> addStory(StoryModel story);
  Future<void> addComment(CommentModel comment);
  Future<void> open(String path);
  Future<void> close();
  Future<void> clear();
}

abstract class Source {
  late final String id;
  Future<List<int>> fetchTopStoryIds();
  Future<StoryModel?> fetchStory(int id);
  Future<CommentModel?> fetchComment(int id);
}
