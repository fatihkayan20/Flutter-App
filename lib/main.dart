import 'dart:async';
import 'package:flutter/material.dart';
import 'package:marquee/marquee.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyAppHome(),
    );
  }
}

class MyAppHome extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return _MyAppHomeState();
  }
}

class _MyAppHomeState extends State<MyAppHome> {
  String userName = '';
  String lorem =
      'Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum.'
          .toLowerCase()
          .replaceAll(',', '')
          .replaceAll('.', '');
  int step = 0;
  int score = 0;
  int lastType;

  void updateLastTypedAt() {
    this.lastType = DateTime.now().millisecondsSinceEpoch;
  }

  void onType(String value) {
    updateLastTypedAt();
    String trimmedValue = lorem.trim();
    print(value);
    if (trimmedValue.indexOf(value) != 0) {
      setState(() {
        step = 2;
      });
    } else {
      score = value.length;
    }
  }

  void setUserName(String value) {
    setState(() {
      this.userName = value.trim();
      return userName;
    });
  }

  startClick() {
    setState(() {
      updateLastTypedAt();
      print(userName);
      step += 1;
    });
    Timer.periodic(Duration(seconds: 1), (timer) {
      int now = DateTime.now().millisecondsSinceEpoch;

      setState(() {
        if (step == 1 && now - lastType > 4000) {
          step = 2;
        }
        if (step != 1) {
          timer.cancel();
        }
      });
    });
  }

  startAgain() {
    setState(() {
      score = 0;
      step = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    var shownWidget;

    //Login Screen

    if (step == 0) {
      shownWidget = <Widget>[
        Padding(
          padding: const EdgeInsets.only(bottom: 20),
          child: Text(
            'Would you like to play a game?',
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 50),
          child: TextField(
            onChanged: setUserName,
            decoration: InputDecoration(
              border: OutlineInputBorder(),
              labelText: 'Set Your Username',
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10),
          child: RaisedButton(
            child: Text('Start'),
            onPressed: userName.trim().length == 0 ? null : startClick,
            padding: EdgeInsets.symmetric(horizontal: 50),
          ),
        ),
      ];
    }

    //Game Screen

    else if (step == 1) {
      shownWidget = <Widget>[
        Column(
          children: <Widget>[
            Text(
              'Your Score',
              style: TextStyle(fontSize: 20),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 50),
              child: Text(
                score.toString(),
                style: TextStyle(fontSize: 20),
              ),
            ),
          ],
        ),
        Container(
            height: 50,
            child: Marquee(
              text: lorem,
              style: TextStyle(fontSize: 24),
              scrollAxis: Axis.horizontal,
              crossAxisAlignment: CrossAxisAlignment.start,
              blankSpace: MediaQuery.of(context).size.width,
              velocity: 100.0,
              startPadding: MediaQuery.of(context).size.width - 50,
              accelerationDuration: Duration(seconds: 15),
              accelerationCurve: Curves.linear,
              // decelerationDuration: Duration(milliseconds: 500),
              // decelerationCurve: Curves.ease,
            )),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
          child: TextField(
            obscureText: false,
            autofocus: true,
            autocorrect: false,
            onChanged: onType,
            decoration: InputDecoration(
                border: OutlineInputBorder(), labelText: 'Type something'),
          ),
        ),
      ];
    }

    //Resault Screen

    else if (step == 2) {
      shownWidget = <Widget>[
        Column(
          children: <Widget>[
            Text(
              'Game Over',
              style: TextStyle(fontSize: 20),
            ),
            Text(
              'Your Score',
              style: TextStyle(fontSize: 20),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, bottom: 50),
              child: Text(
                score.toString(),
                style: TextStyle(fontSize: 20),
              ),
            ),
            RaisedButton(
              onPressed: startAgain,
              child: Text('Start Again'),
            )
          ],
        ),
      ];
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('Deneme'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: shownWidget,
        ),
      ),
    );
  }
}
