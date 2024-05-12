import 'package:flutter/material.dart';
import '../layout/default_layout.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int number = 123;

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: "Home Screen",
      children: [
        Text(
          "arguments: $number",
          textAlign: TextAlign.center,
        ),
        OutlinedButton(
          onPressed: () async {
            // Declarative routing을 사용하면 코드가 간결해진다
            number = await Navigator.of(context).pushNamed(
              '/one',
              arguments: number,
            ) as int;
            // num을 받아온 후 화면에 출력하려면 다시 그려야 한다
            setState(() {});
          },
          child: Text("Push"),
        ),
      ],
    );
  }
}
