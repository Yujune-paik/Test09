import 'package:flutter/material.dart';

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
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double dH = MediaQuery.of(context).size.height;
    final double dW = MediaQuery.of(context).size.width;
    double std_font_size = dH*0.03;
    String _state="提出済";
    List<String> Student_id = [
      "AA11111",
      "AA11112",
      "AA11113",
    ];

    if(_counter==0) {
      _state="未提出";
    } else {
      _state="提出済";
    }

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color(0xFF8fab59),
        ),
        body: Column(
            children: <Widget>[
              Container(
                margin:EdgeInsets.fromLTRB(0, dH*0.01, 0, dH*0.005),
                child: Text('課題名', style: TextStyle(fontSize: dH*0.04, fontWeight: FontWeight.bold)),
              ),
              Divider(
                color: Color(0xFF8fab59),
                thickness: 3,
                height: 0,
                indent:25,
                endIndent: 25,
              ),
              Container(
                margin:EdgeInsets.all(10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.fromLTRB(dW*0.12, 0, 0, 0),
                      child: Text('科目', style: TextStyle(fontSize: std_font_size, fontWeight: FontWeight.bold)),
                    ),
                    Container(
                      padding: EdgeInsets.fromLTRB(0, 0, dW*0.12, 0),
                      child: Text('科目名', style: TextStyle(fontSize: std_font_size, fontWeight: FontWeight.bold)),
                    )
                  ]
                ),
              ),
              Divider(
                color: Colors.black26,
                thickness: 3,
                height: 0,
                indent:40,
                endIndent: 40,
              ),
              Container(
                margin:EdgeInsets.all(10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(dW*0.12, 0, 0, 0),
                        child: Text('締切', style: TextStyle(fontSize: std_font_size, fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        padding: EdgeInsets.fromLTRB(0, 0, dW*0.12, 0),
                        child: Text('〇月〇日 XX:XX', style: TextStyle(fontSize: std_font_size, fontWeight: FontWeight.bold)),
                      )
                    ]
                ),
              ),
              Divider(
                color: Colors.black26,
                thickness: 3,
                height: 0,
                indent:40,
                endIndent: 40,
              ),
              Container(
                margin:EdgeInsets.all(10),
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Container(
                        padding: EdgeInsets.fromLTRB(dW*0.12, 0, 0, 0),
                        child: Text('提出状況', style: TextStyle(fontSize: std_font_size, fontWeight: FontWeight.bold)),
                      ),
                      Container(
                        margin: EdgeInsets.fromLTRB(0, 0, dW*0.12, 0),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.black54,
                        ),
                        padding: EdgeInsets.fromLTRB(dW*0.03, dH*0.005, dW*0.03, dH*0.005),
                        child: Text('$_state', style: TextStyle(fontSize: std_font_size, color: Colors.white, fontWeight: FontWeight.w400)),
                      )
                    ]
                ),
              ),
              Divider(
                color: Color(0xFF8fab59),
                thickness: 3,
                height: 0,
                indent:25,
                endIndent: 25,
              ),
              Container(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Container(
                    margin:EdgeInsets.fromLTRB(dW*0.1, dH*0.025, 0, dH*0.01),
                    child: Text('課題完了者一覧', style: TextStyle(fontSize: std_font_size, fontWeight: FontWeight.bold)),
                    ),
                  ]
                ),
              ),
              Divider(
                color: Colors.black26,
                thickness: 3,
                height: 0,
                indent:40,
                endIndent: 40,
              ),

              //ここから提出者のリストを作らなくてはいけないが，分からないのでとりあえず一人分の表示だけ行う

              for(int i = 0; i<3; i++)
                Column(
                    children: <Widget>[
                      Container(
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Container(
                                margin:EdgeInsets.fromLTRB(dW*0.15, dH*0.01, 0, dH*0.01),
                                child: Icon(
                                  Icons.assignment_ind,
                                  size: std_font_size,
                                ),
                              ),
                              Container(
                                margin:EdgeInsets.fromLTRB(dW*0.02, dH*0.01, 0, dH*0.01),
                                child: Text(Student_id[i], style: TextStyle(fontSize: std_font_size, fontWeight: FontWeight.w400)),
                              ),
                            ]
                        ),
                      ),
                      Divider(
                        color: Colors.black26,
                        thickness: 3,
                        height: 0,
                        indent:40,
                        endIndent: 40,
                      ),
                    ]
                ),
            ]
        ),
    );
  }
}
