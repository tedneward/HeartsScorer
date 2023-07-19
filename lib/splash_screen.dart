import 'package:flutter/material.dart';
import 'dart:async';

import 'package:hearts_scorer/games_list.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3),
            ()=>Navigator.pushReplacement(context,MaterialPageRoute(builder:(context) => GamesListScreen(title: 'Hearts Games'))));
  }
  @override
  Widget build(BuildContext context) {
    return Container(
        child: Text("Ready to play some Hearts?")
    );
  }
}
