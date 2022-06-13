import 'package:flutter/material.dart';
/*import 'package:b1/LogInPage.dart';
import 'package:b1/my_page.dart';
import 'package:flutter/material.dart';*/
// From. Added 小筆赳 2022.6.8
import 'package:coriander/W1_LoginPage.dart';
// To. Changed 小筆赳 2022.6.8

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
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
class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  //State<MyHomePage> createState() => _MyHomePageState();
  _MyHomePageState createState() => _MyHomePageState();
}
class _MyHomePageState extends State<MyHomePage> {
  // From. Changed 小筆赳 2022.6.8
  /*
  int _counter = 0;

  void _incrementCounter() {
    setState(() {

      _counter++;
    });
   */
  @override
  Widget build(BuildContext context) {
    return Scaffold(body: W1_LoginPage());
    /*return Scaffold(
      backgroundColor: Colors.lightGreen,
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body:
      Center(
        child:

        Column(


          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'You have pushed the button this many times:',
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headline4,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}*/

  }
}//To.Changed　小筆赳 2022.6.9
