/*******************************************************
 *** File name      : W2_2MyHomePage
 *** Version        : V1.0
 *** Designer       : 二宮淑霞
 *** Purpose        : ホームページ2_1
 *******************************************************/
/*
*** Revision
 */
import 'package:flutter/material.dart';

void main() {
  runApp(W2_1MyHomePage());
}

//ホーム画面(未提出)
class W2_1MyHomePage extends StatelessWidget {

  //課題情報を格納
  final List<Map<String, dynamic>> kadai_mi = [
    {
      'text': '課題 1',
      'date': '6/5 23:59',
    },
    {
      'text': '課題 2',
      'date': '6/5 23:59',
    },
    {
      'text': '課題 3',
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

              //課題検索バー
              const TextField(

                style: TextStyle(
                  fontSize: 15,
                ),
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.all(10),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                    prefixIcon: Icon(Icons.search, color: Colors.grey,),
                    hintText:'課題を検索する'
                ),
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
                    onPressed: () {},
                  ),
                  ElevatedButton(
                    child: const Text('提出済'),
                    style: ElevatedButton.styleFrom(
                      primary: Colors.white,
                      onPrimary: Colors.green,
                      shape: const StadiumBorder(),
                    ),
                    onPressed: () {},
                  ),
                ],
                //),
              ),

              //課題リスト
              SizedBox(
                height: 500,
                child: ListView.separated(
                  itemCount: kadai_mi.length,
                  itemBuilder: (context, index){
                    return ListTile(
                      /*leading: const CircleAvatar(
                          backgroundColor: Colors.green,
                          child: Text(
                            kadai_mi[index]['date']
                          ),
                        ),*/
                      title: Text(kadai_mi[index]['text']),
                      subtitle: Text(kadai_mi[index]['date']),

                      //チェックボタン
                      trailing: IconButton(
                        iconSize: 30,
                        icon: const Icon(Icons.check_circle_outline,),
                        onPressed: () {},
                      ),
                      //dense: true,

                      //クリックされた時の処理（提出済みに移動）
                      onTap: (){

                      },

                    );
                  },
                  separatorBuilder: (context, index){
                    return const Divider();
                  },
                ),

              ),
              
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

          },
          child: const Icon(Icons.add),
          backgroundColor: Colors.green,

        ),

      ),
    );
  }
}
