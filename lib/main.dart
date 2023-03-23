import 'package:flutter/material.dart';
import 'package:noteapp/first.dart';
import 'package:sqflite/sqflite.dart';

import 'DBHelper.dart';

void main() {
  runApp(MaterialApp(
    home: note(),
    debugShowCheckedModeBanner: false,
  ));
}

class note extends StatefulWidget {
  const note({Key? key}) : super(key: key);

  @override
  State<note> createState() => _noteState();
}

class _noteState extends State<note> {
  Database? db;

  List<Map> list = [];
  bool Status = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    DBHelper().opendb().then((value) {
      db = value;
      getdata();
    });
  }

  getdata() async {
    String qry = "select * from notes";
    await db!.rawQuery(qry).then((value) {
      print(value);
      list = value;
      Status = true;
      setState(() {
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(onPressed: () {}, icon: Icon(Icons.search)),
        ],
        title: Text('Samsung Notes'),
      ),
      body: Status ?  ListView.separated(
          itemBuilder: (context, index) {
            Map map = list[index];
            print(map);
            return ListTile(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return first(map: map,);
                    },
                  ),
                );
              },
              title: Text("${map["title"]}"),
              subtitle: Text("${map["subject"]}"),
              trailing: IconButton(onPressed: () {
                String qry = "delete from notes where id =${map['id']}";
                db!.rawDelete(qry).then((value) {
                  print("delete");
                  getdata();
                });
              }, icon: Icon(Icons.delete)),
            );
          },
          separatorBuilder: (context, index) {
            return Divider(
              color: Colors.black,
              height: 10,
            );
          },
          itemCount: list.length) : Center(child: CircularProgressIndicator()),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
              builder: (context) => first(),
            ),
          );
        },
        child: Icon(Icons.note_add_outlined),
      ),
    );
  }
}
