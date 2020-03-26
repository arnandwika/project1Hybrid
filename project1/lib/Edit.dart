import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';

import 'main.dart';

void main() => runApp(Edit(0,"","",""));
void OpenDb() async{
  var databasesPath = await getDatabasesPath();
  String path = databasesPath +'project1.db';
  await deleteDatabase(path);
  database = await openDatabase(path);
//  print(database.isOpen);
  print(list);
}
Future<bool> databaseExists(String path) =>
    databaseFactory.databaseExists(path);
class EditRunner extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Edit(0,"","",""),
    );
  }
}

class Edit extends StatefulWidget{
  int id;
  String judul;
  String tanggal;
  String deskripsi;
  Edit(this.id,this.judul, this.tanggal, this.deskripsi);
  @override
  State createState(){
    return EditState(this.id,this.judul,this.tanggal, this.deskripsi);
  }
}

class HasilEdit{
  String judul;
  String tanggal;
  String isi;
  HasilEdit({this.judul,this.tanggal,this.isi});
  Map<String, dynamic> toMap(){
    return{
      'judul': judul,
      'isi': isi,
      'tanggal': tanggal,
    };
  }
}
class EditState extends State<Edit>{
  int id=0;
  String judul;
  String tanggal;
  String deskripsi;
  EditState(this.id,this.judul, this.tanggal, this.deskripsi);
  final TextJudulController = TextEditingController();
  final TextTanggalController = TextEditingController();
  final TextIsiController = TextEditingController();
  void updateDb(int id, String judulBaru, String tanggalBaru, String isiBaru) async{
    int count = await database.rawUpdate(
        'UPDATE reminder SET judul = ?, tanggal = ?, isi = ? WHERE id = ?',
        [judulBaru, tanggalBaru, isiBaru, id]);
    print('updated: $count');
    list = await database.rawQuery('SELECT * FROM reminder ORDER BY tanggal ASC');
}
  @override
  Widget build(BuildContext context) {
    HasilEdit h1;
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
              controller: TextJudulController,
            ),
            Text(
                'Tanggal'
            ),
            TextFormField(
              decoration: InputDecoration(
                  hintText: '${this.tanggal}'
              ),
              controller: TextTanggalController,
            ),
            Text(
                'Deskripsi'
            ),
            TextField(
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "${this.deskripsi}",
              ),
              controller: TextIsiController,
            ),
            RaisedButton(
              onPressed: () =>{
//                print(TextJudulController.text),
//                h1 = HasilEdit(judul: TextJudulController.text, tanggal: TextTanggalController.text, isi: TextIsiController.text),
              updateDb(id, TextJudulController.text, TextTanggalController.text, TextIsiController.text),
                print(list),
                Navigator.pop(context)
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