import 'package:flutter/material.dart';

import 'Edit.dart';

void main() => runApp(Reminder("","",""));


class Reminder extends StatelessWidget{
  String judul;
  String tanggal;
  String deskripsi;
  Reminder(this.judul,this.tanggal,this.deskripsi);
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
              '${this.judul}',
              style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 30
              ),
            ),
            Text(
              '${this.tanggal}',
              style: TextStyle(
                fontSize: 14,
              ),
            ),
            SingleChildScrollView(
              child: Container(
                height: 200,
                child: Text(
                    '${this.deskripsi}'
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
                          builder: (context) =>Edit(judul,this.tanggal,this.deskripsi),
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