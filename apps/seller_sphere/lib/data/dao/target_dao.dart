import 'package:sqflite/sqflite.dart';

import '../database/app_database.dart';
import '../models/models.dart';

abstract class TargetDao {
  Future<SalesTarget?> getTodayTarget();

  Stream<SalesTarget?> getTargetForDate(String dateString);

  Future<void> insertTarget(SalesTarget target);

  Stream<List<SalesTarget>> getAllTargets();
}

class TargetDaoImpl implements TargetDao {
  final AppDatabase _appDatabase;

  TargetDaoImpl(this._appDatabase);

  @override
  Future<SalesTarget?> getTodayTarget() async {
    final db = await _appDatabase.database;
    final String today = DateTime.now().toIso8601String().substring(0, 10);
    final List<Map<String, dynamic>> maps = await db.query(
      AppDatabase.tableSalesTargets,
      where: '${AppDatabase.columnTargetDate} = ?',
      whereArgs: [today],
    );

    if (maps.isNotEmpty) {
      return SalesTarget.fromMap(maps.first);
    }
    return null;
  }

  @override
  Stream<SalesTarget?> getTargetForDate(String dateString) async* {
    final db = await _appDatabase.database;
    final List<Map<String, dynamic>> maps = await db.query(
      AppDatabase.tableSalesTargets,
      where: '${AppDatabase.columnTargetDate} = ?',
      whereArgs: [dateString],
    );

    if (maps.isNotEmpty) {
      yield SalesTarget.fromMap(maps.first);
    } else {
      yield null;
    }
  }

  @override
  Future<void> insertTarget(SalesTarget target) async {
    final db = await _appDatabase.database;
    await db.insert(
      AppDatabase.tableSalesTargets,
      target.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  @override
  Stream<List<SalesTarget>> getAllTargets() async* {
    final db = await _appDatabase.database;
    final List<Map<String, dynamic>> maps = await db.query(AppDatabase.tableSalesTargets);
    yield List.generate(maps.length, (i) {
      return SalesTarget.fromMap(maps[i]);
    });
  }
}
