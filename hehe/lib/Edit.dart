import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sqflite/sqflite.dart';

import 'Reminder.dart';
import 'main.dart';
import 'DB.dart';

void main() => runApp(Edit(0,"","",""));
//void OpenDbEdit() async{
//  DB helper = DB.instance;
//  var databasesPath = await getDatabasesPath();
//  String path = databasesPath +'project1.db';
//  await deleteDatabase(path);
//  database.db = await openDatabase(path);
////  print(database.isOpen);
//  print(list);
//}
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
    DB helper = DB.instance;
    int count = await helper.editReminder(judulBaru, tanggalBaru, isiBaru, id);
    print('updated: $count');
    DateTime waktu = DateTime.now();
    String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(waktu);
    list = await helper.listReminder(formattedDate);
}
  final format = DateFormat("yyyy-MM-dd HH:mm");
  String tanggalJam="";
  @override
  Widget build(BuildContext context) {
    HasilEdit h1;
    TextJudulController.text = this.judul;
    TextIsiController.text = this.deskripsi;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.deepOrange,
      ),
      body: Container(
        padding: EdgeInsets.all(20.0),
        child: Column(
          children: <Widget>[
            Text(""),
            TextFormField(
              decoration: InputDecoration(
                  hintText: '${this.judul}',
                  border: OutlineInputBorder()
              ),
              controller: TextJudulController,
            ),
            Text(""),
            DateTimeField(
              format: format,
              decoration: InputDecoration(
                hintText: '${this.tanggal}',
                border: OutlineInputBorder()
              ),
              onShowPicker: (context, currentValue) async {
                final date = await showDatePicker(
                    context: context,
                    firstDate: DateTime(1900),
                    initialDate: currentValue ?? DateTime.now(),
                    lastDate: DateTime(2100));
                if (date != null) {
                  final time = await showTimePicker(
                    context: context,
                    initialTime:
                    TimeOfDay.fromDateTime(currentValue ?? DateTime.now()),
                  );
                  tanggalJam = (DateTimeField.combine(date, time)).toString();
                  return DateTimeField.combine(date, time);
                } else {
                  return currentValue;
                }
              },
            ),
            Text(""),
            TextField(
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "${this.deskripsi}",
                border: OutlineInputBorder(),
              ),
              controller: TextIsiController,
            ),
            Text(""),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                RaisedButton(
                  onPressed: () async =>{
//                print(TextJudulController.text),
//                h1 = HasilEdit(judul: TextJudulController.text, tanggal: TextTanggalController.text, isi: TextIsiController.text),
                    await updateDb(id, TextJudulController.text, tanggalJam, TextIsiController.text),
                    print(list),
                    Navigator.pop(context),
                    Navigator.pop(context),
                    Navigator.push(context, MaterialPageRoute(builder: (context) => Reminder(id,TextJudulController.text,TextIsiController.text,tanggalJam)))
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

          ],
        ),
      ),
    );
  }
}