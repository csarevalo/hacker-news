import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:hacker_news/src/service/news_api.dart';
import 'package:http/http.dart';
import 'package:http/testing.dart';

main() {
  group('NewsApi', () {
    test('.fetchTopStoryIds() gets top story ids', () async {
      const sampleTopIds = [
        9129911,
        9129199,
        9127761,
        9128141,
        9128264,
        9127792
      ];
      final mockClient = MockClient((request) async {
        if (request.url.path != "/v0/topstories.json") {
          return Response("", 404);
        }
        return Response(json.encode(sampleTopIds), 200);
      });
      final newsApi = NewsApi(client: mockClient);
      final List<int> topIds = await newsApi.fetchTopStoryIds();
      expect(topIds, sampleTopIds);
    });

    test('.fetchItem(storyId) gets story ItemModel', () async {
      const Map<String, dynamic> sampleStory = {
        "by": "dhouston",
        "descendants": 71,
        "id": 8863,
        "kids": [9224, 8917, 8884, 8887, 8952, 8869, 8873, 8958, 8940, 8908],
        "score": 104,
        "time": 1175714200,
        "title": "My YC app: Dropbox - Throw away your USB drive",
        "type": "story",
        "url": "http://www.getdropbox.com/u/2/screencast.html"
      };
      final mockClient = MockClient((request) async {
        if (request.url.path != "/v0/item/${sampleStory['id']}.json") {
          return Response("", 404);
        }
        return Response(json.encode(sampleStory), 200);
      });
      final newsApi = NewsApi(client: mockClient);
      final itemModel = await newsApi.fetchItem(sampleStory['id'] as int);
      expect(itemModel.id, sampleStory['id'] as int);
    });

    test('.fetchItem(commentId) gets comment ItemModel', () async {
      const Map<String, dynamic> sampleComment = {
        "by": "norvig",
        "id": 2921983,
        "kids": [2922097, 2922429, 2924562, 2922709, 2922573, 2922140, 2922141],
        "parent": 2921506,
        "text": "Aw shucks, guys ... you make me blush with your compliments.",
        "time": 1314211127,
        "type": "comment"
      };
      final mockClient = MockClient((request) async {
        if (request.url.path != "/v0/item/${sampleComment['id']}.json") {
          return Response("", 404);
        }
        return Response(json.encode(sampleComment), 200);
      });
      final newsApi = NewsApi(client: mockClient);
      final itemModel = await newsApi.fetchItem(sampleComment['id'] as int);
      expect(itemModel.id, sampleComment['id'] as int);
    });

    test('.fetchStory gets StoryModel', () async {
      const Map<String, dynamic> sampleStory = {
        "by": "dhouston",
        "descendants": 71,
        "id": 8863,
        "kids": [9224, 8917, 8884, 8887, 8952, 8869, 8873, 8958, 8940, 8908],
        "score": 104,
        "time": 1175714200,
        "title": "My YC app: Dropbox - Throw away your USB drive",
        "type": "story",
        "url": "http://www.getdropbox.com/u/2/screencast.html"
      };
      final mockClient = MockClient((request) async {
        if (request.url.path != "/v0/item/${sampleStory['id']}.json") {
          return Response("", 404);
        }
        return Response(json.encode(sampleStory), 200);
      });
      final newsApi = NewsApi(client: mockClient);
      final storyModel = await newsApi.fetchStory(sampleStory['id'] as int);
      expect(storyModel.id, sampleStory['id'] as int);
    });

    test('.fetchComment gets CommentModel', () async {
      const Map<String, dynamic> sampleComment = {
        "by": "norvig",
        "id": 2921983,
        "kids": [2922097, 2922429, 2924562, 2922709, 2922573, 2922140, 2922141],
        "parent": 2921506,
        "text": "Aw shucks, guys ... you make me blush with your compliments.",
        "time": 1314211127,
        "type": "comment"
      };
      final mockClient = MockClient((request) async {
        if (request.url.path != "/v0/item/${sampleComment['id']}.json") {
          return Response("", 404);
        }
        return Response(json.encode(sampleComment), 200);
      });
      final newsApi = NewsApi(client: mockClient);
      final commentModel =
          await newsApi.fetchComment(sampleComment['id'] as int);
      expect(commentModel.id, sampleComment['id'] as int);
    });
  });
}
