import 'dart:io';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';


const List<String> storeList = [
  '신가네칼국수',
  '파리바게트',
  '오이시돈까스',
  '와플대학',
  '시골청국장',
  '반찬카페',
  '분식사',
  '역전우동',
  '소문난순대국',
  '신고집찜',
  '정가네족발',
  '태릉숯불갈비',
  '양자강',
];


class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {
  Map<String, Map<String, List<int>>> totalTicketData = {
    "와플대학": {'송재혁': [1, 5, 7], '김재형': [3, 9]},
    "반찬카페": {'이재환': [10], '정헌옥': [19, 20], '정서연': []},
  };
  Map<String, List<int>> contentsFromFile = {};
  Map<String, List<int>> currentTicketData = {'박옥주': [7, 9, 10], '맹진아': [1, 11, 20]};

  String targetDate = "202405";
  String selectedStore = "신가네칼국수";
  String folderPath = "";
  String filePath = "";

  @override
  void initState() {
    super.initState();

    // 폴더명+파일명 얻어오기
    _setFolderFilePath();
  }

  Future<void> _setFolderFilePath() async {
    final directory = await getApplicationDocumentsDirectory();
    final folder = Directory('${directory.path}/$targetDate');

    if (!await folder.exists()) {
      await folder.create(recursive: true);
    }

    folderPath = folder.path;
    filePath = '$folderPath/$selectedStore.json';
  }

  Future<File> writeToFile(Map<String, List<int>> content) async {
    String jsonContent = jsonEncode(content);
    return File(filePath).writeAsString(jsonContent);
  }

  Future<Map<String, Map<String, List<int>>>> readFromFile() async {
    try {
      if (await File(filePath).exists()) {
        String jsonContent = await File(filePath).readAsString();
        Map<String, dynamic> decoded = jsonDecode(jsonContent);
        Map<String, Map<String, List<int>>> content = decoded.map(
          (outerKey, innerMap) {
            return MapEntry(outerKey, Map<String, List<int>>.from(
                (innerMap as Map).map(
                  (innerKey, value) {
                    return MapEntry(
                      innerKey,
                      List<int>.from(value),
                    );
                  },
                ),
              )
            );
          },
        );
        return content;
      } else {
        print('File does not exist');
        return {};
      }
    } catch (e) {
      print('Error reading file: $e');
      return {};
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('File 저장 예제'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            ElevatedButton(
              onPressed: () async {
                await writeToFile(data);
                print('Data saved to file');
              },
              child: Text('파일에 예시 데이터 저장'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () async {
                Map<String, Map<String, List<int>>> content = await readFromFile();
                setState(() {
                  contentsFromFile = content;
                });
                print('Data read from file: $contentsFromFile');
              },
              child: Text('파일에서 읽기'),
            ),
            SizedBox(height: 20),
            Text('파일 내용: $contentsFromFile'),
          ],
        ),
      ),
    );
  }
}
