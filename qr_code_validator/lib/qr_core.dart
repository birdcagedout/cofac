import 'staff_store_data.dart';
import 'dart:convert';
import 'const.dart';

///========================================================================================
/// <BASE32 Lookup Table>
/// 원래 BASE32 인코딩/디코딩 테이블: A(0) ~ Z(25) + 숫자 6개(2,3,4,5,6,7) + 패딩(=)
/// https://www.myanglog.com/Binary-to-text%20encoding(base64,%2032,%2016,%2062,%2058)
/// 하지만 내가 만든 BASE32 인코딩/디코딩 테이블은 숫자(10개) + 영문자(A~V)만 사용한다
///========================================================================================
/// Base32 Key & Value  <=== 원래 맞는 코드
final List<int> _B36_KEY = List<int>.generate(36, (index) => index); // 0 ~ 35
final List<String> _B36_VAL =
    List<String>.generate(10, (index) => index.toString()) + // 0 ~ 9
        List<String>.generate(
            26, (index) => String.fromCharCode(index + 65)); // A ~ Z

/// Base32 Forward Lookup(키:int, 값:String), 예) B32F[11] = 'B'
final Map<int, String> B36F =
    Map<int, String>.fromIterables(_B36_KEY, _B36_VAL);

/// Base32 Backward Lookup(키:String, 값:int) 예) B32B['V'] = 31
final Map<String, int> B36B =
    Map<String, int>.fromIterables(_B36_VAL, _B36_KEY);

///========================================================================================

/// Base64Encoding 되어있는지 확인
bool isB64Encoded(String str) {
  // Base64인코딩된 문자열: A-Z, a-z, +,/,=(패딩0~2개)
  final base64Pattern = RegExp(r'^[A-Za-z0-9+/]+={0,2}$');

  // Base64인코딩된 문자열: 문자열 길이는 4의 배수이고 패턴매치=true
  if ((str.length % 4 != 0) || (!base64Pattern.hasMatch(str))) {
    return false;
  }
  return true;
}

/// Base64Decoding
// import 'dart:convert';
String B64Decode(String encoded) {
  List<int> decodedBytes = base64Decode(encoded);
  return utf8.decode(decodedBytes);
}

/// 전체 코드를 역순으로 얻기
String getReversed(String code) {
  return code.split('').reversed.join('');
}

// 식권 QR 1개에서 추출된 정보
class QRInfo {
  bool isMyQR = false;
  String id = "";
  String name = "";
  int number = 0;

  String getString() {
    String numberString = number.toString().padLeft(2, "0");
    return (numberString + name);
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

  // 3) AppID
  String appID = baseQR[0];
  if (appID != "G") return returnValue;

  // 4) 식권번호
  int num = B36B[baseQR[2]]!;
  if (num <= 0 || num > 20) return returnValue;

  // 5) 연월
  int year = B36B[baseQR[3]]! + 2000;
  int month = B36B[baseQR[4]]!;
  if (year != targetYear || month != targetMonth) return returnValue;

  // 6) 조직(하계2동), 부서(행정팀)
  String org = baseQR.substring(6, 8); // 조직: 문자 2개
  String dept = baseQR.substring(8, 9); // 부서: 문자 1개
  if (org != "H2" || !["1", "A", "W"].contains(dept))
    return returnValue; // 복지팀 = 'W'

  // 7) 아이디(2596)
  String id = baseQR.substring(10, 14);
  if (!staffIDList.contains(id)) return returnValue;
  String name = staffTable[id]!;

  // 8) salt1 검증
  String salt1 = baseQR[1];
  String realSalt1 = B36F[((int.parse(id) * num) % 36)]!;
  if (salt1 != realSalt1) return returnValue;

  // 9) salt2 검증
  String salt2 = baseQR[5];
  String realSalt2 = B36F[((int.parse(id.substring(0, 2)) * num) % 36)]!;
  if (salt2 != realSalt2) return returnValue;

  // 10) salt2 검증
  String salt3 = baseQR[9];
  String realSalt3 = B36F[((int.parse(id.substring(2)) * num) % 36)]!;
  if (salt3 != realSalt3) return returnValue;

  // 11) Hash 검증
  String hash = baseQR[14];
  String realHash = B36F[(B36B[baseQR[0]]! +
          B36B[baseQR[1]]! +
          B36B[baseQR[2]]! +
          B36B[baseQR[3]]! +
          B36B[baseQR[4]]! +
          B36B[baseQR[5]]! +
          B36B[baseQR[6]]! +
          B36B[baseQR[7]]! +
          B36B[baseQR[8]]! +
          B36B[baseQR[9]]! +
          B36B[baseQR[10]]! +
          B36B[baseQR[11]]! +
          B36B[baseQR[12]]! +
          B36B[baseQR[13]]!) %
      36]!;
  if (hash != realHash) return returnValue;

  // 모든 검증을 통과한 경우
  returnValue.isMyQR = true;
  returnValue.id = id;
  returnValue.name = name;
  returnValue.number = num;
  return returnValue;
}
///================================================


