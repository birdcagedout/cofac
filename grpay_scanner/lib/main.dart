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
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('ko', ''),
        Locale('en', ''),
      ],
      title: APP_TITLE_FULL,
      theme: ThemeData(
        primarySwatch: Colors.purple,
      ),
      home: const SplashScreen(),
    ),
  );
}
