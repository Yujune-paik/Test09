import 'package:flutter/material.dart';


//ホーム画面
class W2_2MyHomePage extends StatelessWidget {

  //課題情報を格納
  final items = List<String>.generate(300, (i) => "Item $i");



  @override
  Widget build(BuildContext context) {

    //デバイスのサイズを獲得
    //final double deviceHeight = MediaQuery.of(context).size.height;

    return MaterialApp(
      title: 'UI',
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
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index){
                    return ListTile(
                      title: Text('${items[index]}'),
                    );
                  },
                ),
              ),
              IconButton(
                padding: const EdgeInsets.only(left: 400),
                icon: const Icon(Icons.add_circle),
                alignment: const Alignment(1,1),
                onPressed: () {},
                color: Colors.green,
                iconSize: 60,
              ),
            ],
          ),
        ),

      ),
    );
  }
}