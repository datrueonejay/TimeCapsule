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
      title: 'Time Capsule',
      theme: new ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: new MyHomePage(title: "Time Capsule"),
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

  int _currPage = 0;
  PageController _pageController;
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
    _pageController = new PageController();

    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: new AppBar(
        title: new Text(widget.title),
        actions: <Widget>[
          IconButton(
            icon: new Icon(Icons.add_circle),
            onPressed: _goToNewTimeCapsulePage,
          ),
        ],
      ),
      body: new PageView(
        onPageChanged: (pageNum) {
          setState(() {
            _currPage = pageNum;
          });
        },
        children: [
          new Container(
            child: new ListView.builder(
              padding: new EdgeInsets.all(20.0),
              itemCount: _timeCapsules.length,
              itemBuilder: (context, index) {
                return new ListTile(
                  title: new Text("${_timeCapsules[index].title}"),
                  subtitle: new Text("${_timeCapsules[index].message}"),
                );
              }
            ),
          ),
          new Container(
            child: new ListView.builder(
                padding: new EdgeInsets.all(20.0),
                itemCount: _timeCapsules.length,
                itemBuilder: (context, index) {
                  return new ListTile(
                    title: new Text("${_timeCapsules[index].title}"),
                    subtitle: new Text("${_timeCapsules[index].message}"),
                  );
                }
            ),
          ),
          new Container(
            child: new ListView.builder(
                padding: new EdgeInsets.all(20.0),
                itemCount: _timeCapsules.length,
                itemBuilder: (context, index) {
                  return new ListTile(
                    title: new Text("${_timeCapsules[index].title}"),
                    subtitle: new Text("${_timeCapsules[index].message}"),
                  );
                }
            ),
          ),
              ],
        controller: _pageController,
      ),
      bottomNavigationBar: new BottomNavigationBar(
        items: [
          new BottomNavigationBarItem(
              icon: new Icon(Icons.title),
              title: new Text("All Time Capsules")
          ),
          new BottomNavigationBarItem(
              icon: new Icon(Icons.title),
              title: new Text("Coming Soon Time Capsules")
          ),
          new BottomNavigationBarItem(
              icon: new Icon(Icons.title),
              title: new Text("Opened Time Capsules")
          ),
        ],
        currentIndex: _currPage,
        onTap: (pageNum) {
          _pageController.animateToPage(pageNum,
              duration: Duration(milliseconds: 300),
              curve: Curves.ease);
        },

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
