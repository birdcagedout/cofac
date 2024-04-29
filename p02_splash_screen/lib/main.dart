import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(
    MaterialApp(
      home: HomeScreen(),
    )
  );
}


class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // backgroundColor: Color(0xFF335CB0),   // Hex값 입력할 때는 Color(값), FF는 Alpha
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(padding: EdgeInsets.symmetric(horizontal: 80.0), child: Image.asset('asset/img/grpay2.png')),
          SizedBox(height: 5.0),
          Text("급 량 페 이", style: TextStyle(fontSize: 60, fontWeight: FontWeight.w900,),),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("QR Scanner ", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.w900,),),
              Text("ver.0.1b", style: TextStyle(fontSize: 20.0, color: Colors.green),),
            ],
          ),
          SizedBox(height: 15.0),
          CircularProgressIndicator(color: Color(0xFFFFC400),),
        ],
      )
    );
  }
}
