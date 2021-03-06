/*******************************************************
 *** File name      : W2_1MyHomePage
 *** Version        : V1.0
 *** Designer       : 二宮淑霞
 *** Purpose        : ホームページ2_2
 *******************************************************/
 
import 'package:flutter/material.dart';
//From. Added 小筆赳 2022.6.9
import 'W2-2_MyHomePage.dart';
import 'W3_Search.dart';
import 'W4_Completed.dart';
import 'W5_AddTask.dart';
import 'W6-1_MyPage.dart';
import 'package:intl/intl.dart';
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
  //From. Added 二宮淑霞 2022.7.3
  //サーバの課題をローカルに入れる。
  String studentNum= "";
  //未完了課題を格納
  List<Task> uncomTasks = [];
  void disPush() async{
    final SharedPreferences student = await SharedPreferences.getInstance();
    studentNum = student.getString('number') ?? '';
    TaskServer().readAllTask(studentNum);
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

  void uncompList(){
    uncomTasks = [];
    for(int j=0;j<tasks.length;j++){
      if(tasks[j].isCompleted==false){
        uncomTasks.add(tasks[j]);
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
    await TaskDatabase.instance.deleteExpiredTask();
    tasks = await TaskDatabase.instance.readAllTask();
    setState(() => isLoading = false);
    uncompList();
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
        width:  size.width,
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
                    primary: Colors.green,
                    onPrimary: Colors.white,
                    shape: const StadiumBorder(),
                  ),
                  onPressed: () {},
                  child: const Text('未提出'),
                ),
                ElevatedButton(
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
                          builder: (context) => const W2_2MyHomePage()),
                    );//To. Added 小筆赳 2022.6.9
                  },
                  child: const Text('提出済')
                ),
              ],
            ),
            //課題リスト
            SizedBox(
              height: 500,
              child: ListView.builder(
                itemCount: uncomTasks.length,
                itemBuilder: (context, index){
                  final task = uncomTasks[index];
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
                                    color: Colors.black,
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
                                Icons.check_circle_outline,
                                color: Colors.green,
                              ),
                              onPressed: () async {
                                await TaskDatabase.instance.completeTask(task.id!);
                                if(task.isPrivate != '-1') {
                                  TaskServer().addWhoCompleted(task.isPrivate,studentNum);
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
        onPressed: () async {
          //From. Added 小筆赳 2022.6.9
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const W5_AddTask(),
            ),
          );
          loadTasks();//To. Added 小筆赳 2022.6.9
        },
        backgroundColor: Colors.green,
        child: const Icon(Icons.add),
      ),
    );
  }
}
