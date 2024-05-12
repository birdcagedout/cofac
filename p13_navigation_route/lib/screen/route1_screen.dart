import 'package:flutter/material.dart';
import '../layout/default_layout.dart';

class Route1Screen extends StatefulWidget {

  const Route1Screen({super.key});

  @override
  State<Route1Screen> createState() => _Route1ScreenState();
}

class _Route1ScreenState extends State<Route1Screen> {
  int? number;

  @override
  Widget build(BuildContext context) {
    number = number ?? ModalRoute.of(context)?.settings.arguments as int;   // int형으로 받을 때 as int로

    return DefaultLayout(
      title: "Route1 Screen",
      children: [
        Text(
          "arguments: ${number}",
          textAlign: TextAlign.center,
        ),

        OutlinedButton(
          onPressed: () async {
            var result = await Navigator.of(context).pushNamed(
              '/two',
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
      ],
    );
  }
}
