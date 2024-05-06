import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:p09_you_and_i/screen/home_screen.dart';

void main() {
  runApp(
    MaterialApp(
      theme: ThemeData(
        textTheme: TextTheme(
          // displayLarge
          displayLarge: TextStyle(
            color: Colors.white,
            fontSize: 80,
            fontFamily: "parisienne",
          ),
          // bodyLarge
          bodyLarge: TextStyle(
            color: Colors.white,
            fontSize: 50,
            fontWeight: FontWeight.w700,
            fontFamily: "sunflower",
          ),
          // bodyMedium
          bodyMedium: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontFamily: "sunflower",
          ),
          // bodySmall
          bodySmall: TextStyle(
            color: Colors.white,
            fontSize: 20,
            fontFamily: "sunflower",
          ),
        )
      ),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        Locale('ko', ''),
        Locale('en', ''),
      ],
      home: HomeScreen(),
    )
  );
}
