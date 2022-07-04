/*******************************************************************
 ***  File Name		: read_User.dart
 ***  Version		: V1.0
 ***  Designer		: 栗田　遥生
 ***  Date			: 2022.07.02
 ***  Purpose       	: 与えられた連絡先と連絡先の名称をサーバ内のデータベースに追加する
 ***
 *******************************************************************/
/*
*** Revision:
*** V1.1 : 栗田遥生, 2022.07.02
 */
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mysql1/mysql1.dart';
import 'dart:async';
import 'W6-1_MyPage.dart';



class add_Address {
  Future add_address(String addressName,String address) async {

  //学籍情報を取り出す
    final SharedPreferences student = await SharedPreferences.getInstance();
    String studentNum = student.getString('number') ?? '';

    //データベースに接続する
    final conn = await MySqlConnection.connect(ConnectionSettings(
        host: '160.16.141.77',
        port: 50900,
        user: 'app09',
        db: 'App_db',
        password: 'pracb2022'));

   //データベースに与えられたデータを追加する
    try {
      await conn.query(
          "INSERT INTO StudentAddr (StudentNum, AddressName, Address) VALUES ('$studentNum','$addressName', '$address')");
      return 1;
    } catch (e) {
      return 0;
    }

      finally {
        await conn.close();
      }
  }
}

