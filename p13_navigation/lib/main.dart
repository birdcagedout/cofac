import 'package:flutter/material.dart';
import 'package:p13_navigation/screen/home_screen.dart';
import 'package:p13_navigation/screen/route1_screen.dart';
import 'package:p13_navigation/screen/route2_screen.dart';

// Routing
// 1) imperative Routing: 코드로 route를 직접 작성
// 2) Declarative Routing:
void main() {
  runApp(
    MaterialApp(
      home: HomeScreen(),

      // Declarative Routing
      // key: 라우트 이름
      // value: builder -> 이동하고 싶은 라우트
      routes: {
        '/': (BuildContext context) => HomeScreen(),
        '/one': (BuildContext context) => Route1Screen(num: 12345),
        '/two': (BuildContext context) => Route2Screen(),
        '/three':
      },
    )
  );
}

