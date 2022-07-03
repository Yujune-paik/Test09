import 'LogInPage.dart';
import 'my_page.dart';
import 'package:flutter/material.dart';
import 'dart:convert' as convert;
import 'package:mysql_utils/mysql_utils.dart';
import 'dart:async';

void main() {
  print("connecting...");
  _connect();
}





Future<void> _connect() async  {
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


  var row = await db.getAll(
    table: 'CourseInfo',
    fields: '*',
  );
  print(row);

  await db.close();
}


