import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';    // 연월 한글로
import 'package:flutter/services.dart';                               // 세로모드 고정

import 'screen/splash_screen.dart';
import 'const/const.dart';


void main() async {

  // 세로모드 고정(main에 async 포함)
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ko', ''),
        Locale('en', ''),
      ],
      title: APP_TITLE_FULL,
      theme: ThemeData(
        brightness: Brightness.light,
        colorScheme: ColorScheme.light(
          primary: Colors.black, // 주요 색상
        ),
      ),
      home: const SplashScreen(),
    ),
  );
}
