import 'dart:convert';
import 'item_model.dart';

class StoryModel {
  /// The story's unique id.
  final int id;

  /// The title of the story, poll or job. HTML.
  final String title;

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
        by = parsedJson['by'] as String,
        created = DateTime.fromMillisecondsSinceEpoch(
          (parsedJson['time'] as int),
        ),
        score = parsedJson['score'] as int,
        descendants = parsedJson['descendants'] as int,
        kids = List<int>.from(parsedJson['kids']),
        url = parsedJson['url'] as String;

  StoryModel.fromItemModel(ItemModel item)
      : id = item.id,
        title = item.title,
        by = item.by,
        created = item.time,
        score = item.score!,
        descendants = item.descendants!,
        kids = item.kids,
        url = item.url;

  StoryModel.fromMap(Map<String, dynamic> map)
      : id = map['_id'] as int,
        title = map['title'] as String,
        by = map['by'] as String,
        created = DateTime.fromMillisecondsSinceEpoch((map['created'] as int)),
        score = map['score'] as int,
        descendants = map['descendants'] as int,
        kids = List<int>.from(jsonDecode(map['kids'])),
        url = map['url'] as String;

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "_id": id,
      "title": title,
      "by": by,
      "score": score,
      "descendants": descendants,
      "kids": jsonEncode(kids),
      "url": url,
      "created": created.millisecondsSinceEpoch,
    };
  }
}
