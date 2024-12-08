import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
import 'package:sqflite/sqflite.dart';

import '../models/comment_model.dart';
import '../models/story_model.dart';
import 'repository.dart' show Source, Cache;

//------------TABLE STORIES------------
const String _tableStories = 'stories';
//------------------
//---Story Schema---
//------------------
const String _columnId = '_id';
const String _columnTitle = 'title';
const String _columnBy = 'by';
const String _columnScore = 'score';
const String _columnDescendants = 'descendants';
const String _columnKids = 'kids';
const String _columnUrl = 'url';
const String _columnCreated = 'created'; //time

//------------TABLE COMMENTS------------
const String _tableComments = 'comments';
//--------------------
//---Comment Schema---
//--------------------
// const String _columnId = '_id';
const String _columnText = 'text';
// const String _columnBy = 'by';
const String _columnParent = 'parent';
// const String _columnKids = 'kids';
// const String _columnCreated = 'created'; //time

class SqfliteDb implements Source, Cache {
  final DatabaseFactory? dbFactory;
  late final Database _db;

  SqfliteDb({this.dbFactory}) {
    if (dbFactory != null) databaseFactory = dbFactory;
  }

  /// Set [Source]/[Cache] id for comparisons.
  @override
  String id = 'sqflite_db';

  /// Open [SqfliteDb], or create a new db if it does not exist.
  @override
  Future<void> open(String path) async {
    if (kIsWeb) {
      // Change default factory on the web
      databaseFactory = databaseFactoryFfiWeb;
      path = 'hacker_news_web_cache.db';
    }
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        db.transaction((txn) async {
          // Create table for stories
          await txn.execute('''
          CREATE TABLE $_tableStories 
            (
              $_columnId INTEGER PRIMARY KEY,
              $_columnTitle TEXT NOT NULL,
              $_columnBy TEXT NOT NULL,
              $_columnScore INTEGER NOT NULL,
              $_columnDescendants INTEGER NOT NULL,
              $_columnKids BLOB NOT NULL,
              $_columnUrl TEXT NOT NULL,
              $_columnCreated INTEGER NOT NULL
            )
          ''');
          // Create table for comments
          await txn.execute('''
          CREATE TABLE $_tableComments
            (
              $_columnId INTEGER PRIMARY KEY,
              $_columnText TEXT NOT NULL,
              $_columnBy TEXT NOT NULL,
              $_columnParent INTEGER NOT NULL,
              $_columnKids BLOB NOT NULL,
              $_columnCreated INTEGER NOT NULL
            )
          ''');
        });
      },
    );
  }

  /// Close [SqfliteDb].
  @override
  Future<void> close() async => await _db.close();

  /// Fetch top story ids from [SqfliteDb].
  @override
  Future<List<int>> fetchTopStoryIds() async {
    return [];
  }

  /// Fetch a story from [SqfliteDb]'s Stories Table.
  /// Throws an exception if the story is not found.
  @override
  Future<StoryModel> fetchStory(int id) async {
    List<Map> maps = await _db.query(_tableStories,
        columns: [
          _columnId,
          _columnTitle,
          _columnBy,
          _columnScore,
          _columnDescendants,
          _columnKids,
          _columnUrl,
          _columnCreated,
        ],
        where: '$_columnId = ?',
        whereArgs: [id]);

    if (maps.isNotEmpty) {
      return StoryModel.fromMap(maps.first as Map<String, dynamic>);
    }
    throw Exception('(sqflit_db) Story not found.');
  }

  /// Add a story to [SqfliteDb]'s Stories Table
  @override
  Future<void> addStory(StoryModel story) async {
    await _db.insert(_tableStories, story.toMap());
  }

  /// Fetch a comment from [SqfliteDb]'s Comments Table.
  /// Throws an exception if the comment is not found.
  @override
  Future<CommentModel> fetchComment(int id) async {
    List<Map> maps = await _db.query(_tableComments,
        columns: [
          _columnId,
          _columnText,
          _columnBy,
          _columnParent,
          _columnKids,
          _columnCreated,
        ],
        where: '$_columnId = ?',
        whereArgs: [id]);

    if (maps.isNotEmpty) {
      return CommentModel.fromMap(maps.first as Map<String, dynamic>);
    }
    throw Exception('(sqflit_db) Comment not found.');
  }

  /// Add a comment to [SqfliteDb]'s Comments Table.
  @override
  Future<void> addComment(CommentModel comment) async {
    await _db.insert(_tableComments, comment.toMap());
  }

  /// Clear [SqfliteDb] by deleting all tables.
  @override
  Future<void> clear() async {
    await _db.transaction((txn) async {
      await txn.delete(_tableStories);
      await txn.delete(_tableComments);
    });
  }
}
