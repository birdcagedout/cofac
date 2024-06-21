import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart'; // 연월 한글로
import 'package:flutter/services.dart'; // 세로모드 고정

import 'screen/splash_screen.dart';
import 'const/const.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {

  // 세로모드 고정(main에 async 포함)
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // firebase 기본세팅 (위쪽 ensureInitialized() 뒤에 위치해야 된다)
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // 앱 로직 시작
  runApp(
    MaterialApp(
      debugShowCheckedModeBanner: false,

      // 로케일 설정(한글 달력)
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
        colorScheme: const ColorScheme.light(
          primary: Colors.black, // 주요 색상
        ),
        fontFamily: GoogleFonts.notoSansKr().fontFamily,
      ),
      home: const SplashScreen(),
    ),
  );
}
