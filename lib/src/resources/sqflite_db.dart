import 'dart:io';

import 'package:hacker_news/src/models/story_model.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart' as p show join;

import '../models/comment_model.dart';

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

class SqfliteDb {
  late Database _db;

  SqfliteDb() {
    init(); // self init
  }

  void init() async {
    final Directory dir = await getApplicationDocumentsDirectory();
    final String path = p.join(dir.path, 'Hacker News', 'demo.db');
    open(path);
  }

  Future<void> open(String path) async {
    _db = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Create table for stories
        await _db.execute('''
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
        await _db.execute('''
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
      },
    );
  }

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

  Future<void> addStory() async {
    //TODO: missing values...
    // await _db.insert(_tableStories, values)
  }

  Future<CommentModel> fetchComment(int id) async {
    List<Map> maps = await _db.query(_tableStories,
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

  Future<void> addComment() async {
    //TODO: missing values...
    // await _db.insert(_tableStories, values)
  }

  Future<void> close() async {
    await _db.close();
  }
}
