/*******************************************************
 *** File name      : W6-2_MyPage
 *** Version        : V1.0
 *** Designer       : 小筆赳
 *** Purpose        : マイページ
 *******************************************************/
import 'read_Address.dart';
import 'package:flutter/material.dart';
import 'Task_database.dart';
import 'Task_database_model.dart';

class SecondScreen extends StatefulWidget {
  @override
  _SecondScreenState createState() => _SecondScreenState();
}

class _SecondScreenState extends State<SecondScreen> {
  List results = [];

  @override
  void read() async{
    Future<List> _futureOfList = read_Address().read_address();
    results = await _futureOfList;
    //loadTask();
  }

  int taskid = 0;
  bool isLoading = false;
  Task task = Task(
    isCompleted: false,
    isPrivate: '-1',
    taskname: 'taskname',
    subject: 'subject',
    sbId: 'sbId',
    deadline: DateTime.now(),
  );

  /*
  Future loadTask() async {
    setState(() => isLoading = true);
    task = await TaskDatabase.instance.readTask(taskid);
    setState(() => isLoading = false);
  }*/

  @override
  Widget build(BuildContext context) {
    read();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('公開する連絡先'),
      ),
      body: ListView.separated(
        itemCount: results.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(results[index]),
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
