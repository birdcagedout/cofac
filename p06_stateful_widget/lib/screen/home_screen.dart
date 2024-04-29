import 'package:flutter/material.dart';
import 'package:colornames/colornames.dart';


class HomeScreen extends StatefulWidget {

  HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  var color = Colors.red;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(onPressed: () {
              setState(() {
                color = (color == Colors.red) ? Colors.blue : Colors.red;   // setState() 밖(호출 전에)에 있어도 된다
              });
            }, child: Text("색깔 변신(현재 색깔=${color.colorName})")),
            SizedBox(width: 50, height: 50,),
            Container(
              color: color,
              width: 50,
              height: 50,
            ),
          ],
        )
      ),
    );
  }
}
