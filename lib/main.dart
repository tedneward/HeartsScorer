import 'package:flutter/material.dart';
import 'package:hearts_scorer/models.dart';
import 'package:hearts_scorer/new_game.dart';

import 'package:hearts_scorer/splash_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hearts Scorer',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      //home: SplashScreen(),
      home: Scaffold(
        appBar: AppBar(title: Text('New Game')),
        body: NewGameScreen()
      )
    );
  }
}
