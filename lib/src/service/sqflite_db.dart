import 'dart:io';

import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:sqflite_common_ffi_web/sqflite_ffi_web.dart';
// import 'package:sqflite/sqflite.dart';

import '../constants/db_constants.dart';
import '../models/comment_model.dart';
import '../models/story_model.dart';
import 'repository.dart' show Source, Cache;

class SqfliteDb implements Source, Cache {
  bool isOpen = false;
  late final String _path;
  late final Database _db;

  /// Set [Source]/[Cache] id for comparisons.
  @override
  String id = 'sqflite_db';

  /// Open [SqfliteDb], or create a new db if it does not exist.
  @override
  Future<void> open(String path) async {
    if (isOpen) return;
    _path = path;
    if (kIsWeb) {
      // Change default factory on the web
      databaseFactory = databaseFactoryFfiWeb;
      // path = 'hacker_news_web_cache.db';
    } else if (Platform.isWindows || Platform.isLinux) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfiNoIsolate;
    } else {
      // Default databaseFactor: already set... no change needed
      // databaseFactory = databaseFactorySqflitePlugin;
    }
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        db.transaction((txn) async {
          // Create table for stories
          await txn.execute('''
          CREATE TABLE $tableStories 
            (
              $columnId INTEGER PRIMARY KEY ON CONFLICT REPLACE,
              $columnTitle TEXT NOT NULL,
              $columnText TEXT NOT NULL,
              $columnBy TEXT NOT NULL,
              $columnScore INTEGER NOT NULL,
              $columnDescendants INTEGER NOT NULL,
              $columnKids BLOB NOT NULL,
              $columnUrl TEXT NOT NULL,
              $columnCreated INTEGER NOT NULL
            )
          ''');
          // Create table for comments
          await txn.execute('''
          CREATE TABLE $tableComments
            (
              $columnId INTEGER PRIMARY KEY ON CONFLICT REPLACE,
              $columnText TEXT NOT NULL,
              $columnBy TEXT NOT NULL,
              $columnParent INTEGER NOT NULL,
              $columnKids BLOB NOT NULL,
              $columnCreated INTEGER NOT NULL
            )
          ''');
        });
      },
      onOpen: (db) async {
        db.transaction((txn) async {
          // Create table for stories
          await txn.execute('''
          CREATE TABLE IF NOT EXISTS $tableStories 
            (
              $columnId INTEGER PRIMARY KEY ON CONFLICT REPLACE,
              $columnTitle TEXT NOT NULL,
              $columnText TEXT NOT NULL,
              $columnBy TEXT NOT NULL,
              $columnScore INTEGER NOT NULL,
              $columnDescendants INTEGER NOT NULL,
              $columnKids BLOB NOT NULL,
              $columnUrl TEXT NOT NULL,
              $columnCreated INTEGER NOT NULL
            )
          ''');
          // Create table for comments
          await txn.execute('''
          CREATE TABLE IF NOT EXISTS $tableComments
            (
              $columnId INTEGER PRIMARY KEY ON CONFLICT REPLACE,
              $columnText TEXT NOT NULL,
              $columnBy TEXT NOT NULL,
              $columnParent INTEGER NOT NULL,
              $columnKids BLOB NOT NULL,
              $columnCreated INTEGER NOT NULL
            )
          ''');
        });
      },
    );
    isOpen = true;
  }

  /// Close [SqfliteDb].
  @override
  Future<void> close() async {
    if (!isOpen || !_db.isOpen) return; //already close, do nothing
    await _db.transaction((txn) async {
      await txn.execute('DROP TABLE IF EXISTS $tableStories'); //drops table
      await txn.execute('DROP TABLE IF EXISTS $tableComments'); //drops table
    });
    await _db.close();
    if (!kIsWeb) await databaseFactory.deleteDatabase(_path);
    isOpen = false;
  }

  /// Fetch top story ids from [SqfliteDb].
  @override
  Future<List<int>> fetchTopStoryIds() async {
    return [];
  }

  /// Fetch a story from [SqfliteDb]'s Stories Table.
  /// Throws an exception if the story is not found.
  @override
  Future<StoryModel?> fetchStory(int id) async {
    List<Map> maps = await _db.query(tableStories,
        columns: [
          columnId,
          columnTitle,
          columnText,
          columnBy,
          columnScore,
          columnDescendants,
          columnKids,
          columnUrl,
          columnCreated,
        ],
        where: '$columnId = ?',
        whereArgs: [id]);

    if (maps.isNotEmpty) {
      return StoryModel.fromMap(maps.first as Map<String, dynamic>);
    }
    // throw Exception('(sqflit_db) Story not found.');
    return null;
  }

  /// Add a story to [SqfliteDb]'s Stories Table
  @override
  Future<void> addStory(StoryModel story) async {
    await _db.insert(tableStories, story.toMap());
  }

  /// Fetch a comment from [SqfliteDb]'s Comments Table.
  /// Throws an exception if the comment is not found.
  @override
  Future<CommentModel?> fetchComment(int id) async {
    List<Map> maps = await _db.query(tableComments,
        columns: [
          columnId,
          columnText,
          columnBy,
          columnParent,
          columnKids,
          columnCreated,
        ],
        where: '$columnId = ?',
        whereArgs: [id]);

    if (maps.isNotEmpty) {
      return CommentModel.fromMap(maps.first as Map<String, dynamic>);
    }
    // throw Exception('(sqflit_db) Comment not found.');
    return null;
  }

  /// Add a comment to [SqfliteDb]'s Comments Table.
  @override
  Future<void> addComment(CommentModel comment) async {
    await _db.insert(tableComments, comment.toMap());
  }

  /// Clear [SqfliteDb] by deleting all tables.
  @override
  Future<void> clear() async {
    await _db.transaction((txn) async {
      await txn.delete(tableStories); //clears data by
      await txn.delete(tableComments); //removing all rows
    });
  }
}
