import 'package:flutter/material.dart';
import 'package:time_capsule/Controllers/TimeCapsuleController.dart';
import 'package:time_capsule/Models/TimeCapsule.dart';
import 'package:time_capsule/Screens/NewTimeCapsuleScreen.dart';
import 'package:time_capsule/Utils/Converter.dart';
import 'package:time_capsule/Utils/TimeCapsuleListItem.dart';

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

  // These lists contain the dates and time capsules
  List<Object> _allCapsulesList = new List<Object>();
  List<Object> _nearCapsulesList = new List<Object>();
  List<Object> _readyCapsulesList = new List<Object>();

//  List<TimeCapsule> _timeCapsules = new List<TimeCapsule>();
//  List<TimeCapsule> _nearCapsules = new List<TimeCapsule>();
//  List<TimeCapsule> _readyCapsules = new List<TimeCapsule>();

  @override
  void initState() {
    _timeCapsuleController = new TimeCapsuleController();
    _refreshcapsules();
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
          _refreshcapsules();
          setState(() {
            _currPage = pageNum;
          });
        },
        children: [
          new Container(
            child: new ListView.builder(
              itemCount: _allCapsulesList.length,
              itemBuilder: (context, index) {
                if (_allCapsulesList[index] is DateTime) {
                  return new Container(
                    padding: new EdgeInsets.only(left: 5.0, top: 20.0, right: 20.0, bottom: 20.0),
                    child: Text(Converter.dateToHeader(_allCapsulesList[index]),
                    style: new TextStyle(color: Colors.white),),
                    color: Colors.blue,
                  );
                } else {
                  return new TimeCapsuleListItem(_allCapsulesList[index], _timeCapsuleController, _refreshcapsules);
                }
              }
            ),
          ),
          new Container(
            child: new ListView.builder(
              itemCount: _readyCapsulesList.length,
              itemBuilder: (context, index) {
                if (_readyCapsulesList[index] is DateTime) {
                  return new Container(
                    padding: new EdgeInsets.only(left: 5.0, top: 20.0, right: 20.0, bottom: 20.0),
                    child: Text(Converter.dateToHeader(_readyCapsulesList[index]),
                      style: new TextStyle(color: Colors.white),),
                    color: Colors.blue,
                  );
                } else {

                  return new TimeCapsuleListItem(_readyCapsulesList[index], _timeCapsuleController, _refreshcapsules);
                }
              }
            ),
          ),
          new Container(
            child: new ListView.builder(
              itemCount: _nearCapsulesList.length,
              itemBuilder: (context, index) {
                if (_nearCapsulesList[index] is DateTime) {
                  return new Container(
                    padding: new EdgeInsets.only(left: 5.0, top: 20.0, right: 20.0, bottom: 20.0),
                    child: Text(Converter.dateToHeader(_nearCapsulesList[index]),
                      style: new TextStyle(color: Colors.white),),
                    color: Colors.blue,
                  );
                } else {
                  return new TimeCapsuleListItem(_nearCapsulesList[index], _timeCapsuleController, _refreshcapsules);
                }
              }
            ),
          ),
              ],
        controller: _pageController,
      ),
      bottomNavigationBar: new BottomNavigationBar(
        items: [
          new BottomNavigationBarItem(
              icon: new Icon(Icons.all_inclusive),
              title: new Text("All")
          ),
          new BottomNavigationBarItem(
              icon: new Icon(Icons.check_circle),
              title: new Text("Ready To Open")
          ),
          new BottomNavigationBarItem(
              icon: new Icon(Icons.access_time),
              title: new Text("Soon")
          ),
        ],
        currentIndex: _currPage,
        onTap: (pageNum) {
          _pageController.animateToPage(pageNum,
              duration: Duration(milliseconds: 300),
              curve: Curves.ease);
          //_restartCounters();
        },

      ),
    );
  }

  _goToNewTimeCapsulePage() async {
    await Navigator.push(context, new MaterialPageRoute(builder: (context) =>
      new NewTimeCapsule()),
    );
    _refreshcapsules();
  }

  _refreshcapsules() {
    _timeCapsuleController.getAllCapsules()
        .then((capsules) {
      setState(() {
        _allCapsulesList = _getListWithHeaders(capsules);
      });
    });
    _timeCapsuleController.getTimeCapsulesBefore(new DateTime.now().add(new Duration(days: 10)))
        .then((capsules) {
      setState(() {
        _nearCapsulesList = _getListWithHeaders(capsules);
      });
    });
    _timeCapsuleController.getReadyCapsules()
        .then((capsules) {
      setState(() {
        _readyCapsulesList = _getListWithHeaders(capsules);
      });
    });
  }

  List<Object> _getListWithHeaders(List<TimeCapsule> capsules) {
    List<Object> capsulesHeadersList = new List<Object>();
    DateTime currDate;
    capsules.forEach((capsule) {
      // Check if first date has been found yet
      if (currDate == null) {
        // Ensure date starts at 12:00 am
        currDate = DateTime(capsule.openDate.year, capsule.openDate.month, capsule.openDate.day, 0, 0, 0);
        capsulesHeadersList.add(currDate);
        // If date is greater than one day
      } else if (capsule.openDate.difference(currDate).inDays >= 1) {
        currDate = DateTime(capsule.openDate.year, capsule.openDate.month, capsule.openDate.day, 0, 0, 0);
        capsulesHeadersList.add(currDate);
      }
      // Add the capsule
      capsulesHeadersList.add(capsule);
    });
    return capsulesHeadersList;
  }
}
