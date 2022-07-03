import 'package:flutter/material.dart';
//From. Added 小筆赳 2022.6.9
import 'W2-2_MyHomePage.dart';
import 'W3_Search.dart';
import 'W4_Completed.dart';
import 'W5_AddTask.dart';
import 'W6-1_MyPage.dart';
import 'package:intl/intl.dart';
import 'package:flutter/cupertino.dart';
import 'Task_database.dart';
import 'Task_database_model.dart';
import 'TaskServer.dart';
import 'package:shared_preferences/shared_preferences.dart';
//To. Added 小筆赳 2022.6.9


//ホーム画面(未提出)

class W2_1_MyHomePage extends StatefulWidget {
  const W2_1_MyHomePage({Key?key}) : super(key: key);

  @override
  _W2_1_MyHomePageState createState() => _W2_1_MyHomePageState();
}

class _W2_1_MyHomePageState extends State<W2_1_MyHomePage>{

/*
  List<String>result = [];//関数から持ってきた課題リスト
  result = read_AllTask(tasks.taskname);
*/

  //From. 二宮淑霞 2022.7.3
  //画面遷移時に実行される関数,サーバの課題をローカルに入れる。
  String studentNum= "";
  void disPush() async{
    final SharedPreferences student = await SharedPreferences.getInstance();
    studentNum = student.getString('number') ?? '';
    TaskServer().readAllTask(studentNum);
  }



  //完了した課題を格納
  List<Task> completeTasks = [];
  //To. Added 二宮淑霞 2022.7.3


  List<Task>tasks = [];
  bool isLoading = false;
  final TextEditingController _categoryNameController =
  new TextEditingController(text: '');




  @override
  void initState() {
    super.initState();
    disPush();
    loadTasks();
  }



  @override
  void dispose() {
    TaskDatabase.instance.closeDatabase();
    super.dispose();
  }

  Future loadTasks() async {
    setState(() => isLoading = true);
    await TaskDatabase.instance.deleteExpiredTask();
    tasks = await TaskDatabase.instance.readAllTask();
    setState(() => isLoading = false);
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green, //アプリバーの背景色
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.account_circle,),
            onPressed: () {
              //From. Added 小筆赳 2022.6.9
              Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => W6_Mypage()),
              );//To.Changed　小筆赳 2022.6.9
            },
          ),
        ],
      ),
      body:  Container(
        width: double.infinity,
        padding:const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[


            //課題検索ページへ

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
                    primary: Colors.green,
                    onPrimary: Colors.white,
                    shape: const StadiumBorder(),

                  ),
                  onPressed: () {
                  },
                ),
                ElevatedButton(
                  child: const Text('提出済'),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.green,
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () {
                    //From. Added 小筆赳 2022.6.9
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => W2_2MyHomePage()),
                    );//To. Added 小筆赳 2022.6.9
                  },
                ),
              ],
              //),
            ),

            //課題リスト
            SizedBox(
              height: 500,
              child: ListView.builder(
                itemCount: tasks.length,
                itemBuilder: (context, index){
                  final task = tasks[index];
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
                              Icons.check_circle_outline,
                              color: Colors.green,
                            ),
                            onPressed: () async {
                              await TaskDatabase.instance.completeTask(task.id!);
                              if(task.isPrivate != '-1') {
                                TaskServer().addWhoCompleted(task.isPrivate,studentNum);
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
                        loadTasks();
                      },

                    ),
                  );
                },
              ),
            ),


            /*
                      title: Text(kadai_mi[index]['text']),
                      subtitle: Text(kadai_mi[index]['date']),

                      //チェックボタン
                      trailing: IconButton(
                        iconSize: 30,
                        icon: const Icon(Icons.check_circle_outline,),
                        onPressed: () {},
                      ),
                      //dense: true,

                      //クリックされた時の処理（提出済みに移動）//課題完了者一覧に
                      onTap: (){
                        //From. Added 小筆赳 2022.6.9
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => W4_Completed()),
                        );//To. Added 小筆赳 2022.6.9
                      },*/


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
      //課題追加ボタン
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          //From. Added 小筆赳 2022.6.9
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => W5_AddTask(),
            ),
          );//To. Added 小筆赳 2022.6.9
        },
        child: const Icon(Icons.add),
        backgroundColor: Colors.green,

      ),
    );
  }
}

void addAllTask(String studentNum){
  TaskServer().readAllTask("al20001");
}