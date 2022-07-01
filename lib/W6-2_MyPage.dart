import 'package:flutter/material.dart';
import 'constants.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'W6-1_MyPage.dart';

class SecondScreen extends StatefulWidget {
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  List<Widget> _items = <Widget>[];

  @override
  void initState() {
    super.initState();
    getItems();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('公開する連絡先'),
      ),
      body: ListView(
        children: _items,
      ),
     /* bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1,
        items: <BottomNavigationBarItem> [
          BottomNavigationBarItem(
              title: Text("追加"),
              icon: Icon(Icons.home)
          ),
          BottomNavigationBarItem(
              title: Text('一覧'),
              icon: Icon(Icons.list)
          )
        ],
        onTap: (int index) {
          if (index == 0) {
            Navigator.pop(context);
          }
        },
      ),*/
    );
  }

  Widget _defaultListView() {
    var _list;
    return ListView.builder(
        itemCount: _list.length,
        itemBuilder: (context, index) {
          return Card(
              child: ListTile(
                  title: Text(_list[index])
              )
          );
        }
    );
  }

  /// 保存したデータを取り出す
  void getItems() async {
    /// データベースのパスを取得
    List<Widget> list = <Widget>[];
    String dbFilePath = await getDatabasesPath();
    String path = join (dbFilePath, Constants().dbName);

    /// テーブルがなければ作成する
    Database db = await openDatabase(
        path,
        version: Constants().dbVersion,
        onCreate: (Database db, int version) async {
          await db.execute("CREATE TABLE IF NOT EXISTS ${Constants().tableName} (id INTEGER PRIMARY KEY, name TEXT, mail TEXT, tel TEXT)"
          );
        });

    /// SQLの実行
    List<Map> result = await db.rawQuery('SELECT * FROM ${Constants().tableName}');

    /// データの取り出し
    for (Map item in result) {
      list.add(ListTile(
        title: Text(item['name']),
        subtitle: Text(item['address'] + ' '),
      ));
    }

    /// ウィジェットの更新
    setState(() {
      _items = list;
    });
  }
}