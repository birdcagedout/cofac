import 'package:flutter/material.dart';
import '../layout/default_layout.dart';

class Route3Screen extends StatelessWidget {
  const Route3Screen({super.key,});

  @override
  Widget build(BuildContext context) {
    int? number = (ModalRoute.of(context)?.settings.arguments ?? 0) as int;

    return DefaultLayout(
      title: "Route3 Screen",
      children: [
        Text("arguments: $number", textAlign: TextAlign.center,),

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
