///=============================================
// 13개
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

// 22명
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


// 직원 lookup table (code -> name) ==> {2610: 송재혁, 2591: 이재환, 2595: 정헌옥, ...}
// staffTable['2596'] = '김재형'
final Map<String, String> staffTable = Map.fromIterables(staffIDList, staffNameList);



// 식권 Data 초기화: Map(k=식당) 속의 Map(k=직원)
// {
//    '신가네칼국수': {'송재혁': [1, 5, 10], '이재환': [6, 9], ...},
//    '파리바게트':  {'송재혁': [], '이재환': [10, 11, 12, 20], ...},
//    ...
// }
// final이어도 참조형이므로 값 변경 가능
// ==> count = ticketData['분식사']!['김재형']!.length;
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

///=============================================


