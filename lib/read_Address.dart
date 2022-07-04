/*******************************************************************
 ***  File Name		: read_User.dart
 ***  Version		: V1.0
 ***  Designer		: 栗田　遥生
 ***  Date			: 2022.06.30
 ***  Purpose       	: サーバにユーザ情報を要求し、ユーザ情報を返す
 ***
 *******************************************************************/
/*
*** Revision:
*** V1.1 : 栗田遥生, 2022.07.02
 */
import 'W1_LoginPage.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:mysql_utils/mysql_utils.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';



class read_Address {
  Future<List> read_address() async {
//学籍番号を読み取る
    final SharedPreferences student = await SharedPreferences.getInstance();
    String studentNum = student.getString('number') ?? '';

List results=[];
//データベースに接続する
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
    //データベースから必要な情報を読み込む

    var row= await db.query(
        "SELECT AddressName, Address FROM StudentAddr where StudentNum = '$studentNum'");
    for (var address in row.rowsAssoc) {
      String AddressName = address.colAt(0);
      String Address = address.colAt(1);
      results.add([AddressName, Address]);
    }

//カラム名を削除する
    List result = deleteColum(
        'AddressName', deleteColum('Adress', results));
    await db.close();
    return result;
  }

//カラム名を削除する関数
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

