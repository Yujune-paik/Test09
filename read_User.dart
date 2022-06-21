/*******************************************************************
 ***  File Name		: read_User.dart
 ***  Version		: V1.0
 ***  Designer		: 栗田　遥生
 ***  Date			: 2022.06.18
 ***  Purpose       	: サーバにユーザ情報を要求し、ユーザ情報を返す
 ***
 *******************************************************************/
import 'package:b1/LogInPage.dart';
import 'package:b1/my_page.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
class User {
  final String number;
  final String password;

  User(this.number, this.password);

  User.fromJson(Map<String, dynamic> json)
      : number = json['number'],
        password = json['password'];
}
class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}



class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;
  String _word = '';
  String _userNumber = '';
  String _userPass = '';

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }



  Future<void> _handleHttp() async {
   //var url = Uri.parse('tk2-406-44323.vs.sakura.ne.jp:50980');

    var response = await http.get(Uri.https(
        'www.googleapis.com',
        '/books/v1/volumes',
        {'q': '{Flutter}'}));


    if (response.statusCode == 200) {
      var jsonResponse = convert.jsonDecode(response.body) as Map<String, dynamic>;
      print("レスポンスBODY:${response.body}");
      User user=User.fromJson(jsonResponse);
      var itemCount = jsonResponse['totalItems'];
      setState(() {
        _counter = itemCount;
        _word = 'Flutter';
        _userNumber=user.number;
        _userPass=user.password;
      });

    } else {
      print('Request failed with status: ${response.statusCode}.');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              '「$_word」の検索結果:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _handleHttp,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}
