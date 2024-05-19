// 13개
final List<String> storeList = [
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

// 22명
final List<String> staffNameList = [
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

final List<String> staffIDList = [
  '2610',
  '2591', '2595', '2592', '2597', '2596', '2594', '2599', '2598', '2600',
  '2141', '2142', '2151', '2146', '2230', '2143', '2601', '2149', '2148', '2145', '2112', '2113'
];

final Map<String, String> staffTable = Map.fromIterables(staffIDList, staffNameList);



final String targetDate = "2024년 5월";

// storeList.map을 사용하여 Map 생성
final Map<String, Map<String, int>> ticketData = Map.fromEntries(
  storeList.map(
        (store) => MapEntry(
      store,
      Map.fromEntries(staffNameList.map((staff) => MapEntry(staff, 0))),
    ),
  ),
);

void main() {
  // '분식사'의 '김재형' 값을 5로 변경
  if (ticketData.containsKey('분식사')) {
    Map<String, int> bunshiksaMap = ticketData['분식사']!;
    if (bunshiksaMap.containsKey('김재형')) {
      bunshiksaMap['김재형'] = 5;
    }
  }

  // 다른 방법
  ticketData['분식사']!['김재형'] = 10;

  print(ticketData);
  print(ticketData['분식사']);
  print(ticketData['분식사']!['김재형']);
  print(staffTable);
  print(staffTable['2596']);
}
