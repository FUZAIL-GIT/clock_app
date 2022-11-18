import 'dart:async';

import 'package:sqflite/sqflite.dart';

import 'logger.dart';

class LocalDatabase {
  static Database? db;
  static const int version = 1;
  static const String tableName = 'alarm_info';
  static Future<Database?> initDb() async {
    if (db != null) {
      return db;
    }
    if (db == null) {
      try {
        String path = '${await getDatabasesPath()}alarm_info.db';
        db = await openDatabase(path, version: version,
            onCreate: (Database db, int version) async {
          talker.info("Local DataBase created At : $db");
          // When creating the db, create the table
          await db.execute("""
            CREATE TABLE $tableName (
              id INTEGER PRIMARY KEY AUTOINCREMENT, 
              alarmDateTime STRING , 
              alarmLabel STRING , 
              isActive INTEGER  ,
              alarmId INTEGER  ,
              isVibrate INTEGER ,
              isOnce INTEGER ,
              isMon INTEGER ,
              isTue INTEGER ,
              isWed INTEGER ,
              isThu INTEGER ,
              isFri INTEGER ,
              isSat INTEGER ,
              isSun INTEGER 
              )
              """);
        });
      } catch (e) {
        talker.error(e);
      }
    } else {
      talker.error("DataBase already Created");
    }
    return null;
  }
}
