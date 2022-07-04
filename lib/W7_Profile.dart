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
import 'W2-2_MyHomePage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'W4_Completed.dart';// From. Added 小筆赳 2022.6.8

class W7_Profile extends StatelessWidget {
  //暫定的にここに適当なリストを作って表示させています。
  //このリストにはユーザの連絡先が格納される予定です。
  final List<String> entries = <String>['A', 'B', 'C'];
//ここに提出済みの学生の情報を格納
  //read_User
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        //飛ぶ前のページと同じ課題名(書かなくてもいいかも)
        title: Text('課題名'),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: <Widget>[
          //学籍番号(ユーザ名)表示
          //ここはW4で押した学生の学籍番号を表示
          Text(
            'AA00000',//
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