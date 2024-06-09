import 'package:flutter/material.dart';

///=============================================
/// 13개
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

/// 직원 22명 이름
const List<String> staffNameList = [
  '송재혁',
  '이재환',
  '정헌옥',
  '정서연',
  '최경희',
  '김재형',
  '강효정',
  '유예준',
  '류은지',
  '강희진',
  '이유미',
  '박옥주',
  '윤상익',
  '이형진',
  '송의화',
  '맹진아',
  '문길준',
  '박사영',
  '신은경',
  '황석연',
  '이현정',
  '이지혜'
];


/// 직원 22명의 ID(내선번호)
const List<String> staffIDList = [
  '2610',
  '2591',
  '2595',
  '2592',
  '2597',
  '2596',
  '2594',
  '2599',
  '2598',
  '2600',
  '2141',
  '2142',
  '2151',
  '2146',
  '2230',
  '2143',
  '2601',
  '2149',
  '2148',
  '2145',
  '2112',
  '2113'
];

/// 22명 각각의 QR 테두리 색깔
final List<Color> edgeColorList = [
  Color(0xFFff1493),
  Color(0xffa14e14),
  Color(0xff5b4acb),
  Color(0xFF3cb371),
  Color(0xFF008b8b),
  Color(0xFF9acd32),
  Color(0xff0a0abe),
  Color(0xFFff4500),
  Color(0xFFffa500),
  Color(0xffecec03),
  Color(0xFF7cfc00),
  Color(0xff78a231),
  Color(0xFFba55d3),
  Color(0xFFdc143c),
  Color(0xFF00ffff),
  Color(0xFF00bfff),
  Color(0xFF0000ff),
  Color(0xFFff00ff),
  Color(0xFF1e90ff),
  Color(0xFFdb7093),
  Color(0xFFeee8aa),
  Color(0xFFffa07a),
];


/// 직원 lookup table (code -> name) ==> {2610: 송재혁, 2591: 이재환, 2595: 정헌옥, ...}
/// staffTable['2596'] = '김재형'
final Map<String, String> staffTable = Map.fromIterables(staffIDList, staffNameList);


/// 직원별 Color lookup table (code -> color)
final Map<String, Color> colorTable = Map.fromIterables(staffIDList, edgeColorList);



// 전체 식권 Data: Map(k=식당) 속의 Map(k=직원)
// {
//    '신가네칼국수': {'송재혁': [1, 5, 10], '이재환': [6, 9], ... },
//    '파리바게트':  {'송재혁': [], '이재환': [10, 11, 12, 20], ... },
//    ...
// }
// final이어도 참조형이므로 내용 변경 가능
final Map<String, Map<String, List<int>>> ticketData = Map.fromEntries(
  storeList.map(
    (store) => MapEntry(
      store,
      Map.fromEntries(
        ['소계', ...staffNameList].map(
          (staff) => MapEntry(staff, []),
        ),
      ),
    ),
  ),
);


// 식당 스캔 여부 저장
final Map<String, bool> doneStores = { for(var store in storeList) store: false };
///=============================================


