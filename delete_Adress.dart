import 'package:mysql1/mysql1.dart';
import 'dart:async';
import 'W6-1_MyPage.dart';

class delete_Adress {
  Future _delete(String studentNum,String addressName) async {
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
      return true;
    }

    catch (e) {
      return false;
    }
  }
}


