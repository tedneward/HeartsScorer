import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:window_size/window_size.dart';

import 'package:hearts_scorer/app.dart';
import 'package:hearts_scorer/models/providers.dart';

void main() {
  setupWindow();
  runApp(
    ChangeNotifierProvider(
      // Initialize the model in the builder. That way, Provider
      // can own GameProvider's lifecycle, making sure to call `dispose`
      // when not needed anymore.
      create: (context) => GameProvider(),
      child: const HeartsScorerApp(),
    ),
  );
}

const double windowWidth = 400;
const double windowHeight = 800;

void setupWindow() {
  if (!kIsWeb && (Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
    WidgetsFlutterBinding.ensureInitialized();
    setWindowTitle('Hearts Scorer');
    setWindowMinSize(const Size(windowWidth, windowHeight));
    setWindowMaxSize(const Size(windowWidth, windowHeight));
    getCurrentScreen().then((screen) {
      setWindowFrame(Rect.fromCenter(
        center: screen!.frame.center,
        width: windowWidth,
        height: windowHeight,
      ));
    });
  }
}

