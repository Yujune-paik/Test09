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
import 'package:shared_preferences/shared_preferences.dart';

class Login {
  //科目情報を引き出す
  var settings = new ConnectionSettings(
      host: '160.16.141.77',
      port: 50900,
      user: 'app09',
      db: 'App_db',
      password: 'pracb2022');  //データベースの情報

  Future<int> check(String StudentNum, String inputPassWord) async {
    final conn = await MySqlConnection.connect(settings);
    SharedPreferences.setMockInitialValues({});
    final SharedPreferences student = await SharedPreferences.getInstance();
    student.setString('number', StudentNum);
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
    var row = await db.query(
        'SELECT PassWord FROM App_db.StudentInfo where StudentNum = ("$StudentNum")');

    String PassWord = "";

    // PassWordを取得する
    for (var pass in row.rowsAssoc) {
      PassWord = pass.colAt(0);
      break;
    }

// データベースを閉じる
    await db.close();
    if (inputPassWord == PassWord)
      return Future.value(1);
    else
      return Future.value(0);
  }
}

// // テスト用のmain関数
// void main() async {
//   Future<int> _futureOfList = Login().check("al20001", "hage");
//   int result = await _futureOfList;
//   print(result);
// }