import 'dart:convert';

import 'repository.dart' show Source;
import 'package:http/http.dart' show Client;

import '../models/item_model.dart';
import '../models/comment_model.dart';
import '../models/story_model.dart';

const _apiBaseUrl = 'https://hacker-news.firebaseio.com/v0';

/// Network Handler for Hacker News Api.
class NewsApi implements Source {
  final Client _client;

  NewsApi({Client? client}) : _client = client ?? Client();

  /// Set [Source] id for comparisons.
  @override
  String id = 'hacker_news_api';

  /// Fetch the ids of the Top Stories.
  @override
  Future<List<int>> fetchTopStoryIds() async {
    final response = await _client.get(
      Uri.parse('$_apiBaseUrl/topstories.json'),
    );
    if (response.statusCode != 200) {
      throw Exception(
        'Failed Hacker News API request with status code ${response.statusCode}',
      );
    }
    final ids = json.decode(response.body);
    return ids.cast<int>();
  }

  /// Fetch Item from Hacker [NewsApi].
  Future<ItemModel> fetchItem(int id) async {
    final response = await _client.get(Uri.parse('$_apiBaseUrl/item/$id.json'));
    if (response.statusCode != 200) {
      throw Exception(
        'Failed Hacker News API request with status code ${response.statusCode}',
      );
    }
    final parsedJson = json.decode(response.body);
    return ItemModel.fromJson(parsedJson);
  }

  /// Fetch a story from Hacker [NewsApi].
  @override
  Future<StoryModel?> fetchStory(int id) async {
    final response = await _client.get(Uri.parse('$_apiBaseUrl/item/$id.json'));
    if (response.statusCode != 200) {
      throw Exception(
        'Failed Hacker News API request with status code ${response.statusCode}',
      );
    }
    final parsedJson = json.decode(response.body);
    if (parsedJson['type']! == 'story') return StoryModel.fromJson(parsedJson);
    return null;
  }

  /// Fetch a story from  Hacker [NewsApi].
  @override
  Future<CommentModel> fetchComment(int id) async {
    final response = await _client.get(Uri.parse('$_apiBaseUrl/item/$id.json'));
    if (response.statusCode != 200) {
      throw Exception(
        'Failed Hacker News API request with status code ${response.statusCode}',
      );
    }
    final parsedJson = json.decode(response.body);
    return CommentModel.fromJson(parsedJson);
  }
}
