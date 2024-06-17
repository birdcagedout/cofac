import 'package:flutter/material.dart';

import '../layout/default_layout.dart';

class Route3Screen extends StatelessWidget {
  final arg;
  const Route3Screen({required this.arg, super.key,});

  @override
  Widget build(BuildContext context) {
    return DefaultLayout(
      title: "Route3 Screen",
      children: [
        Text("arguments: $arg", textAlign: TextAlign.center,),
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
