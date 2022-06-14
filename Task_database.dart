/*******************************************************************
***  File Name		: Task_database.dart
***  Version		: V1.0
***  Designer		: 千手　香穂
***  Date			: 2022.06.14
***  Purpose       	: データベースへの処理（書込・削除等）を記述する
***
*******************************************************************/
/*
*** Revision :
*** V1.0 : 千手香穂, 2022/06/14
*/

import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:task_database_model.dart';

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

        return await openDatabase(path, version: 1, onCreate: _createDB);
    }

    Future _createDB(Database db, int version) async {
        final idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
        final textType = 'TEXT NOT NULL';
        final boolType = 'BOOLEAN NOT NULL';
        final integerType = 'INTEGER NOT NULL';

        await db.execute('''
    CREATE TABLE $tableTasks ( 
    ${TaskFields.id} $idType, 
    ${TaskFields.isCompleted} $boolType,
    ${TaskFields.isPrivate} $integerType,
    ${TaskFields.task} $textType,
    ${TaskFields.subject} $textType,
    ${TaskFields.time} $textType
    )
    ''');
    }

    //引数として与えられたデータを新規タスクとしてDBに追加する
    Future<Task> add_Task(Task task) async {
        /*引数はオブジェクト引数にした方がわかりやすい？どうかな
        引数を(int isPrivate, String task, String subject, String deadline)にするなら
        try {
            Datetime time = DateFormat('y/MM/dd HH:mm').parseStrict(deadline);
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
            task: task,   
            subject: subject,  
            deadline: time, 
        );*/
        final db = await instance.database;
        final id = await db.insert(tableTasks, task.toJson());
        return task.copy(id: id);
    }

    //引数として与えられたidのデータをDBから読みだす
    Future<Task> read_Task(int id) async {
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
    Future<List<Task>> read_AllTask() async {
        final db = await instance.database;
        final orderBy = '${TaskFields.time} ASC';
        final result = await db.query(tableTasks, orderBy: orderBy);
        return result.map((json) => Task.fromJson(json)).toList();
    }

    //引数として与えられたデータに紐づくデータを編集する
    Future<int> edit_Task(Task task) async {
        /*
        引数を(int id, bool isCompleted, int isPrivate, String task, String subject, String deadline)にするなら
        try {
            Datetime time = DateFormat('y/MM/dd HH:mm').parseStrict(deadline);
        } catch(e){
            throw Exception('deadline: invalid value');
        }
        final task = Task(
            id: id, 
            isCompleted: isCompleted, 
            isPrivate: isPrivate,  
            task: task,   
            subject: subject,  
            deadline: time, 
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
    //以下あってるかわからん
    Future<int> complete_Task(int id) async {
        final db = await instance.database;
        return db.rawUpdate(
            'UPDATE $tableTasks SET isCompleted = 1 WHERE ${TaskFields.id} = $id'
        ); 
    }

    //引数として与えられたidに紐づくデータをDBから削除する
    Future<int> delete_Task(int id) async {
        final db = await instance.database;
        return await db.delete(
            tableTasks,
            where: '${TaskFields.id} = ?',
            whereArgs: [id],
        );
    }

    //期限が切れた課題をDBから削除する
    /*未完。delete_Task使うとかして表示側の処理で何とかなりませんか
    Future<int> delete_ExpiredTask() async {
        final db = await instance.database;
        //以下あってるかわからん
        DateTime now = DateTime.now();
        /*return await db.rawDelete(
            'DELETE FROM $tableTasks 
            WHERE time = ?',
            ['another name']
        );*/
        return await db.delete(
            tableTasks,
            where: '${TaskFields.time} = ?',
            whereArgs: [id],
        );
    }*/

    //DBを閉じる
    Future close_Database() async {
        final db = await instance.database;
        db.close();
    }
}
