import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class W7_Profile extends StatelessWidget {
    final List<String> entries = <String>['A', 'B', 'C'];

    @override
    Widget build(BuildContext context) {
        return Scaffold(
            appBar: AppBar(
                title: Text('課題名'),//飛ぶ前のページと同じ課題名(書かなくてもいいかも)
            ),
            body: Column(
            children: <Widget>[
                Text(
                    'AA00000', 
                    style: TextStyle(fontWeight: FontWeight.bold, height: 1.5, fontSize: 40),
                ),            
                const Divider(
                    height: 10,
                    thickness: 3,
                    indent: 20,
                    endIndent: 20,
                    color: Colors.green,
                ),
                Container(
                height: 125,
                padding: const EdgeInsets.all(4),
                // 各アイテムの間にスペースなどを挟みたい場合
                child: entries.length > 0
                    ? ListView.separated(
                    itemCount: entries.length,
                    itemBuilder: (context, index) {
                        return Container(
                        child: Text(entries[index]),
                        );
                    },
                    separatorBuilder: (context, index) {
                        return const Divider();
                    },
                    )
                    : const Center(child: Text('No items')),
                ),
            ],
            ),
        );
    }
}
