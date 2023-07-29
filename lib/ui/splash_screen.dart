import 'package:flutter/material.dart';
import 'dart:async';

import 'package:hearts_scorer/ui/games_list.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}
class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      Duration(seconds: 3),
      () => Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => GamesListScreen(title: 'Hearts Games')))
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                  const Text('Ready to play some Hearts?'),
              ]
            ),
        )
    );
  }
}
