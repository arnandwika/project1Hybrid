import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:project1/Reminder.dart';
import 'package:sqflite/sqflite.dart';

void main() => runApp(MyApp());
List<Map> list;
bool cekDB=false;
class MyApp extends StatelessWidget {
  // This widget is the root of your application.

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
        routes: <String, WidgetBuilder>{
          '/': (context) => FirstPage(),
          'home': (context) => Home(),
          '/openreminder': (context) => Reminder("","",""),
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
  List cards = new List.generate(list.length, (i)=>new CustomCard()).toList();
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
                      builder: (context)=> Tambah()
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

void BuatDb() async{
  cekDB=true;
  var databasesPath = await getDatabasesPath();
  String path = databasesPath +'project1.db';
  await deleteDatabase(path);
  Database database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async{
        await db.execute(
          "CREATE TABLE reminder(id INTEGER PRIMARY KEY AUTOINCREMENT, judul TEXT, isi TEXT, tanggal TEXT)",);
      }
  );
  ObjectReminder o1 = ObjectReminder(judul:"coba1", tanggal:"2020-12-20",isi:"pengujian");
  ObjectReminder o2 = ObjectReminder(judul:"coba2", tanggal:"2020-03-20",isi:"pengujian");
  database.insert('reminder', o1.toMap());
  database.insert('reminder', o2.toMap());
  list = await database.rawQuery('SELECT * FROM reminder');
  print(list.length);
}
int i=0;
class CustomCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  new Card(
      child: InkWell(
        onTap: (){
          Navigator.push(context, MaterialPageRoute(
            builder: (context) =>Reminder("tes","16-03-2020","Lorem adslgfjkhasldgfjh"),
          ),);
        },
        child: new Column(
          children: <Widget>[
            Text(list[i]['judul']),
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
            Text(""),
            Text(""),
          ],
        ),
      ),
    );
  }
}

class Tambah extends StatelessWidget{
  DateTime _date = new DateTime.now();
  TimeOfDay _time = new TimeOfDay.now();

  Future<Null> _selectDate(BuildContext context) async{
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: _date,
        firstDate: new DateTime(2010),
        lastDate: new DateTime(2030)
    );
    if(picked != null && picked != _date){
      print("Date Selected: ${_date.toString()}");
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
      ),
      body: new Padding(padding: EdgeInsets.all(15.0),
        child: new Column(
          children: <Widget>[
            new TextField(
              decoration: InputDecoration(
                hintText:"Judul",
              ),
            ),
            new Text('Date Selected: ${_date.toString()}'),
            new RaisedButton(
              child: new Text('Select date'),
                onPressed: (){_selectDate(context);}
            ),
            new TextField(
              maxLines: 5,
              decoration: InputDecoration(
                hintText: "Description",
              ),
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