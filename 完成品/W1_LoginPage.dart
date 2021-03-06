import 'package:flutter/material.dart';
// From. Added 小筆赳 2022.6.8
import 'main.dart';
import 'W2-2_MyHomePage.dart';
import 'W2-1_MyHomePage.dart';
import 'Login.dart';
import 'TaskServer.dart';


class W1_LoginPage extends StatelessWidget{

/*class LoginScreen extends StatelessWidget{
  const LoginScreen({Key? key}) : super(key: key);*/
//To. Changed 小筆赳 2022.6.8
  @override
  Widget build(BuildContext context)  {
    var  Size= MediaQuery.of(context).size;

    //Future<List> _futureOfList = Login().check("al21821");//ログイン処理
    TextEditingController ID= TextEditingController();
    //var integerFromTextfield = ID.text;

    TextEditingController password= TextEditingController();
    //var integerFromTextfield = password.text;

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
                  RaisedButton(
                    child:const Text('ログイン'),
                    onPressed: () async {
                      //flag = Login().check(ID.text,password.text);
                      //変更後(2022-07-05 15:19千手)
                      int results = 0;
                      if(password.text!=""&&ID.text!= "") {
                        Future<int> _futureOfList = Login().check(ID.text,password.text);
                        results = await _futureOfList;
                      }
                      /*変更前
                      Future<int> _futureOfList = Login().check(ID.text,password.text);
                      int results = await _futureOfList;
                      */
                      print(results);
                      print(password.text);
                      if (results == 1){
                        //ここに押したら反応するコードを書く

                        TaskServer().readAllTask(ID.text);
                        //From Added 小筆赳 2022.6.6
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => W2_1_MyHomePage(/*ID.text,list*/)
                          ),
                        );
                      }
                      else if(results == 0){
                        showDialog(
                            context: context,
                            builder: (BuildContext context) =>
                                AlertDialog(
                                  title: Text("エラー"),
                                  content: Text('IDかパスワードが違います'),
                                )
                          //To.Changed　小筆赳 2022.6.9
                        );
                      }

                    },
                  )
                ],
              ),
            ),
          ),],),),
    );

  }

}