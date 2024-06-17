import 'package:flutter/material.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool show = false;
  Color color = Colors.red;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if(show) GestureDetector(onTap: () {setState(() {
              color = (color == Colors.red) ? Colors.blue : Colors.red;
            });}, child: CodeFactoryWidget(color: color)),   // (주의) 이 문법은 list 안에서만 쓸 수 있다
            SizedBox(height: 32,),
            //////////////////////////////////////////////////////////////////////////////////
            // 1. setState: show를 바꿔주면서 build를 새로 실행해주기 위해서는 setState()가 반드시 필요하다.
            ElevatedButton(
              onPressed: () {
                setState(() {
                  show = !show;
                });
              },
              child: Text("보이기/안보이기"),
            ),
          ],
        ),
      )
    );
  }
}

/////////////////////////////////////////////
// 2. StatefulWidget의 호출 순서: print로 알아보자
class CodeFactoryWidget extends StatefulWidget {
  final color;

  /////////////////////////////////////////////
  // 4. didUpdateWidget: StatefulWidget 생성자의 인자값을 달리 주고 생성할 때
  CodeFactoryWidget({super.key, required this.color}) {
   print("(1) 생성자");
  }

  @override
  State<CodeFactoryWidget> createState() {
    print("(2) createState");
    return _CodeFactoryWidgetState();
  }
}

class _CodeFactoryWidgetState extends State<CodeFactoryWidget> {

  /////////////////////////////////////////////
  // 3. setState가 build만 실행시킴을 print로 확인 ==> GestureDetector로 사각형 클릭할 때마다 setState -> build 실행
  // var color = Colors.red;


  @override
  void initState() {
    super.initState();
    print("(3) initState");
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    print("(4) didChangeDependencies");
  }
  @override
  void didUpdateWidget(covariant CodeFactoryWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    print("(5) didUpdateWidget");
  }

  @override
  Widget build(BuildContext context) {
    print("(6) build");
    // return GestureDetector(
    //   onTap: () {
    //     setState(() {
    //       color = (color == Colors.red) ? Colors.blue : Colors.red;
    //     });
    //   },
    //   child: Container(
    //     color: color,
    //     width: 50,
    //     height: 50,
    //   ),
    // );
    return Container(
      color: widget.color,
      width: 50,
      height: 50,
    );
  }

  @override
  void deactivate() {
    print("(7) deactivate");
    super.deactivate();
  }

  @override
  void dispose() {
    print("(8) dispose");
    super.dispose();
  }
}

