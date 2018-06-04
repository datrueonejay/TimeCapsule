import 'package:flutter/material.dart';
import 'package:time_capsule/Controllers/TimeCapsuleController.dart';
import 'package:time_capsule/Models/TimeCapsule.dart';
import 'package:time_capsule/Screens/NewTimeCapsule.dart';

void main() => runApp(new MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      title: 'Flutter Demo',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  TimeCapsuleController _timeCapsuleController;
  List<TimeCapsule> _timeCapsules = new List<TimeCapsule>();


  @override
  void initState() {
    _timeCapsuleController = new TimeCapsuleController();
    _timeCapsuleController.getAllCapsules()
        .then((capsules) {
          setState(() {
            _timeCapsules = capsules;
          });
        });
    super.initState();

  }


  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
      ),
      body: new ListView.builder(
          padding: new EdgeInsets.all(20.0),
          itemCount: _timeCapsules.length,
          itemBuilder: (context, index) {
            return new ListTile(
                title: new Text("${_timeCapsules[index].title}"),
                subtitle: new Text("${_timeCapsules[index].message}"),
            );
          }
      ),
      floatingActionButton: new FloatingActionButton(
        onPressed: _goToNewTimeCapsulePage,
        child: new Icon(Icons.add),
      ),
    );
  }

  _goToNewTimeCapsulePage() async {
    await Navigator.push(context, new MaterialPageRoute(builder: (context) =>
      new NewTimeCapsule()),
    );
    _timeCapsuleController.getAllCapsules().then((capsules) {
      setState(() {
        _timeCapsules = capsules;
      });
    });
  }
}
