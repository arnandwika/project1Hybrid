import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:project1/Reminder.dart';
import 'package:sqflite/sqflite.dart';

void main() => runApp(MyApp());
List<Map> list;

class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    BuatDb();
    OpenDb();
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
        routes: <String, WidgetBuilder>{
          '/': (context) => Home(),
          '/openreminder': (context) => Reminder(0,"","",""),
        }
    );
  }
}

class FirstPage extends StatelessWidget{
  @override
  Widget build(BuildContext context) {
    if(cekDB==false){
      BuatDb();
    }
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Reminder"),
      ),
      body: new Padding(
        padding: EdgeInsets.all(7.0),
        child: new Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                new RaisedButton(
                  onPressed: ()=>{
                    Navigator.pushNamed(context, 'home'),
                  },
                  child: new Text("List Reminder"),
                ),
                new RaisedButton(
                  onPressed: ()=>{},
                  child: new Text("History"),
                )
              ],
            )
          ],
        ),
      ),
    );
  }

}

class Home extends StatefulWidget{
  @override
  MyCard createState()=> new MyCard();
}

class MyCard extends State<Home>{
  int jmlh = list.length;
  List cards = new List.generate(list.length, (int index)=>new CustomCard(index)).toList();
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: new AppBar(
          title: new Text('Reminder'),
          backgroundColor: Colors.deepOrange,
        ),
        body: new Container(
            child: new ListView(
              children: cards,
            )

        ),
        floatingActionButton: new FloatingActionButton(
            elevation: 0.0,
            child: new Icon(Icons.add_circle),
            backgroundColor: new Color(0xFFE57373),
            onPressed: (){
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context)=> StateTambah()
                  )
              );
            }
        )
    );

  }
}

class ObjectReminder{
  String judul;
  String tanggal;
  String isi;
  ObjectReminder({this.judul,this.tanggal,this.isi});
  Map<String, dynamic> toMap(){
    return{
      'judul': judul,
      'isi': isi,
      'tanggal': tanggal,
    };
  }
}
Database database;
void BuatDb() async{
  cekDB=true;
  var databasesPath = await getDatabasesPath();
  String path = databasesPath +'project1.db';
  await deleteDatabase(path);
  database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async{
        await db.execute(
          "CREATE TABLE reminder(id INTEGER PRIMARY KEY AUTOINCREMENT, judul TEXT, isi TEXT, tanggal TEXT)",);
      }
  );
  ObjectReminder o1 = ObjectReminder(judul:"harusnya ketiga", tanggal:"2020/12/20",isi:"pengujian");
  ObjectReminder o2 = ObjectReminder(judul:"harusnya pertama", tanggal:"2020/03/20",isi:"pengujian yang kedua");
  ObjectReminder o3 = ObjectReminder(judul:"harusnya kedua", tanggal:"2020/04/19",isi:"pengujian yang kedua");
  database.insert('reminder', o1.toMap());
  database.insert('reminder', o2.toMap());
  database.insert('reminder', o3.toMap());
  OpenDb();
  print(list);
}
void InsertDb(ObjectReminder o1) async{
  database.insert('reminder',o1.toMap());
}
void OpenDb() async{
  list = await database.rawQuery('SELECT * FROM reminder ORDER BY tanggal ASC');
}
class CustomCard extends StatelessWidget {
  int i;
  CustomCard(this.i);
  @override
  Widget build(BuildContext context) {
    return new Card(
      child: InkWell(
        onTap: ()=>{
          Navigator.push(context, MaterialPageRoute(
            builder: (context) =>Reminder(
              list[i]['id'],list[i]['judul'],list[i]['isi'],list[i]['tanggal']
            ),
          ),
            ),
        },
        child: new Column(
          children: <Widget>[
            Text(list[i]['judul']+" "+list[i]['id'].toString()),
//            new Image.network('https://i.ytimg.com/vi/fq4N0hgOWzU/maxresdefault.jpg'),
            new Padding(
                padding: new EdgeInsets.all(7.0),
//                child: new Row(
//                  children: <Widget>[
//                    new Padding(
//                      padding: new EdgeInsets.all(7.0),
//                      child: new Icon(Icons.thumb_up),
//                    ),
//                    new Padding(
//                      padding: new EdgeInsets.all(7.0),
//                      child: new Text('Like',style: new TextStyle(fontSize: 18.0),),
//                    ),
//                    new Padding(
//                      padding: new EdgeInsets.all(7.0),
//                      child: new Icon(Icons.comment),
//                    ),
//                    new Padding(
//                      padding: new EdgeInsets.all(7.0),
//                      child: new Text('Comments',style: new TextStyle(fontSize: 18.0)),
//                    )
//
//                  ],
//                )
            ),
            Text(list[i]['tanggal']),
            Text(list[i]['isi']),
          ],
        ),
      ),
    );
  }
}

class StateTambah extends StatefulWidget{
  @override
  State createState() => Tambah();
}

class Tambah extends State<StateTambah>{
  String tanggalJam=" ";
  ObjectReminder objectInsert;
  final _JudulEditingController = TextEditingController();
  final _IsiEditingController = TextEditingController();
  final format = DateFormat("yyyy-MM-dd HH:mm");
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
      ),
      body: new Padding(padding: EdgeInsets.all(15.0),
        child: new Column(
          children: <Widget>[
            Text("Judul:"),
            new TextField(
              controller: _JudulEditingController,
              decoration: InputDecoration(
                hintText:"Judul",
              ),
            ),
            Text("Tanggal & Waktu:"),
            new DateTimeField(
              format: format,
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
            Text("Deskripsi:"),
            new TextField(
              controller: _IsiEditingController,
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Description",
              ),
            ),
            RaisedButton(
              child: Text("Save"),
              onPressed: (){
                objectInsert= new ObjectReminder(judul: _JudulEditingController.text, isi: _IsiEditingController.text, tanggal: tanggalJam);
                InsertDb(objectInsert);
                Navigator.pop(context);
              },
            )
          ],
        ),
      ),
    );
  }
}

//class _InputDropdown extends StatelessWidget {
//  const _InputDropdown(
//      {Key key,
//        this.child,
//        this.labelText,
//        this.valueText,
//        this.valueStyle,
//        this.onPressed})
//      : super(key: key);
//
//  final String labelText;
//  final String valueText;
//  final TextStyle valueStyle;
//  final VoidCallback onPressed;
//  final Widget child;
//
//  @override
//  Widget build(BuildContext context) {
//    return new InkWell(
//      onTap: onPressed,
//      child: new InputDecorator(
//        decoration: new InputDecoration(
//          labelText: labelText,
//        ),
//        baseStyle: valueStyle,
//        child: new Row(
//          mainAxisAlignment: MainAxisAlignment.spaceBetween,
//          mainAxisSize: MainAxisSize.min,
//          children: <Widget>[
//            new Text(valueText, style: valueStyle),
//            new Icon(Icons.arrow_drop_down,
//                color: Theme.of(context).brightness == Brightness.light
//                    ? Colors.grey.shade700
//                    : Colors.white70),
//          ],
//        ),
//      ),
//    );
//  }
//}