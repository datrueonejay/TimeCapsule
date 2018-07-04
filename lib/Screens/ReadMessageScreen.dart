import "package:flutter/material.dart";
import 'package:time_capsule/Models/TimeCapsule.dart';


class ReadMessageScreen extends StatelessWidget {

  final TimeCapsule _timeCapsule;

  ReadMessageScreen(this._timeCapsule);

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text("View Capsule"),

      ),
      body: new ListView.builder(
          itemCount: 1,
          itemBuilder: (BuildContext context, int index) {
            return new Column(
              children: <Widget>[
                new Padding(
                  padding: new EdgeInsets.all(20.0),
                  child: new Text("Name of Capsule: ${_timeCapsule.title}"),
                ),
                new Padding(
                  padding: new EdgeInsets.all(20.0),
                  child: new Text("Created On: ${_timeCapsule.createdDate.toString()}"),
                ),
                new Padding(
                  padding: new EdgeInsets.all(20.0),
                  child: new Text("Message: ${_timeCapsule.message}"),
                )
              ],
            );
          }
      ),
    );
  }
}