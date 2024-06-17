import 'package:flutter/material.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              Container(
                width: 200,
                height: 200,
                color: Colors.red,
                // 자식 위젯이 어디에 정렬되는지 constraints를 주지 않은 상황 ==> 자식 위젯의 크기가 무시된다
                // 파란색 Container가 50x50 크기를 가지려면 Column, Row, Center, Alignment 등으로 감싸야 한다.
                child: Container(
                  width: 50,
                  height: 50,
                  color: Colors.blue,
                ),
              ),

              SizedBox(height: 10,),

              Container(
                width: 200,
                height: 200,
                color: Colors.red,
                child: Align(
                  alignment: Alignment.center,
                  child: Container(
                    width: 50,
                    height: 50,
                    color: Colors.blue,
                  ),
                ),
              ),

              SizedBox(height: 10,),

              // Align에서 x,y값 사용하기
              // center=(0,0), centerRight=(1,0), topLeft=(-1,-1), bottomRight=(1,1)
              Container(
                width: 200,
                height: 200,
                color: Colors.red,
                child: Align(
                  alignment: Alignment(0.5, -0.5),
                  child: Container(
                    width: 50,
                    height: 50,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
