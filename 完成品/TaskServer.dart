/******************************************************************
 ***  File Name		: TaskServer.dart
 ***  Version		: V1.0
 ***  Designer		: 中田 裕紀
 ***  Date			: 2022.07.01
 ***  Purpose       	: 課題情報をデータベース;から引き出す + 課題完了者の追加・削除を行う
 ***
 *******************************************************************/
/*
*** Revision :
*** V1.0 : 中田裕紀, 2022.07.01
*** V1.1 : 二宮淑霞, 2022.07.02
*/

import 'dart:async';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart';
import 'package:mysql1/mysql1.dart';
import 'package:mysql_utils/mysql_utils.dart';
import 'Task_database.dart';
import 'Task_database_model.dart';

class TaskServer {
  //データベースの情報
  var settings = new ConnectionSettings(
      host: '160.16.141.77',
      port: 50900,
      user: 'app09',
      db: 'App_db',
      password: 'pracb2022');

  //課題完了者を追加
  Future<void> addWhoCompleted(String taskId, String studentNum) async {
    // データベースに接続
    final conn = await MySqlConnection.connect(settings);

    var db = MysqlUtils(
        settings: {
          'host': '160.16.141.77',
          'port': 50900,
          'user': 'app09',
          'password': 'pracb2022',
          'db': 'App_db',
          'maxConnections': 10,
          'secure': false,
          'prefix': '',
          'pool': true,
          'collation': 'utf8mb4_general_ci',
        },
        errorLog: (error) {
          print(error);
        },
        sqlLog: (sql) {
          print(sql);
        },
        connectInit: (db1) async {
          print('whenComplete');
        });

    // 課題情報を引き出す
    var taskInfo = await db.query(
        'SELECT TaskName, DeadLine, CourseId FROM App_db.TaskInfo where TaskId = ("$taskId")');

    for (var Info in taskInfo.rowsAssoc) {
      String taskName = Info.colAt(0);
      String deadLine = Info.colAt(1);
      String courseId = Info.colAt(2);

      // 課題完了者をデータベースに追加する
      var tasks = await conn.query(
          "INSERT INTO TaskInfo VALUES ('$taskId', '$taskName', '$deadLine', '$courseId', '$studentNum')");
      break;
    }

    // データベースを閉じる
    await conn.close();
    await db.close();
  }

  // From. Changed 二宮淑霞 2022.07.01
  // 課題完了者のリストを取ってくる
  Future<List> completeList(String Taskid) async {
    var db = MysqlUtils(
        settings: {
          'host': '160.16.141.77',
          'port': 50900,
          'user': 'app09',
          'password': 'pracb2022',
          'db': 'App_db',
          'maxConnections': 10,
          'secure': false,
          'prefix': '',
          'pool': true,
          'collation': 'utf8mb4_general_ci',
        },
        errorLog: (error) {
          print(error);
        },
        sqlLog: (sql) {
          print(sql);
        },
        connectInit: (db1) async {
          print('whenComplete');
        });

    List results = [];
    //完了者の抽出
    var CplStudents = await db.query(
        'SELECT CplStudent FROM App_db.TaskInfo where TaskId = ("$Taskid")');

    //
    for (var CplStudent in CplStudents.rowsAssoc) {
      results.add(CplStudent);

    }

    await db.close();

    return Future.value(results);
  }
  //To. Changed 二宮淑霞 2022.07.01

