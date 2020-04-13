
import 'package:date_format/date_format.dart';
import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:async';
import 'package:intl/intl.dart';
import 'package:project1/Reminder.dart';
import 'package:sqflite/sqflite.dart';

import 'DB.dart';

void main() => runApp(MyApp());
List<Map> list;
List<Map> listHistory;
bool cekDB=false;
Color fix;
Color hijau = Colors.lightGreenAccent[400];
Color amber = Colors.amber;
Color merah = Colors.red;

//Future selectNotification(String payload) async {
//  if (payload != null) {
//    debugPrint('notification payload: ' + payload);
//  }
//  await Navigator.push(
//    context,
//    MaterialPageRoute(builder: (context) => SecondScreen(payload)),
//  );
//}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
        routes: <String, WidgetBuilder>{
          '/': (context) => FirstPageState(),
          '/home': (context) => Home(),
          '/openreminder': (context) => Reminder(0,"","",""),
          '/history': (context) => History(),
        }
    );
  }
}

class FirstPageState extends StatefulWidget{
  @override
  FirstPage createState()=> new FirstPage();
}

class FirstPage extends State<FirstPageState>{
  String title;
  String content;
  void initState() {
    super.initState();
    initializing();
  }
  
  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  AndroidInitializationSettings androidInitializationSettings;
  IOSInitializationSettings iosInitializationSettings;
  InitializationSettings initializationSettings;

