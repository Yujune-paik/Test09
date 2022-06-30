/******************************************************************
 ***  File Name		: TaskServer.dart
 ***  Version		: V1.0
 ***  Designer		: 中田 裕紀
 ***  Date			: 2022.07.01
 ***  Purpose       	: 課題情報をデータベースから引き出す + 課題完了者の追加・削除を行う
 ***
 *******************************************************************/
/*
*** Revision :
*** V1.0 : 中田裕紀, 2022.07.01
*/

import 'dart:async';
import 'package:http/http.dart';
import 'package:mysql1/mysql1.dart';
import 'package:mysql_utils/mysql_utils.dart';

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

    //課題情報を[課題Id, 課題名, 締切]というリストの形で抽出し、resultsに追加
    var tasks = await db.query(
        'SELECT DISTINCT TaskName, Deadline, TaskId FROM App_db.TaskInfo where CourseId = ("$courseId")');

// 課題の名前を取得する
    for (var task in tasks.rowsAssoc) {
      String taskName = task.colAt(0);
      String deadline = task.colAt(1);
      String taskId = task.colAt(2);
      results.add([taskId, taskName, deadline]);      
    }

      await db.close();

    return Future.value(results);
  }

// 履修している科目の課題を全て取り出す
  Future<List> readAllTask(String studentNum) async {
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

    //科目IDの抽出
    var courseIds = await db.query(
        'SELECT CourseId FROM App_db.StudentInfo where StudentNum = ("$studentNum")');

    //課題情報を[課題Id, 課題名, 締切]というリストの形で抽出し、resultsに追加
    for (var course in courseIds.rowsAssoc) {
      String courseId = course.colAt(0);
      var tasks = await db.query(
          'SELECT DISTINCT TaskName, Deadline, TaskId FROM App_db.TaskInfo where CourseId = ("$courseId")');

// 課題の名前を取得する
      for (var task in tasks.rowsAssoc) {
        String taskName = task.colAt(0);
        String deadline = task.colAt(1);
        String taskId = task.colAt(2);
        results.add([taskId, taskName, deadline]);
      }
    }

    await db.close();

    return Future.value(results);
  }
}

// こんな感じにしてFuture<List>型を<List>に変えてください
//  Future<List> _futureOfList = TaskServer().readAllTask("al21821");
//// List results = await _futureOfList;

// void main() async {

// // // addWhoCompletedテスト用
// //   TaskServer().addWhoCompleted("T2E0S2T23", "al20005");

// // // deleteWhoCompletedテスト用
// //   TaskServer().deleteWhoCompleted("T2E0S2T23", "al20005");

// // // readAllTaskテスト用
//     // Future<List> _futureOfList = TaskServer().readAllTask("al21821");
//     // List results = await _futureOfList;
//     // results.forEach((result) => print(result));

// // // // readTaskテスト用
// //     Future<List> _futureOfList = TaskServer().readTask("202201SU0054321001", "al21821");
// //     List results = await _futureOfList;
// //     results.forEach((result) => print(result));
// }
