import 'package:flutter_test/flutter_test.dart';
import 'package:hacker_news/src/models/comment_model.dart';
import 'package:hacker_news/src/models/story_model.dart';
import 'package:hacker_news/src/service/sqflite_db.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

void main() {
  group('SqfliteDb', () {
    setUpAll(() {
      // Initialize FFI
      sqfliteFfiInit();
      // Change the default factory for unit testing calls for SQFlite
      databaseFactory = databaseFactoryFfi;
    });
    test('Simple sqflite test', () async {
      var db = await openDatabase(inMemoryDatabasePath, version: 1,
          onCreate: (db, version) async {
        await db
            .execute('CREATE TABLE Test (id INTEGER PRIMARY KEY, value TEXT)');
      });
      // Insert some data
      await db.insert('Test', {'value': 'my_value'});
      // Check content
      expect(await db.query('Test'), [
        {'id': 1, 'value': 'my_value'}
      ]);

      await db.close();
    });
    test(
      'Open/close sqflite database.',
      () async {
        const String mockPath = inMemoryDatabasePath;
        final sqlDb = SqfliteDb();
        await sqlDb.open(mockPath);
        await sqlDb.close();
      },
    );

    test(
      'Add/fetch comment to/from sqflite database.',
      () async {
        const String mockPath = inMemoryDatabasePath;
        CommentModel sampleComment = CommentModel(
          id: 1,
          text: 'text',
          by: 'Tester',
          created: DateTime.now(),
          parent: 123,
          kids: [124, 125],
        );
        final sqlDb = SqfliteDb();
        await sqlDb.open(mockPath);
        // await sqlDb.clear(); //DO NOT USE unless intended
        await sqlDb.addComment(sampleComment);
        var comment = await sqlDb.fetchComment(sampleComment.id);
        expect(comment.id, sampleComment.id);
        expect(comment.text, sampleComment.text);
        expect(comment.by, sampleComment.by);
        expect(
          comment.created,
          DateTime.fromMillisecondsSinceEpoch(
            sampleComment.created.millisecondsSinceEpoch,
          ),
        );
        expect(comment.parent, sampleComment.parent);
        expect(comment.kids, sampleComment.kids);
        await sqlDb.close();
      },
    );

    test(
      'Add/fetch story to/from sqflite database.',
      () async {
        const String mockPath = inMemoryDatabasePath;
        StoryModel sampleStory = StoryModel(
          id: 1,
          title: 'Fake Title',
          by: 'Fake Author',
          created: DateTime.now(),
          score: 100,
          descendants: 2,
          kids: [123, 1245],
          url: 'https://fakeurl.com',
        );
        final sqlDb = SqfliteDb();
        await sqlDb.open(mockPath);
        // await sqlDb.clear(); //DO NOT USE unless intended
        await sqlDb.addStory(sampleStory);
        var story = await sqlDb.fetchStory(sampleStory.id);
        expect(story.id, sampleStory.id);
        expect(story.title, sampleStory.title);
        expect(story.by, sampleStory.by);
        expect(story.score, sampleStory.score);
        expect(
          story.created,
          DateTime.fromMillisecondsSinceEpoch(
            sampleStory.created.millisecondsSinceEpoch,
          ),
        );
        expect(story.descendants, sampleStory.descendants);
        expect(story.kids, sampleStory.kids);
        expect(story.url, sampleStory.url);
        await sqlDb.close();
      },
    );
  });
}
