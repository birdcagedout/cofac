import 'dart:async';

import 'package:flutter/material.dart';
import 'dart:math';

class HomeScreen extends StatefulWidget {
  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final ValueNotifier<int> count = ValueNotifier<int>(0);

  final ValueNotifier<Set<int>> counter = ValueNotifier({});
  Timer? timer;

  @override
  void initState() {
    super.initState();

    timer = Timer.periodic(
      Duration(seconds: 2),
      (timer) {
        // count.value = Random().nextInt(10);
        counter.value.add(Random().nextInt(10));
        print("현재 counter: ${counter.value}");
        setState(() {

        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ValueListenableBuilder(
          valueListenable: counter,
          builder: (context, value, child) {
            return Text("현재값: ${value.length}");
          },
        ),
      ),
    );
  }
}
