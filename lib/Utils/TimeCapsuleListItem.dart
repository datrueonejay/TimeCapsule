import 'package:flutter/material.dart';
import 'package:time_capsule/Models/TimeCapsule.dart';

class TimeCapsuleListItem extends StatefulWidget {
  final TimeCapsule _timeCapsule;

  TimeCapsuleListItem(this._timeCapsule);

  @override
  _TimeCapsuleListItemState createState() => new _TimeCapsuleListItemState(_timeCapsule);

}

class _TimeCapsuleListItemState extends State<TimeCapsuleListItem> {
  final TimeCapsule _timeCapsule;

  _TimeCapsuleListItemState(this._timeCapsule);

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return new Container(
      child: new GestureDetector(
        child: new Column(
          children: <Widget>[
            new Text(_timeCapsule.title,
                textAlign: TextAlign.start),
            new Text("Created on ${_timeCapsule.createdDate.toString()}"),
            new Text("Can open on ${_timeCapsule.openDate.toString()}"),
            new Text("${DateTime.now().toString()}")
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        onTap: () {
          if (_timeCapsule.openDate.isAfter(DateTime.now()))
            {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return new AlertDialog(
                    title: Text("Not Yet"),
                    content: new Text("You can not open this yet"),
                    actions: <Widget>[
                      new FlatButton(
                        onPressed: () => Navigator.pop(context),
                        child: new Text("OK"),
                      )
                    ],
                  );
                }
              );
            }
        },
      ),
      padding: new EdgeInsets.all(20.0),
    );
  }

}