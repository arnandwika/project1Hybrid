import 'package:flutter/material.dart';

void main() => runApp(Edit("","",""));

class EditRunner extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Edit("","",""),
    );
  }
}

class Edit extends StatefulWidget{
  String judul;
  String tanggal;
  String deskripsi;
  Edit(this.judul, this.tanggal, this.deskripsi);
  @override
  State createState(){
    return EditState(this.judul,this.tanggal, this.deskripsi);
  }
}

class EditState extends State<Edit>{
  String judul;
  String tanggal;
  String deskripsi;
  EditState(this.judul, this.tanggal, this.deskripsi);

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
                'Judul'
            ),
            TextFormField(
              decoration: InputDecoration(
                  hintText: '${this.judul}'
              ),
            ),
            Text(
                'Tanggal'
            ),
            TextFormField(
              decoration: InputDecoration(
                  hintText: '${this.tanggal}'
              ),
            ),
            Text(
                'Deskripsi'
            ),
            TextField(
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "${this.deskripsi}",
              ),
            ),
            RaisedButton(
              onPressed: () =>{
                //save ke db lalu pop
              },
              child: Text("Save"),
            ),
            RaisedButton(
              onPressed: () =>{
                Navigator.pop(context),
              },
              child: Text("Cancel"),
            ),
          ],
        ),
      ),
    );
  }
}