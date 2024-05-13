import 'package:flutter/material.dart';
import 'package:p02_splash_screen/screen/splash_screen.dart';
import 'const/const.dart';


void main() {
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      title: APP_TITLE_FULL,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const SplashScreen(),
    ),
  );
}
