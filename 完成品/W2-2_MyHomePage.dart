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
import 'W6-1_MyPage.dart';
import 'package:intl/intl.dart';
import 'Task_database.dart';
import 'Task_database_model.dart';
import 'TaskServer.dart';
import 'package:shared_preferences/shared_preferences.dart';
//To. Added 小筆赳 2022.6.8


//ホーム画面(未提出)

class W2_2MyHomePage extends StatefulWidget {
  const W2_2MyHomePage({Key?key}) : super(key: key);

  @override
  _W2_2MyHomePageState createState() => _W2_2MyHomePageState();
}

class _W2_2MyHomePageState extends State<W2_2MyHomePage>{
  //From. 二宮淑霞 2022.7.3
  String studentNum= "";
  //完了した課題を格納
  List<Task> completeTasks = [];
  //画面遷移時に実行される関数,サーバの課題をローカルに入れる。
  void disPush() async{
    final SharedPreferences student = await SharedPreferences.getInstance();
    studentNum = student.getString('number') ?? '';
  }
  //To. Added 二宮淑霞 2022.7.3

  List<Task>tasks = [];
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    disPush();
    loadTasks();
  }

  void compList(){
    completeTasks = [];
    for(int j=0;j<tasks.length;j++){
      if(tasks[j].isCompleted==true){
        completeTasks.add(tasks[j]);
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    TaskDatabase.instance.closeDatabase();

  }

  Future loadTasks() async {
    setState(() => isLoading = true);
    //await TaskDatabase.instance.deleteExpiredTask();
    tasks = await TaskDatabase.instance.readAllTask();
    setState(() => isLoading = false);
    compList();
  }

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green, //アプリバーの背景色
        actions: <Widget>[
          ButtonBar(
            children: [
              IconButton(
                icon: const Icon(Icons.refresh,),
                onPressed: () {
                  loadTasks();
                },
              ),
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
        ],
      ),
      body:  Container(
        width: size.width,
        padding:const EdgeInsets.all(30),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            //課題検索ページへ
            ButtonBar(
              children: [
                TextButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green[800],
                    onPrimary: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              const W3_Search(title: '',/*read_AllTask*/)),
                    );
                  },
                  child: const Text('課題を検索する'),
                ),
              ],
            ),
            //課題の提出状態
            ButtonBar(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    onPrimary: Colors.green,
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () { //From. Added 小筆赳 2022.6.9
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const W2_1_MyHomePage()),
                    );
                  },
                  child: const Text('未提出'),//To. Added 小筆赳 2022.6.9
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                    onPrimary: Colors.white,
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () {},
                  child: const Text('提出済'),
                ),
              ],
            ),
            //課題リスト
            SizedBox(
              height: 500,
              child: ListView.builder(
                itemCount: completeTasks.length,
                itemBuilder: (context, index){
                  final task = completeTasks[index];
                  return Card(
                    child:InkWell(
                      child: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              children: [
                                (task.isPrivate != '-1') ?
                                Text(
                                  task.taskname,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                    //color: Colors.black,
                                  ),
                                )
                                :Text(
                                  task.taskname,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                    color: Colors.indigo,
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
                                await TaskDatabase.instance.deleteCompTask(task.id!);
                                //await TaskDatabase.instance.deleteTask(task.id!);
                                //await TaskDatabase.instance.addTask(task);
                                //task.isCompleted = false;
                                if(task.isPrivate != '-1') {
                                  TaskServer().deleteWhoCompleted(task.isPrivate,studentNum);
                                }
                                loadTasks();
                              },
                            ),
                          ],
                        ),
                      ),
                      onTap: () async {
                        SharedPreferences.setMockInitialValues({});
                        final SharedPreferences student = await SharedPreferences.getInstance();
                        student.setInt('taskid', task.id!);
                        if (!mounted) return;
                        await Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const W4_Completed(),
                          ),
                        );
                        loadTasks();
                      },
                    ),
                  );
                },
              ),
            ),
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
              builder: (context) => const W5_AddTask(),
            ),
          );
          //To. Added 小筆赳 2022.6.9
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}
