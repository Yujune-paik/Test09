/*******************************************************
 *** File name      : W2_2MyHomePage
 *** Version        : V1.0
 *** Designer       : 二宮淑霞
 *** Purpose        : ホームページ2_2
 *******************************************************/
/*
*** Revision
 */
import 'W4_Completed.dart';
import 'package:flutter/material.dart';
import 'W2-1_MyHomePage.dart';
// From. Added 小筆赳 2022.6.8
import 'W3_Search.dart';
import 'W5_AddTask.dart';
import 'W7_Proflie.dart';
// To. Added 小筆赳 2022.6.8

//ホーム画面(提出済)
class W2_2MyHomePage extends StatelessWidget {

  //課題情報を格納
  final List<Map<String, dynamic>> kadai_zumi = [
    {
      'text': '課題 4',
      'date': '6/5 23:59',
    },
    {
      'text': '課題 5',
      'date': '6/5 23:59',
    },
    {
      'text': '課題 6',
      'date': '6/5 23:59',
    },
  ];


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
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => W7_Profile()),
                      );//To. Added 小筆赳 2022.6.9
                    },
                  ),
                ],
                //),
              ),

              //課題リスト
              SizedBox(
                height: 500,
                child: ListView.separated(
                  itemCount: kadai_zumi.length,
                  itemBuilder: (context, index){
                    return ListTile(
                      /*leading: const CircleAvatar(
                          backgroundColor: Colors.green,
                          child: Text(
                            kadai_mi[index]['date']
                          ),
                        ),*/
                      title: Text(kadai_zumi[index]['text']),
                      subtitle: Text(kadai_zumi[index]['date']),

                      //バックボタン
                      trailing: IconButton(
                        iconSize: 30,
                        icon: const Icon(Icons.arrow_circle_left_outlined,),
                        onPressed: () {
                          //delete_Task;
                          //add_Task;
                    //課題を未提出に戻す,delete_Task,add_Task
                        },
                      ),
                      //dense: true,

                      //クリックされた時の処理（W4）
                      onTap: (){
                        //From. Added 小筆赳 2022.6.9
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => W4_Completed()),
                        );//To. Added 小筆赳 2022.6.9
                      },

                    );
                  },
                  separatorBuilder: (context, index){
                    return const Divider();
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