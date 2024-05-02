import 'package:flutter/material.dart';
import 'dart:async';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  Timer? timer;
  PageController controller = PageController();

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(
      Duration(seconds: 2),
      (timer) {
        int currentPage = controller.page!.toInt();
        int nextPage = (currentPage + 1) % 5;
        print("current: $currentPage, next: $nextPage");

        controller.animateToPage(nextPage, duration: Duration(milliseconds: 500), curve: Curves.linear);
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
    if(timer != null) {
      timer!.cancel();
    }
    controller.dispose();
    super.dispose();
  }
}
