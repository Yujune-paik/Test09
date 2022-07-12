/*******************************************************
 *** File name      : main.dart
 *** Version        : V1.0
 *** Designer       : 小筆赳
 *** Purpose        : main処理
 *******************************************************/

import 'package:flutter/material.dart';
// From. Added 小筆赳 2022.6.8
import "W1_LoginPage.dart";
// To. Changed 小筆赳 2022.6.8

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '1b_Kadai',
      theme: ThemeData(
        primarySwatch: Colors.lightGreen,
      ),
      home: MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}
class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  // From. Changed 小筆赳 2022.6.8
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: W1_LoginPage());
  }
}//To.Changed　小筆赳 2022.6.9
