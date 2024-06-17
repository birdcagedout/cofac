import 'package:flutter/material.dart';
import 'package:p13_navigation/layout/default_layout.dart';
import 'package:p13_navigation/screen/route2_screen.dart';

class Route1Screen extends StatefulWidget {
  final int num;

  const Route1Screen({
    required this.num,
    super.key,
  });

  @override
  State<Route1Screen> createState() => _Route1ScreenState();
}

class _Route1ScreenState extends State<Route1Screen> {
  int number = 0;

  @override
  void initState() {
    super.initState();
    number = widget.num;
  }

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: "Route1 Screen",
      children: [
        Text(
          "arguments: ${number}",
          textAlign: TextAlign.center,
        ),
        OutlinedButton(
          onPressed: () async {
            number = await Navigator.of(context).push(
              MaterialPageRoute(
                builder: (context) {
                  return Route2Screen();
                },
                // push하면서 Data 넘기기 2번째 방법 ==> MaterialPageRoute.setting
                settings: RouteSettings(
                  arguments: number,
                ),
              ),
            );
            setState(() {

            });
          },
          child: Text("Push"),
        ),
        OutlinedButton(
          onPressed: () {
            Navigator.of(context).pop(number - 1);
          },
          child: Text("Pop"),
        ),
      ],
    );
  }
}
