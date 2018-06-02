import 'package:flutter/material.dart';
import 'package:time_capsule/Database/DatabaseClient.dart';
import 'dart:async';

import 'package:time_capsule/Models/TimeCapsule.dart';
import 'package:time_capsule/Repositories/TimeCapsuleRespository.dart';

class NewTimeCapsule extends StatefulWidget {
  @override
  _NewTimeCapsuleState createState() => new _NewTimeCapsuleState();
}

class _NewTimeCapsuleState extends State<NewTimeCapsule> {

  DatabaseClient _db = new DatabaseClient();
  TimeCapsuleRepository _timeCapsuleRepo;
  DateTime _date = new DateTime.now();
  TimeOfDay _time = new TimeOfDay.now();
  DateTime openDate = new DateTime.now();
  DateAsString openDateAsString = new DateAsString(new DateTime.now());
  final titleTextController = new TextEditingController();
  final messageTextController = new TextEditingController();

  @override
  void initState() async {
    super.initState();
    await _db.create();
    _timeCapsuleRepo = new TimeCapsuleRepository(_db.db);
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    titleTextController.dispose();
    messageTextController.dispose();
    super.dispose();
  }

  Future<Null> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: openDate,
        firstDate: _date,
        lastDate: new DateTime.now().add(new Duration(days: 365))
    );

    if (picked != null)
      {
        setState(() {
          openDate = new DateTime(picked.year, picked.month, picked.day,
            openDate.hour, openDate.minute);
          openDateAsString = new DateAsString(openDate);
        });
      }
  }

  Future<Null> _selectTime(BuildContext context) async {
    final TimeOfDay timePicked = await showTimePicker(context: context,
        initialTime: _time);

    if (timePicked != null)
      {
        setState(() {
          openDate = new DateTime(openDate.year, openDate.month, openDate.day,
            timePicked.hour, timePicked.minute);
          openDateAsString = new DateAsString(openDate);
        });
      }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold (
      
      appBar: new AppBar(
        title: new Text("Create New Time Capsule"),
      ),
      body: new ListView.builder(
        itemCount: 1,
        itemBuilder: (BuildContext context, int index) {
          return new Column(
            children: <Widget>[
              new Padding(
                padding: new EdgeInsets.all(20.0),
                child: new TextField(
                  controller: titleTextController,
                  decoration: new InputDecoration(
                      hintText: "Time Capsule Name*"
                  ),
                ),
              ),
              new Padding(
                  padding: new EdgeInsets.all(20.0),
                  child: new TextField(
                    controller: messageTextController,
                    decoration: new InputDecoration(
                        hintText: "Time Capsule Message*"
                    ),
                  )
              ),
              new Padding(
                padding: new EdgeInsets.all(20.0),
                child: new Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    new Expanded(
                      child: new Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: <Widget>[
                          new Text(
                            "Open date is set to ${openDateAsString.month} "
                                + "${openDateAsString.day}, ${openDateAsString.year}, "
                                + "at ${openDateAsString.time}",
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                    ),
                    new IconButton(
                      icon: new Icon(Icons.calendar_today),
                      onPressed: () {_selectDate(context);},
                    ),
                    new IconButton(
                      icon: new Icon(Icons.access_time),
                      onPressed: () {_selectTime(context);},
                    )
                  ],

                ),
              ),
              Padding(
                padding: EdgeInsets.all(20.0),
                child: new RaisedButton(
                    child: new Text("Press to save"),
                    onPressed: () {_createNewTimeCapsule(context);}),
              )
            ],
          );
        }
      )
    );
  }

  void _createNewTimeCapsule(BuildContext context){
    if (messageTextController.text.isEmpty || titleTextController.text.isEmpty) {
      Scaffold.of(context).showSnackBar(new SnackBar(content: new Text("Ensure all fields are filled in and try again.")));
    }
    else {
      TimeCapsule capsule = new TimeCapsule();
      capsule.openDate = openDate.toUtc().toIso8601String();
      capsule.createdDate = new DateTime.now().toUtc().toIso8601String();
      capsule.isDeleted = 0;
      capsule.isOpened = 0;
      capsule.message = messageTextController.text;
      capsule.title = titleTextController.text;
      Scaffold.of(context).showSnackBar(new SnackBar(content: new Text("Time capsule created successfully.")));
    }

  }
}

class DateAsString{
  List<String> _months = const ["Jan.", "Feb.", "Mar.", "Apr.", "May", "Jun.",
    "Jul.", "Aug.", "Sep.", "Oct.", "Nov.", "Dec."];
  String year;
  String month;
  String day;
  String time;

  DateAsString(DateTime date) {
    this.year = date.year.toString();
    this.month  = _months[date.month];
    this.day = date.day.toString();
    time = date.hour > 12 ? (date.hour - 12).toString() : date.hour.toString();
    time += ":${date.minute} ";
    time += date.hour > 12 ? "PM" : "AM";
  }
}