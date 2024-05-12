import 'package:flutter/material.dart';
import 'package:p13_navigation_route/screen/home_screen.dart';
import 'package:p13_navigation_route/screen/route1_screen.dart';
import 'package:p13_navigation_route/screen/route2_screen.dart';
import 'package:p13_navigation_route/screen/route3_screen.dart';

// Routing
// 1) imperative Routing: 코드로 route를 직접 작성
// 2) Declarative Routing:
void main() {
  runApp(
      MaterialApp(
        // Declarative Routing
        // key: 라우트 이름
        // value: builder -> 이동하고 싶은 라우트
        // **
        // 장점: 모든 라우트를 모아놓으면 보기 편하고, push() 함수 내부가 간결해진다
        // 단점: route를 정적으로 미리 선언해야 하므로, arguments를 넘길 때 반드시 pushNamed(라우트, arguments: )로 전달해야 한다.
        routes: {
          '/': (BuildContext context) => HomeScreen(),
          '/one': (BuildContext context) => Route1Screen(),
          '/two': (BuildContext context) => Route2Screen(),
          '/three': (BuildContext context) => Route3Screen(),
        },
        initialRoute: '/',
      )
  );
}

