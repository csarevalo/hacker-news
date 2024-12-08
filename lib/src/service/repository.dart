import 'dart:io';

import 'package:flutter/foundation.dart' show debugPrint, kIsWeb;
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p show join;

import '../models/comment_model.dart';
import '../models/story_model.dart';

class Repository implements Source, Cache {
  final List<Source> sources = [];
  final List<Cache> caches = [];

  @override
  String id = 'repo';

  /// Initialize [Repository].
  Future<void> init() async {
    String path;
    if (kIsWeb) {
      path = ''; // set internally by [Cache] when kIsWeb is true.
    } else {
      final Directory dir = await getApplicationDocumentsDirectory();
      path = p.join(dir.path, 'Hacker News', 'demo.db');
    }
    await open(path);
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
  Future<StoryModel> fetchStory(int id) async {
    late final StoryModel story;
    late String usedSourceId;
    for (var source in sources) {
      try {
        story = await source.fetchStory(id);
        usedSourceId = source.id;
        break;
      } catch (e) {
        debugPrint(e.toString());
      }
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
  Future<CommentModel> fetchComment(int id) async {
    late final CommentModel comment;
    late String usedSourceId;
    for (var source in sources) {
      try {
        comment = await source.fetchComment(id);
        usedSourceId = source.id;
        break;
      } catch (e) {
        debugPrint(e.toString());
      }
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
  Future<StoryModel> fetchStory(int id);
  Future<CommentModel> fetchComment(int id);
}
