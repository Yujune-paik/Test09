/******************************************************************
 ***  File Name		: SubjectServer.dart
 ***  Version		: V1.0
 ***  Designer		: 中田 裕紀
 ***  Date			: 2022.07.01
 ***  Purpose       	: 科目情報をデータベースから引き出す
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

class SubjectServer {
  //科目情報を引き出す
  Future<List> readSubject(String courseId) async {
    // データベースと接続
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

    //select文
    var row = await db
        .query('SELECT * FROM App_db.CourseInfo where CourseId = ("$courseId")');

  //返すリスト
    List results = [];

    // 課題情報を[科目名, 教員名, 曜日, 時限]の形でListにまとめて、resultsに追加する
    for (var info in row.rowsAssoc) {
      String courseId = info.colAt(0);
      String courseName = info.colAt(1);
      String teacher = info.colAt(2);
      String day = info.colAt(3);
      String period = info.colAt(4);
      results.add([courseName, teacher, day, period]);
    }

// データベースを閉じる
    await db.close();
    return Future.value(results);
  }
}

// テスト用のmain関数
// void main() async {
//   Future<List> _futureOfList =
//       SubjectServer().readSubject("202201SU0140521001");
//   List results = await _futureOfList;
//   results.forEach((result) => print(result));
// }
