import 'package:flutter/material.dart';

import 'Edit.dart';
import 'main.dart';


void main() => runApp(Reminder(0));


class Reminder extends StatelessWidget{
  int id=0;
  void printList() async{
    list = await database.rawQuery("SELECT * FROM reminder WHERE id="+id.toString()+"");
  }
  Reminder(this.id);
    @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Text(
              list[0]['judul'].toString(),
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30
              ),
            ),
            Text(
              list[0]['tanggal'].toString(),
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            SingleChildScrollView(
              child: Container(
                height: 200,
                child: Text(
                    list[0]['isi'].toString()
                ),
              ),
            ),
            Container(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Expanded(
                    child: RaisedButton(
                      onPressed: () => {

                      },
                      color: Colors.deepOrangeAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0),
                      ),
                      child: Text(
                        "Hapus",
                        style: TextStyle(
                            fontSize: 20
                        ),),
                    ),
                  ),
                  Expanded(
                    child: RaisedButton(
                      onPressed: () => {
                        Navigator.push(context, MaterialPageRoute(
                          builder: (context) =>Edit(id, list[0]['judul'].toString(), list[0]['tanggal'].toString(), list[0]['isi'].toString()),
                        )),
                      },
                      color: Colors.deepOrangeAccent,
                      shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(18.0),
                      ),
                      child: Text("Edit",
                        style: TextStyle(
                            fontSize: 20
                        ),),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}