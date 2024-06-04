import 'dart:typed_data';

import 'package:encrypt/encrypt.dart' as Encrypt;    // encrypt 패키지
import 'dart:convert';    // utf8 객체

void main() {
  final plainTexts = [
    "G1O6H21L2610M",
    "G2O6H21K2610M",
    "G3O6H21J2610M",
    "G4O6H21I2610M",
    "G5O6H21H2610M",
    "G6O6H21G2610M",
    "G7O6H21V2610M",
    "G8O6H21U2610M",
    "G9O6H21T2610M",
    "GAO6H21S2610M",
    "GBO6H21R2610M",
    "GCO6H21Q2610M",
    "GDO6H21P2610M",
    "GEO6H21O2610M",
    "GFO6H21N2610M",
    "GGO6H21M2610M",
    "GHO6H21L2610M",
    "GIO6H21K2610M",
    "GJO6H21J2610M",
    "GKO6H21I2610M",
  ];
  var targetDate = DateTime(2024, 5);


  String myKey = "급량페이2024";

  Encrypt.Key key = Encrypt.Key(utf8.encode(myKey));
  Encrypt.IV iv = Encrypt.IV.fromSecureRandom(16);
  final encrypter = Encrypt.Encrypter(Encrypt.AES(key));

  for (var plainText in plainTexts) {
    final encrypted = encrypter.encrypt(plainText, iv: iv);
    final decrypted = encrypter.decrypt(encrypted, iv: iv);
    print("text: ${plainText}, encrypted: ${encrypted.base64}, decrypted: ${decrypted}");
    // print(encrypted.base64);    
  }
}