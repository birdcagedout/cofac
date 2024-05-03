import 'package:flutter/material.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? timer;
  PageController controller = PageController(); // PageViewController 아님

  @override
  void initState() {
    super.initState();

    // 타이머 인스턴스 생성 => 나중에 삭제(timer.cancel)
    timer = Timer.periodic(
      Duration(seconds: 2),
      (timer) {
        int currentPage = controller.page!.toInt();   // 0부터 시작(index임)
        int nextPage = (currentPage + 1) % 5;
        print("current: $currentPage, next: $nextPage");

        controller.animateToPage(
          nextPage,
          duration: Duration(milliseconds: 500),    // animation 지속시간
          curve: Curves.linear,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: controller,
        children: [1, 2, 3, 4, 5]
          .map(
            (e) => Image.asset(
              'asset/img/image_$e.jpeg',
              fit: BoxFit.cover,
            ),
          )
          .toList(),
      ),
    );
  }

  @override
  void dispose() {
    // memory leak 방지: timer, controller는 항상 dispose에서 삭제해야 함
    if (timer != null) {
      timer!.cancel();
    }
    controller.dispose();

    super.dispose();
  }
}
