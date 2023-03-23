import 'package:flutter/material.dart';
import 'package:noteapp/DBHelper.dart';
import 'package:noteapp/main.dart';
import 'package:sqflite/sqflite.dart';

class first extends StatefulWidget {
  Map? map;

  first({this.map});

  @override
  State<first> createState() => _firstState();
}

class _firstState extends State<first> {
  TextEditingController t = TextEditingController(text: "");
  TextEditingController t1 = TextEditingController(text: "");

  Database? db;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    DBHelper().opendb().then((value) {
      db = value;
    });
    if (widget.map != null) {
      t.text = widget.map!["title"];
      t1.text = widget.map!["subject"];
    }
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          actions: [
            IconButton(
                onPressed: () async {
                  String title = t.text;
                  String subject = t1.text;

                  if (title.isNotEmpty && subject.isNotEmpty) {
                    if (widget.map == null) {
                      String qry =
                          "insert into notes (title,subject) values ('$title','$subject')";
                      await db!.rawInsert(qry).then((value) {
                        print(value);
                      });
                    } else {
                      String qry =
                          "update notes  set title='${title}',subject='${subject}' where id =${widget.map!['id']}";
                      db!.rawUpdate(qry).then((value) {
                        print(value);
                      });
                    }
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => note(),
                        ));
                  }
                },
                icon: Icon(Icons.save)),
          ],
        ),
        body: Column(
          children: [
            Container(
              margin: EdgeInsets.all(10),
              child: TextField(
                controller: t,
                decoration: InputDecoration(
                  hintText: 'Enter Title',
                  labelText: 'Title',
                  border: InputBorder.none,
                ),
              ),
            ),
            Container(
              margin: EdgeInsets.all(10),
              child: TextField(
                textInputAction: TextInputAction.newline,
                maxLines: null,
                controller: t1,
                decoration: InputDecoration(
                  hintText: 'Enter Typing',
                  border: InputBorder.none,
                ),
              ),
            ),
          ],
        ),
      ),
      onWillPop: onback,
    );
  }

  Future<bool> onback() {
    Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => note(),
        ));

    return Future.value();
  }
}
