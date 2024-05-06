import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.pink[100],
      body: SafeArea(
        bottom: false,
        child: SizedBox(
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
              _Top(selectedDate: selectedDate, onHeartPressed: onHeartPressed,),
              _Bottom(),
            ],
          ),
        ),
      ),
    );
  }

  // 하트 IconButton 눌렀을 때 DatePicker 띄우는 콜백함수
  void onHeartPressed() {
    showCupertinoDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            color: Colors.white,
            height: 300,
            child: CupertinoDatePicker(
              mode: CupertinoDatePickerMode.date,
              initialDateTime: selectedDate,
              maximumDate: DateTime.now(),
              dateOrder: DatePickerDateOrder.ymd,
              onDateTimeChanged: (DateTime dt) {
                SystemSound.play(SystemSoundType.click);
                HapticFeedback.lightImpact();
                setState(() {
                  selectedDate = dt;
                });
                print(dt);
              },
            ),
          ),
        );
      },
    );
  }
}




class _Top extends StatelessWidget {
  final DateTime selectedDate;
  final VoidCallback? onHeartPressed;

  const _Top({
    required this.selectedDate,
    required this.onHeartPressed,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();

    return Expanded(
      child: Container(
        child: Column(
          children: [
            // 기존 textTheme 중 특정 파라미터만 바꾸고 싶다면 ==> copyWith
            // Text("U&I", style: Theme.of(context).textTheme.copyWith(displayLarge: Theme.of(context).textTheme.displayLarge!.copyWith(fontSize: 90)).displayLarge,),
            Text(
              "U&I",
              style: Theme.of(context).textTheme.displayLarge,
            ),
            Text(
              "우리 처음 만난 날",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            Text(
              "${selectedDate.year}.${selectedDate.month}.${selectedDate.day}.",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            IconButton(
              icon: Icon(
                Icons.favorite,
              ),
              color: Colors.red,
              iconSize: 60,
              onPressed: onHeartPressed,
            ),
            Text(
              "D+${now.difference(selectedDate).inDays + 1}",
              style: Theme.of(context).textTheme.bodyLarge,
            ),
          ],
        ),
      ),
    );
  }
}



class _Bottom extends StatelessWidget {
  const _Bottom({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: Image.asset(
          'asset/img/middle_image.png',
        ),
      ),
    );
  }
}
