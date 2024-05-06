import 'dart:math';

import 'package:flutter/material.dart';
import 'package:p11_random_numbers/conponent/num2img.dart';
import 'package:p11_random_numbers/const/colors.dart';

class SettingScreen extends StatefulWidget {
  double maxNumber;    // slider값이 double이므로
  SettingScreen({required this.maxNumber, super.key});

  @override
  State<SettingScreen> createState() => _SettingScreenState();
}

class _SettingScreenState extends State<SettingScreen> {

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
              _Numbers(maxNumber: widget.maxNumber,),
              _Slider(value: widget.maxNumber, onSliderChanged: onSliderChanged,),
              _SaveButton(onSavePressed: onSavePressed,),
            ],
          ),
        ),
      ),
    );
  }

  void onSliderChanged(double val) {
    print("실행전: ${widget.maxNumber}");
    setState(() {
      widget.maxNumber = val;
      print("실행후: ${widget.maxNumber}");
    });
  }


  void onSavePressed() {
    Navigator.of(context).pop(widget.maxNumber.toInt());    // 전달할 값을 pop의 인자로 넣어줌
  }
}


class _Numbers extends StatelessWidget {
  final double maxNumber;

  const _Numbers({
    required this.maxNumber,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Num2Img(num: maxNumber.toInt(),),
    );
  }
}


class _Slider extends StatelessWidget {
  final double value;
  final ValueChanged<double> onSliderChanged;

  const _Slider({required this.value, required this.onSliderChanged, super.key});

  @override
  Widget build(BuildContext context) {
    return Slider(
      min: 1000,
      max: 100000,
      value: value,
      activeColor: redColor,
      onChanged: onSliderChanged,
      );
  }
}

class _SaveButton extends StatelessWidget {
  final VoidCallback? onSavePressed;
  const _SaveButton({required this.onSavePressed, super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onSavePressed,
      child: Text("저장"),
      style: ElevatedButton.styleFrom(
        backgroundColor: redColor,
        foregroundColor: whiteColor,
      ),
    );
  }
}
