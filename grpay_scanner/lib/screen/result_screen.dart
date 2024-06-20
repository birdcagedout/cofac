import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'package:syncfusion_flutter_core/theme.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart' as xlsio;
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../const/const.dart';
import '../core/staff_store_data.dart';



// Grid를 만들기 위한 DataSource(식당별 식권 개수)
class RestaurantDataSource extends DataGridSource {
  final Map<String, Map<String, List<int>>> ticketData;
  final List<DataGridRow> _restaurants;

  RestaurantDataSource({required this.ticketData})
      : _restaurants = List<DataGridRow>.generate(storeList.length + 1, (index) {
    return DataGridRow(
      cells: [
        DataGridCell<String> (
          columnName: 'restaurant',
          value: ticketData.keys.toList()[index] + "(" + ticketData[ticketData.keys.toList()[index]]!['소계']!.length.toString() + ")"
        ),

        for (var staff in staffNameList)
          DataGridCell<int> (
            columnName: staff,
            value: ticketData[ticketData.keys.toList()[index]]![staff]!.length,
          ),
      ],
    );
  });

  @override
  List<DataGridRow> get rows => _restaurants;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    int rowIndex = _restaurants.indexOf(row);
    Color bgColor = rowIndex.isOdd ? Colors.purple[50]! : Colors.white;
    if (rowIndex == storeList.length) bgColor = Colors.blue;

    return DataGridRowAdapter(
      color: bgColor,
      cells: [
        for (var cell in row.getCells())
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            alignment: Alignment.center,
            // decoration: BoxDecoration(
            //   border: Border.all(color: Colors.transparent),
            // ),
            child: Text(cell.value.toString()),
          ),
      ],
    );
  }
}




// DataGrid를 위한 위젯
class ResultScreen extends StatefulWidget {
  final Map<String, Map<String, List<int>>> ticketData;
  const ResultScreen({required this.ticketData, super.key});

  @override
  _ResultScreenState createState() => _ResultScreenState();
}


class _ResultScreenState extends State<ResultScreen> {
  late RestaurantDataSource restaurantDataSource;

  @override
  void initState() {
    super.initState();
    restaurantDataSource = RestaurantDataSource(ticketData: widget.ticketData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(title: Text('${targetYear}년 $targetMonth월 식권 정산', style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold,),), centerTitle: true,),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 0.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Column(
              children: [
                Expanded(
                  flex: 10,
                  child: SfDataGridTheme(
                    data: const SfDataGridThemeData(frozenPaneLineColor: Colors.transparent),
                    child: SfDataGrid(
                      source: restaurantDataSource,
                      frozenColumnsCount: 1,        // 첫번째 컬럼 고정 (좌우 스크롤 시)
                      frozenRowsCount: 0,
                      rowHeight: 42,
                      // allowEditing: true,
                      gridLinesVisibility: GridLinesVisibility.none,
                      columns: [
                        // 첫번째 컬럼 헤더
                        GridColumn(
                          columnName: 'restaurant',
                          columnWidthMode: ColumnWidthMode.auto,
                          autoFitPadding: const EdgeInsets.all(10),
                          width: 110,
                          label: Container(
                            color: Colors.purple[800],
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            alignment: Alignment.center,
                            child: const Text('식당(개수)', style: TextStyle(fontSize: 16, color: Colors.white,),),
                          ),
                        ),
                        // 나머지 컬럼 헤더
                        for (var staff in staffNameList)
                          GridColumn(
                            columnName: staff,
                            columnWidthMode: ColumnWidthMode.auto,
                            autoFitPadding: const EdgeInsets.all(10),
                            label: Container(
                              color: Colors.purple[800],
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              alignment: Alignment.center,
                              child: Text(staff, style: const TextStyle(fontSize: 16, color: Colors.white,),),
                            ),
                          ),
                      ],
                    ),
                  ),
                ),

                Expanded(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 0, bottom: 15),
                    child: SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: OutlinedButton.icon(
                        icon: const Icon(Icons.ios_share),
                        label: const Text('엑셀 파일로 공유하기', style: TextStyle(fontSize: 20,),),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: Colors.green[800],
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12),),
                          side: const BorderSide(color: Colors.transparent,),
                          elevation: 5,
                          shadowColor: Colors.black,
                        ),
                        onPressed: () async {
                          await saveExcel(widget.ticketData);
                        },
                      ),
                    ),
                  ),
                ),

              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> saveExcel(Map<String, Map<String, List<int>>> ticketData) async {
    final xlsio.Workbook workbook = xlsio.Workbook();
    final xlsio.Worksheet sheet = workbook.worksheets[0];

    // 첫 번째 컬럼의 너비 설정 (예: 15 포인트)
    sheet.getRangeByIndex(1, 1).columnWidth = 15;

    // 컬럼 헤더 넣기: ['식당이름', '소계', '송재혁', '이재환', ...]
    List<String> headerRow = ['식당이름', '소계'] + staffNameList;
    for (int i = 0; i < headerRow.length; i++) {

      // 헤더 셀에 테두리 추가
      var cell = sheet.getRangeByIndex(1, i + 1);
      cell.cellStyle.borders.all.lineStyle = xlsio.LineStyle.thin;
      cell.cellStyle.backColor = '#${(Colors.purple[800]!.value & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
      cell.cellStyle.fontColor = '#FFFFFF';

      // 헤더 셀에 값 넣기
      cell.setText(headerRow[i]);
    }

    // 데이터 row 넣기: ['신가네', 54, 5, 10, ...]
    int rowIndex = 2; // Start from row 2 as row 1 is header
    ticketData.forEach((restaurant, staffData) {
      List<dynamic> row = [restaurant, staffData['소계']!.length];
      row.addAll(staffNameList.map((staff) => staffData[staff]!.length));

      for (int i = 0; i < row.length; i++) {

        // 각 셀에 테두리 추가
        var cell = sheet.getRangeByIndex(rowIndex, i + 1);
        cell.cellStyle.borders.all.lineStyle = xlsio.LineStyle.thin;

        // 각 셀에 값 넣기
        cell.setText(row[i].toString());

        // 짝수 row(데이터 첫줄이 rowIndex=2)일 때 배경색 넣기
        if(rowIndex.isOdd) {
          cell.cellStyle.backColor = '#${(Colors.purple[50]!.value & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
        }

        // 맨끝 합계 row의 배경색, 글자색
        if(restaurant.contains('합계')) {
          cell.cellStyle.backColor = '#${(Colors.blue.value & 0xFFFFFF).toRadixString(16).padLeft(6, '0').toUpperCase()}';
          cell.cellStyle.fontColor = '#FFFFFF';
        }
      }
      rowIndex++;
    });

    // Save the file
    final List<int> bytes = workbook.saveAsStream();
    workbook.dispose();
    final String path = (await getApplicationDocumentsDirectory()).path;
    final String fileName = '$path/급량페이${targetYear}${targetMonth < 10 ? "0" + targetMonth.toString() : targetMonth.toString()}.xlsx';
    final File file = File(fileName);
    await file.writeAsBytes(bytes, flush: true);

    print('Excel file saved: $fileName');

    // Share the file
    final result = await Share.shareXFiles([XFile(fileName)], subject: '급량페이 정산결과(${targetYear}${targetMonth < 10 ? "0" + targetMonth.toString() : targetMonth.toString()})', text: '엑셀 파일로 저장된 식권 정산 데이터입니다.');
    if(result.status == ShareResultStatus.success) {
      debugPrint("공유 성공");
    } else {
      debugPrint("공유 실패");
    }
  }
}
