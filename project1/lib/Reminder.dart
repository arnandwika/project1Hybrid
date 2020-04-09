import 'package:flutter/material.dart';

import 'Edit.dart';
import 'main.dart';


void main() => runApp(Reminder(0,"","",""));



class Reminder extends StatelessWidget{
  int id;
  String judul;
  String isi;
  String tanggal;
  Reminder(this.id, this.judul, this.isi, this.tanggal);
//  void printList() async{
//    list = await database.rawQuery("SELECT * FROM reminder WHERE id="+id.toString()+"");
//    print(list);
//  }
    @override
  Widget build(BuildContext context) {
      OpenDb();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
      ),
      body: Container(
        child: Column(
          children: <Widget>[
            Text(
              judul,
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30
              ),
            ),
            Text(
              tanggal,
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            SingleChildScrollView(
              child: Container(
                height: 200,
                child: Text(
                   isi
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
                          builder: (context) =>Edit(id,judul, tanggal, isi),
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