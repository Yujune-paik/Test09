/*******************************************************
 *** File name      : W2_2MyHomePage
 *** Version        : V1.0
 *** Designer       : 二宮淑霞
 *** Purpose        : ホームページ2_2
 *******************************************************/
/*
*** Revision:
*** V1.0 : 二宮淑霞, 2022.06.02
*** V1.1 : 二宮淑霞, 2022.07.04
 */



import 'W4_Completed.dart';
import 'package:flutter/material.dart';
import 'W2-1_MyHomePage.dart';
// From. Added 小筆赳 2022.6.8
import 'W3_Search.dart';
import 'W5_AddTask.dart';
import 'W7_Proflie.dart';
import 'package:flutter/material.dart';
//From. Added 小筆赳 2022.6.9
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'Task_database.dart';
import 'Task_database_model.dart';
import 'TaskServer.dart';
import 'package:shared_preferences/shared_preferences.dart';

// To. Added 小筆赳 2022.6.8

//ホーム画面(提出済)
class W2_2MyHomePage extends StatelessWidget {
  W2_2MyHomePage(this.completeList);
  //完了した課題情報を格納
  final List<Task> completeList;


  //From. 二宮淑霞 2022.7.3
  //学籍番号を取得
  String studentNum= "";
  void disPush() async{
    final SharedPreferences student = await SharedPreferences.getInstance();
    studentNum = student.getString('number') ?? '';
  }

  void initState() {
    disPush();

  }




  @override
  Widget build(BuildContext context) {

    //デバイスのサイズを獲得
    //final double deviceHeight = MediaQuery.of(context).size.height;

    return MaterialApp(
      title: 'HomePage',
      //theme: ThemeData(primarySwatch: Colors.blue),
      home: Scaffold(

        appBar:AppBar(
          backgroundColor: Colors.green, //アプリバーの背景色
          actions: <Widget>[
            IconButton(
              icon: const Icon(Icons.account_circle,),
              onPressed: () {},
            ),
          ],
        ),


        body: Container(
          width: double.infinity,
          padding:const EdgeInsets.all(30),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[

              ButtonBar(
                children: [
                  TextButton(
                    child: Text('課題を検索する'),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => W3_Search(title: '',/*read_AllTask*/)),
                      );
                    },
                  ),
                ],
              ),
              //課題の提出状態
              ButtonBar(
                //child: Row(
                //alignment: Alignment.topRight,
                children: [
                  ElevatedButton(
                    child: const Text('未提出'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.green,
                      shape: const StadiumBorder(),

                    ),
                    onPressed: () {//提出済みの課題を未提出に移動,delete_Task,add_Task
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => W2_1_MyHomePage()),
                      );
                      //To.Changed　小筆赳 2022.6.9
                    },
                  ),
                  ElevatedButton(
                    child: const Text('提出済'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.green,
                      onPrimary: Colors.white,
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () {
                      //From. Added 小筆赳 2022.6.9
                      /*Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => W7_Profile()),
                      );*///To. Added 小筆赳 2022.6.9
                    },
                  ),
                ],
                //),
              ),

              //課題リスト
              SizedBox(
                height: 400,
                child: ListView.builder(
                  itemCount: completeList.length,
                  itemBuilder: (context, index){
                    final task = completeList[index];
                    return Card(


                      child:InkWell(
                        child: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                children: [
                                  Text(
                                    task.taskname,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 24,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      const Text('期限：'),
                                      Text(DateFormat('yyyy/MM/dd HH:mm')
                                          .format(task.deadline)),
                                    ],
                                  ),
                                ],
                              ),
                              IconButton(
                                alignment: Alignment.center,
                                icon: const Icon(
                                  Icons.arrow_circle_left_outlined,
                                  color: Colors.green,
                                ),
                                onPressed: () async {
                                  await TaskDatabase.instance.addTask(task);
                                  if(task.isPrivate != '-1') {
                                    TaskServer().deleteWhoCompleted(task.isPrivate,studentNum);
                                  }

                                },
                              ),
                              /*
                            onTap: (){


                            },*/
                            ],
                          ),

                        ),
                        onTap: () async {
                          await Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => W4_Completed(),

                            ),
                          );
                          //loadTasks();
                        },

                      ),
                    );

                  },
                ),
              ),

              //課題追加ボタン
              /*const ButtonBar(
                children: [
                  IconButton(
                    icon: const Icon(Icons.add_circle),
                    onPressed: () {},
                    color: Colors.green,
                    iconSize: 60,
                  ),
                ],
              ),*/

            ],
          ),

        ),
        /*floatingActionButton: FloatingActionButton(
          onPressed: () {
          },
          child: const Icon(Icons.add),
          backgroundColor: Colors.green,
        ),*/

      ),
    );
  }
}