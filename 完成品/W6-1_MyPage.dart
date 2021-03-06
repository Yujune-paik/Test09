/*******************************************************
 *** File name      : W6-1_MyPage
 *** Version        : V1.0
 *** Designer       : 小筆赳
 *** Purpose        : マイページ
 *******************************************************/

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
//From. Added 小筆赳 2022.6.9
import 'Constants.dart';
import 'package:sqflite/sqflite.dart';
import 'W1_LoginPage.dart';
import 'W6-2_MyPage.dart';
import 'add_Address.dart';


class W6_Mypage extends StatefulWidget {
  @override
  _W6_MypageState createState() => _W6_MypageState();
}

class _W6_MypageState extends State<W6_Mypage> {
  final nameController = TextEditingController();
  final addressController = TextEditingController();
  final myController = TextEditingController();
  final upDateController = TextEditingController();

  final TextStyle style1 = TextStyle(
      fontSize: 15.0,
      color: Colors.black
  );
  final TextStyle style2 = TextStyle(
      fontSize: 15.0,
      color: Colors.black
  );

  get _items => null;

  final name = TextEditingController();
  final address= TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('MyPage'),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            Align(
              alignment: Alignment.centerLeft,
              child: Text('名前:', style: style2,),
            ),
            TextField(
              controller: name,
              style: style1,

            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('address:', style: style2,),
            ),
            TextField(
              controller: address,
              style: style1,
            ),
            ButtonBar(
              children: [
                ElevatedButton(
                  child: const Text('追加'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey,
                    onPrimary: Colors.white,
                    shape: const StadiumBorder(),
                  ),
                  //From. Changed 西尾　翔輝　2022.07.17
                  onPressed: () async{
                    int results = 0;
                    Future<int> judge = add_Address().add_address(name.text, address.text);
                    results = await judge;
                    Navigator.push( //From Added 小筆赳 2022.6.6
                      context,
                      MaterialPageRoute(
                          builder: (context) => SecondScreen()),
                    );


                    _saveData();
                    if(results == 1) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                              AlertDialog(
                                title: Text("追加しました"),
                                content: Text('公開する連絡先に追加できました'),
                              )
                      );
                    } else {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                          AlertDialog(
                            title: Text("追加できませんでした"),
                            content: Text('名前とaddress両方を入力してください'),
                          )
                      );
                    }
                  },
                  //To. Changed 西尾　翔輝　2022.07.17
                )
              ],
            ),
            ButtonBar(
              children: [
                ElevatedButton(
                  child: const Text('公開する連絡先一覧'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey,
                    onPrimary: Colors.white,
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () {
                    Navigator.push( //From Added 小筆赳 2022.6.6
                      context,
                      MaterialPageRoute(
                          builder: (context) => SecondScreen()),
                    );
                  },
                )
              ],
            ),
            ButtonBar(
              children: [
                ElevatedButton(
                  child: const Text('ログアウトする'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.grey,
                    onPrimary: Colors.white,
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () {
                    Navigator.push( //From Added 小筆赳 2022.6.6
                      context,
                      MaterialPageRoute(
                          builder: (context) => W1_LoginPage()),
                    );
                  },
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// データを保存する
  void _saveData() async {
    /// データベースのパスを取得
    String dbFilePath = await getDatabasesPath();
    String path = join(dbFilePath, Constants().dbName);

    /// 保存するデータの用意
    String name = nameController.text;
    String address = addressController.text; //studentnumber


    /// SQL文
    String query = 'INSERT INTO ${Constants()
        .tableName}(name, address) VALUES("$name", "$address")';

    Database db = await openDatabase(path, version: Constants().dbVersion,
        onCreate: (Database db, int version) async {
          await db.execute(
              "CREATE TABLE IF NOT EXISTS ${Constants()
                  .tableName} (id INTEGER PRIMARY KEY, name TEXT, mail TEXT)"
          );
        });

    /// SQL 実行
    await db.transaction((txn) async {
      int id = await txn.rawInsert(query);
      print("保存成功 id: $id");
    });

    /// ウィジェットの更新
    setState(() {
      nameController.text = "";
      addressController.text = "";
    });
  }
}

class Data{

  String name = 'nameController.text';
  String address = 'addressController.text';
  String StudentNum = 'StudenNumController.text';

}