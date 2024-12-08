import 'dart:convert';
import 'item_model.dart';

class CommentModel {
  /// The comment's unique id.
  final int id;

  /// The comment text html.-
  final String text;

  /// The username of the comment's author.
  final String by;

  /// The date and time created, in Unix Time.
  final DateTime created;

  /// The comment's parent: either another comment or the relevant story.
  final int parent;

  /// The ids of the subcomments, in ranked display order.
  final List<int> kids;

  CommentModel({
    required this.id,
    required this.text,
    required this.by,
    required this.created,
    required this.parent,
    required this.kids,
  });

  CommentModel.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson['id'] as int,
        text = parsedJson['text'] as String,
        by = parsedJson['by'] as String,
        created = DateTime.fromMillisecondsSinceEpoch(
          (parsedJson['time'] as int),
        ),
        parent = parsedJson['parent'] as int,
        kids = List<int>.from(parsedJson['kids']);

  CommentModel.fromItemModel(ItemModel item)
      : id = item.id,
        text = item.text,
        by = item.by,
        created = item.time,
        parent = item.parent!,
        kids = item.kids;

  CommentModel.fromMap(Map<String, dynamic> map)
      : id = map['_id'] as int,
        text = map['text'] as String,
        by = map['by'] as String,
        created = DateTime.fromMillisecondsSinceEpoch((map['created'] as int)),
        parent = map['parent'] as int,
        kids = List<int>.from(jsonDecode((map['kids'])));

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      "_id": id,
      "text": text,
      "by": by,
      "parent": parent,
      "kids": jsonEncode(kids),
      "created": created.millisecondsSinceEpoch,
    };
  }
}
