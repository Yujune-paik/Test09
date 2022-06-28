import 'package:mysql1/mysql1.dart';
import 'dart:async';
import 'W6-1_MyPage.dart';
void main() {
  print("connecting...");
  _connect();
}





Future<void> _connect() async  {

  final conn = await MySqlConnection.connect(ConnectionSettings(
      host: '160.16.141.77',
      port: 50900,
      user: 'app09',
      db: 'App_db',
      password: 'pracb2022'));
  print("connected");

  Data data =  Data();
  var studentNum = data.num;
  var addressName = data.name;
  var address = data.address;

 await conn.query("INSERT INTO StudentAddr (StudentNum, AddressName, Address) VALUES ('$studentNum','$addressName', '$address')");
  await conn.close();

}


