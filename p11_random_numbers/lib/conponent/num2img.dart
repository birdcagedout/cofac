import 'package:flutter/material.dart';

class Num2Img extends StatelessWidget {
  final int num;
  const Num2Img({required this.num, super.key,});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: num.toString().split('')
        .map(
          (e) => Image.asset(
            'asset/img/$e.png',
            width: 50,
            height: 70,
          ),
        )
        .toList(),
    );
  }
}
