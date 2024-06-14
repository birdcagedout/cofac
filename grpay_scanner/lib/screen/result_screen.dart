import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
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
    Color bgColor = rowIndex.isOdd ? Colors.grey[200]! : Colors.white;

    return DataGridRowAdapter(
      color: bgColor,
      cells: [
        for (var cell in row.getCells())
          Container(
            padding: EdgeInsets.symmetric(horizontal: 5),
            alignment: Alignment.center,
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
      appBar: AppBar(title: Text('${targetYear}년 $targetMonth월 식권 정산', style: TextStyle(fontSize: 25,),), centerTitle: true,),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              flex: 10,
              child: SfDataGrid(
                source: restaurantDataSource,
                frozenColumnsCount: 1,        // 첫번째 컬럼 고정 (좌우 스크롤 시)
                frozenRowsCount: 0,
                rowHeight: 42,
                columns: [
                  // 첫번째 컬럼 헤더
                  GridColumn(
                    columnName: 'restaurant',
                    columnWidthMode: ColumnWidthMode.auto,
                    autoFitPadding: const EdgeInsets.all(10),
                    width: 110,
                    label: Container(
                      color: Colors.black54,
                      padding: EdgeInsets.symmetric(horizontal: 5),
                      alignment: Alignment.center,
                      child: Text('식당(개수)', style: TextStyle(fontSize: 16, color: Colors.white,),),
                    ),
                  ),
                  // 나머지 컬럼 헤더
                  for (var staff in staffNameList)
                    GridColumn(
                      columnName: staff,
                      columnWidthMode: ColumnWidthMode.auto,
                      autoFitPadding: const EdgeInsets.all(10),
                      label: Container(
                        color: Colors.black54,
                        padding: EdgeInsets.symmetric(horizontal: 5),
                        alignment: Alignment.center,
                        child: Text(staff, style: TextStyle(fontSize: 16, color: Colors.white,),),
                      ),
                    ),
                ],
              ),
            ),

            Expanded(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.only(top: 0, bottom: 15, left: 10, right: 10,),
                child: SizedBox(
                  width: MediaQuery.of(context).size.width,
                  child: OutlinedButton.icon(
                    icon: Icon(Icons.ios_share),
                    label: Text('엑셀 파일로 공유하기', style: TextStyle(fontSize: 20,),),
                    style: OutlinedButton.styleFrom(
                      backgroundColor: Colors.green[800],
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13),),
                      side: BorderSide(color: Colors.transparent,),
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
    );
  }

  Future<void> saveExcel(Map<String, Map<String, List<int>>> ticketData) async {
    final xlsio.Workbook workbook = xlsio.Workbook();
    final xlsio.Worksheet sheet = workbook.worksheets[0];

    // Add header row
    List<String> headerRow = ['식당(개수)'] + staffNameList;
    for (int i = 0; i < headerRow.length; i++) {
      sheet.getRangeByIndex(1, i + 1).setText(headerRow[i]);
    }

    // Add data rows
    int rowIndex = 2; // Start from row 2 as row 1 is header
    ticketData.forEach((restaurant, staffData) {
      List<dynamic> row = [restaurant + "(${staffData['소계']!.length})"];
      row.addAll(staffNameList.map((staff) => staffData[staff]!.length));
      for (int i = 0; i < row.length; i++) {
        sheet.getRangeByIndex(rowIndex, i + 1).setText(row[i].toString());
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
