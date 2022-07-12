/*******************************************************
 *** File name      : W6-2_MyPage
 *** Version        : V1.0
 *** Designer       : 小筆赳
 *** Purpose        : マイページ
 *******************************************************/
import 'read_Address.dart';
import 'package:flutter/material.dart';

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
          );
        },
        separatorBuilder: (context, index) {
          return const Divider();
        },
      ),
    );
  }
}