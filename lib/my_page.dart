import 'package:flutter/material.dart';

class Mypage extends StatelessWidget{
  const Mypage({Key? key}) : super(key: key);

//時間割生成
  Widget _table(String name,double w,double h){
      return
        Table(
            border: TableBorder.all(),
            children:[
              for(int i=0;i<6;i++)
              TableRow(children: [
                for(int i=0;i<6;i++)
              SizedBox(
                width: w,
                height: h*0.06,
                  child:
                  TableCell(child:Center(child:Text(name)))),
              ]),]);
  }

  @override
  Widget build(BuildContext context) {
    // ignore: non_constant_identifier_names
    final items = List<String>.generate(10000, (i) => "Item $i");
    var  Size= MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightGreen,
      ),

          body:
              Column(children:[
                Container(
                  color: Colors.green,

                  child:Table(
                    border: TableBorder.all(),
                    children: const [
                    TableRow(children: <Widget>[
                    TableCell(child:Center(child:Text('月'))),
                    TableCell(child:Center(child:Text('火'))),
                    TableCell(child:Center(child:Text('水'))),
                      TableCell(child:Center(child:Text('木'))),
                      TableCell(child:Center(child:Text('金'))),
                      TableCell(child:Center(child:Text('土'))),
                      ]),
                    ]),
                ),
                _table("a",Size.width,Size.height),
                 Align(
                  alignment: Alignment(Size.width*-0.0015,1),
                    child:const Text('公開する連絡先',
                    style:TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                    )),
                )

              ]),
    );


  }


}
