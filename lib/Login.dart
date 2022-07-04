/*******************************************************
 *** File name      : W2_2MyHomePage
 *** Version        : V1.0
 *** Designer       : 二宮淑霞
 *** Purpose        : ホームページ2_2
 *******************************************************/
/*
*** Revision:
*** V1.1 : 栗田遥生, 2022.07.02
 */

import 'package:flutter/material.dart';

import 'dart:async';
import 'package:mysql1/mysql1.dart';
import 'package:mysql_utils/mysql_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';



//ホーム画面(提出済)
class Login {
  //データベースの情報
  var settings = new ConnectionSettings(
      host: '160.16.141.77',
      port: 50900,
      user: 'app09',
      db: 'App_db',
      password: 'pracb2022');

  //List flag = [];

  //学籍番号とパスワードが一致していれば”1”を返す。
  Future <int> check(String StudentNum, String PassWord) async {
    final conn = await MySqlConnection.connect(settings);
    SharedPreferences.setMockInitialValues({});
    final SharedPreferences student = await SharedPreferences.getInstance();
    student.setString('number', StudentNum);

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

    var results = await db.getAll(
      table: 'StudentInfo',
      fields: 'PassWord',
      where: {'StudentNum': '$StudentNum'},
    );

    //From. Changed 栗田遥生 2022.07.02
    List result1=deleteColum('PassWord', results);
    var result2=result1.join(',');
    result2 = result2.replaceAll("{", "");
    result2 = result2.replaceAll("}", "");

//From. Changed 栗田遥生 2022.07.02
    if(result2 == PassWord){
      return  Future<int>.value(1);}
    // var result = await conn.query(
    //     "INSERT INTO StudentInfo (StudentNum, PassWord, CourseId) VALUES ('$studentNum', '$passWord', '$courseId')");
    else {
      return Future<int>.value(0);
    }

    await conn.close();
    await db.close();
  }

}



List deleteColum(String columName, List before) {
  String space = ": ";
  String colum = "${columName}${space}";
  List newResults = [];
  for (int i = 0; i < before.length; i++) {
    newResults.add(before[i].toString().replaceAll("$colum", ""));
  }

  return newResults;
}