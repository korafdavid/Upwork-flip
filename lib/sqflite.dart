import 'package:flip/models.dart';
import 'package:flutter/animation.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'dart:io';
import 'package:sqflite/sqflite.dart';

//intent
//616331981658.
class DatabaseHelper {
  static const _databaseName = 'ContactData.db';
  static const _databaseVersion = 1;

  // DatabaseHelper._();
  static final DatabaseHelper instance = DatabaseHelper();

  Database? _database;

  Future<Database> get database async => _database ?? await _initDatabase();

  _initDatabase() async {
    Directory dataDirectory = await getApplicationDocumentsDirectory();
    String dbPath = join(dataDirectory.path, _databaseName);
    return await openDatabase(dbPath,
        version: _databaseVersion, onCreate: _onCreateDB);
  }

  _onCreateDB(Database db, int verson) async {
    await db.execute('''
          CREATE TABLE ${COINUNIT.tblContact}(
          ${COINUNIT.colId} INTEGER PRIMARY KEY AUTOINCREMENT,
          ${COINUNIT.colValue} TEXT NOT NULL
          )
    ''');
  }

  //insert function
  Future<int> insertCoinUnit(COINUNIT contact) async {
    Database db = await database;
    return await db.insert(COINUNIT.tblContact, contact.toMap());
  }



  Future<int> deleteCoinUnit(int id) async {
    Database db = await database;
    return await db.delete(COINUNIT.tblContact,
        where: '${COINUNIT.colId} = ?', whereArgs: [id]);
  }

  Future clearCoinUnit() async {
    Database db = await database;
    return await db.delete(COINUNIT.tblContact);
  }

  Stream<int> calculateTotal() async* {
    Database db = await database;
    var result = await db.query(
      COINUNIT.tblContact,
    );
    yield result.length;
  }

  Stream<int> calculateTotalHead() async* {
    Database db = await database;
    Set newSet = {};
    var result = await db.query(COINUNIT.tblContact);
    for (Map<String, dynamic> item in result) {
      item.forEach((key, value) {
        if (value.toString().contains('H') == true) {
          newSet.add(item);
        }
      });
    }
    yield newSet.length;
  }

  Future<int> totalHead() async {
    Database db = await database;
    Set newSet = {};
    var result = await db.query(COINUNIT.tblContact);
    for (Map<String, dynamic> item in result) {
      item.forEach((key, value) {
        if (value.toString().contains('H') == true) {
          newSet.add(item);
        }
      });
    }
    return newSet.length;
  }

  Stream<int> calculateTotalTail() async* {
    Database db = await database;
    Set newSet = {};
    var result = await db.query(COINUNIT.tblContact);
    for (Map<String, dynamic> item in result) {
      item.forEach((key, value) {
        if (value.toString().contains('T') == true) {
          newSet.add(item);
        }
      });
    }
    yield newSet.length;
  }

  Future<int> totalTail() async {
    Database db = await database;
    Set newSet = {};
    var result = await db.query(COINUNIT.tblContact);
    for (Map<String, dynamic> item in result) {
   item.forEach((key, value) {
        if (value.toString().contains('T') == true) {
          newSet.add(item);
        }
      });
    }
    return newSet.length;
  }

  Future<List<COINUNIT>> fetchCoinUnit() async {
    Database db = await database;
    List<Map<String, dynamic>> contacts = await db.query(COINUNIT.tblContact);
    return contacts.isEmpty
        ? []
        : contacts.map((e) => COINUNIT.fromMap(e)).toList();
  }
}
