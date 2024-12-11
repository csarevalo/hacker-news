/// Hacker News Api Item Model
class ItemModel {
  /// The item's unique id.
  final int id;

  /// Returns true if the item is deleted.
  // final bool deleted;

  /// The type of item. One of "job", "story", "comment", "poll", or "pollopt".
  final String type;

  /// The username of the item's author.
  final String by;

  /// Creation date of the item, in Unix Time.
  final DateTime time;

  /// The comment, story or poll text. HTML.
  final String text;

  /// true if the item is dead.
  // final bool dead;

  /// The comment's parent: either another comment or the relevant story.
  final int? parent;

  /// The pollopt's associated poll.
  // final int? poll;

  /// The ids of the item's comments, in ranked display order.
  final List<int>? kids;

  /// The URL of the story.
  final String url;

  /// The story's score, or the votes for a pollopt.
  final int? score;

  /// The title of the story, poll or job. HTML.
  final String title;

  /// A list of related pollopts, in display order.
  // final List<int>? parts;

  /// In the case of stories or polls, the total comment count.
  final int? descendants;

  ItemModel({
    required this.id,
    // required this.deleted, //never returned by api
    required this.type,
    required this.by,
    required this.time,
    required this.text,
    // required this.dead, //never returned by api
    required this.parent,
    // required this.poll, //won't use polls
    required this.kids,
    required this.url,
    required this.score,
    required this.title,
    // required this.parts, //won't use polls
    required this.descendants,
  });

  ItemModel.fromJson(Map<String, dynamic> parsedJson)
      : id = parsedJson['id'] as int,
        // deleted = parsedJson['deleted'] as bool? ?? false, //never returned
        type = parsedJson['type'] as String,
        by = parsedJson['by'] as String,
        time = DateTime.fromMicrosecondsSinceEpoch(
          (parsedJson['time'] as int) * 1000,
        ),
        text = parsedJson['text'] ?? '',
        // dead = parsedJson['dead'] as bool? ?? false, //never returned by api
        parent = parsedJson['parent'] as int?,
        // poll = parsedJson['poll'] as int?, //won't use polls
        kids = List<int>.from(parsedJson['kids']),
        url = parsedJson['url'] as String? ?? '',
        score = parsedJson['score'] as int?,
        title = parsedJson['title'] as String? ?? '',
        // parts = parsedJson['parts'], //won't use polls
        descendants = parsedJson['descendants'] as int?;
}
