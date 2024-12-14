import 'dart:convert';

import 'item_model.dart';
import '../constants/db_constants.dart';

class StoryModel {
  /// The story's unique id.
  final int id;

  /// The title of the story in HTML.
  final String title;

  /// The text of the story (shown in discussions) in HTML.
  final String text;

  /// The username of the story's author.
  final String by;

  /// The date and time created, in Unix Time.
  final DateTime created;

  /// The story's score, or the votes for a pollopt.
  final int score;

  /// The total comment count.
  final int descendants;

  /// The ids of the comments, in ranked display order.
  final List<int> kids;

  /// The URL of the story.
  final String url;

  StoryModel({
    required this.id,
    required this.title,
    required this.text,
    required this.by,
    required this.created,
    required this.score,
    required this.descendants,
    required this.kids,
    required this.url,
  });

  StoryModel.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson['id'] as int,
        title = parsedJson['title'] as String,
        text = parsedJson['text'] as String? ?? '',
        by = parsedJson['by'] as String,
        created = DateTime.fromMillisecondsSinceEpoch(
          parsedJson['time'] as int,
        ),
        score = parsedJson['score'] as int,
        descendants = parsedJson['descendants'] as int? ?? 0,
        kids = List<int>.from(parsedJson['kids'] ?? []),
        url = parsedJson['url'] as String? ?? '' {
    assert(parsedJson['type'] == 'story');
  }

  StoryModel.fromItemModel(ItemModel item)
      : id = item.id,
        title = item.title,
        text = item.text,
        by = item.by,
        created = item.time,
        score = item.score!,
        descendants = item.descendants ?? 0,
        kids = item.kids ?? [],
        url = item.url;

  /// Get [StoryModel] from [Map] given by database.
  StoryModel.fromMap(Map<String, dynamic> map)
      : id = map[columnId] as int,
        title = map[columnTitle] as String,
        text = map[columnText] as String,
        by = map[columnBy] as String,
        created = DateTime.fromMillisecondsSinceEpoch(
          map[columnCreated] as int,
        ),
        score = map[columnScore] as int,
        descendants = map[columnDescendants] as int,
        kids = List<int>.from(jsonDecode(map[columnKids])),
        url = map[columnUrl]! as String;

  /// Transform [StoryModel] to [Map] for database.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      columnId: id,
      columnTitle: title,
      columnText: text,
      columnBy: by,
      columnScore: score,
      columnDescendants: descendants,
      columnKids: jsonEncode(kids),
      columnUrl: url,
      columnCreated: created.millisecondsSinceEpoch,
    };
  }
}
