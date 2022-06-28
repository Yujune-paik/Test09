import 'dart:async';
import 'package:mysql1/mysql1.dart';
import 'package:mysql_utils/mysql_utils.dart';

Future main() async {
  // データベース接続（mysql1）
  final conn = await MySqlConnection.connect(ConnectionSettings(
      host: '160.16.141.77',
      port: 50900,
      user: 'app09',
      db: 'App_db',
      password: 'pracb2022'));

//データベース接続（mysql_utils)
  var db = MysqlUtils(
      settings: {
        'host': '160.16.141.77',
        'port': 50900,
        'user': 'app09',
        'password': 'pracb2022',
        'db': 'App_db',
        'maxConnections': 10,
        'secure': false,
        'prefix': '',
        'pool': true,
        'collation': 'utf8mb4_general_ci',
      },
      errorLog: (error) {
        print(error);
      },
      sqlLog: (sql) {
        print(sql);
      },
      connectInit: (db1) async {
        print('whenComplete');
      });

//select文
  var studentNum = "al21821";
  var row = await db.getAll(
    table: 'StudentInfo',
    fields: 'StudentNum,PassWord',
    where: {'StudentNum': '$studentNum'},
  );
  print(row);


//insert文
  var passWord = "hensuu";
  var courseId = "tukattetuika";

  var result = await conn.query(
      "INSERT INTO StudentInfo (StudentNum, PassWord, CourseId) VALUES ('$studentNum','$passWord', '$courseId')");

  // Finally, close the connection
  await conn.close();
  await db.close();
}
