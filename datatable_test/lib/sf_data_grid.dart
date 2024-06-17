import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_datagrid/datagrid.dart';
import 'core.dart';





// Grid를 만들기 위한 DataSource(식당별 식권 개수)
class RestaurantDataSource extends DataGridSource {
  final Map<String, Map<String, List<int>>> ticketData;
  final List<DataGridRow> _restaurants;

  RestaurantDataSource({required this.ticketData})
      : _restaurants = List<DataGridRow>.generate(storeList.length, (index) {
    return DataGridRow(
      cells: [
        DataGridCell<String> (
          columnName: 'restaurant',
          value: storeList[index],
        ),

        for (var staff in staffNameList)
          DataGridCell<int> (
            columnName: staff,
            value: ticketData[storeList[index]]![staff]!.length,
          ),
      ],
    );
  });

  @override
  List<DataGridRow> get rows => _restaurants;

  @override
  DataGridRowAdapter buildRow(DataGridRow row) {
    int rowIndex = _restaurants.indexOf(row);
    Color bgColor = rowIndex.isOdd ? Colors.grey[200]! : Colors.transparent;

    return DataGridRowAdapter(
      color: bgColor,
      cells: [
        for (var cell in row.getCells())
          Container(
            padding: EdgeInsets.all(8.0),
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
    restaurantDataSource = RestaurantDataSource(ticketData:  widget.ticketData);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('${targetYear}년 $targetMonth월 식권 정산'),),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SfDataGrid(
                source: restaurantDataSource,
                frozenColumnsCount: 1,        // 첫번째 컬럼 고정 (좌우 스크롤 시)
                frozenRowsCount: 0,
                columns: [
                  // 첫번째 컬럼 헤더
                  GridColumn(
                    columnName: 'restaurant',
                    label: Container(
                      color: Colors.green[100],
                      padding: EdgeInsets.all(8.0),
                      alignment: Alignment.center,
                      child: Text('식당', style: TextStyle(fontSize: 16,),),
                    ),
                  ),
                  // 나머지 컬럼 헤더
                  for (var staff in staffNameList)
                    GridColumn(
                      columnName: staff,
                      label: Container(
                        color: Colors.green[100],
                        padding: EdgeInsets.all(8.0),
                        alignment: Alignment.center,
                        child: Text(staff, style: TextStyle(fontSize: 16,),),
                      ),
                    ),
                ],
              ),
            ),
        
            OutlinedButton(
              onPressed: () async {
                // await saveExcel(widget.ticketData);
                },
              child: Text('엑셀 파일로 저장'),
            ),
          ],
        ),
      ),
    );
  }

  // Future<void> saveExcel(Map<String, Map<String, int>> ticketData) async {
  //   var excel = Excel.createExcel();
  //   Sheet sheet = excel['Sheet1'];
  //
  //   // Add header row
  //   List<String> headerRow = ['식당'] + staffList;
  //   sheet.appendRow(headerRow);
  //
  //   // Add data rows
  //   for (var store in storeList) {
  //     List<dynamic> row = [store];
  //     row.addAll(List<int>.generate(staffList.length, (index) => ticketData[store]![staffList[index]]));
  //     sheet.appendRow(row);
  //   }
  //
  //   // Save the file
  //   Directory directory = await getApplicationDocumentsDirectory();
  //   String path = directory.path;
  //   String fileName = '$path/restaurant_meals.xlsx';
  //   File(fileName)
  //     ..createSync(recursive: true)
  //     ..writeAsBytesSync(excel.encode()!);
  //
  //   print('Excel file saved: $fileName');
  // }
}
