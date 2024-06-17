import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:p13_navigation/layout/default_layout.dart';
import 'package:p13_navigation/screen/route1_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController controller = TextEditingController();
  var num;

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: "Home Screen",
      children: [
        TextField(
          controller: controller,
          decoration: InputDecoration(
            labelText: "숫자 입력",
            hintText: "숫자를 입력해주세요",
          ),
        ),
        OutlinedButton(
          onPressed: () {
            print(controller.text.runtimeType);   // String
            num = int.parse(controller.text);
            controller.clear();
            setState(() {

            });
          },
          child: Text("입력"),
        ),
        SizedBox(height: 50,),


        Text(
          "arguments: $num",
          textAlign: TextAlign.center,
        ),
        OutlinedButton(
          onPressed: () async {
            num = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return Route1Screen(
                    num: num,
                  );
                },
              ),
            );

            // num을 받아온 후 화면에 출력하려면 다시 그려야 한다
            setState(() {});
          },
          child: Text("Push"),
        ),
      ],
    );
  }
}
