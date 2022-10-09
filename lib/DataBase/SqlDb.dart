import 'package:sqflite/sqflite.dart';

import 'package:path/path.dart';

class SqlDb {
  static Database _db;

  Future<Database> get db async {
    if (_db == null) {
      _db = await initialDb();
      return _db;
    } else {
      return _db;
    }
  }

  initialDb() async {
    String databasePath = await getDatabasesPath();
    String path = join(databasePath, 'barbells.db');
    Database mydb = await openDatabase(path,
        onCreate: _onCreate, version: 1, onUpgrade: _onUpgrade);
    return mydb;
  }

  _onUpgrade(Database db, int oldversion, int newVersion) {
    print("onUpgrade=======================");
  }

  //creates the tabels
  _onCreate(Database db, int version) async {
    //Member Table
    await db.execute('''
    CREATE TABLE "Members" (
      "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      "clubId" TEXT,
      "staffId" TEXT,
      "name" TEXT,
      "email" TEXT,
      "phone" TEXT,
      "countryCode" TEXT,
      "gender" TEXT,
      "birthYear" TEXT,
      "canAuthenticate" INTEGER,
      "QRCodeURL" TEXT,
      "QRCodeUUID" TEXT,
      "isBlocked" INTEGER,
      "createdAt" TEXT,
      "sync" INTEGER,
      "operation" TEXT
    )
    
    ''');
//Packages Table
    await db.execute('''
    CREATE TABLE "Packages" (
      "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      "clubId" TEXT,
      "title" TEXT,
      "attendance" INTEGER,
      "expiresIn" TEXT,
      "price" INTEGER,
      "isOpen" INTEGER,
      "createdAt" TEXT,
      "sync" INTEGER,
      "operation" TEXT
    )
    
    ''');

    //Registrations Table
    await db.execute('''
    CREATE TABLE "Registrations" (
      "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      "clubId" TEXT,
      "memberId" TEXT,
      "staffId" TEXT,
      "packageId" TEXT,
      "isActive" INTEGER,
      "attended" INTEGER,
      "expiresAt" TEXT,
      "paid" INTEGER,
      "isFreezed" INTEGER,
      "createdAt" TEXT,
      "sync" INTEGER,
      "operation" TEXT
    )
    
    ''');

    //Cancelled Registrations Table
    await db.execute('''
    CREATE TABLE "CancelledRegistrations" (
      "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
      "clubId" TEXT,
      "memberId" TEXT,
      "staffId" TEXT,
      "packageId" TEXT,
      "attended" INTEGER,
      "expiresAt" TEXT,
      "paid" INTEGER,
      "registrationDate" TEXT,
      "createdAt" TEXT,
      "sync" INTEGER,
      "operation" TEXT
    )
    
    ''');

    print("onCreate ================================");
  }

  readData(String sql) async {
    Database mydb = await db;

    List<Map> response = await mydb.rawQuery(sql);
    return response;
  }

  insertData(String sql) async {
    Database mydb = await db;

    int response = await mydb.rawInsert(sql);
    return response;
  }

  updateData(String sql) async {
    Database mydb = await db;

    int response = await mydb.rawUpdate(sql);
    return response;
  }

  deleteData(String sql) async {
    Database mydb = await db;

    int response = await mydb.rawDelete(sql);
    return response;
  }
}
