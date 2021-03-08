import 'dart:async';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:weather_app/model/city.dart';

Future<List<City>> getCitiesByLetters(String letters) async {
  final db = await getDb();

  final List<Map<String, dynamic>> maps = await db.query('city',
      columns: ['id', 'name', 'state', 'country', 'lat', 'lon'],
      where: 'name LIKE ?',
      whereArgs: ['$letters%']);

  return List.generate(maps.length, (i) {
    return City(
      id: maps[i]['id'],
      name: maps[i]['name'],
      state: maps[i]['state'],
      country: maps[i]['country'],
      lat: maps[i]['lat'],
      lon: maps[i]['lon'],
    );
  });
}

Future<Database> getDb() async {
  var databasesPath = await (getDatabasesPath() as FutureOr<String>);
  var path = join(databasesPath, "cities.db");

// Check if the database exists
  var exists = await databaseExists(path);

  if (!exists) {
    // Should happen only the first time you launch your application
    print("Creating new copy from asset");

    // Make sure the parent directory exists
    try {
      await Directory(dirname(path)).create(recursive: true);
    } catch (_) {}

    // Copy from asset
    ByteData data = await rootBundle.load(join("db", "weather_cities_db.db"));
    List<int> bytes =
        data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);

    // Write and flush the bytes written
    await File(path).writeAsBytes(bytes, flush: true);
  } else {
    print("Opening existing database");
  }
// open the database
  return await openDatabase(path, readOnly: true);
}
