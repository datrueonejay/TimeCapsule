import 'package:flutter/material.dart';
import 'package:time_capsule/Controllers/TimeCapsuleController.dart';
import 'package:time_capsule/Models/TimeCapsule.dart';
import 'package:time_capsule/Screens/ReadMessageScreen.dart';

class TimeCapsuleListItem extends StatefulWidget {
  final TimeCapsule _timeCapsule;
  final TimeCapsuleController _controller;
  final Function _refreshCapsules;

  TimeCapsuleListItem(this._timeCapsule, this._controller, this._refreshCapsules);

  @override
  _TimeCapsuleListItemState createState() => new _TimeCapsuleListItemState();

}

class _TimeCapsuleListItemState extends State<TimeCapsuleListItem> {
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
            new Text(widget._timeCapsule.title,
                textAlign: TextAlign.start),
            new Text("Created on ${widget._timeCapsule.createdDate.toString()}"),
            new Text("Can open on ${widget._timeCapsule.openDate.toString()}"),
            new Text("${DateTime.now().toString()}")
          ],
          crossAxisAlignment: CrossAxisAlignment.start,
        ),
        onTap: () {
          bool canOpen = widget._timeCapsule.openDate.isBefore(DateTime.now())
              || widget._timeCapsule.openDate.isAtSameMomentAs(DateTime.now());
          // Capsule can not be opened yet
          if (!canOpen) {
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

          // Capsule can be opened but has not yet been
          else if (canOpen && !widget._timeCapsule.isOpened) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return new AlertDialog(
                  title: Text("Open Capsule"),
                  content: new Text("This capsule has not yet been opened. "
                      "Would you like to open it now?"),
                  actions: <Widget>[
                    new FlatButton(
                      onPressed: () => Navigator.pop(context),
                      child: new Text("CANCEL"),
                    ),
                    new FlatButton(
                      onPressed: () {
                        widget._controller.setIsOpened(widget._timeCapsule);
                        Navigator.pop(context);
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            widget._refreshCapsules();
                            return new ReadMessageScreen(widget._timeCapsule);
                          }
                        );
                      },
                      child: new Text("OPEN"),
                    )
                  ],
                );
              }
            );
          }

          // Capsule can be opened and has been opened
          else if (canOpen && widget._timeCapsule.isOpened) {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return new ReadMessageScreen(widget._timeCapsule);
                }
            );
          }
        },
      ),
      padding: new EdgeInsets.all(20.0),
    );


  }
}