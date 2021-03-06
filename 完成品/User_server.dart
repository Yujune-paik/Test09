/*******************************************************************
 ***  File Name		: User_server.dart
 ***  Version		: V1.0
 ***  Designer		: 西尾 翔輝
 ***  Date			: 2022.06.29
 ***  Purpose       	: ユーザ情報に関するDBとやりとりする。
 ***
 *******************************************************************/
/*
*** Revision :
*** V1.0 : 西尾　翔輝, 2022.06.29
*** V1.1 : 西尾　翔輝, 2022.07.05 Add_Address
*/

import 'dart:async';
import 'package:mysql1/mysql1.dart';
import 'package:mysql_utils/mysql_utils.dart';

class User_server {
  var settings = new ConnectionSettings(
      host: '160.16.141.77',
      port: 50900,
      user: 'app09',
      db: 'App_db',
      password: 'pracb2022');  //データベースの情報

  //ユーザ情報を追加
  Future<void> add_Address(var StudentNum, var AddressName, var Address) async {

    //From. Added 西尾　翔輝 2022.07.05
    //空文字排除
    if(StudentNum.isEmpty || AddressName.isEmpty || Address.isEmpty)return ;

    //前後の空白削除
    StudentNum = StudentNum.trim();
    AddressName = AddressName.trim();
    Address = Address.trim();
    //To. Added 西尾　翔輝 2022.07.05

    //既に同じデータがないかcheck
    Future<List> _check = read_User(StudentNum);//Future型のcheck用リスト
    List check = await _check;//check用リスト
    for(int i=0; i<check.length; i+=3) {
      if ((check[i + 1] == AddressName) && (check[i + 2] == Address)) return ;
    }

    final conn = await MySqlConnection.connect(settings);  //データベースの情報
    var result = await conn.query(
        "INSERT INTO StudentAddr (StudentNum, AddressName, Address) VALUES ('$StudentNum','$AddressName', '$Address')");
    close_Database1(conn);
  }

  //ユーザ情報を削除
  Future<void> delete_Address(var StudentNum, var AddressName, var Address) async{
    final conn = await MySqlConnection.connect(settings);  //データベースの情報
    //"*"分岐処理
    if(AddressName == "*" && Address == "*"){
      var result = await conn.query(
          "DELETE FROM StudentAddr WHERE StudentNum = ('$StudentNum')");
    } else if(Address == "*"){
      var result = await conn.query(
          "DELETE FROM StudentAddr WHERE StudentNum = ('$StudentNum') AND AddressName = ('$AddressName')");
    } else {
      var result = await conn.query(
        //一行120文字以上になってる
          "DELETE FROM StudentAddr WHERE StudentNum = ('$StudentNum') AND AddressName = ('$AddressName') AND Address = ('$Address')");
    }
    close_Database1(conn);
  }

  //ユーザ情報を引き出す
  Future<List> read_User(var StudentNum) async{
    var AddressName, Address;
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
        });  //データベースの情報

    var row = await db.query(
        "SELECT * FROM App_db.StudentAddr WHERE StudentNum = ('$StudentNum')"
    );
    //抽出データのリスト化
    List<String> info = [];//返り値リスト
    for (var item in row.rowsAssoc) {
      String STUDENTNUM = item.colAt(0);
      String ADDRESSNAME = item.colAt(1);
      String ADDRESS = item.colAt(2);
      //print(STUDENTNUM + ' ' + ADDRESSNAME + ' ' + ADDRESS);
      info.add('$STUDENTNUM');
      info.add('$ADDRESSNAME');
      info.add('$ADDRESS');
    }

    close_Database2(db);
    return info;
  }

  //final型：データベースをクローズする
  void close_Database1(final conn) async {
    await conn.close();
  }
  //var型：データベースをクローズする
  void close_Database2(var db) async {
    await db.close();
  }
}
