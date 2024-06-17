import 'package:flutter/material.dart';


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.red,
          child: Padding(
            // 1. EdgeInsets.all
            // padding: const EdgeInsets.all(28.0),    // 파란색 박스 크기는 고정이고, 외부 padding 크기가 변한다

            // 2. EdgeInsets.symmetric
            // padding: const EdgeInsets.symmetric(horizontal: 10),    // 파란색 박스 크기는 고정이고, 외부 padding 크기가 변한다

            // 3. EdgeInsets.only
            // padding: const EdgeInsets.only(top: 10, bottom: 10),    // 파란색 박스 크기는 고정이고, 외부 padding 크기가 변한다
            
            // 4. EdgeInsets.
            padding: EdgeInsets.fromLTRB(10, 20, 30, 40),

            child: Container(
              color: Colors.blue,
              width: 50,
              height: 50,
            ),
          ),
        ),
      ),
    );
  }
}
