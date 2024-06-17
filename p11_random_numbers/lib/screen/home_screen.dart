import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:p11_random_numbers/conponent/num2img.dart';
import 'package:p11_random_numbers/const/colors.dart';
import 'dart:math';

import 'package:p11_random_numbers/screen/setting_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key,});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<int> numbers = [123, 456, 789];
  int maxNumber = 1000;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: primaryColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 제목+아이콘
              _Header(onSettingPressed: onSettingPressed,),

              // 화면 중앙 숫자표시 부분
              _Body(numbers: numbers,),

              // 화면 하단 버튼부
              _Footer(onGeneratePressed: onGeneratePressed,),
            ],
          ),
        ),
      ),
    );
  }


  void onSettingPressed() async {
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (BuildContext context){
          return SettingScreen(maxNumber: maxNumber.toDouble(),);
        },
      ),
    );
    print(result);
    setState(() {
      this.maxNumber = result;
    });
  }

  void onGeneratePressed() {
    // print('pressed');
    final rand = Random();

    final Set<int> newNums = {};
    while(newNums.length < 3) {
      final n = rand.nextInt(maxNumber);
      newNums.add(n);
    }

    setState(() {
      numbers = newNums.toList();
    });
  }
}


class _Header extends StatelessWidget {
  final VoidCallback onSettingPressed;
  const _Header({
    required this.onSettingPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          "랜덤숫자 생성기",
          style: TextStyle(
            color: whiteColor,
            fontSize: 30,
            fontWeight: FontWeight.w700,
          ),
        ),
        IconButton(
          color: redColor,
          onPressed: onSettingPressed,
          icon: Icon(Icons.settings),
        ),
      ],
    );
  }
}


class _Body extends StatelessWidget {
  final List<int> numbers;

  const _Body({
    required this.numbers,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,

        // 1. 한번에 1줄씩
        // children: [
          // Row(
          //   children: [
          //     '1', '2', '3'
          //   ].map((e) => Text(e, style: TextStyle(color: whiteColor),)).toList(),
          // ),
          // Row(
          //   children: [
          //     '4', '5', '6'
          //   ].map((e) => Text(e, style: TextStyle(color: whiteColor),)).toList(),
          // ),
          // Row(
          //   children: [
          //     '7', '8', '9'
          //   ].map((e) => Text(e, style: TextStyle(color: whiteColor),)).toList(),
          // ),
        // ],

        // 2. map을 2번 써서 간단하게
        // children: [
        //   [1, 2, 3],
        //   [4, 5, 6],
        //   [7, 8, 9],
        // ]
        //   .map(
        //     (e) => Row(
        //       children: e
        //         .map(
        //           (f) => Image.asset(
        //             'asset/img/$f.png',
        //             width: 50,
        //             height: 70,
        //           ),
        //         )
        //       .toList(),
        //     ),
        //   )
        // .toList(),

        // 3. 2차 List가 아니라 1차 List로 사용하기
        // children: numbers
        //   .map(
        //     (e1) => e1.toString().split(''),    // 123 -> ['1', '2', '3']
        //   )
        //     .map(
        //       (e) => Row(
        //         children: e
        //           .map(
        //             (f) => Image.asset(
        //               'asset/img/$f.png',
        //               width: 50,
        //               height: 70,
        //             ),
        //           )
        //           .toList(),
        //       ),
        //     )
        //     .toList(),
        
        // 4. component로 Num2Img 사용하기
        children: numbers.map((e) => Num2Img(num: e)).toList(),
      ),
    );
  }
}

class _Footer extends StatelessWidget {
  final VoidCallback onGeneratePressed;
  const _Footer({
    required this.onGeneratePressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onGeneratePressed,
      child: Text("생성하기"),
      style: ElevatedButton.styleFrom(
        backgroundColor: redColor,
        foregroundColor: whiteColor,
      ),
    );
  }
}
