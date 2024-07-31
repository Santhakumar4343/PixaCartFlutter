// database.dart

// required package imports
import 'dart:async';
import 'package:floor/floor.dart';

import 'package:sqflite/sqflite.dart' as sqflite;

import 'DaoAccess.dart';
import 'ListEntity.dart';


part 'AppDatabase.g.dart';

@Database(version: 1, entities: [ListEntity])
abstract class AppDatabase extends FloorDatabase {
  DaoAccess get daoaccess;
}