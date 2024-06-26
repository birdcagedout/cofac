import 'dart:convert';
import 'ticket_data.dart';
import 'staff_store_data.dart';
import '../const/const.dart';


///========================================================================================
/// <BASE32 Lookup Table>
/// 원래 BASE32 인코딩/디코딩 테이블: A(0) ~ Z(25) + 숫자 6개(2,3,4,5,6,7) + 패딩(=)
/// https://www.myanglog.com/Binary-to-text%20encoding(base64,%2032,%2016,%2062,%2058)
/// 하지만 내가 만든 BASE32 인코딩/디코딩 테이블은 숫자(10개) + 영문자(A~V)만 사용한다
///========================================================================================
/// Base32 Key & Value  <=== 원래 맞는 코드
final List<int> _B32_KEY = List<int>.generate(32, (index) => index);            // 0 ~ 31
final List<String> _B32_VAL =
    List<String>.generate(10, (index) => index.toString()) +                    // 0 ~ 9
    List<String>.generate(22, (index) => String.fromCharCode(index + 65));      // A ~ V


/// Base32 Forward Lookup(키:int, 값:String), 예) B32F[11] = 'B'
final Map<int, String> B32F = Map<int, String>.fromIterables(_B32_KEY, _B32_VAL);

/// Base32 Backward Lookup(키:String, 값:int) 예) B32B['V'] = 31
final Map<String, int> B32B = Map<String, int>.fromIterables(_B32_VAL, _B32_KEY);
///========================================================================================




/// 0. Base64Encoding되어있는지 확인
bool isB64Encoded(String str) {
  // Base64인코딩된 문자열: A-Z, a-z, +,/,=(패딩0~2개)
  final base64Pattern = RegExp(r'^[A-Za-z0-9+/]+={0,2}$');

  // Base64인코딩된 문자열: 문자열 길이는 4의 배수이고 패턴매치=true
  if ((str.length % 4 != 0) || (!base64Pattern.hasMatch(str))) {
    return false;
  }
  return true;
}

/// 1. Base64Decoding
// import 'dart:convert';
String B64Decode(String encoded) {
  List<int> decodedBytes = base64Decode(encoded);
  return utf8.decode(decodedBytes);
}

/// 2. 전체 코드를 역순으로 얻기
String getReversed(String code) {
  return code.split('').reversed.join('');
}








/// 3. 연번날짜: baseQR에서 연번, 연, 월 뽑아내기: final (num, year, month) = getNumberDate("KO5");
// (int, int, int) getNumberDate(String code) {
//   String base3 = code.substring(1, 4);
//   int num = B32B[base3[0]]!;
//   int year = B32B[base3[1]]!;
//   int month = B32B[base3[2]]!;
//   return (num, year, month);
// }

/// 4. 소속코드: baseQR에서 소속코드 뽑아내기: org='H2'(공통), dept=1(동장) / A(행정) / W(복지)
// (String, String) getOrgDept(String code) {
//   String base3 = code.substring(4, 7);
//   String org = base3.substring(0, 2);
//   String dept = base3.substring(2);
//   return (org, dept);
// }

/// 5. 고유번호(ID): baseQR에서 내선번호(ID) 뽑아내기
// String getID(String code) {
//   return code.substring(9, 13);
// }

/// 6. salt 검증
// bool isSaltValid(String code) {
//   int number = B32B[code[1]]!;
//   String id = code.substring(9, 13);
//   String saltInCode = code[8];
//
//   String realSalt = B32F[31 -
//       ((int.parse(id[0]) +
//               int.parse(id[1]) +
//               int.parse(id[2]) +
//               int.parse(id[3]) +
//               number) %
//           16)]!;
//   print("saltIncode: ${saltInCode}, realSalt: ${realSalt}");
//   return saltInCode == realSalt;
// }

/// 7. hash
// String getHash(String code) {
//   return code[7] + code[14];
// }

