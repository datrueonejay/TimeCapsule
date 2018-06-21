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
      padding: new EdgeInsets.all(20.0),
    );
  }

}