/*******************************************************
 *** File name      : W4_Completed.dart
 *** Version        : V1.0
 *** Designer       : 西尾　翔輝
 *** Purpose        : 課題完了表示
 *******************************************************/

import 'package:flutter/material.dart';
//From. Added 小筆赳 2022.6.9
import 'Task_database_model.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'Task_database.dart';
import 'W7_Profile.dart';
import 'TaskServer.dart';
import 'package:shared_preferences/shared_preferences.dart';
//To. Added 小筆赳 2022.6.9

class W4_Completed extends StatefulWidget {
  const W4_Completed({Key?key}) : super(key: key);

  @override
  _W4_CompletedState createState() => _W4_CompletedState();

}

class _W4_CompletedState extends State<W4_Completed>{
  List results = [];//関数から持ってきた完了者リスト
  int taskid = 0;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadTask();
  }

  Task task = Task(
    isCompleted: false,
    isPrivate: '-1',
    taskname: 'taskname',
    subject: 'subject',
    sbId: 'sbId',
    deadline: DateTime.now(),
  );

  void init() async{
    final SharedPreferences student = await SharedPreferences.getInstance();
    taskid = (student.getInt('taskid') ?? '') as int;
    //task = await TaskDatabase.instance.readTask(taskid);
    loadTask();
    Future<List> _futureOfList = TaskServer().completeList(task.taskname);
    results = await _futureOfList;
  }

  Future loadTask() async {
    setState(() => isLoading = true);
    task = await TaskDatabase.instance.readTask(taskid);
    setState(() => isLoading = false);
  }

//遷移元から渡される変数を保持する変数を作る
  @override
  Widget build(BuildContext context) {
    final double dH = MediaQuery.of(context).size.height; //画面のHeight
    final double dW = MediaQuery.of(context).size.width;  //画面のWidth
    double std_font_size = dH*0.03; //標準的な文字サイズ
    String _state="不明";  //提出状況
    int judge_state=0;
    if(task.isCompleted == true)
    {
      judge_state=1;
    }
    //0で未提出，それ以外で提出済

    if(judge_state==0) {
      _state="未提出";
    } else {
      _state="提出済";
    }
    init();

    return Scaffold(
      //From.added 小筆赳 2022.06.28
      appBar: AppBar(
        backgroundColor: Colors.green,
        leading: TextButton(
          child: const Text(
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
      ),
      //To.added 小筆赳 2022.06.28
      body: Column(
          children: <Widget>[
            Container(
              margin:EdgeInsets.fromLTRB(0, dH*0.01, 0, dH*0.005),
              child: Text(
                  task.taskname,
                  style: TextStyle(
                      fontSize: dH*0.04,
                      fontWeight: FontWeight.bold
                  )
              ),
            ),
            const Divider(
              color: Colors.green,
              thickness: 3,
              height: 0,
              indent:25,
              endIndent: 25,
            ),
            Container(
              margin:const EdgeInsets.all(10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(dW*0.12, 0, 0, 0),
                      child: Text(
                          '科目',
                          style: TextStyle(
                              fontSize: std_font_size,
                              fontWeight: FontWeight.bold
                          )
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 0, dW*0.12, 0),
                      child: Text(
                          task.subject,
                          style: TextStyle(
                              fontSize:
                              std_font_size,
                              fontWeight: FontWeight.bold
                          )
                      ),
                    )
                  ]
              ),
            ),
            const Divider(
              color: Colors.black26,
              thickness: 3,
              height: 0,
              indent:40,
              endIndent: 40,
            ),
            Container(
              margin:const EdgeInsets.all(10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(dW*0.12, 0, 0, 0),
                      child: Text(
                          '締切',
                          style: TextStyle(
                              fontSize: std_font_size,
                              fontWeight: FontWeight.bold
                          )
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 0, dW*0.12, 0),
                      //W2から課題情報をひっぱってきて日時を表示
                      child: Text(DateFormat('yyyy/MM/dd HH:mm')
                          .format(task.deadline),
                          style: TextStyle(
                              fontSize: std_font_size,
                              fontWeight: FontWeight.bold
                          )
                      ),
                    )
                  ]
              ),
            ),
            const Divider(
              color: Colors.black26,
              thickness: 3,
              height: 0,
              indent:40,
              endIndent: 40,
            ),
            Container(
              margin:const EdgeInsets.all(10),
              child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(dW*0.12, 0, 0, 0),
                      child: Text(
                          '提出状況',
                          style: TextStyle(
                              fontSize: std_font_size,
                              fontWeight: FontWeight.bold
                          )
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.fromLTRB(0, 0, dW*0.12, 0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        color: Colors.black54,
                      ),
                      padding: EdgeInsets.fromLTRB(dW*0.03, dH*0.005, dW*0.03, dH*0.005),
                      child: Text(
                          _state,
                          style: TextStyle(
                              fontSize: std_font_size,
                              color: Colors.white,
                              fontWeight: FontWeight.w400
                          )
                      ),
                    )
                  ]
              ),
            ),
            const Divider(
              color: Color(0xFF8fab59),
              thickness: 3,
              height: 0,
              indent:25,
              endIndent: 25,
            ),

            //From.added 小筆赳 2022.07.01
            TextButton(
              style: ElevatedButton.styleFrom(
                primary: Colors.green,
                onPrimary: Colors.white,
                shape: const StadiumBorder(),
              ),
              onPressed: () async {
                //課題を消す
                await TaskDatabase.instance.deleteTask(task.id!);
                if (!mounted) return;
                Navigator.of(context).pop();
              },
              child: const Text('削除する'),
            ),
            //To.added 小筆赳 2022.07.01
            Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    margin:EdgeInsets.fromLTRB(dW*0.1, dH*0.025, 0, dH*0.01),
                    child: Text(
                        '課題完了者一覧',
                        style: TextStyle(
                            fontSize: std_font_size,
                            fontWeight: FontWeight.bold
                        )
                    ),
                  ),
                ]
              ),
            const Divider(
              color: Colors.black26,
              thickness: 3,
              height: 0,
              indent:40,
              endIndent: 40,
            ),

            //ここから提出者のリストを作らなくてはいけないが，分からないのでとりあえず一人分の表示だけ行う
            SizedBox(
              height: 300,
              child: ListView.builder(
                itemCount: results.length,
                itemBuilder: (context, index){
                  //From.changed 西尾翔輝 2022.07.05
                  final String result = results[index].colAt(0) as String;
                  //To.changed 西尾翔輝 2022.07.05
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                        margin:EdgeInsets.fromLTRB(dW*0.15, dH*0.01, 0, dH*0.01),
                        child: Icon(
                          Icons.assignment_ind,
                          size: std_font_size,
                        ),
                      ),
                      Container(
                        margin:EdgeInsets.fromLTRB(dW*0.02, dH*0.01, 0, dH*0.01),
                        //From. Added 小筆赳 2022.6.12
                        child: TextButton(
                          child: Text(
                              result,
                              style: TextStyle(
                                  fontSize: std_font_size,
                                  fontWeight: FontWeight.w400
                              )
                          ),
                          onPressed: (){
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => W7_Profile()),
                            );
                          },
                        ),
                        //To. Added 小筆赳 2022.6.12
                      ),
                    ]
                  );
                },
              ),
            ),
          ]
      ),
    );
  }
}
