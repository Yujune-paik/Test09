import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        backgroundColor: Colors.white,
      ),
      home: MyPage(),
    );
  }
}

class MyPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text(
          '課題を追加',
          style: TextStyle(
            color: Colors.black,
          ),
        ),
        leading: TextButton(
          child: Text(
            '☓',
            style: TextStyle(
              color: Colors.black,
              fontWeight: FontWeight.bold,
              fontSize: 20.0,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        bottom: PreferredSize(
          child: Container(
            height: 5,
            color: Colors.green,
          ),
          preferredSize: Size.fromHeight(5),
        ),
      ),
      body: Container(
        padding: EdgeInsets.all(30),
        child: Column(
          children: [
            /*Container(
            child: const Text('科目'),
            height:100,
            width:200,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                border: const Border(
                  bottom: const BorderSide(
                    color: Colors.black12,
                    width: 3,
                  ),
                ),
              ),
            ),*/
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                /*border: OutlineInputBorder(),*/
                labelText: '科目',
              ),
            ),
            /*Container(
              child: const Text('課題'),
              height:100,
              width:200,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                border: const Border(
                  bottom: const BorderSide(
                    color: Colors.black12,
                    width: 3,
                  ),
                ),
              ),
            ),*/
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                //border: OutlineInputBorder(),
                labelText: '課題',
              ),
            ),
            /*Container(
              child: const Text('締め切り'),
              height:100,
              width:200,
              alignment: Alignment.centerLeft,
              decoration: BoxDecoration(
                border: const Border(
                  bottom: const BorderSide(
                    color: Colors.black12,
                    width: 3,
                  ),
                ),
              ),
            ),*/
            const TextField(
              obscureText: true,
              decoration: InputDecoration(
                //border: OutlineInputBorder(),
                labelText: '締め切り',
              ),
            ),
            Container(
              child: ElevatedButton(
                child: Text('追加'),
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  onPrimary: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                onPressed: () {},
              ),
            )
          ],
        ),
      ),
    );
  }
}
