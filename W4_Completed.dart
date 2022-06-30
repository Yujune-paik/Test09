import 'package:flutter/material.dart';
//From. Added 小筆赳 2022.6.9
import 'package:sqflite/sqflite.dart';
import 'Task_database_model.dart';
import 'package:intl/intl.dart';
import 'Task_database.dart';
import 'W7_Proflie.dart';
//To. Added 小筆赳 2022.6.9

class W4_Completed extends StatelessWidget {
/*
  List<String>result = [];//関数から持ってきた完了者リスト
  result = add_WhoCompleted(tasks.task);
  追加した課題を消す処理も必要かも
*/
//遷移元から渡される変数を保持する変数を作る
List<String> result = [];
W4_Completed(this.result);

List<String> Completed = [];


  @override
  Widget build(BuildContext context) {
    final double dH = MediaQuery.of(context).size.height; //画面のHeight
    final double dW = MediaQuery.of(context).size.width;  //画面のWidth
    double std_font_size = dH*0.03; //標準的な文字サイズ
    String _state="不明";  //提出状況
    int judge_state=0;  //0で未提出，それ以外で提出済
    List<String> Student_id = [//完了者を表示、サーバから持ってくる
      "AA11111",
      "AA11112",
      "AA11113",
    ];

    if(judge_state==0) {
      _state="未提出";
    } else {
      _state="提出済";
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,

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
                      //W2から課題情報をひっぱてきて日時を表示
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
                              //From. Added 小筆赳 2022.6.12
                              child: TextButton(
                              child: Text(Student_id[i], style: TextStyle(fontSize: std_font_size, fontWeight: FontWeight.w400)),
                            onPressed: (){
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => W7_Profile()),
                              );
                            },
                              ),
                              //To. Added 小筆赳 2022.6.12
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
                    ButtonBar(
                      children: [
                      ElevatedButton(
                      child: const Text('削除'),
                      style: ElevatedButton.styleFrom(
                      primary: Colors.grey,
                      onPrimary: Colors.white,
                      shape: const StadiumBorder(),
                      ),
                      onPressed: () {}
                      )
                      ]
                    )
                  ]
              ),
          ]
      ),
    );
  }

  void delete_Task() {
  }

Future<int> deleteTask(int id) async {
  var instance;
  final db = await instance.database;
  return await db.delete(
    tableTasks,
    where: '${TaskFields.id} = ?',
    whereArgs: [id],
  );
}

}