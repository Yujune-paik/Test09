import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
//From. Added 小筆赳 2022.6.9
import 'Constants.dart';
import 'package:sqflite/sqflite.dart';
import 'W1_LoginPage.dart';
import 'W3_Search.dart';
import 'W6-2_MyPage.dart';
import 'address.dart';


//To. Added 小筆赳 2022.6.9
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

  TextEditingController name= TextEditingController();
  TextEditingController address= TextEditingController();
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
              controller: nameController,
              style: style1,

            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text('address:', style: style2,),
            ),
            TextField(
              controller: addressController,
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
                  onPressed: () {
                    Navigator.push( //From Added 小筆赳 2022.6.6
                      context,
                      MaterialPageRoute(
                          builder: (context) => SecondScreen()),
                    );

                    add_Address().add_address(name.text, address.text);
                    _saveData();
                    showDialog(
                        context: context,
                        builder: (BuildContext context) =>
                            AlertDialog(
                              title: Text("追加しました"),
                              content: Text('公開する連絡先に追加できました'),
                            )
                    );
                  },
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