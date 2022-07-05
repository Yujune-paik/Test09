import 'read_Address.dart';
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
  List results = [];

  @override
  void read()  async{
    Future<List> _futureOfList = read_Address().read_address();
    results = await _futureOfList;
  }

  @override
  void initState() {
    super.initState();
    read();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text('公開する連絡先'),
      ),
      body: ListView.separated(
        itemCount: results.length,
        itemBuilder: (context, index) {
          return ListTile(

            title: Text(results[index]),
            //subtitle: Text(results[index]['date']),


            //クリックされた時の処理（W4）


          );
        },
        separatorBuilder: (context, index) {
          return const Divider();
        },
      ),
    );
  }
}