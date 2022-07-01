import 'package:kadai1/Test09/W4_Completed.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
//From. Added 小筆赳 2022.6.9
import 'Constants.dart';
import 'package:sqflite/sqflite.dart';
import 'W1_LoginPage.dart';
import 'W3_Search.dart';
import 'W6-2_MyPage.dart';


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
                    _saveData();
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => AlertDialog(
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
    String address = addressController.text;

    /// SQL文
    String query = 'INSERT INTO ${Constants().tableName}(name, address) VALUES("$name", "$address")';

    Database db = await openDatabase(path, version: Constants().dbVersion, onCreate: (Database db, int version) async {
      await db.execute(
          "CREATE TABLE IF NOT EXISTS ${Constants().tableName} (id INTEGER PRIMARY KEY, name TEXT, mail TEXT)"
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
  /*
  /// 保存したデータを取り出す
  void getItems() async {
    /// データベースのパスを取得
    List<Widget> list = <Widget>[];
    String dbFilePath = await getDatabasesPath();
    String path = join(dbFilePath, Constants().dbName);

    /// テーブルがなければ作成する
    Database db = await openDatabase(
        path,
        version: Constants().dbVersion,
        onCreate: (Database db, int version) async {
          await db.execute("CREATE TABLE IF NOT EXISTS ${Constants()
              .tableName} (id INTEGER PRIMARY KEY, name TEXT, mail TEXT, tel TEXT)"
          );
        });

    /// SQLの実行
    List<Map> result = await db.rawQuery(
        'SELECT * FROM ${Constants().tableName}');

    /// データの取り出し
    for (Map item in result) {
      list.add(ListTile(
        title: Text(item['name']),
        subtitle: Text(item['mail'] + ' ' + item['tel']),
      ));
    }

    /// ウィジェットの更新
    setState(() {
      _items = list;
    });
  }

  void insert() {
    var studentNum = "al21821";
    var passWord = "hensuu";
    var courseId = "tukattetuika";

   // var result = await conn.query(
     //   "INSERT INTO StudentInfo (StudentNum, PassWord, CourseId)
    //   VALUES ('$studentNum','$passWord', '$courseId')");
  }*/
}
/*
//時間割生成
  @override
  Widget build(BuildContext context) {
    // ignore: non_constant_identifier_names
    final items = List<String>.generate(10000, (i) => "Item $i");
    final TextEditingController _categoryNameController =
        new TextEditingController(text: '');

    final String key;
    final String Address;
    final int id;
    final String text;

    List<W6_Mypage> _memoList = [];

    var _selectedvalue;

    var  Size= MediaQuery.of(context).size;
    var itemList = List<Text>.generate(50, (i)=>Text("Item"+i.toString()));

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
      ),

      body:
      Column(children:[
        Container(
          color: Colors.green,

          child:Table(
              border: TableBorder.all(),
              children: const [
                TableRow(children: <Widget>[
                  TableCell(child:Center(child:Text('月'))),
                  TableCell(child:Center(child:Text('火'))),
                  TableCell(child:Center(child:Text('水'))),
                  TableCell(child:Center(child:Text('木'))),
                  TableCell(child:Center(child:Text('金'))),
                  TableCell(child:Center(child:Text('土'))),
                ]),
              ]),
        ),
        _table(" ",Size.width,Size.height),

        Align(
          alignment: Alignment(Size.width*-0.0015,1),
          child:const Text('公開する連絡先',
              style:TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 18,
              )),
        ),

        ListTile(
          title: Text('学校メール'),
          //サーバーのデータベースから持ってきた学生のメールアドレスをここに表示

          trailing: Icon(
            Icons.clear,
          ),
          onTap: (){
            //_delete()
          },
        ),

        ListTile(
          title: Text('LINE ID'),
          //☓ボタンを付けて、押したら公開する連絡先を削除する
          trailing: Icon(
            Icons.clear,
          ),
          onTap: (){
            //_delete()
          },
        ),


        TextFormField(
          decoration: InputDecoration(
            labelText: '種類',
            border: OutlineInputBorder(),
            //キー
            prefixIcon: IconButton(
              onPressed: () =>
                  _categoryNameController.clear(),
              icon: Icon(Icons.clear),
            ),
          ),
        ),
        //追加する連絡先の種類を書くところ 追加したらリストに追加？
        TextFormField(
          controller: _categoryNameController,
          decoration: InputDecoration(
            labelText: 'アドレス',
            border: OutlineInputBorder(),
              prefixIcon: IconButton(
                onPressed: () =>
                _categoryNameController.clear(),
                icon: Icon(Icons.clear),
              ),
          ),
          //☓ボタンを押したらdelete_address
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
              onPressed: (){
                /*新しい公開する連絡先を公開する連絡先に追加する
                種類　アドレス　と表示されるような処理を書く
                 */
                //_insert();
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
              onPressed: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => W4_Completed()),
                );
              },
            )
          ],
        ),
      ],
    ),
    );
  }
}*/