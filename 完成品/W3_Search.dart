/*******************************************************************
 ***  File Name		: W3.dart
 ***  Version		: V1.0
 ***  Designer		: 中田　裕紀
 ***  Date			: 2022/6/06
 ***  Purpose       	: シミュレーションデータを保存する。
 ***
 *******************************************************************/
/*
*** Revision :
*** V1.0 : 中田　裕紀
*/
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'W2-1_MyHomePage.dart';
import 'W2-2_MyHomePage.dart';
import 'Task_database.dart';
import 'Task_database_model.dart';
import 'TaskServer.dart';

//void main() => runApp(MyApp());

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      //From. Changed 小筆赳 2022.6.12
      //title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        //primarySwatch: Colors.blue,
        primarySwatch: Colors.green,
      ),
      //home: const MyHomePage(title: 'Flutter Demo Home Page'),
      //home: const W2-1_MyHomePage(title: ''),
      //To. Changed 小筆赳 2022.6.12
    );
  }
}

class W3_Search extends StatefulWidget {
  final String title;



  const W3_Search({
    Key? key,
    required this.title,
  }) : super(key: key);

  @override
  _W3_SearchState createState() => _W3_SearchState();
}

class _W3_SearchState extends State<W3_Search> {
  //W2-1から課題リストを持ってくる
  //遷移元から渡される変数を保持する変数を作る
  /*
  List<String>result = [];//関数から持ってきた課題リスト
  result = read_Task(tasks.task);
*/
  bool _searchBoolean = false;
  List<int> _searchIndexList = [];

  //List<String> _list = ['高度情報処理演習1A','情報工学通論','a','a','b'];
  //W2からヒットしたものを表示
//From. Changed 二宮淑霞 2022.6.12
  List<Task>tasks = [];
  bool isLoading = false;
  final TextEditingController _categoryNameController =
  new TextEditingController(text: '');
  @override
  void initState() {
    super.initState();

    loadTasks();

  }

  Future loadTasks() async {
    setState(() => isLoading = true);
    await TaskDatabase.instance.deleteExpiredTask();
    tasks = await TaskDatabase.instance.readAllTask();
    setState(() => isLoading = false);
  }
  //To. Changed 二宮淑霞 2022.6.12

  Widget _searchTextField() {
    return TextField(
      onChanged: (String s) {
        setState(() {
          _searchIndexList = [];
          for (int i = 0; i < tasks.length; i++) {
            if (tasks[i].taskname.contains(s)) {
              _searchIndexList.add(i);
            }
          }
        });
      },
      autofocus: true,
      cursorColor: Colors.white,
      style: TextStyle(
        color: Colors.white,
        fontSize: 20,
      ),
      textInputAction: TextInputAction.search,
      decoration: InputDecoration(
        enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white)
        ),
        focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white)
        ),
        hintText: 'Search',
        hintStyle: TextStyle(
          color: Colors.white60,
          fontSize: 20,
        ),
      ),
    );
  }

  Widget _searchListView() {
    return ListView.builder(
        itemCount: _searchIndexList.length,
        itemBuilder: (context, index) {
          index = _searchIndexList[index];
          return Card(
              child: ListTile(
                  title: Text(tasks[index].taskname)
              )
          );
        }
    );
  }

  Widget _defaultListView() {
    return ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context, index) {
          return Card(
              child: ListTile(
                  title: Text(tasks[index].taskname)
              )
          );
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
            backgroundColor: Colors.green,
            title: !_searchBoolean ? Text(widget.title) : _searchTextField(),
            actions: !_searchBoolean
                ? [
              IconButton(
                  icon: Icon(Icons.search),
                  onPressed: () {
                    setState(() {
                      _searchBoolean = true;
                      _searchIndexList = [];
                    });
                  })
            ]
                : [
              IconButton(
                  icon: Icon(Icons.clear),
                  onPressed: () {
                    setState(() {
                      _searchBoolean = false;
                    });
                  }
              )
            ]
        ),
        body: !_searchBoolean ? _defaultListView() : _searchListView()
    );
  }
}