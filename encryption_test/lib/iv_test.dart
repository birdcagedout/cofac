import 'package:encrypt/encrypt.dart';
import 'dart:convert';
import 'dart:typed_data';

void main() {
  // DateTime dt1 = DateTime(2024, 5);
  // DateTime dt2 = DateTime(2024, 6);

  // print(dt1);
  // Duration diff = dt2.difference(dt1);
  // print(diff.inMicroseconds.toString().length);

  final a0 = generateIV(0);
  final a1 = generateIV(1);
  final a8 = generateIV(8);
  print(a0.base64);
  print(a1);
  print(a8);



}


// IV를 카운터 값으로 생성하는 함수
  IV generateIV(int counter) {
    // 카운터 값을 16 바이트로 변환
    final counterBytes = Uint8List(16);
    for (int i = 0; i < 8; i++) {
      counterBytes[15 - i] = (counter >> (i * 8)) & 0xff;
    }
    return IV(counterBytes);
  }