/// 8. hash 검증: index가 7,14인 문자열 2개 빼서, 실제 계산결과와 동일한지 검증
// bool isHashValid(String code) {
//   String base13 = code
//       .split('')
//       .asMap()
//       .entries
//       .where((entry) => entry.key != 7 && entry.key != 14)
//       .map((entry) => entry.value)
//       .join('');
//
//   String h1 = B32F[((B32B[base13[0]]! * 13 +
//           B32B[base13[1]]! * 29 +
//           B32B[base13[2]]! * 37 +
//           B32B[base13[3]]! * 47 +
//           B32B[base13[4]]! * 59 +
//           B32B[base13[5]]! * 61) %
//       32)]!;
//   String h2 = B32F[((B32B[base13[6] == 'W' ? 'V' : base13[6]]! * 13 +
//           B32B[base13[7]]! * 29 +
//           B32B[base13[8]]! * 37 +
//           B32B[base13[9]]! * 47 +
//           B32B[base13[10]]! * 59 +
//           B32B[base13[11]]! * 61) %
//       32)]!;
//
//   return (code[7] + code[14]) == (h1 + h2);
// }


// 식권 QR 1개에서 추출된 정보
class QRInfo {
  bool isMyQR = false;
  String id = "";
  String name = "";
  int number = 0;

  String getString() {
    String numberString = (number >= 0 && number < 10) ? "0" + number.toString() : number.toString();
    return numberString + name;
  }
}



///================================================
/// 한방에 모든 검증(rawQR은 displayValue)
QRInfo getValidQRInfo(String rawQR) {
  String baseQR = "";
  QRInfo returnValue = QRInfo();

  // 1) Base64Encoded 문자열인지 확인
  if (!isB64Encoded(rawQR)) {
    return returnValue;
  }
  baseQR = getReversed(B64Decode(rawQR)); // 길이=15

  // 2) 길이 체크(15)
  if (baseQR.length != 15) {
    return returnValue;
  }

  // 3) 성분 분해 + 검증
  String appID = baseQR[0];
  if (appID != "G") return returnValue;

  int num = B32B[baseQR[1]]!;
  if (num < 0 || num > 20) return returnValue;

  int year = B32B[baseQR[2]]! + 2000;
  int month = B32B[baseQR[3]]!;
  if (year != targetYear || month != targetMonth) return returnValue;

  String org = baseQR.substring(4, 6);
  String dept = baseQR.substring(6, 7);
  if (org != "H2" || !["1", "A", "S"].contains(dept)) return returnValue;

  String id = baseQR.substring(9, 13);
  if (!staffIDList.contains(id)) return returnValue;
  String name = staffTable[id]!;



  // 4) salt 검증
  String saltInCode = baseQR[8];
  String realSalt = B32F[31 -
      ((int.parse(id[0]) +
          int.parse(id[1]) +
          int.parse(id[2]) +
          int.parse(id[3]) +
          num) %
          16)]!;
  if (saltInCode != realSalt) {
    return returnValue;
  }

  // 5) Hash 검증: hash(7, 14)를 제외한 base코드에서 처음부터 hash 계산하여 일치하는지 검증
  String base13 = baseQR
    .split('')
    .asMap()
    .entries
    .where((entry) => entry.key != 7 && entry.key != 14)
    .map((entry) => entry.value)
    .join('');

  String h1 = B32F[((B32B[base13[0]]! * 13 +
    B32B[base13[1]]! * 29 +
    B32B[base13[2]]! * 37 +
    B32B[base13[3]]! * 47 +
    B32B[base13[4]]! * 59 +
    B32B[base13[5]]! * 61) %
    32)]!;

  String h2 = B32F[((B32B[base13[6]]! * 13 +
    B32B[base13[7]]! * 29 +
    B32B[base13[8]]! * 37 +
    B32B[base13[9]]! * 47 +
    B32B[base13[10]]! * 59 +
    B32B[base13[11]]! * 61) %
    32)]!;

  if ((baseQR[7] + baseQR[14]) != (h1 + h2)) return returnValue;

  // 6) 맨끝자리 "M"(멤버 QR) 검증
  String qrClass = baseQR[13];
  if (qrClass != "M") return returnValue;

  // 모든 검증을 통과한 경우
  returnValue.isMyQR = true;
  returnValue.id = id;
  returnValue.name = name;
  returnValue.number = num;
  return returnValue;
}
///================================================


