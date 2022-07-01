import 'package:flutter/material.dart';
// From. Added 小筆赳 2022.6.8
import 'package:kadai1/main.dart';
import 'W2-2_MyHomePage.dart';
import 'W2-1_MyHomePage.dart';
//To.Changed　小筆赳 2022.6.9

// From. Changed 小筆赳 2022.6.8
class W1_LoginPage extends StatelessWidget{
/*class LoginScreen extends StatelessWidget{
  const LoginScreen({Key? key}) : super(key: key);*/
//To. Changed 小筆赳 2022.6.8
  @override
  Widget build(BuildContext context)  {
    var  Size= MediaQuery.of(context).size;
    return Scaffold(

      backgroundColor: Colors.lightGreenAccent,
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
                  const Text('ID'),
                  TextFormField(),
                  const Text('パスワード'),
                  TextFormField(),
                  RaisedButton(
                    child:const Text('ログイン'),
                    onPressed: (){
                      //ここに押したら反応するコードを書く
                      Navigator.push( //From Added 小筆赳 2022.6.6
                        context,
                        MaterialPageRoute(
                            builder: (context) => W2_1_MyHomePage()),
                      );//To.Changed　小筆赳 2022.6.9

                    },
                  )
                ],
              ),
            ),
          ),],),),
    );

  }

}