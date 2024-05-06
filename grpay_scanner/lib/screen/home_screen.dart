import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {
  final now = DateTime.now();

  final lastMonth = DateTime(DateTime.now().year, DateTime.now().month-1);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xFF335CB0),   // Hex값 입력할 때는 Color(값), FF는 Alpha
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 80.0),
            child: GestureDetector(
              child: Image.asset('asset/img/grpay2.png'),
              onTap: showDatePicker,
            ),
          ),
          SizedBox(height: 1.0),
          Text(
            "급 량 페 이",
            style: TextStyle(
              fontSize: 60,
              fontWeight: FontWeight.w900,
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "QR Scanner ",
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w800,
                ),
              ),
              Text(
                "ver.0.1b",
                style: TextStyle(fontSize: 20.0, color: Colors.green,),
              ),
            ],
          ),
          SizedBox(height: 10.0),
          CircularProgressIndicator(
            color: Color(0xFFFFC400),
          ),
        ],
      ),
    );
  }

  void showDatePicker() {
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
              mode: CupertinoDatePickerMode.monthYear,
              // dateOrder: DatePickerDateOrder.ymd,
              minimumDate: DateTime(2024, 5),
              maximumDate: now,
              initialDateTime: lastMonth.isBefore(DateTime(2024, 5)) ? DateTime(2024, 5) : lastMonth,
              onDateTimeChanged: (DateTime dt) {
                SystemSound.play(SystemSoundType.click);
                HapticFeedback.lightImpact();
                print(dt);
              },
            ),
          ),
        );
      },
    );
  }
}
