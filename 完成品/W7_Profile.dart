/*******************************************************************
 ***  File Name		: W7_Profile.dart
 ***  Version		: V1.0
 ***  Designer		: 千手　香穂
 ***  Date			: 2022.06.02
 ***  Purpose       	: 画面7(W7_Profile)の画面を作る
 ***
 *******************************************************************/
/*
*** Revision :
*** V1.0 : 千手香穂, 2022/06/02
*/

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
//From.added 小筆赳 2022.07.05
import 'package:shared_preferences/shared_preferences.dart';
import 'read_Address.dart';
//To.changed 小筆赳 2022.07.05
class W7_Profile extends StatefulWidget {
  @override
  _W7_ProfileState createState() => _W7_ProfileState();
}

class _W7_ProfileState extends State<W7_Profile> {
  List entries = [];
  String studentID = '';
  // List results = [];
  @override
  void read()  async{
    //From.added 小筆赳 2022.07.05
    // Future<List> _futureOfList = read_Address().read_address();
    // entries = await _futureOfList;

    final SharedPreferences studentinfo = await SharedPreferences.getInstance();
    studentID = studentinfo.getString('studentinfo') ?? '';

    Future<List> _futureOfList = read_Address().read_otheraddress(studentID);
    entries = await _futureOfList;
    //To.changed 小筆赳 2022.07.05
  }

  @override
  void initState() {
    super.initState();
    read();
  }
  //To.added 小筆赳 2022.07.04

  //暫定的にここに適当なリストを作って表示させています。
  //このリストにはユーザの連絡先が格納される予定です。
  //final List<String> entries = <String>['A', 'B', 'C'];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //飛ぶ前のページと同じ課題名(書かなくてもいいかも)
        //title: Text('課題名'),
        //From.added 小筆赳 2022.07.02
        leading: TextButton(
          child: Text(
            '☓',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          onPressed: () => Navigator.of(context
          ).pop(),
        ),
        //To.changed 小筆赳 2022.07.02
      ),
      body: Column(
        children: <Widget>[
          //学籍番号(ユーザ名)表示
          Text(
            studentID,
            style: TextStyle(
                fontWeight: FontWeight.bold,
                height: 1.5,
                fontSize: 40
            ),
          ),
          //学籍番号の下線
          const Divider(
            height: 10,
            thickness: 3,
            indent: 20,
            endIndent: 20,
            color: Colors.green,
          ),
          Container(
            height: 125,
            padding: const EdgeInsets.all(4),
            //連絡先リスト
            child: entries.length > 0
                ? ListView.separated(
              itemCount: entries.length,
              itemBuilder: (context, index) {
                return Container(
                  child: Text(entries[index]),
                );
              },
              separatorBuilder: (context, index) {
                return const Divider();
              },
            )
            //リストが空の場合は No items と表示
                : const Center(child: Text('No items')),
          ),
        ],
      ),
    );
  }
}