import 'package:coriander/read_Address.dart';
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
  List results=[];
  @override
  void initState()async {
    super.initState();
    Future<List> _futureOfList = read_Address().read_address();
     results = await _futureOfList;
  }



  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('公開する連絡先'),
      ),
      body:  ListView.separated(
        itemCount: results.length,
        itemBuilder: (context, index){
          return ListTile(

            title: Text(results[index]['text']),
            subtitle: Text(results[index]['date']),

            //バックボタン
            trailing: IconButton(
              iconSize: 30,
              icon: const Icon(Icons.arrow_circle_left_outlined,),
              onPressed: () {
                //delete_Task;
                //add_Task;
                //課題を未提出に戻す,delete_Task,add_Task
              },
            ),
            //dense: true,

            //クリックされた時の処理（W4）


          );
        },
        separatorBuilder: (context, index){
          return const Divider();
        },
      ),
    );
  }

