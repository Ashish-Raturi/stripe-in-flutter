import 'package:flutter/material.dart';

loading(String msg) {
  return Scaffold(
    body: Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(msg),
        SizedBox(
          height: 10,
        ),
        CircularProgressIndicator()
      ],
    )),
  );
}
