/*******************************************************************
 ***  File Name		: Task_database.dart
 ***  Version		: V1.2
 ***  Designer		: 千手　香穂
 ***  Date			: 2022.06.14
 ***  Purpose       	: データベースへの処理（書込・削除等）を記述する
 ***
 *******************************************************************/
/*
*** Revision :
*** V1.0 : 千手香穂, 2022/06/14
*** V1.1 : 千手香穂, 2022/06/14 _createDBにsbIdを追加
*** V1.2 : 千手香穂, 2022/06/20 deleteExpiredTask()を更新
*/

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'Task_database_model.dart';
import 'package:intl/intl.dart';

class TaskDatabase {
  static final TaskDatabase instance = TaskDatabase._init();
  static Database? _database;
  TaskDatabase._init();
  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('tasks.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);
    return await openDatabase(
        path,
        version: 1,
        onCreate: _createDB
    );
  }

  Future _createDB(Database db, int version) async {
    const String idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const String textType = 'TEXT NOT NULL';
    const String boolType = 'BOOLEAN NOT NULL';
    const String integerType = 'INTEGER NOT NULL';

    await db.execute('''
    CREATE TABLE $tableTasks ( 
    ${TaskFields.id} $idType, 
    ${TaskFields.isCompleted} $boolType,
    ${TaskFields.isPrivate} $integerType,
    ${TaskFields.taskname} $textType,
    ${TaskFields.subject} $textType,
    ${TaskFields.sbId} $textType,
    ${TaskFields.deadline} $textType
    )
    ''');
  }

  //引数として与えられたデータを新規タスクとしてDBに追加する
  Future addTask(Task task) async {
    /*引数はオブジェクト引数にした方がわかりやすい？どうかな
        引数を(int isPrivate, String task, String subject, String sbId, String deadline)にするなら
        try {
            Datetime deadline = DateFormat('y/MM/dd HH:mm').parseStrict(deadline);
        } catch(e){
            throw Exception('deadline: invalid value');
        }
        //できればdeadlineはStringではなくDateTime型でほしい
        //（tryの処理を書かなくて済むので）
        final task = Task(
            isCompleted: false,
            isPrivate: isPrivate,
            //自作タスクの場合ここには-1を入れる
            //サーバからとってきたタスクならサーバ上DBでのidを入れるのでどうだろう
            taskname: taskname,
            subject: subject,
            sbId: sbId,
            deadline: deadline,
        );*/
    final db = await instance.database;
    await db.insert(tableTasks, task.toJson());
  }

  //引数として与えられたidのデータをDBから読みだす
  Future<Task> readTask(int id) async {
    final db = await instance.database;
    final maps = await db.query(
      tableTasks,
      columns: TaskFields.values,
      where: '${TaskFields.id} = ?',
      whereArgs: [id],
    );
    if (maps.isNotEmpty) {
      return Task.fromJson(maps.first);
    } else {
      throw Exception('ID $id not found');
    }
  }

  //すべてのデータをDBから読みだす
  Future<List<Task>> readAllTask() async {
    final db = await instance.database;
    const orderBy = '${TaskFields.deadline} ASC';
    final result = await db.query(
        tableTasks,
        orderBy: orderBy
    );
    return result.map((json) => Task.fromJson(json)).toList();
  }

  //引数として与えられたデータに紐づくデータを編集する
  Future<int> editTask(Task task) async {
    /*
        引数を(int id, bool isCompleted, int isPrivate, String task, String subject, String sbId, String deadline)にするなら
        try {
            Datetime deadline = DateFormat('y/MM/dd HH:mm').parseStrict(deadline);
        } catch(e){
            throw Exception('deadline: invalid value');
        }
        final task = Task(
            id: id,
            isCompleted: isCompleted,
            isPrivate: isPrivate,
            taskname: taskname,
            subject: subject,
            sbId: sbId,
            deadline: deadline,
        );*/
    final db = await instance.database;
    return db.update(
      tableTasks,
      task.toJson(),
      where: '${TaskFields.id} = ?',
      whereArgs: [task.id],
      //↑idを引数で渡してくるならtask.idではなくidと書く
    );
  }

  //引数として与えられたidに紐づくデータのステータスを完了済みする
  Future<int> completeTask(int id) async {
    final db = await instance.database;
    return db.rawUpdate(
        'UPDATE $tableTasks '
            'SET isCompleted = 1 '
            'WHERE ${TaskFields.id} = $id'
    );
  }

  //引数として与えられたidに紐づくデータをDBから削除する
  Future<int> deleteTask(int id) async {
    final db = await instance.database;
    return await db.delete(
      tableTasks,
      where: '${TaskFields.id} = ?',
      whereArgs: [id],
    );
  }

  //期限が切れた課題をDBから削除する
  //時間ではなく日付単位で参照している臭いがどうしていいかわからなかったため保留
  Future deleteExpiredTask() async {
    final db = await instance.database;
    final now = DateFormat('yyyy-MM-dd HH:mm:s').format(DateTime.now());
    await db.delete(
      tableTasks,
      where: '${TaskFields.deadline} <= ?',
      whereArgs: [now],
    );
  }

  //DBを閉じる
  Future closeDatabase() async {
    final db = await instance.database;
    db.close();
  }
}