  void initializing() async {
    androidInitializationSettings = AndroidInitializationSettings('ic_launcher');
    iosInitializationSettings = IOSInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
    initializationSettings = InitializationSettings(
        androidInitializationSettings, iosInitializationSettings);
    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onSelectNotification: onSelectNotification);
  }

  Future onSelectNotification(String payLoad) {
    if (payLoad != null) {
      print(payLoad);
    }

    // we can set navigator to navigate another screen
  }

  Future onDidReceiveLocalNotification(
      int id, String title, String body, String payload) async {
    return CupertinoAlertDialog(
      title: Text(title),
      content: Text(body),
      actions: <Widget>[
        CupertinoDialogAction(
            isDefaultAction: true,
            onPressed: () {
              print("");
            },
            child: Text("Okay")),
      ],
    );
  }
  void showNotifications(String s1, String s2, int i) async {
    await notification(s1,s2,i);
  }

  Future<void> notification(String s1, String s2, int i) async {
    AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
        'Channel ID', 'Channel title', 'channel body',
        priority: Priority.High,
        importance: Importance.Max,
        ticker: 'test');

    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();

    NotificationDetails notificationDetails =
    NotificationDetails(androidNotificationDetails, iosNotificationDetails);
    await flutterLocalNotificationsPlugin.show(
        i, s1, s2, notificationDetails);
  }

  void showScheduledNotifications(String s1, String s2, int i, alarm) async {
    await scheduledNotification(s1,s2,i, alarm);
  }

  Future<void> scheduledNotification(String s1, String s2, int i, alarm) async {
    var scheduledTime = DateTime.now().add(Duration(seconds: alarm));
    print(scheduledTime);
    AndroidNotificationDetails androidNotificationDetails =
    AndroidNotificationDetails(
        'Channel ID', 'Channel title', 'channel body',
        priority: Priority.High,
        importance: Importance.Max,
        ticker: 'test');

    IOSNotificationDetails iosNotificationDetails = IOSNotificationDetails();

    NotificationDetails notificationDetails =
    NotificationDetails(androidNotificationDetails, iosNotificationDetails);
    await flutterLocalNotificationsPlugin.schedule(
        i, s1, s2,scheduledTime, notificationDetails);
  }
  Future<void> cekSisa(String tgl,int i) async{
    DateTime waktu = DateTime.now();
    DateTime pembanding = convertDateFromString(tgl);
    Duration diff= waktu.difference(pembanding);
    if(diff.inSeconds>=-259200 && diff.inSeconds<=0){
      print(diff.inSeconds);
      int alarm = (diff.inSeconds - diff.inSeconds - diff.inSeconds) - 86400;
      String gabungan = "Akan berlangsung pada ${tgl}";
      if(alarm>=0){
        await showScheduledNotifications(list[i]['judul'].toString(),gabungan,i,alarm);
      }else{
        await showNotifications(list[i]['judul'].toString(),gabungan,i);
      }
    }
  }
  void notif() async{
    await OpenDb();
    if(list.length!=null){
      for(int i=0; i<list.length;i++){
        cekSisa(list[i]['tanggal'].toString(), i);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
//    if(cekDB==false){
//      BuatDb();
//      cekDB=true;
//      print(cekDB);
//    }

    notif();
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("Reminder"),
        backgroundColor: Colors.deepOrange,
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
                  onPressed: () async =>{
//                    await OpenDb(),
//
                    Navigator.pushNamed(context, '/home'),
                  },
                  child: new Text("List Reminder"),
                ),
                new RaisedButton(
                  onPressed: () async =>{
                    await searchHistory(),
                    Navigator.pushNamed(context, '/history')
                  },
                  child: new Text("History"),
                ),
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
  List cards = new List.generate(list.length, (int index)=>new StateCard(index)).toList();


  @override
  void initState() {
    super.initState();
  }

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

//Future BuatDb() async{
//  if(database==null){
//    var databasesPath = await getDatabasesPath();
//    String path = databasesPath +'project1.db';
//    await deleteDatabase(path);
//    database = await openDatabase(
//        path,
//        version: 1,
//        onCreate: (db, version) async{
//          await db.execute(
//            "CREATE TABLE reminder(id INTEGER PRIMARY KEY AUTOINCREMENT, judul TEXT, isi TEXT, tanggal TEXT)",);
//        }
//    );
////    ObjectReminder o1 = ObjectReminder(judul:"harusnya ketiga", tanggal:"2020-12-20 23:30",isi:"pengujian");
////    ObjectReminder o2 = ObjectReminder(judul:"harusnya pertama", tanggal:"2020-03-20 07:30",isi:"pengujian yang kedua");
////    ObjectReminder o3 = ObjectReminder(judul:"harusnya kedua", tanggal:"2020-04-15 22:00",isi:"pengujian yang kedua");
////    database.insert('reminder', o1.toMap());
////    database.insert('reminder', o2.toMap());
////    database.insert('reminder', o3.toMap());
//  }
//  OpenDb();
//  print(list);
//}
Future InsertDb(String judul, String tanggal, String isi) async{
  DB helper = DB.instance;
  await helper.insertReminder(judul, tanggal, isi);
}
Future OpenDb() async{
  DB helper = DB.instance;
  DateTime waktu = DateTime.now();
  String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(waktu);
  list = await helper.listReminder(formattedDate);
}
DateTime convertDateFromString(String strDate){
  DateTime todayDate = DateTime.parse(strDate);
  return todayDate;
}
Color selectColor(String tgl){
  DateTime waktu = DateTime.now();
  DateTime pembanding = convertDateFromString(tgl);
  Duration diff= waktu.difference(pembanding);
  if(diff.inHours>=-72 && diff.inHours<=0){
    return merah;
  }else if(diff.inHours>=-168){
    return amber;
  }else{
    return hijau;
  }
}

class StateCard extends StatefulWidget{
  int i;
  StateCard(this.i);
  @override
  CustomCard createState()=> new CustomCard(i);
}

class CustomCard extends State<StateCard> {
  int i;
  CustomCard(this.i);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Card(
      color: selectColor(list[i]['tanggal']),
      child: InkWell(
        onTap: (){
          Navigator.of(context).push(MaterialPageRoute<String>(
            builder: (BuildContext context) {
              return Reminder(
                  list[i]['id'],list[i]['judul'],list[i]['isi'],list[i]['tanggal']
              );
            }
          )).then((String str){
//            setState(){};
          });
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

  @override
  void initState() {
    super.initState();
  }

  String tanggalJam=" ";
  ObjectReminder objectInsert;
  final _JudulEditingController = TextEditingController();
  final _IsiEditingController = TextEditingController();
  final format = DateFormat("yyyy-MM-dd HH:mm");
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        backgroundColor: Colors.deepOrange,
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
              onPressed: () async {
                await InsertDb(_JudulEditingController.text, tanggalJam, _IsiEditingController.text);
                await OpenDb();
                Navigator.pop(context);
                Navigator.pop(context);
                Navigator.pushNamed(context, '/home');
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
class History extends StatefulWidget{
  @override
  MyHistory createState()=> new MyHistory();
}

class MyHistory extends State<History>{
  @override
  void initState() {
    super.initState();
  }

  int jmlh = listHistory.length;
  List cards = new List.generate(listHistory.length, (int index)=>new CardHistory(index)).toList();
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
//        floatingActionButton: new FloatingActionButton(
//            elevation: 0.0,
//            child: new Icon(Icons.add_circle),
//            backgroundColor: new Color(0xFFE57373),
//            onPressed: (){
//              Navigator.push(
//                  context,
//                  MaterialPageRoute(
//                      builder: (context)=> StateTambah()
//                  )
//              );
//            }
//        )
    );
  }
}

Future searchHistory() async{
  DB helper = DB.instance;
  DateTime waktu = DateTime.now();
  String formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(waktu);
  listHistory = await helper.listHistory(formattedDate);
}

class CardHistory extends StatelessWidget {
  int i;
  CardHistory(this.i);
  @override
  Widget build(BuildContext context) {
    return new Card(
      child: InkWell(
        onTap: ()=>{
          Navigator.push(context, MaterialPageRoute(
            builder: (context) =>Reminder(
                listHistory[i]['id'],listHistory[i]['judul'],listHistory[i]['isi'],listHistory[i]['tanggal']
            ),
          ),
          ),
        },
        child: new Column(
          children: <Widget>[
            Text(listHistory[i]['judul']+" "+listHistory[i]['id'].toString()),
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
            Text(listHistory[i]['tanggal']),
            Text(listHistory[i]['isi']),
          ],
        ),
      ),
    );
  }
}