  //課題完了者を削除する
  Future<void> deleteWhoCompleted(String taskId, String studentNum) async {
    // データベースに接続
    final conn = await MySqlConnection.connect(settings);

    var db = MysqlUtils(
        settings: {
          'host': '160.16.141.77',
          'port': 50900,
          'user': 'app09',
          'password': 'pracb2022',
          'db': 'App_db',
          'maxConnections': 10,
          'secure': false,
          'prefix': '',
          'pool': true,
          'collation': 'utf8mb4_general_ci',
        },
        errorLog: (error) {
          print(error);
        },
        sqlLog: (sql) {
          print(sql);
        },
        connectInit: (db1) async {
          print('whenComplete');
        });

    // 課題情報を引き出す
    var taskInfo = await db.query(
        'SELECT TaskName, DeadLine, CourseId FROM App_db.TaskInfo where TaskId = ("$taskId")');

    for (var Info in taskInfo.rowsAssoc) {
      String taskName = Info.colAt(0);
      String deadLine = Info.colAt(1);
      String courseId = Info.colAt(2);

      // 課題完了者をデータベースに追加する
      var tasks = await conn.query(
          "DELETE FROM TaskInfo WHERE TaskId = ('$taskId') AND CplStudent = ('$studentNum')");
      break;
    }

    // データベースを切断する
    await conn.close();
    await db.close();
  }

// 履修している科目の内、選択した1つの科目の課題を全て取り出す
  Future<List> readTask(String courseId, String studentNum) async {
    var db = MysqlUtils(
        settings: {
          'host': '160.16.141.77',
          'port': 50900,
          'user': 'app09',
          'password': 'pracb2022',
          'db': 'App_db',
          'maxConnections': 10,
          'secure': false,
          'prefix': '',
          'pool': true,
          'collation': 'utf8mb4_general_ci',
        },
        errorLog: (error) {
          print(error);
        },
        sqlLog: (sql) {
          print(sql);
        },
        connectInit: (db1) async {
          print('whenComplete');
        });
    List results = [];

    //課題情報を[課題Id, 課題名, 科目名, 科目id, 締切]というリストの形で抽出し、resultsに追加
    var tasks = await db.query(
        'SELECT DISTINCT TaskId, TaskName, Deadline FROM App_db.TaskInfo where CourseId = ("$courseId")');

    //From. Changed 二宮淑霞 2022.07.01
    //ローカルデータベースに追加する
    dynamic course = await db.query(
        'SELECT DISTINCT CourseName FROM App_db.CourseInfo where CourseId = ("$courseId")');
    String courseName = course;


    // 課題の名前を取得する
    for (var task in tasks.rowsAssoc) {
      final savertask = Task(
        isCompleted: false, //完了済みor未完了
        isPrivate: task.colAt(0),//課題ID
        taskname: task.colAt(1), //課題名
        subject: courseName,//科目名
        sbId: courseId, //科目id
        deadline: DateTime.parse(task.colAt(2)),//締め切り
      );

      results.add([task.colAt(0), task.colAt(1), courseName, courseId, task.colAt(2)]);
      await TaskDatabase.instance.addTaskForServer(savertask);
    }

    //To. Changed 二宮淑霞 2022.07.01

    await db.close();

    return Future.value(results);
  }

// 履修している科目の課題を全て取り出す
  Future<void> readAllTask(String studentNum) async {
    var db = MysqlUtils(
        settings: {
          'host': '160.16.141.77',
          'port': 50900,
          'user': 'app09',
          'password': 'pracb2022',
          'db': 'App_db',
          'maxConnections': 10,
          'secure': false,
          'prefix': '',
          'pool': true,
          'collation': 'utf8mb4_general_ci',
        },
        errorLog: (error) {
          print(error);
        },
        sqlLog: (sql) {
          print(sql);
        },
        connectInit: (db1) async {
          print('whenComplete');
        });
    List results = [];
    String listcourse="";
    //科目IDの抽出
    var courseIds = await db.query(
        'SELECT CourseId FROM App_db.StudentInfo where StudentNum = ("$studentNum")');

    //課題情報を[課題Id, 課題名, 締切]というリストの形で抽出し、resultsに追加
    for (var course in courseIds.rowsAssoc) {
      String courseId = course.colAt(0);
      var tasks = await db.query(
          'SELECT DISTINCT TaskId, TaskName, Deadline FROM App_db.TaskInfo where CourseId = ("$courseId")');


      //From. Changed 二宮淑霞 2022.07.01
      //ローカルデータベースに追加する
      dynamic coursename = await db.query(
          'SELECT DISTINCT CourseName FROM App_db.CourseInfo where CourseId = ("$courseId")');
      for (var coursename in coursename.rowsAssoc) {
        String courseName = coursename.colAt(0);
        listcourse = courseName;

      }

   // 課題の名前を取得する
      for (var task in tasks.rowsAssoc) {
        final servertask = Task(
          isCompleted: false, //完了済みor未完了
          isPrivate: task.colAt(0) as String,//課題ID
          taskname: task.colAt(1) as String, //課題名
          subject: listcourse as String,//科目名
          sbId: courseId as String, //科目id
          deadline: DateTime.parse(task.colAt(2)),//締め切り
        );

        /*
        print(servertask.isCompleted);
        print(servertask.isPrivate);
        print(servertask.taskname);
        print(servertask.subject);
        print(servertask.sbId);
        print(servertask.deadline);
        print("");*/
        //results.add([task.colAt(0), task.colAt(1), listcourse, courseId, task.colAt(2)]);
        await TaskDatabase.instance.addTaskForServer(servertask);
      }
    }

    //To. Changed 二宮淑霞 2022.07.01
    await db.close();

  }
}

// こんな感じにしてFuture<List>型を<List>に変えてください
//  Future<List> _futureOfList = TaskServer().readAllTask("al21821");
//// List results = await _futureOfList;
