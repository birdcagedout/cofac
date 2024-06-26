import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:p02_splash_screen/screen/scanner_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final now = DateTime.now();
  final lastMonth = DateTime(DateTime.now().year, DateTime.now().month-1);
  DateTime selectedDate = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("홈", style: TextStyle(fontSize: 25,),), centerTitle: true,),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 0),
        child: Column(
          children: [
            // 첫번째=설정
            Column(
              children: [
                // SizedBox(height: 15,),
                Row(
                  children: [
                    Text("설정", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),),
                    IconButton(onPressed: showDatePicker, icon: Icon(Icons.settings), iconSize: 25,),
                  ],
                ),
                SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Expanded(child: Text("기준월")), Text("${selectedDate.year}년 ${selectedDate.month}월"),],
                ),
                SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text("가맹점"), Text("13개")],
                ),
                SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text("스캔방법"), Text("스캔전 묻기 + 스캔후 저장")],
                ),
              ],
            ),

            SizedBox(height: 30,),


            // 두번째=작업
            Column(
              children: [
                // SizedBox(height: 15,),
                Row(
                  children: [Text("작업", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),)],
                ),
                SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Expanded(child: Text("완료")), Column(
                    children: [
                      Text("가맹점 0개"),
                      Text("스캔됨 0개"),
                    ],
                  ),],
                ),
                SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text("예정"), Text("가맹점 13개")],
                ),
              ],
            ),

            SizedBox(height: 30,),

            // 사용방법
            Column(
              children: [
                // SizedBox(height: 15,),
                Row(
                  children: [Text("사용방법", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),)],
                ),
                SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text("1. 스캔하기를 터치한다"),],
                ),
                SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text("2. 가맹점(식당)을 선택한다")],
                ),
                SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text("3. 식권을 스캔한다")],
                ),
                SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text("4. 스캔완료 후 반드시 저장을 누른다")],
                ),
              ],
            ),

            SizedBox(height: 40,),

            // 스캔하기 버튼
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.red[700],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15),),
                  side: BorderSide(color: Colors.transparent,),
                ),
                onPressed: () {
                  // 스캐너 페이지로 넘어간다
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return ScannerScreen();
                    },),
                  );
                },
                child: Text("스캔하기", style: TextStyle(fontSize: 20,),),
              ),
            ),

            SizedBox(height: 20,),

            // 결과보기 버튼
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.green[800],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15),),
                  side: BorderSide(color: Colors.transparent,),
                ),
                onPressed: () {
                  // 스캐너 페이지로 넘어간다
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) {
                      return ScannerScreen();
                    },),
                  );
                },
                child: Text("결과보기", style: TextStyle(fontSize: 20,),),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void showDatePicker() {
    showCupertinoModalPopup(
      context: context,
      builder: (_) => Container(
        height: 350,
        color: CupertinoColors.systemBackground,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                CupertinoButton(
                  child: Text('완료'),
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),
            // DatePicker
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.monthYear,
                // dateOrder: DatePickerDateOrder.ymd,
                minimumDate: DateTime(2024, 5),
                maximumDate: now,
                initialDateTime: lastMonth.isBefore(DateTime(2024, 5))
                    ? DateTime(2024, 5)
                    : lastMonth,
                onDateTimeChanged: (DateTime selected) {
                  SystemSound.play(SystemSoundType.click);
                  HapticFeedback.mediumImpact();
                  // print(dt);
                  setState(() {
                    selectedDate = selected;
                  });
                },
              ),
            ),
          ],
        ),
      ),
    );
  }



}
