import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:meta/meta.dart';

Future<Database> getDB() async {
  return openDatabase(
    join(await getDatabasesPath(), 'doggie_database.db'),
    onCreate: (db, version) {
      return db.execute(
        '''
          CREATE TABLE memo(
            id INTEGER PRIMARY KEY, 
            title TEXT, 
            body TEXT
          )
        ''',
      );
    },
    version: 1,
  );
}

class Memo {
  int id;
  String title;
  String body;

  Memo({
    int id,
    @required String title,
    @required String body,
  }) {
    this.id = id;
    this.title = title;
    this.body = body;
  }

  Map<String, dynamic> toMap() {
    return {'id': id, 'title': title, 'body': body};
  }
}

class MemoDB {
  Future<Database> _db;

  MemoDB() {
    _db = getDB();
  }

  Future<void> addMemo(Memo memo) async {
    final db = await _db;
    await db.insert('memo', memo.toMap());
  }

  Future<List<Memo>> getMemos() async {
    final db = await _db;
    final maps = await db.query('memo');
    return List.generate(
      maps.length,
      (index) => Memo(
        id: maps[index]['id'],
        body: maps[index]['body'],
        title: maps[index]['title'],
      ),
    );
  }

  Future<Memo> getOne(int id) async {
    final db = await _db;
    final maps = await db.query(
      'memo',
      where: 'id = ?',
      whereArgs: [id],
      limit: 1,
    );

    return Memo(
      id: maps[0]['id'],
      body: maps[0]['body'],
      title: maps[0]['title'],
    );
  }

  Future<void> edit(id, Memo newMemo) async {
    final db = await _db;
    newMemo.id = id;
    await db.update(
      'memo',
      newMemo.toMap(),
      where: 'id = ?',
      whereArgs: [id],
    );
  }

  Future<void> delete(id) async {
    final db = await _db;
    await db.delete('memo', where: 'id = ?', whereArgs: [id]);
  }
}
