import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CodeFactoryWidget(),
    );
  }
}

// 실행해보면: 생성자 호출됨 -> 빌드 호출됨 -> 생성자 호출됨 -> 빌드 호출됨
// 이렇게 처음 실행될 때 항상 2번씩 생성자-빌드 쌍이 호출됨


class CodeFactoryWidget extends StatelessWidget {
  CodeFactoryWidget({super.key}) {
    // 생성자 body를 만들고, 안에 생성자 호출됨을 출력
    print("CodeFactoryWidget 생성자 호출됨");
  }

  @override
  Widget build(BuildContext context) {
    print("CodeFactoryWidget 빌드 호출됨");
    return Container(
      color: Colors.red,
      width: 50,
      height: 50,
    );
  }
}
