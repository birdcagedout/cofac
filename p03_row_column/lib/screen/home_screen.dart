import 'dart:ffi';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:p03_row_column/const/colors.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: Colors.black,

          // 5. Container 너비 최대 지정
          // width: double.infinity,
          // 6. Container 높이 최대 지정
          // height: double.infinity,

          // 1. MainAxisAlignment - Column
          // child: Column(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   // crossAxisAlignment: CrossAxisAlignment.stretch,
          //   children: mycolors.map((e) => Container(width: 50, height: 50, color: e,)).toList(),

          // 2. MainAxisAlignment - Row
          // child: Row(
          //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //   children: mycolors.map((e) => Container(width: 50, height: 50, color: e,)).toList(),
          // ),

          // 3. MainAxisSize
          // child: Column(
          //   mainAxisSize: MainAxisSize.min,
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   children: mycolors.map((e) => Container(width: 50, height: 50, color: e,)).toList(),
          // ),

          // 4. MainAxisSize
          // child: Row(
          //   mainAxisSize: MainAxisSize.min,
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   children: mycolors.map((e) => Container(width: 50, height: 50, color: e,)).toList(),
          // ),

          // 5. CrossAxisAlignment - 상위 Container의 width를 최대화(double.infinity)한 다음
          // child: Column(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   // crossAxisAlignment: CrossAxisAlignment.center,    // 이건 Row, Column의 기본값
          //   crossAxisAlignment: CrossAxisAlignment.stretch,       // 자식 Container의 너비가 최대로 늘어남
          //   children: mycolors.map((e) => Container(width: 50, height: 50, color: e,)).toList(),
          // ),

          // 6. CrossAxisAlignment - 상위 Container의 height를 최대화(double.infinity)한 다음
          // child: Row(
          //   mainAxisAlignment: MainAxisAlignment.start,
          //   // crossAxisAlignment: CrossAxisAlignment.center,    // 이건 Row, Column의 기본값
          //   crossAxisAlignment: CrossAxisAlignment.stretch,     // 자식 Container의 높이가 최대로 늘어남
          //   children: mycolors.map((e) => Container(width: 50, height: 50, color: e,)).toList(),
          // ),

          // 7. Expanded
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 7-1. 정상적인 경우
              Column(
                children: [
                  Container(width: 50, height: 50, color: Colors.red,),
                  Container(width: 50, height: 50, color: Colors.orange,),
                  Container(width: 50, height: 50, color: Colors.yellow,),
                ],
              ),
              SizedBox(width: 5,),

              // 7-2. 1개만 Expanded 사용
              Column(
                children: [
                  Expanded(child: Container(width: 50, height: 50, color: Colors.red,)),
                  Container(width: 50, height: 50, color: Colors.orange,),
                  Container(width: 50, height: 50, color: Colors.yellow,),
                ],
              ),
              SizedBox(width: 5,),

              // 7-3. 2개만 Expanded 사용
              Column(
                children: [
                  Expanded(child: Container(width: 50, height: 50, color: Colors.red,)),
                  Expanded(child: Container(width: 50, height: 50, color: Colors.orange,)),
                  Container(width: 50, height: 50, color: Colors.yellow,),
                ],
              ),
              SizedBox(width: 5,),

              // 7-4. 3개 전부 Expanded 사용
              Column(
                children: [
                  Expanded(child: Container(width: 50, height: 50, color: Colors.red,)),
                  Expanded(child: Container(width: 50, height: 50, color: Colors.orange,)),
                  Expanded(child: Container(width: 50, height: 50, color: Colors.yellow,)),
                ],
              ),
              SizedBox(width: 5,),

              // 7-5. flex 사용 ==> 다른 Expanded의 flex값만큼 배로 차지
              Column(
                children: [
                  Expanded(flex: 2, child: Container(width: 50, height: 50, color: Colors.red,)),
                  Expanded(child: Container(width: 50, height: 50, color: Colors.orange,)),
                  Expanded(child: Container(width: 50, height: 50, color: Colors.yellow,)),
                ],
              ),
              SizedBox(width: 5,),

              // 7-6. flex 사용 ==> 다른 Expanded 위젯들과 flex값 비율대로 차지, Expanded 아닌 위젯 제외
              Column(
                children: [
                  Expanded(flex: 2, child: Container(width: 50, height: 50, color: Colors.red,)),
                  Expanded(flex: 3, child: Container(width: 50, height: 50, color: Colors.orange,)),
                  Container(width: 50, height: 50, color: Colors.yellow,),
                ],
              ),
              SizedBox(width: 5,),

              // 8. Flexible (Flexible에 fit값을 FlexFit.tight로 준 것이 Expanded이다. 잘 안 쓴다)
              //    - FlexFit.loose를 하면 Expanded가 원래 먹을 만큼을 잡아놓은 다음, child 크기만큼 먹고 나머지는 버린다
              Column(
                children: [
                  Flexible(fit: FlexFit.tight, child: Container(width: 50, height: 50, color: Colors.red,)),
                  Expanded(child: Container(width: 50, height: 50, color: Colors.orange,)),
                  Expanded(child: Container(width: 50, height: 50, color: Colors.yellow,)),
                ],
              ),
              SizedBox(width: 5,),
            ],
          ),
        ),
      )
    );
  }
}
