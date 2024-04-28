import 'package:flutter/material.dart';

/// dart format 단축기 등록: Settings - Keymap - 검색에 'dart format' - 키보드 바인딩에 Option+Command+L 등록(이미 등록되었을 수도 있다)
void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Text(
          'Code Factory',
          style: TextStyle(
            color: Colors.white,
          ),
        ),
      ),
    ),
  ));
}
