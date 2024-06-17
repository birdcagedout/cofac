import 'dart:typed_data';

import 'package:encrypt/encrypt.dart' as Encrypt; // encrypt 패키지
import 'dart:convert'; // utf8 객체
import 'data.dart';

void main() {
  String myKey = "급량페이2024";

  Encrypt.Key key = Encrypt.Key(utf8.encode(myKey));
  // Encrypt.IV iv = Encrypt.IV.fromSecureRandom(16);
  Encrypt.IV iv = Encrypt.IV(utf8.encode("H2A김재형2596")); // 길이 = 16 (3 + 3*3 + 4)

  final encrypter = Encrypt.Encrypter(Encrypt.AES(key));

  for (var eachData in totalData) {
    final encrypted = encrypter.encrypt(eachData, iv: iv);
    final decrypted = encrypter.decrypt(encrypted, iv: iv);
    print("text: ${eachData}, encrypted: ${encrypted.base64}, decrypted: ${decrypted}");
    // print(encrypted.base64);
  }
}
