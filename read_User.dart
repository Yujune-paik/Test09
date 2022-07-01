/*******************************************************************
 ***  File Name		: read_User.dart
 ***  Version		: V1.0
 ***  Designer		: 栗田　遥生
 ***  Date			: 2022.06.18
 ***  Purpose       	: サーバにユーザ情報を要求し、ユーザ情報を返す
 ***
 *******************************************************************/
import 'LogInPage.dart';
import 'my_page.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:mysql_utils/mysql_utils.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';



class read_User {
  Future readuser() async {
//学籍番号を読み取る
    final SharedPreferences student = await SharedPreferences.getInstance();
    String studentNum = student.getString('number') ?? '';

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

    var row = await db.getAll(
      table: 'StudentInfo',
      fields: '*',
      where:"StudentNum='$studentNum'",
    );


    List result = deleteColum(
        'StudentNum', deleteColum('PassWord', deleteColum('CourseId', row)));
    await db.close();
    return result;
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
}


