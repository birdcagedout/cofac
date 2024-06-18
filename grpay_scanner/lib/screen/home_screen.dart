import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '/const/const.dart';
import '/core/staff_store_data.dart';
import '/screen/result_screen.dart';
import '/screen/scanner_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final DateTime today = DateTime.now();
  // 오늘의 1달 전 날짜(5월 31일의 한달 전은 4월의 마지막날인 4월 30일)
  final DateTime lastMonth = DateTime(
    DateTime.now().year,
    DateTime.now().month - 1,
    DateTime.now().day > DateTime(DateTime.now().year, DateTime.now().month, 0).day
        ? DateTime(DateTime.now().year, DateTime.now().month, 0).day
        : DateTime.now().day,
    DateTime.now().hour,
  );
  DateTime selectedDate = DateTime.now();
  String selectedStore = "";
  
  // 데이터 저장 ==> 전역변수 ticketData

  @override
  void initState() {
    super.initState();

    selectedDate = lastMonth.isBefore(DateTime(2024, 5, 1))
        ? DateTime(2024, 5, 1)
        : lastMonth;
  }

  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("급량  ", style: TextStyle(fontSize: 25,),),
          Container(width: 30, height: 30, child: Image.asset('asset/img/grpay2.png', fit: BoxFit.contain,)),
          const Text("  페이", style: TextStyle(fontSize: 25,),),
        ],
      ), centerTitle: true,),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 0),
        child: Column(
          children: [

            // 첫번째=설정
            Column(
              children: [
                const Divider(
                  height: 20,
                  thickness: 1,
                  indent: 0,
                  endIndent: 0,
                  color: Color(0x739E9E9E),
                ),

                // Row(
                //   children: [
                //     const Text("설정", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),),
                //     IconButton(onPressed: showDatePicker, icon: Icon(Icons.settings), iconSize: 25, color: Colors.deepPurple,),
                //   ],
                // ),
                // const SizedBox(height: 15,),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     const Expanded(child: Text("기준연월", style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600,),)),
                //     Text("${selectedDate.year}년 ${selectedDate.month}월", style: TextStyle(color: Colors.deepPurple, fontSize: 16, fontWeight: FontWeight.w600,),),
                //   ],
                // ),
                // const SizedBox(height: 10,),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                //   children: [
                //     const Text("가맹점 / 직원수", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,),),
                //     Text("${storeList.length}개 / ${staffIDList.length}명", style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600,),),
                //   ],
                // ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  height: 150,
                  decoration: BoxDecoration(
                    color: Colors.blue[200],
                    borderRadius: BorderRadius.circular(8),
                    boxShadow: kElevationToShadow[2],
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Container(
                            color: Colors.green[500],
                          ),
                        ),
                      ),
                      Expanded(flex: 5, child: Container()),
                    ],
                  ),
                )
              ],
            ),
            const Divider(
              height: 40,
              thickness: 1,
              indent: 0,
              endIndent: 0,
              color: Color(0x739E9E9E),
            ),


            // 두번째=작업
            Column(
              children: [
                // SizedBox(height: 15,),
                const Row(
                  children: [Text("작업", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),)],
                ),
                const SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(child: Text("완료", style: TextStyle(color: Colors.green[700], fontSize: 17, fontWeight: FontWeight.w600),)),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text("가맹점 ${doneStores.values.where((isDone) => isDone).length}개", style: TextStyle(color: Colors.green[700], fontSize: 16, fontWeight: FontWeight.w600,),),
                        Text("스캔됨 ${ [for(var store in storeList) ticketData[store]!['소계']!.length].fold(0, (acc, val) => acc + val) }개", style: TextStyle(color: Colors.green[700], fontSize: 16, fontWeight: FontWeight.w600),),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text("예정", style: TextStyle(color: Colors.redAccent, fontSize: 17, fontWeight: FontWeight.w600,),),
                    Text("가맹점 ${doneStores.values.where((isDone) => !isDone).length}개", style: TextStyle(color: Colors.redAccent, fontSize: 16, fontWeight: FontWeight.w600,),)],
                ),
              ],
            ),

            const Divider(
              height: 40,
              thickness: 1,
              indent: 0,
              endIndent: 0,
              color: Color(0x739E9E9E),
            ),

            // 세번째=사용방법
            const Column(
              children: [
                // SizedBox(height: 15,),
                Row(
                  children: [Text("사용방법", style: TextStyle(fontSize: 25, fontWeight: FontWeight.w800),)],
                ),
                SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text("1. 스캔하기를 선택한다"),],
                ),
                SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text("2. 스캔할 가맹점(식당)을 선택한다")],
                ),
                SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text("3. 그 가맹점의 식권을 모두 스캔한다")],
                ),
                SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text("4. 저장하기를 누른다 (다시 1번부터 반복)")],
                ),
                SizedBox(height: 15,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [Text("⚠︎ 스캔하기 전 반드시 상호명을 확인해주세요")],
                ),
              ],
            ),

            const Divider(
              height: 40,
              thickness: 1,
              indent: 0,
              endIndent: 0,
              color: Color(0x739E9E9E),
            ),

            // 스캔하기 버튼
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: OutlinedButton.icon(
                icon: const Icon(Icons.qr_code),
                label: const Text("스캔하기", style: TextStyle(fontSize: 20,),),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.red[700],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),),
                  side: BorderSide(color: Colors.transparent,),
                ),
                onPressed: () async {
                  // 스캔할 가맹점 입력 받기
                  final String? selectedValue = await _showDialog(context);
                  if (selectedValue == null) return;

                  // 가맹점 입력이 제대로 들어오면 push
                  // 리턴값까지 받아옴
                  selectedStore = selectedValue;
                  Map<String, List<int>>? dataFromTheStore = await Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return ScannerScreen(selectedStore: selectedStore,);
                      },
                    ),
                  );

                  // 저장하기 안 누르고 뒤로 돌아간 경우
                  if(dataFromTheStore == null) {
                    print("널값 리턴");
                    return;
                  }

                  // 아래는 모두 저장하기 누른 경우

                  // 리턴값을 식권데이터 표에 저장
                  for(var staff in dataFromTheStore.keys) {
                    for(var eachNumber in dataFromTheStore[staff]!) {
                      if(!ticketData[selectedStore]![staff]!.contains(eachNumber)) {
                        ticketData[selectedStore]![staff]!.add(eachNumber);
                      }
                    }
                  }
                  // print(ticketData);

                  // '(식당별)소계' 저장 ==> 리턴값을 받은 타이밍에 반드시 계산하여 저장(나중에 selectedStore는 달라질 수도 있다)
                  int total = 0;
                  for(var staff in staffNameList) {
                    total += ticketData[selectedStore]![staff]!.length;
                  }
                  ticketData[selectedStore]!['소계'] = List.filled(total, 0);   // 스캔된 식권이 5개이면 [0,0,0,0,0]

                  // 스캔 마친 가게 + 스캔완료 개수 update
                  setState(() {
                    doneStores[selectedStore] = true;
                  });
                },
              ),
            ),

            SizedBox(height: 20,),

            // 결과보기 버튼
            SizedBox(
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: OutlinedButton.icon(
                icon: Icon(Icons.list_alt),
                label: Text("결과보기", style: TextStyle(fontSize: 20,),),
                style: OutlinedButton.styleFrom(
                  backgroundColor: Colors.blue[700],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),),
                  side: BorderSide(color: Colors.transparent,),
                ),
                onPressed: () {
                  // "개인별 합계" + "합계의 소계(=전체 총계)"를 계산한다
                  int totalForEveryone = 0;
                  for(var staff in staffNameList) {
                    int totalForEachOne = 0;
                    for(var store in storeList) {
                      totalForEachOne += ticketData[store]![staff]!.length;
                    }
                    ticketData['합계']![staff] = List.filled(totalForEachOne, 1);   // 개인별 합계
                    totalForEveryone += totalForEachOne;
                  }
                  ticketData['합계']!['소계'] = List.filled(totalForEveryone, 1);   // 합계의 소계(=전체 총계)
                  
                  // DataTable 페이지로 넘어간다
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) {
                        return ResultScreen(ticketData: ticketData,);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }


  // 날짜(연,월) 입력받는 함수
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
                  onPressed: () {
                    targetYear = selectedDate.year;
                    targetMonth = selectedDate.month;
                    Navigator.of(context).pop();
                  }
                ),
              ],
            ),
            // DatePicker
            Expanded(
              child: CupertinoDatePicker(
                mode: CupertinoDatePickerMode.monthYear,
                // dateOrder: DatePickerDateOrder.ymd,
                minimumDate: DateTime(2024, 5),
                maximumDate: today,
                initialDateTime: selectedDate,
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

  // 식당 선택 다이얼로그 창
  Future<String?> _showDialog(BuildContext context) async {
    return await showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        String? _dialogSelectedValue;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setState) {
            return AlertDialog(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('스캔할 가맹점 선택  '),
                ],
              ),
              content: DropdownButton<String>(
                hint: Text('가맹점을 선택해주세요'),
                value: _dialogSelectedValue,
                items: storeList.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _dialogSelectedValue = newValue;
                  });
                },
              ),
              actions: <Widget>[
                TextButton(
                  child: Text('완료'),
                  onPressed: () {
                    Navigator.of(context).pop(_dialogSelectedValue);
                  },
                ),
              ],
            );
          },
        );
      },
    );
  }

}
