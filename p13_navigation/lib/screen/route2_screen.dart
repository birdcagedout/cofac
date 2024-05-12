import 'package:flutter/material.dart';
import 'package:p13_navigation/screen/route3_screen.dart';

import '../layout/default_layout.dart';

class Route2Screen extends StatefulWidget {
  const Route2Screen({super.key});

  @override
  State<Route2Screen> createState() => _Route2ScreenState();
}

class _Route2ScreenState extends State<Route2Screen> {
  var arg;

  @override
  Widget build(BuildContext context) {
    // 최초 1번만 argument를 넘겨받음 (나중에 setState 호출될 때는 argument로 초기화 하지 않음)
    // (주의) ModalRoute.of(context)는 클래스 초기화문에 사용 불가, initState() 내부에서도 사용 불가
    arg = arg ?? ModalRoute.of(context)?.settings.arguments;   // Route1에서 넘겨받은 data(setting 앞에 ?)

    return DefaultLayout(
      title: "Route2 Screen",
      children: [
        Text("arguments: ${arg}", textAlign: TextAlign.center,),
        OutlinedButton(
          onPressed: () async {
            arg = await Navigator.of(context).push(
              MaterialPageRoute(builder: (context) {
                return Route3Screen(arg: arg,);
              },),
            );
            setState(() {

            });
          },
          child: Text("Push"),
        ),
        OutlinedButton(
          onPressed: () {
            Navigator.of(context).pop(arg - 1);
          },
          child: Text("Pop"),
        ),
      ],
    );
  }
}
