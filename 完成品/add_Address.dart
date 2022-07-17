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
*** V1.2 : 西尾翔輝, 2022.07.10 add_Address
*** V1.3 : 西尾翔輝, 2022.07/17 add_Address
 */
import 'package:shared_preferences/shared_preferences.dart';
import 'package:mysql1/mysql1.dart';
import 'dart:async';
import 'W6-1_MyPage.dart';
import 'package:mysql_utils/mysql_utils.dart';


//From. Changed 西尾　翔輝　2022.07.17
class add_Address {
  Future<int> add_address(String addressName,String address) async {

    //学籍情報を取り出す
    final SharedPreferences student = await SharedPreferences.getInstance();
    String studentNum = student.getString('number') ?? '';

    //データベースに接続する
    final conn = await MySqlConnection.connect(ConnectionSettings(
        host: '160.16.141.77',
        port: 50900,
        user: 'newApp09',
        db: 'App_db',
        password: 'pracb2022'));

    //データベースに与えられたデータを追加する
    try {
      //From. Added 西尾　翔輝 2022.07.10
      //空文字排除
      if(studentNum.isEmpty || addressName.isEmpty || address.isEmpty)return Future.value(0);

      //前後の空白削除
      studentNum = studentNum.trim();
      addressName = addressName.trim();
      address = address.trim();

      //既に同じデータがないかcheck
      Future<List> _check = read_User(studentNum);//Future型のcheck用リスト
      List check = await _check;//check用リスト
      for(int i=0; i<check.length; i+=3) {
        if ((check[i + 1] == addressName) && (check[i + 2] == address)) return Future.value(0);
      }
      //To. Added 西尾　翔輝 2022.07.10

      await conn.query(
          "INSERT INTO StudentAddr (StudentNum, AddressName, Address) VALUES ('$studentNum','$addressName', '$address')");
      return Future.value(1);
    } catch (e) {
      return Future.value(0);
    }

    finally {
      await conn.close();
    }
  }
  //To. Changed 西尾　翔輝　2022.07.17


  //From. Added 西尾　翔輝 2022.07.10
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

    db.close();
    return info;
  }
//To. Added 西尾　翔輝 2022.07.10
}

