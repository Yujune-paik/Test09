import 'package:flutter/material.dart';

class LoginScreen extends StatelessWidget{
  const LoginScreen({Key? key}) : super(key: key);

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

                          },
                        )
                    ],
                  ),
            ),
    ),],),),
    );

  }

}

