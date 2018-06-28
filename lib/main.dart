import 'package:flutter/material.dart';
import 'package:time_capsule/Controllers/TimeCapsuleController.dart';
import 'package:time_capsule/Models/TimeCapsule.dart';
import 'package:time_capsule/Screens/NewTimeCapsule.dart';
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
  List<TimeCapsule> _timeCapsules = new List<TimeCapsule>();
  List<TimeCapsule> _nearCapsules = new List<TimeCapsule>();
  List<TimeCapsule> _readyCapsules = new List<TimeCapsule>();

  List<DateTime> _allDateHeaders = new List<DateTime>();
  List<DateTime> _readyDateHeaders = new List<DateTime>();
  List<DateTime> _nearDateHeaders = new List<DateTime>();

  int _allCapsulesCounter = 0;
  int _readyCapsulesCounter = 0;
  int _nearCapsulesCounter = 0;

  int _allDateCounter = 0;
  int _readyDateCounter = 0;
  int _nearDateCounter = 0;

  @override
  void initState() {
    _timeCapsuleController = new TimeCapsuleController();
    _timeCapsuleController.getAllCapsules()
        .then((capsules) {
          setState(() {
            _timeCapsules = capsules;
            _allDateHeaders = _findDateHeaders(_timeCapsules);
          });
        });
    _timeCapsuleController.getTimeCapsulesBefore(new DateTime.now().add(new Duration(days: 10)))
        .then((capsules) {
      setState(() {
        _nearCapsules = capsules;
        _nearDateHeaders = _findDateHeaders(_nearCapsules);
      });
    });
    _timeCapsuleController.getReadyCapsules()
      .then((capsules) {
        setState(() {
          _readyCapsules = capsules;
          _readyDateHeaders = _findDateHeaders(_readyCapsules);
        });
    });
    _pageController = new PageController();

    super.initState();
  }

  void _restartCounters() {
    _allCapsulesCounter = 0;
    _nearCapsulesCounter = 0;
    _readyCapsulesCounter = 0;

    _allDateCounter = 0;
    _nearDateCounter = 0;
    _readyDateCounter = 0;
  }

  List<DateTime> _findDateHeaders(List<TimeCapsule> capsules) {
    List<DateTime> dateHeaders= List<DateTime>();
    DateTime currDate;
    capsules.forEach((capsule) {
      // Check if first date has been found yet
      if (currDate == null) {
        // Ensure date starts at 12:00 am
        currDate = DateTime(capsule.openDate.year, capsule.openDate.month, capsule.openDate.day, 0, 0, 0);
        dateHeaders.add(currDate);
      // If date is greater than one day
      } else if (capsule.openDate.difference(currDate).inDays >= 1) {
        currDate = DateTime(capsule.openDate.year, capsule.openDate.month, capsule.openDate.day, 0, 0, 0);
        dateHeaders.add(currDate);
      }
    });
    return dateHeaders;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  dynamic _getListItem(int currDateIndex, int currCapsuleIndex, List<DateTime> dateHeaders, List<TimeCapsule> timeCapsules) {
    DateTime curr = dateHeaders[currDateIndex];
    DateTime capsule = timeCapsules[currCapsuleIndex].openDate;
    Duration a = capsule.difference(curr);
    if (timeCapsules[currCapsuleIndex].openDate.difference(dateHeaders[currDateIndex]).inDays >= 1) {
      // This case is if we need to return the next date header
      return dateHeaders[currDateIndex + 1];
    } else {
      // This case is if the next capsule falls under the date still
      return timeCapsules[currCapsuleIndex];
    }
  }

  @override
  Widget build(BuildContext context) {
    _restartCounters();
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
              itemCount: _timeCapsules.length + _allDateHeaders.length,
              itemBuilder: (context, index) {
                // Show first date
                if (index == 0) {
                  return new Text(_allDateHeaders[0].toString());
                } else {
                  // If date time show date time
                  if (_getListItem(_allDateCounter, _allCapsulesCounter, _allDateHeaders, _timeCapsules) is DateTime) {
                    _allDateCounter++;
                    return Text(_allDateHeaders[_allDateCounter].toString());
                  } else {
                    // If we get a timecapsule back show the time capsule
                    _allCapsulesCounter++;
                    return new TimeCapsuleListItem(_timeCapsules[_allCapsulesCounter - 1]);
                  }
                }
              }
            ),
          ),
          new Container(
            child: new ListView.builder(
              padding: new EdgeInsets.all(20.0),
              itemCount: _readyCapsules.length + _readyDateHeaders.length,
              itemBuilder: (context, index) {
                // Show first date
                if (index == 0) {
                  return new Text(_readyDateHeaders[0].toString());
                } else {
                  // If date time show date time
                  if (_getListItem(_readyDateCounter, _readyCapsulesCounter, _readyDateHeaders, _readyCapsules) is DateTime) {
                    _readyDateCounter++;
                    return Text(_readyDateHeaders[_readyDateCounter].toString());
                  } else {
                    // If we get a timecapsule back show the time capsule
                    _readyCapsulesCounter++;
                    return new TimeCapsuleListItem(_readyCapsules[_readyCapsulesCounter - 1]);
                  }
                }
              }
            ),
          ),
          new Container(
            child: new ListView.builder(
              padding: new EdgeInsets.all(20.0),
              itemCount: _nearCapsules.length + _nearDateHeaders.length,
              itemBuilder: (context, index) {
                // Show first date
                if (index == 0) {
                  return new Text(_nearDateHeaders[0].toString());
                } else {
                  // If date time show date time
                  if (_getListItem(_nearDateCounter, _nearCapsulesCounter, _nearDateHeaders, _nearCapsules) is DateTime) {
                    _nearDateCounter++;
                    return Text(_nearDateHeaders[_nearCapsulesCounter].toString());
                  } else {
                    // If we get a timecapsule back show the time capsule
                    _nearCapsulesCounter++;
                    return new TimeCapsuleListItem(_nearCapsules[_nearCapsulesCounter - 1]);
                  }
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
              icon: new Icon(Icons.title),
              title: new Text("All")
          ),
          new BottomNavigationBarItem(
              icon: new Icon(Icons.title),
              title: new Text("Ready To Open")
          ),
          new BottomNavigationBarItem(
              icon: new Icon(Icons.title),
              title: new Text("Soon")
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
    _timeCapsuleController.getAllCapsules()
        .then((capsules) {
      setState(() {
        _timeCapsules = capsules;
        _allDateHeaders = _findDateHeaders(_timeCapsules);
      });
    });
    _timeCapsuleController.getTimeCapsulesBefore(new DateTime.now().add(new Duration(days: 10)))
        .then((capsules) {
      setState(() {
        _nearCapsules = capsules;
        _nearDateHeaders = _findDateHeaders(_nearCapsules);
      });
    });
    _timeCapsuleController.getReadyCapsules()
        .then((capsules) {
      setState(() {
        _readyCapsules = capsules;
        _readyDateHeaders = _findDateHeaders(_readyCapsules);
      });
    });
  }
}
