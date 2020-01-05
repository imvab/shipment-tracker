import 'dart:async';

import 'package:flutter/material.dart';
import 'package:skyking_tracking/screens/search.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: SplashScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  startTime() async {
    var _duration = new Duration(seconds: 3);
    return new Timer(_duration, navigationPage);
  }

  void navigationPage() {
    var route = MaterialPageRoute(
      builder: (context) => SearchPage()
    );
    Navigator.of(context).pushReplacement(route);
  }

  @override
  void initState() {
    super.initState();
    startTime();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Image(image: AssetImage("assets/web-gif.gif")))
      // body: Column(children: <Widget>[
      //   Image(image: AssetImage("assets/logo.png"),),
      //   Image(image: AssetImage("assets/web-gif.gif"),)
      // ],)
    );
  }
}
