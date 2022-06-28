import 'dart:async';
import 'package:mysql1/mysql1.dart';
import 'package:mysql_utils/mysql_utils.dart';

class TaskServer {
  //データベースの情報
  var settings = new ConnectionSettings(
      host: '160.16.141.77',
      port: 50900,
      user: 'app09',
      db: 'App_db',
      password: 'pracb2022');

  //課題完了者を追加
  Future<void> addWhoCompleted(String taskId, String cplStudent) async {
    final conn = await MySqlConnection.connect(settings);

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

    var results = await db.getAll(
      table: 'TaskInfo',
      fields: 'TaskName, DeadLine, CourseId',
      where: {'TaskId': '$taskId'},
    );

    results
        .forEach((result) => result.toString().replaceAll("StudentNum :", ""));

    // var result = await conn.query(
    //     "INSERT INTO StudentInfo (StudentNum, PassWord, CourseId) VALUES ('$studentNum', '$passWord', '$courseId')");

    for (var row in results) {
      var result = await conn.query(
          "INSERT INTO TaskInfo (TaskId, TaskName, DeadLine, CourseId, CplStudent) VALUES ('$taskId', '${row[0]}', '${row[1]}', '${row[2]}', '$cplStudent')");
    }

    await conn.close();
    await db.close();
  }

  Future<List> read_AllTask(String studentNum) async {
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

    var results = await db.getAll(
      table: 'StudentInfo',
      fields: '*',
      where: {'StudentNum': '$studentNum'},
    );

    await db.close();

    return Future.value(results);
  }
}

void main() async {
  Future<List> _futureOfList = TaskServer().read_AllTask("al21821");
  List results = await _futureOfList;
      results
        .forEach((result) => result.toString().replaceAll("PassWord:", ""));
  results.forEach((result) => print(result));
}
