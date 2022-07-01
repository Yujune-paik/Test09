import 'package:mysql1/mysql1.dart';
import 'dart:async';
import 'W6-1_MyPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class delete_Address {
  Future delete_address(String studentNum,String addressName) async {

    //学籍情報を取り出す
    final SharedPreferences student = await SharedPreferences.getInstance();
    String studentNum = student.getString('number') ?? '';

    try {
      final conn = await MySqlConnection.connect(ConnectionSettings(
          host: '160.16.141.77',
          port: 50900,
          user: 'app09',
          db: 'App_db',
          password: 'pracb2022'));

/*
      Data data = Data();

      var studentNum = data.num;
      var addressName = data.name;
  */    await conn.query(
          "delete from StudentAddr where StudentNum='$studentNum' and AddressName='$addressName'");

      conn.close();
      return 1;
    }

    catch (e) {
      return 0;
    }
  }
}


