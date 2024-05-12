import 'package:flutter/material.dart';
import 'package:p13_navigation_route/screen/route3_screen.dart';
import '../layout/default_layout.dart';

class Route2Screen extends StatefulWidget {
  const Route2Screen({super.key});

  @override
  State<Route2Screen> createState() => _Route2ScreenState();
}

class _Route2ScreenState extends State<Route2Screen> {
  int? number;

  @override
  Widget build(BuildContext context) {
    // 최초 1번만 argument를 넘겨받음 (나중에 setState 호출될 때는 argument로 초기화 하지 않음)
    // (주의) ModalRoute.of(context)는 클래스 초기화문에 사용 불가, initState() 내부에서도 사용 불가
    number = number ??
        ModalRoute.of(context)?.settings.arguments
            as int; // Route1에서 넘겨받은 data(setting 앞에 ?)

    return DefaultLayout(
      title: "Route2 Screen",
      children: [
        Text(
          "arguments: ${number}",
          textAlign: TextAlign.center,
        ),
        OutlinedButton(
          onPressed: () async {
            var result = await Navigator.of(context).pushNamed(
              '/three',
              arguments: number,
            );
            number = (result == null) ? 0 : result as int;
            setState(() {});
          },
          child: Text("Push"),
        ),
        OutlinedButton(
          onPressed: () {
            Navigator.of(context).pop(number! - 1);
          },
          child: Text("Pop"),
        ),
        OutlinedButton(
          onPressed: () {
            Navigator.of(context).pushReplacement(
              MaterialPageRoute(
                  builder: (BuildContext context) {
                    return Route3Screen();
                  },
                  settings: RouteSettings(
                    arguments: number,
                  )),
            );
          },
          child: Text("Push Replacement"),
        ),

        // 새로운 라우트를 push한 후에 나머지 라우트는 라우트 스택에서 삭다 삭제함
        // 단, 삭제하지 않고 남길 라우트는 predicate 조건에 true를 반환하도록 남겨둔다
        OutlinedButton(
          onPressed: () {
            Navigator.of(context).pushNamedAndRemoveUntil(
              '/three',
              (route) {
                return (route.settings.name == '/') || (route.settings.name == '/one');
              },
            );
          },
          child: Text("Push Named and Remove Until"),
        ),
      ],
    );
  }
}
