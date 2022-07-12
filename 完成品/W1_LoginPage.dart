/*******************************************************
 *** File name      : W1_LoginPage
 *** Version        : V1.0
 *** Designer       : 栗田遥生/小筆赳
 *** Purpose        : ログインページ
 *******************************************************/

import 'package:flutter/material.dart';
// From. Added 小筆赳 2022.6.8
import 'W2-1_MyHomePage.dart';
import 'Login.dart';
import 'TaskServer.dart';
//To.Changed　小筆赳 2022.6.9

// From. Changed 小筆赳 2022.6.8
class W1_LoginPage extends StatelessWidget{
//To. Changed 小筆赳 2022.6.8
  @override
  Widget build(BuildContext context)  {
    var  Size= MediaQuery.of(context).size;
    TextEditingController ID= TextEditingController();
    TextEditingController password= TextEditingController();

    return Scaffold(
      backgroundColor: Colors.green,
      body:
      Center(
        child:
        Stack(
          children:[Container(
            alignment: Alignment.center,
            height: Size.height*0.25,
            width: Size.width*0.7,
            color: Colors.white,
            child:Center(
              child: Column(
                children:[
                  TextFormField(
                    controller: ID,
                    decoration: const InputDecoration(
                        labelText: "ID :"
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter valid data';
                      }
                      return null;
                    },
                  ),
                  TextFormField(
                    controller: password,
                    decoration: const InputDecoration(
                        labelText: "パスワード :"
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter valid data';
                      }
                      return null;
                    },
                  ),
                  ElevatedButton(
                    child:const Text('ログイン'),
                    onPressed: () async {
                      //From Added 千手 2022-07-05
                      int results = 0;
                      if(password.text!=""&&ID.text!= "") {
                        Future<int> _futureOfList = Login().check(ID.text,password.text);
                        results = await _futureOfList;
                      }
                      //To.Changed 千手 2022-07-05
                      if (results == 1){
                        TaskServer().readAllTask(ID.text);
                        Navigator.pushReplacement( //From Added 小筆赳 2022.6.6
                          context,
                          MaterialPageRoute(
                            builder: (context) => const W2_1_MyHomePage(/*ID.text,list*/)
                          ),
                        );//To.Changed　小筆赳 2022.6.9
                      }
                      else if(results == 0){
                        showDialog(
                          context: context,
                          builder: (BuildContext context) =>
                            const AlertDialog(
                              title: Text("エラー"),
                              content: Text('IDかパスワードが違います'),
                          )
                        );
                      }
                    },
                  )
                ],
              ),
            ),
          ),
          ],
        ),
      ),
    );
  }
}
