/*******************************************************************
 ***  File Name		: read_User.dart
 ***  Version		: V1.0
 ***  Designer		: 栗田　遥生
 ***  Date			: 2022.07.02
 ***  Purpose       	: 与えられた連絡先の名称と学籍番号に対応するデータを
 * データベースから削除する
 ***
 *******************************************************************/
/*
*** Revision:
*** V1.1 : 栗田遥生, 2022.07.02
 */
import 'package:mysql1/mysql1.dart';
import 'dart:async';
import 'W6-1_MyPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class delete_Address {
  Future delete_address(String addressName) async {

    //学籍情報を取り出す
    final SharedPreferences student = await SharedPreferences.getInstance();
    String studentNum = student.getString('number') ?? '';

    //データベースに接続する
    try {
      final conn = await MySqlConnection.connect(ConnectionSettings(
          host: '160.16.141.77',
          port: 50900,
          user: 'app09',
          db: 'App_db',
          password: 'pracb2022'));

      //与えられたデータに対応するデータを削除する
      await conn.query(
          "delete from StudentAddr where StudentNum='$studentNum' and AddressName='$addressName'");

      conn.close();
      return 1;
    }

    catch (e) {
      return 0;
    }
  }
}