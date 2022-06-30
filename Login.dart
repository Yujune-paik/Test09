/*******************************************************
 *** File name      : W2_2MyHomePage
 *** Version        : V1.0
 *** Designer       : 二宮淑霞
 *** Purpose        : ホームページ2_2
 *******************************************************/
/*
*** Revision
 */
import 'package:coriander/Test09/W2-2MyHomePage.dart';
import 'package:coriander/Test09/W4_Completed.dart';
import 'package:coriander/W6-1_MyPage.dart';
import 'package:flutter/material.dart';
import 'W2-1_MyHomePage.dart';
import 'dart:async';
import 'package:mysql1/mysql1.dart';
import 'package:mysql_utils/mysql_utils.dart';




//ホーム画面(提出済)
class Login {
  //データベースの情報
  var settings = new ConnectionSettings(
      host: '160.16.141.77',
      port: 50900,
      user: 'app09',
      db: 'App_db',
      password: 'pracb2022');


  //学籍番号とパスワードが一致していれば”1”を返す。
  Future check(String StudentNum, String PassWord) async {
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

    var results = await db.getAll(
      table: 'StudentInfo',
      fields: 'PassWord',
      where: {'StudentNum': '$StudentNum'},
    );


    results = results.toString().replaceAll("PassWord :", "") as List;

    print(results);
    if(results == PassWord)
      return await 1;
    // var result = await conn.query(
    //     "INSERT INTO StudentInfo (StudentNum, PassWord, CourseId) VALUES ('$studentNum', '$passWord', '$courseId')");


    await conn.close();
    await db.close();
  }
}

void main(){
  print("start");
  dynamic a;
  a = Login().check("al21821","pass");
  print(a);

}

